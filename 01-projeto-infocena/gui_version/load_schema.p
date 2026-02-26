/* load_schema.p - Carrega arquivo .df via linha de comando usando SESSION:PARAMETER */
DEFINE VARIABLE cDF AS CHARACTER NO-UNDO.

ASSIGN cDF = SESSION:PARAMETER.

IF cDF = "" OR cDF = ? THEN DO:
    MESSAGE "Nenhum arquivo .df informado via -param!" VIEW-AS ALERT-BOX ERROR.
    QUIT.
END.

/* Tenta carregar o arquivo .df */
RUN prodict/load_df.p (INPUT cDF).

MESSAGE "Schema atualizado com sucesso: " cDF VIEW-AS ALERT-BOX INFORMATION.
QUIT.
