/*------------------------------------------------------------------------
    File: estoque_logica.p
    Description: Logica de Negocios para Gestao de Estoque
------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcAcao       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piTotalItens AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pdValorTotal AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcMensagem   AS CHARACTER NO-UNDO.

IF pcAcao = "CALCULAR_RESUMO" THEN DO:
    ASSIGN piTotalItens = 0
           pdValorTotal = 0.
    
    FOR EACH Produto NO-LOCK:
        piTotalItens = piTotalItens + 1.
        pdValorTotal = pdValorTotal + (Produto.Quantidade_Estoque * Produto.Preco_Custo).
    END.
    pcMensagem = "SUCESSO".
END.
ELSE pcMensagem = "Acao invalida em estoque_logica.p".
