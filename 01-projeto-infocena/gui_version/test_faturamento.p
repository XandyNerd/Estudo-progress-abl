/* test_faturamento_fase1.p */
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE TEMP-TABLE ttItens LIKE ItemVenda. /* Tabela dummy apenas para passar parametro */

/* Vamos simular o faturamento do Pedido 1 */
RUN logica_vendas.p (INPUT "FATURAR_PEDIDO", INPUT 1, INPUT-OUTPUT TABLE ttItens, OUTPUT cMsg, INPUT 0).

MESSAGE "Resultado da Inteligencia Fiscal: " SKIP cMsg VIEW-AS ALERT-BOX INFORMATION.
QUIT.
