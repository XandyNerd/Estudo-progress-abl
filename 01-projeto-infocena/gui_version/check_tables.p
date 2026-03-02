/* Verifica se as tabelas NFe existem */
DEFINE VARIABLE cTabelas AS CHARACTER NO-UNDO.

FIND FIRST NotaFiscal NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR THEN
    cTabelas = "NotaFiscal: NAO EXISTE!".
ELSE
    cTabelas = "NotaFiscal: OK".

FIND FIRST ContasPagar NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR THEN
    cTabelas = cTabelas + " | ContasPagar: NAO EXISTE!".
ELSE
    cTabelas = cTabelas + " | ContasPagar: OK".

MESSAGE cTabelas VIEW-AS ALERT-BOX.
QUIT.
