{vendas.i}

DEFINE INPUT  PARAMETER pcAcao       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER piID         AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttItensVenda.
DEFINE OUTPUT PARAMETER pcMensagem   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pdQtd        AS DECIMAL   NO-UNDO.

IF pcAcao = "BUSCAR_PRODUTO" THEN DO:
    FIND Produto WHERE Produto.Id_Produto = piID NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Produto THEN DO:
        pcMensagem = "Produto não encontrado!".
        RETURN.
    END.
    
    IF Produto.Ativo = NO THEN DO:
        pcMensagem = "Este produto está inativo!".
        RETURN.
    END.

    /* Retorna dados via temp-table (um registro so para a busca) */
    CREATE ttItensVenda.
    ASSIGN ttItensVenda.Id_Produto = Produto.Id_Produto
           ttItensVenda.Descricao  = Produto.Descricao
           ttItensVenda.Marca      = Produto.Marca
           ttItensVenda.Unidade    = Produto.Unidade
           ttItensVenda.Preco_Unit = Produto.Preco_Venda.
    pcMensagem = "SUCESSO".
END.

ELSE IF pcAcao = "VALIDAR_ESTOQUE" THEN DO:
    FIND Produto WHERE Produto.Id_Produto = piID NO-LOCK NO-ERROR.
    IF AVAILABLE Produto THEN DO:
        IF Produto.Quantidade_Estoque <= 0 THEN
            pcMensagem = "ERRO: Produto sem estoque disponível!".
        ELSE IF Produto.Quantidade_Estoque < pdQtd THEN
            pcMensagem = "AVISO: Saldo insuficiente! Estoque atual: " + STRING(Produto.Quantidade_Estoque).
        ELSE
            pcMensagem = "SUCESSO".
    END.
END.

ELSE IF pcAcao = "FINALIZAR_VENDA" THEN DO:
    DEFINE VARIABLE iProxIdVenda AS INTEGER NO-UNDO.
    DEFINE VARIABLE dTotalSoma   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cErroTransacao AS CHARACTER NO-UNDO.

    /* Validações Básicas */
    IF piID = 0 THEN DO:
        pcMensagem = "ERRO: Selecione um cliente antes de finalizar a venda!".
        RETURN.
    END.

    /* Verifica se tem itens na temp-table */
    FIND FIRST ttItensVenda NO-ERROR.
    IF NOT AVAILABLE ttItensVenda THEN DO:
        pcMensagem = "ERRO: Adicione pelo menos um item ao pedido.".
        RETURN.
    END.

    /* Pega o proximo ID da Venda */
    FIND LAST Venda NO-LOCK NO-ERROR.
    iProxIdVenda = (IF AVAILABLE Venda THEN Venda.Id_Venda + 1 ELSE 1).

    /* TRANSAÇÃO PRINCIPAL */
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        /* 1. Salva o Cabeçalho da Venda */
        CREATE Venda.
        ASSIGN Venda.Id_Venda   = iProxIdVenda
               Venda.CodCliente = piID
               Venda.DataVenda  = TODAY
               Venda.StatusVenda = "CONCLUIDA".
        
        /* 2. Salva os Itens e Abate Estoque */
        FOR EACH ttItensVenda:
            /* Salva o Item */
            CREATE ItemVenda.
            ASSIGN ItemVenda.Id_Venda   = iProxIdVenda
                   ItemVenda.Sequencia  = ttItensVenda.Sequencia
                   ItemVenda.Id_Produto = ttItensVenda.Id_Produto
                   ItemVenda.Quantidade = ttItensVenda.Quantidade
                   ItemVenda.Preco_Unit = ttItensVenda.Preco_Unit
                   ItemVenda.Total_Item = ttItensVenda.Total_Item.
            
            dTotalSoma = dTotalSoma + ttItensVenda.Total_Item.

            /* Abate o Estoque - Lock Exclusivo */
            FIND Produto WHERE Produto.Id_Produto = ttItensVenda.Id_Produto EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Produto THEN DO:
                IF Produto.Quantidade_Estoque < ttItensVenda.Quantidade THEN DO:
                    cErroTransacao = "ERRO: Saldo insuficiente para o produto " + STRING(Produto.Id_Produto) + " durante a finalização.".
                    UNDO, LEAVE. /* Desfaz a transação inteira */
                END.
                ASSIGN Produto.Quantidade_Estoque = Produto.Quantidade_Estoque - ttItensVenda.Quantidade.
            END.
            ELSE DO:
                 cErroTransacao = "ERRO: Produto " + STRING(ttItensVenda.Id_Produto) + " não encontrado no banco de dados.".
                 UNDO, LEAVE.
            END.
        END. /* Fim do FOR EACH */

        /* Atualiza Valor Total no Cabeçalho */
        ASSIGN Venda.ValorTotal = dTotalSoma.
    END. /* Fim da Transação */

    IF cErroTransacao <> "" THEN
        pcMensagem = cErroTransacao.
    ELSE
        pcMensagem = "SUCESSO|" + STRING(iProxIdVenda).
