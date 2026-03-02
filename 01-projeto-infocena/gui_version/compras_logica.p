/* compras_logica.p */
DEFINE INPUT PARAMETER pAcao         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pIdPedido     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pIdForne      AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pDataPedido   AS DATE      NO-UNDO.
DEFINE INPUT PARAMETER pStatus       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCondPagto    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pComprador    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pTotalPedido  AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pQtd          AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pPrecoUnit    AS DECIMAL   NO-UNDO.

DEFINE OUTPUT PARAMETER pOutID       AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pOutNome     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pOutPreco    AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pOutEstMin   AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pOutEstAtu   AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pMessage     AS CHARACTER NO-UNDO.

/* Lógica central de Compras - Independente de Interface */

IF pAcao = "PROXIMO_ID" THEN DO:
    FIND LAST PedidoCompra NO-LOCK NO-ERROR.
    pOutID = (IF AVAILABLE PedidoCompra THEN PedidoCompra.Id_Pedido + 1 ELSE 1).
    pMessage = "SUCESSO".
END.

ELSE IF pAcao = "BUSCAR_FORNECEDOR" THEN DO:
    IF pIdForne = 0 THEN DO:
        pOutNome = "".
        pMessage = "ERRO: Informe um codigo de fornecedor.".
        RETURN.
    END.
    
    FIND Fornecedor WHERE Fornecedor.Id_Fornecedor = pIdForne NO-LOCK NO-ERROR.
    IF AVAILABLE Fornecedor THEN DO:
        pOutNome = Fornecedor.Razao_Social.
        pMessage = "SUCESSO".
    END.
    ELSE DO:
        pOutNome = "".
        pMessage = "ERRO: Fornecedor nao encontrado.".
    END.
END.

ELSE IF pAcao = "BUSCAR_PRODUTO" THEN DO:
    /* pIdPedido servirá como Id_Produto aqui para simplificar */
    FIND Produto WHERE Produto.Id_Produto = pIdPedido NO-LOCK NO-ERROR.
    IF AVAILABLE Produto THEN DO:
        ASSIGN pOutNome     = Produto.Descricao
               pOutPreco    = Produto.Preco_Custo
               pOutEstAtu   = 0 /* Campo customizado de saldo nao encontrado no .df atual */
               pOutEstMin   = Produto.Estoque_Minimo
               pMessage     = "SUCESSO".
    END.
    ELSE DO:
        ASSIGN pOutNome     = ""
               pOutPreco    = 0
               pOutEstAtu   = 0
               pOutEstMin   = 0
               pMessage     = "ERRO: Produto nao encontrado.".
    END.
END.

ELSE IF pAcao = "SALVAR_CABECALHO" THEN DO:
    IF pIdForne = 0 THEN DO:
        pMessage = "ERRO: Selecione um fornecedor para o pedido.".
        RETURN.
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN:
        FIND PedidoCompra WHERE PedidoCompra.Id_Pedido = pIdPedido EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE PedidoCompra THEN DO:
            CREATE PedidoCompra.
            ASSIGN PedidoCompra.Id_Pedido = pIdPedido.
        END.
        
        ASSIGN PedidoCompra.Id_Fornecedor = pIdForne
               PedidoCompra.Data_Pedido   = pDataPedido
               PedidoCompra.Status_Pedido = pStatus
               PedidoCompra.Condicao_Pagto = pCondPagto
               PedidoCompra.Comprador    = pComprador
               PedidoCompra.Total_Pedido = pTotalPedido.
    END.
    pMessage = "SUCESSO".
END.

ELSE IF pAcao = "SALVAR_ITEM" THEN DO:
    DO TRANSACTION ON ERROR UNDO, RETURN:
        FIND FIRST ItemPedidoCompra WHERE ItemPedidoCompra.Id_Pedido = pIdPedido 
                                     AND ItemPedidoCompra.Id_Produto = pIdForne EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ItemPedidoCompra THEN DO:
            CREATE ItemPedidoCompra.
            ASSIGN ItemPedidoCompra.Id_Pedido = pIdPedido
                   ItemPedidoCompra.Id_Produto = pIdForne.
        END.
        
        ASSIGN ItemPedidoCompra.Quantidade = pQtd
               ItemPedidoCompra.Preco_Unit = pPrecoUnit
               ItemPedidoCompra.Total_Item = ItemPedidoCompra.Quantidade * ItemPedidoCompra.Preco_Unit.
    END.
    pMessage = "SUCESSO".
END.

ELSE IF pAcao = "SINCRONIZAR_CUSTO" THEN DO:
    /* Sincroniza o preco de custo do cadastro conforme o pedido */
    IF pIdForne = 0 THEN RETURN.
    
    DO TRANSACTION ON ERROR UNDO, RETURN:
        FIND Produto WHERE Produto.Id_Produto = pIdForne EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE Produto THEN DO:
            ASSIGN Produto.Preco_Custo = pPrecoUnit.
            pMessage = "SUCESSO".
        END.
    END.
END.
