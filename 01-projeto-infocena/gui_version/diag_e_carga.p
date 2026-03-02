/* Diagnostico + Carga das tabelas NFe */
DEFINE VARIABLE cTabelas AS CHARACTER NO-UNDO.
DEFINE VARIABLE lNFe     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lItem    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCP      AS LOGICAL   NO-UNDO.

/* 1) Verificar quais tabelas ja existem */
FIND _File WHERE _File._File-Name = "NotaFiscal" NO-LOCK NO-ERROR.
lNFe = AVAILABLE _File.

FIND _File WHERE _File._File-Name = "ItemNotaFiscal" NO-LOCK NO-ERROR.
lItem = AVAILABLE _File.

FIND _File WHERE _File._File-Name = "ContasPagar" NO-LOCK NO-ERROR.
lCP = AVAILABLE _File.

cTabelas = "NotaFiscal: " + STRING(lNFe, "SIM/NAO")
         + " | ItemNotaFiscal: " + STRING(lItem, "SIM/NAO")
         + " | ContasPagar: " + STRING(lCP, "SIM/NAO").

MESSAGE "Tabelas existentes ANTES:" + CHR(10) + cTabelas VIEW-AS ALERT-BOX.

/* 2) Se alguma tabela falta, carrega o .df combinado */
IF NOT lNFe OR NOT lItem OR NOT lCP THEN DO:
    MESSAGE "Carregando tabelas faltantes..." VIEW-AS ALERT-BOX.
    RUN prodict/load_df.p ("../data/all_nfe_tables.df") NO-ERROR.
    
    /* Re-verificar */
    FIND _File WHERE _File._File-Name = "NotaFiscal" NO-LOCK NO-ERROR.
    lNFe = AVAILABLE _File.
    FIND _File WHERE _File._File-Name = "ItemNotaFiscal" NO-LOCK NO-ERROR.
    lItem = AVAILABLE _File.
    FIND _File WHERE _File._File-Name = "ContasPagar" NO-LOCK NO-ERROR.
    lCP = AVAILABLE _File.
    
    cTabelas = "NotaFiscal: " + STRING(lNFe, "SIM/NAO")
             + " | ItemNotaFiscal: " + STRING(lItem, "SIM/NAO")
             + " | ContasPagar: " + STRING(lCP, "SIM/NAO").
    MESSAGE "Tabelas DEPOIS da carga:" + CHR(10) + cTabelas VIEW-AS ALERT-BOX.
END.
ELSE
    MESSAGE "Todas as tabelas ja existem! Nenhuma acao necessaria." VIEW-AS ALERT-BOX.

QUIT.
