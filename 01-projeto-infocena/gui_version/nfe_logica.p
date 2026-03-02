/* nfe_logica.p - Logica de Negocios para Entrada de Notas Fiscais */

DEFINE INPUT PARAMETER pcAcao     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcCaminho  AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE ttItensNFe NO-UNDO
    FIELD Sequencia    AS INTEGER
    FIELD Id_Produto   AS INTEGER
    FIELD Descricao    AS CHARACTER FORMAT "X(40)"
    FIELD Quantidade   AS DECIMAL   FORMAT "->>>,>>9.99"
    FIELD ValorUnitario AS DECIMAL   FORMAT "->>,>>9.99"
    FIELD ValorTotal   AS DECIMAL   FORMAT "->>>,>>>,>>9.99"
    INDEX idx_seq_nfe IS PRIMARY Sequencia.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttItensNFe.

DEFINE OUTPUT PARAMETER cCabecalho AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cMsg       AS CHARACTER NO-UNDO.

IF pcAcao = "LER_XML" THEN DO:
    EMPTY TEMP-TABLE ttItensNFe.
    
    /* Leitura Mockada do XML (Para validacao de fluxo inicial) */
    IF pcCaminho MATCHES "*mock_nfe*" THEN DO:
        CREATE ttItensNFe.
        ASSIGN ttItensNFe.Sequencia = 1
               ttItensNFe.Id_Produto = 4
               ttItensNFe.Descricao = "COBERTURA NESTLE 1KG CHOCOLATE"
               ttItensNFe.Quantidade = 10.00
               ttItensNFe.ValorUnitario = 5.00
               ttItensNFe.ValorTotal = 50.00.
               
        CREATE ttItensNFe.
        ASSIGN ttItensNFe.Sequencia = 2
               ttItensNFe.Id_Produto = 3
               ttItensNFe.Descricao = "SABAO EM PO OMO MULTI 1KG"
               ttItensNFe.Quantidade = 5.00
               ttItensNFe.ValorUnitario = 15.30
               ttItensNFe.ValorTotal = 76.50.
               
        cCabecalho = "35230911222333000144550010000001231000001234|123|DISTRIBUIDORA DE DOCES LTDA|126.50".
        cMsg = "SUCESSO".
    END.
    ELSE cMsg = "Arquivo XML invalido ou nao encontrado.".
END.

