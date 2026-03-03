/* carga_fiscal_completa.p - Carga automatica da Matriz de ICMS saindo de SP */

DEFINE VARIABLE cUFs7  AS CHARACTER INITIAL "AC,AM,AP,PA,RO,RR,TO,AL,BA,CE,MA,PB,PE,PI,RN,SE,DF,GO,MT,MS,ES" NO-UNDO.
DEFINE VARIABLE cUFs12 AS CHARACTER INITIAL "MG,RJ,PR,RS,SC" NO-UNDO.
DEFINE VARIABLE i      AS INTEGER   NO-UNDO.
DEFINE VARIABLE cUF    AS CHARACTER NO-UNDO.

DO TRANSACTION:
    /* 1. Regra para São Paulo (Interno) */
    FIND RegraFiscal WHERE RegraFiscal.UF_Origem = "SP" AND RegraFiscal.UF_Destino = "SP" EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE RegraFiscal THEN CREATE RegraFiscal.
    ASSIGN RegraFiscal.UF_Origem  = "SP"
           RegraFiscal.UF_Destino = "SP"
           RegraFiscal.AliqICMS   = 18.00
           RegraFiscal.CodCFOP    = "5102".

    /* 2. Regras para Estados de 7% (Norte, NE, CO + ES) */
    DO i = 1 TO NUM-ENTRIES(cUFs7):
        cUF = ENTRY(i, cUFs7).
        FIND RegraFiscal WHERE RegraFiscal.UF_Origem = "SP" AND RegraFiscal.UF_Destino = cUF EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE RegraFiscal THEN CREATE RegraFiscal.
        ASSIGN RegraFiscal.UF_Origem  = "SP"
               RegraFiscal.UF_Destino = cUF
               RegraFiscal.AliqICMS   = 7.00
               RegraFiscal.CodCFOP    = "6102".
    END.

    /* 3. Regras para Estados de 12% (Sul e Sudeste exceto ES) */
    DO i = 1 TO NUM-ENTRIES(cUFs12):
        cUF = ENTRY(i, cUFs12).
        FIND RegraFiscal WHERE RegraFiscal.UF_Origem = "SP" AND RegraFiscal.UF_Destino = cUF EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE RegraFiscal THEN CREATE RegraFiscal.
        ASSIGN RegraFiscal.UF_Origem  = "SP"
               RegraFiscal.UF_Destino = cUF
               RegraFiscal.AliqICMS   = 12.00
               RegraFiscal.CodCFOP    = "6102".
    END.
END.

MESSAGE "Carga da Matriz de ICMS (Origem SP) concluida com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
