CONNECT -db data/infocena -1 NO-ERROR.
IF NOT CONNECTED("infocena") THEN CONNECT -db data/infocena -S 20000 -H localhost NO-ERROR.

IF CONNECTED("infocena") THEN DO:
    FIND FIRST Venda NO-LOCK NO-ERROR.
    OUTPUT TO "teste_venda_db.txt".
    PUT UNFORMATTED "Acesso ok" SKIP.
    OUTPUT CLOSE.
    DISCONNECT infocena.
END.
QUIT.
