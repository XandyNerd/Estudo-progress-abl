OUTPUT TO "01-projeto-infocena/carga_log_banco.txt".

CONNECT -db 01-projeto-infocena/data/infocena -1 NO-ERROR.

IF CONNECTED("infocena") THEN DO:
    PUT UNFORMATTED "Iniciando carga..." SKIP.

    /* Propath setup para garantir que acha as rotinas de dicionario */
    PROPATH = PROPATH + ",C:\Progress\OpenEdge\gui,C:\Progress\OpenEdge\tty".

    CREATE ALIAS DICTDB FOR DATABASE infocena.
    
    /* Usa o utilitario oficial de silent load do Progress com caminho correto */
    RUN prodict/load_df.p (INPUT "01-projeto-infocena/backend/database/venda.df") NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        PUT UNFORMATTED "Erro interno no Progress ao rodar load_df.p:" SKIP.
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
            PUT UNFORMATTED ERROR-STATUS:GET-MESSAGE(i) SKIP.
        END.
    END.
    ELSE DO:
        PUT UNFORMATTED "Sem erros de compilacao no script de carga." SKIP.
    END.

    DISCONNECT infocena.
END.
ELSE DO:
    PUT UNFORMATTED "Falha ao conectar: " + ERROR-STATUS:GET-MESSAGE(1) SKIP.
END.

OUTPUT CLOSE.
QUIT.
