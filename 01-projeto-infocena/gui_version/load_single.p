/* Carregar em modo single-user + diagnostico */
DEFINE VARIABLE lNFe  AS LOGICAL NO-UNDO.
DEFINE VARIABLE lItem AS LOGICAL NO-UNDO.
DEFINE VARIABLE lCP   AS LOGICAL NO-UNDO.

/* Verifica antes */
FIND _File WHERE _File._File-Name = "NotaFiscal" NO-LOCK NO-ERROR.
lNFe = AVAILABLE _File.
FIND _File WHERE _File._File-Name = "ItemNotaFiscal" NO-LOCK NO-ERROR.
lItem = AVAILABLE _File.
FIND _File WHERE _File._File-Name = "ContasPagar" NO-LOCK NO-ERROR.
lCP = AVAILABLE _File.

OUTPUT TO "load_result.txt".
PUT UNFORMATTED "ANTES: NotaFiscal=" + STRING(lNFe) 
  + " ItemNotaFiscal=" + STRING(lItem) 
  + " ContasPagar=" + STRING(lCP) SKIP.

IF NOT lNFe OR NOT lItem OR NOT lCP THEN DO:
    PUT UNFORMATTED "Carregando all_nfe_tables.df..." SKIP.
    RUN prodict/load_df.p ("../data/all_nfe_tables.df").
    
    FIND _File WHERE _File._File-Name = "NotaFiscal" NO-LOCK NO-ERROR.
    lNFe = AVAILABLE _File.
    FIND _File WHERE _File._File-Name = "ItemNotaFiscal" NO-LOCK NO-ERROR.
    lItem = AVAILABLE _File.
    FIND _File WHERE _File._File-Name = "ContasPagar" NO-LOCK NO-ERROR.
    lCP = AVAILABLE _File.
    
    PUT UNFORMATTED "DEPOIS: NotaFiscal=" + STRING(lNFe) 
      + " ItemNotaFiscal=" + STRING(lItem) 
      + " ContasPagar=" + STRING(lCP) SKIP.
END.
ELSE
    PUT UNFORMATTED "Todas tabelas ja existem!" SKIP.

OUTPUT CLOSE.
QUIT.
