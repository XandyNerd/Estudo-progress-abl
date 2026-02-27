/* api_usage_control.p */
DEFINE INPUT PARAMETER pAcao AS CHARACTER NO-UNDO. /* CHECK, DECREMENT */
DEFINE OUTPUT PARAMETER iRestante AS INTEGER NO-UNDO.

DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE dData AS DATE      NO-UNDO.
DEFINE VARIABLE iCont  AS INTEGER     NO-UNDO.

cFile = "api_usage.dat".
iRestante = 0.

/*ELA VERIFICA QUANTOS USOS DA API JÁ FORAM FEITOS NO DIA*/

/* Tenta ler o estado atual */
FILE-INFO:FILE-NAME = cFile.
IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:
    INPUT FROM VALUE(cFile).
    IMPORT dData iCont.
    INPUT CLOSE.
END.
ELSE DO:
    /* Se nao existe, inicializa */
    dData = TODAY.
    iCont = 25.
END.

/* Reset Diario */
IF dData <> TODAY THEN DO:
    dData = TODAY.
    iCont = 25.
END.

IF pAcao = "CHECK" THEN DO:
    iRestante = iCont.
END.
ELSE IF pAcao = "DECREMENT" THEN DO:
    IF iCont > 0 THEN iCont = iCont - 1.
    iRestante = iCont.
END.

/* Salva o estado */
OUTPUT TO VALUE(cFile).
EXPORT dData iCont.
OUTPUT CLOSE.
