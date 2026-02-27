/* utils_validacao.p */
/* Contem funcoes de validacao de documentos brasileiros */

DEFINE INPUT PARAMETER pcAcao  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcValor AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER plOk    AS LOGICAL   NO-UNDO INITIAL FALSE.

/* Funcao de validacao de CNPJ - Definida antes do bloco de execucao */
FUNCTION validarCNPJ RETURNS LOGICAL (pcCNPJ AS CHARACTER):
    DEFINE VARIABLE iSum    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRem    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iDigit1 AS INTEGER NO-UNDO.
    DEFINE VARIABLE iDigit2 AS INTEGER NO-UNDO.
    DEFINE VARIABLE cDigits AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i       AS INTEGER NO-UNDO.

    /* Limpa caracteres nao numericos */
    cDigits = "".
    DO i = 1 TO LENGTH(pcCNPJ):
        IF SUBSTRING(pcCNPJ, i, 1) >= "0" AND SUBSTRING(pcCNPJ, i, 1) <= "9" THEN
            cDigits = cDigits + SUBSTRING(pcCNPJ, i, 1).
    END.

    /* CNPJ deve ter 14 digitos */
    IF LENGTH(cDigits) <> 14 THEN RETURN FALSE.

    /* Evita sequencias repetidas (11111111111111, etc) */
    IF cDigits = FILL(SUBSTRING(cDigits,1,1), 14) THEN RETURN FALSE.

    /* Calculo do Primeiro Digito */
    iSum = 0.
    /* Pesos: 5,4,3,2,9,8,7,6,5,4,3,2 */
    ASSIGN
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 1, 1)) * 5
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 2, 1)) * 4
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 3, 1)) * 3
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 4, 1)) * 2
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 5, 1)) * 9
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 6, 1)) * 8
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 7, 1)) * 7
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 8, 1)) * 6
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 9, 1)) * 5
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 10, 1)) * 4
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 11, 1)) * 3
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 12, 1)) * 2.

    iRem = iSum MOD 11.
    iDigit1 = (IF iRem < 2 THEN 0 ELSE 11 - iRem).
    
    IF iDigit1 <> INTEGER(SUBSTRING(cDigits, 13, 1)) THEN RETURN FALSE.

    /* Calculo do Segundo Digito */
    iSum = 0.
    /* Pesos: 6,5,4,3,2,9,8,7,6,5,4,3,2 */
    ASSIGN
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 1, 1)) * 6
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 2, 1)) * 5
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 3, 1)) * 4
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 4, 1)) * 3
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 5, 1)) * 2
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 6, 1)) * 9
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 7, 1)) * 8
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 8, 1)) * 7
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 9, 1)) * 6
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 10, 1)) * 5
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 11, 1)) * 4
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 12, 1)) * 3
        iSum = iSum + INTEGER(SUBSTRING(cDigits, 13, 1)) * 2.

    iRem = iSum MOD 11.
    iDigit2 = (IF iRem < 2 THEN 0 ELSE 11 - iRem).

    if iDigit2 <> INTEGER(SUBSTRING(cDigits, 14, 1)) THEN RETURN FALSE.

    RETURN TRUE.
END FUNCTION.

/* Bloco principal de execucao */
IF pcAcao = "VALIDAR_CNPJ" THEN DO:
    plOk = validarCNPJ(pcValor).
END.
