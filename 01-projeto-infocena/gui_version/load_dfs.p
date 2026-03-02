/* Recarregar schemas - com log de erros detalhado */
OUTPUT TO "load_log.txt".

PUT UNFORMATTED "=== Inicio da carga: " + STRING(TODAY) + " ===" SKIP.

PUT UNFORMATTED "Carregando nfe_schema.df..." SKIP.
RUN prodict/load_df.p ("../data/nfe_schema.df") NO-ERROR.
IF ERROR-STATUS:ERROR THEN
    PUT UNFORMATTED "  ERRO: " + ERROR-STATUS:GET-MESSAGE(1) SKIP.
ELSE
    PUT UNFORMATTED "  OK!" SKIP.

PUT UNFORMATTED "Carregando financeiro_schema.df..." SKIP.
RUN prodict/load_df.p ("../data/financeiro_schema.df") NO-ERROR.
IF ERROR-STATUS:ERROR THEN
    PUT UNFORMATTED "  ERRO: " + ERROR-STATUS:GET-MESSAGE(1) SKIP.
ELSE
    PUT UNFORMATTED "  OK!" SKIP.

PUT UNFORMATTED "Carregando update_produto_estoque.df..." SKIP.
RUN prodict/load_df.p ("../data/update_produto_estoque.df") NO-ERROR.
IF ERROR-STATUS:ERROR THEN
    PUT UNFORMATTED "  ERRO: " + ERROR-STATUS:GET-MESSAGE(1) SKIP.
ELSE
    PUT UNFORMATTED "  OK!" SKIP.

PUT UNFORMATTED "=== Fim da carga ===" SKIP.
OUTPUT CLOSE.

MESSAGE "Carga completa! Verifique load_log.txt" VIEW-AS ALERT-BOX.
QUIT.
