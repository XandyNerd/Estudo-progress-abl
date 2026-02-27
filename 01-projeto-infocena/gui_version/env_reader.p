/* env_reader.p */
DEFINE INPUT PARAMETER pKey   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pValue AS CHARACTER NO-UNDO.

DEFINE VARIABLE cLine  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPath  AS CHARACTER NO-UNDO.

pValue = "".
cPath = SEARCH("../.env"). /* Procura na raiz do projeto */

IF cPath = ? THEN cPath = SEARCH(".env").

IF cPath <> ? THEN DO:
    INPUT FROM VALUE(cPath).
    REPEAT:
        IMPORT UNFORMATTED cLine.
        IF cLine BEGINS pKey + "=" THEN DO:
            pValue = ENTRY(2, cLine, "=").
            LEAVE.
        END.
    END.
    INPUT CLOSE.
END.
ELSE DO:
    MESSAGE "AVISO: Arquivo .env nao encontrado!" VIEW-AS ALERT-BOX WARNING.
END.
