OUTPUT TO "load_log.txt".
PUT UNFORMATTED "=== Carregar ContasPagar ===" SKIP.
RUN prodict/load_df.p ("../data/contaspagar_schema.df") NO-ERROR.
IF ERROR-STATUS:ERROR THEN
    PUT UNFORMATTED "  ERRO: " + ERROR-STATUS:GET-MESSAGE(1) SKIP.
ELSE
    PUT UNFORMATTED "  OK!" SKIP.
PUT UNFORMATTED "=== Fim ===" SKIP.
OUTPUT CLOSE.
MESSAGE "Pronto!" VIEW-AS ALERT-BOX.
QUIT.