/* ============================================================ */
/* Acao: COMPARAR_PEDIDO - Two-Way Match (NFe x Pedido Compra)  */
/* pcCaminho contem o numero do pedido como STRING               */
/* ============================================================ */
ELSE IF pcAcao = "COMPARAR_PEDIDO" THEN DO:
    DEFINE VARIABLE iPedido       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cResumo       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iDivergencias AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iMatches      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lAchouProdNFe AS LOGICAL   NO-UNDO.
    
    iPedido = INTEGER(pcCaminho) NO-ERROR.
    IF ERROR-STATUS:ERROR OR iPedido = 0 THEN DO:
        cMsg = "ERRO: Numero de Pedido invalido.".
        RETURN.
    END.
    
    /* Verifica se o pedido existe */
    FIND PedidoCompra WHERE PedidoCompra.Id_Pedido = iPedido NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PedidoCompra THEN DO:
        cMsg = "ERRO: Pedido " + STRING(iPedido) + " nao encontrado.".
        RETURN.
    END.

    ASSIGN cResumo = "=== RESULTADO DO CONFERIMENTO ===" + CHR(10)
                   + "Pedido: " + STRING(iPedido) + " | Fornecedor: " + STRING(PedidoCompra.Id_Fornecedor) + CHR(10)
                   + "-----------------------------------" + CHR(10).
    
    /* Para cada item do pedido, busca o correspondente na NFe */
    FOR EACH ItemPedidoCompra WHERE ItemPedidoCompra.Id_Pedido = iPedido NO-LOCK:
        lAchouProdNFe = NO.
        
        FOR EACH ttItensNFe WHERE ttItensNFe.Id_Produto = ItemPedidoCompra.Id_Produto:
            lAchouProdNFe = YES.
            iMatches = iMatches + 1.
            
            /* Compara Quantidade */
            IF ttItensNFe.Quantidade <> ItemPedidoCompra.Quantidade THEN DO:
                iDivergencias = iDivergencias + 1.
                cResumo = cResumo + "[QTD] Prod " + STRING(ItemPedidoCompra.Id_Produto)
                        + ": Pedido=" + STRING(ItemPedidoCompra.Quantidade)
                        + " | NFe=" + STRING(ttItensNFe.Quantidade) + CHR(10).
            END.
            
            /* Compara Preco Unitario */
            IF ttItensNFe.ValorUnitario <> ItemPedidoCompra.Preco_Unit THEN DO:
                iDivergencias = iDivergencias + 1.
                cResumo = cResumo + "[PRECO] Prod " + STRING(ItemPedidoCompra.Id_Produto)
                        + ": Pedido=" + STRING(ItemPedidoCompra.Preco_Unit)
                        + " | NFe=" + STRING(ttItensNFe.ValorUnitario) + CHR(10).
            END.
        END. /* FOR EACH ttItensNFe */
        
        IF NOT lAchouProdNFe THEN DO:
            iDivergencias = iDivergencias + 1.
            cResumo = cResumo + "[FALTANDO] Prod " + STRING(ItemPedidoCompra.Id_Produto) 
                    + " esta no Pedido mas NAO na NFe!" + CHR(10).
        END.
    END. /* FOR EACH ItemPedidoCompra */
    
    /* Verifica itens na NFe que NAO estao no pedido */
    FOR EACH ttItensNFe:
        FIND FIRST ItemPedidoCompra WHERE ItemPedidoCompra.Id_Pedido = iPedido
                                      AND ItemPedidoCompra.Id_Produto = ttItensNFe.Id_Produto NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ItemPedidoCompra THEN DO:
            iDivergencias = iDivergencias + 1.
            cResumo = cResumo + "[EXTRA] Prod " + STRING(ttItensNFe.Id_Produto) 
                    + " (" + ttItensNFe.Descricao + ") esta na NFe mas NAO no Pedido!" + CHR(10).
        END.
    END.
    
    /* Monta resumo final */
    cResumo = cResumo + "-----------------------------------" + CHR(10)
            + "Itens conferidos: " + STRING(iMatches) + " | Divergencias: " + STRING(iDivergencias).
    
    IF iDivergencias = 0 THEN
        cResumo = cResumo + CHR(10) + "CONFERIMENTO OK - Tudo batendo!".
    ELSE
        cResumo = cResumo + CHR(10) + "ATENCAO: Existem divergencias a resolver.".
    
    cCabecalho = cResumo.
    cMsg = "SUCESSO".
END.