END.

ELSE IF pcAcao = "FATURAR_PEDIDO" THEN DO:
    /* Fase 1: Ler Venda, Cliente e buscar Regra Fiscal (ICMS e CFOP) */
    FIND Venda WHERE Venda.Id_Venda = piID NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Venda THEN DO:
        pcMensagem = "ERRO: Pedido de Venda nao encontrado.".
        RETURN.
    END.

    FIND Cliente WHERE Cliente.CodCliente = Venda.CodCliente NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cliente THEN DO:
        pcMensagem = "ERRO: Cliente vinculado a Venda " + STRING(piID) + " nao encontrado.".
        RETURN.
    END.

    DEFINE VARIABLE cUFOrigem  AS CHARACTER INITIAL "SP" NO-UNDO.
    DEFINE VARIABLE cUFDestino AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dAliqICMS  AS DECIMAL   NO-UNDO.

    cUFDestino = Cliente.Estado.
    IF cUFDestino = "" THEN cUFDestino = "SP". /* Fallback preventivo */

    FIND RegraFiscal WHERE RegraFiscal.UF_Origem = cUFOrigem 
                       AND RegraFiscal.UF_Destino = cUFDestino NO-LOCK NO-ERROR.
    
    IF AVAILABLE RegraFiscal THEN DO:
        dAliqICMS = RegraFiscal.AliqICMS.
        
        /* Fase 2: Percorrer Itens e buscar IPI (NCM) */
        DEFINE VARIABLE dAliqIPI  AS DECIMAL NO-UNDO.
        DEFINE VARIABLE cListaIPI AS CHARACTER INITIAL "" NO-UNDO.

        FOR EACH ItemVenda WHERE ItemVenda.Id_Venda = piID NO-LOCK:
            FIND Produto WHERE Produto.Id_Produto = ItemVenda.Id_Produto NO-LOCK NO-ERROR.
            IF AVAILABLE Produto THEN DO:
                FIND NCM WHERE NCM.CodNCM = Produto.NCM NO-LOCK NO-ERROR.
                IF AVAILABLE NCM THEN DO:
                    dAliqIPI = NCM.AliqIPI.
                    cListaIPI = cListaIPI + (IF cListaIPI = "" THEN "" ELSE ", ") + Produto.Descricao + ": " + STRING(dAliqIPI) + "%".
                END.
                ELSE DO:
                    cListaIPI = cListaIPI + (IF cListaIPI = "" THEN "" ELSE ", ") + Produto.Descricao + ": NCM NAO CADASTRADO".
                END.
            END.
        END.

        pcMensagem = "SUCESSO TOTAL! | Cliente: " + Cliente.Nome + " (" + cUFDestino + ")" +
                     "~nICMS: " + STRING(dAliqICMS) + "% | CFOP: " + RegraFiscal.CodCFOP +
                     "~nIPI por Item -> " + cListaIPI.
    END.
    ELSE DO:
        pcMensagem = "ERRO FISCAL: Nenhuma Regra Fiscal localizada (De " + cUFOrigem + " para " + cUFDestino + "). Venda travada por seguranca.".
    END.
END.