/* ============================================================ */
/* Acao: EFETIVAR - Gravar NFe + Estoque + Contas a Pagar       */
/* pcCaminho contem: ChaveAcesso|NumeroNF|NomeForne|Total|IdPed */
/* ============================================================ */
ELSE IF pcAcao = "EFETIVAR" THEN DO:
    DEFINE VARIABLE cChave     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iNumNF     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cForne     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dTotal     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE iIdPedido  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iIdForne   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iNextTit   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iItens     AS INTEGER   NO-UNDO.
    
    /* Decompoe os parametros do cabecalho */
    IF NUM-ENTRIES(pcCaminho, "|") < 4 THEN DO:
        cMsg = "ERRO: Dados do cabecalho incompletos para efetivacao.".
        RETURN.
    END.
    
    ASSIGN cChave = ENTRY(1, pcCaminho, "|")
           cForne = ENTRY(3, pcCaminho, "|").
    iNumNF = INTEGER(ENTRY(2, pcCaminho, "|")) NO-ERROR.
    dTotal = DECIMAL(ENTRY(4, pcCaminho, "|")) NO-ERROR.
    
    IF NUM-ENTRIES(pcCaminho, "|") >= 5 THEN
        iIdPedido = INTEGER(ENTRY(5, pcCaminho, "|")) NO-ERROR.
    
    /* Verifica se ja nao existe essa NFe no banco */
    FIND NotaFiscal WHERE NotaFiscal.ChaveAcesso = cChave NO-LOCK NO-ERROR.
    IF AVAILABLE NotaFiscal THEN DO:
        cMsg = "ERRO: Esta NFe (Chave " + cChave + ") ja foi efetivada anteriormente!".
        RETURN.
    END.
    
    /* Busca o fornecedor pelo nome para pegar o ID */
    FIND FIRST Fornecedor WHERE Fornecedor.Razao_Social = cForne NO-LOCK NO-ERROR.
    IF AVAILABLE Fornecedor THEN
        iIdForne = Fornecedor.Id_Fornecedor.
    ELSE
        iIdForne = 0.
    
    /* ======================== */
    /* TRANSACAO PRINCIPAL      */
    /* ======================== */
    DO TRANSACTION ON ERROR UNDO, RETURN:
    
        /* 1) Gravar Cabecalho da NFe */
        CREATE NotaFiscal.
        ASSIGN NotaFiscal.ChaveAcesso     = cChave
               NotaFiscal.NumeroNF        = iNumNF
               NotaFiscal.Serie           = 1
               NotaFiscal.Id_Fornecedor   = iIdForne
               NotaFiscal.Id_PedidoCompra = iIdPedido
               NotaFiscal.DataEmissao     = TODAY
               NotaFiscal.DataEntrada     = TODAY
               NotaFiscal.ValorTotal      = dTotal
               NotaFiscal.StatusNFe      = "EFETIVADA".
        
        /* 2) Gravar Itens + Atualizar Estoque */
        FOR EACH ttItensNFe:
            iItens = iItens + 1.
            
            /* Grava o item na tabela permanente */
            CREATE ItemNotaFiscal.
            ASSIGN ItemNotaFiscal.ChaveAcesso   = cChave
                   ItemNotaFiscal.Sequencia      = ttItensNFe.Sequencia
                   ItemNotaFiscal.Id_Produto     = ttItensNFe.Id_Produto
                   ItemNotaFiscal.Quantidade     = ttItensNFe.Quantidade
                   ItemNotaFiscal.ValorUnitario  = ttItensNFe.ValorUnitario
                   ItemNotaFiscal.ValorTotal     = ttItensNFe.ValorTotal.
            
            /* Atualiza o estoque do produto */
            FIND Produto WHERE Produto.Id_Produto = ttItensNFe.Id_Produto EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Produto THEN
                ASSIGN Produto.Quantidade_Estoque = Produto.Quantidade_Estoque + ttItensNFe.Quantidade.
        END. /* FOR EACH ttItensNFe */
        
        /* 3) Gerar Contas a Pagar */
        FIND LAST ContasPagar NO-LOCK NO-ERROR.
        iNextTit = (IF AVAILABLE ContasPagar THEN ContasPagar.Id_Titulo + 1 ELSE 1).
        
        CREATE ContasPagar.
        ASSIGN ContasPagar.Id_Titulo       = iNextTit
               ContasPagar.Id_Fornecedor   = iIdForne
               ContasPagar.ChaveAcessoNFe  = cChave
               ContasPagar.NumeroNF        = iNumNF
               ContasPagar.DataEmissao     = TODAY
               ContasPagar.DataVencimento  = TODAY + 30  /* Prazo padrao 30 dias */
               ContasPagar.ValorOriginal   = dTotal
               ContasPagar.ValorPago       = 0
               ContasPagar.StatusTitulo   = "ABERTO".
    
    END. /* TRANSACTION */
    
    cCabecalho = "NFe " + STRING(iNumNF) + " efetivada com " + STRING(iItens) + " itens."
               + CHR(10) + "Estoque atualizado!"
               + CHR(10) + "Contas a Pagar #" + STRING(iNextTit) + " gerada (Venc: " + STRING(TODAY + 30, "99/99/9999") + ")".
    cMsg = "SUCESSO".
END.
