/* fiscal_logica.p */
DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pAcao        AS CHARACTER NO-UNDO.

/* 
 * Fiscal Business Logic
 * Centraliza as regras de impostos, NCM e CFOP
 */

CASE pAcao:
    WHEN "NCM" THEN DO:
        /* Abre a interface de cadastro de NCM */
        RUN interface_ncm.w (INPUT pUsuarioNome, 
                             INPUT-OUTPUT iState, 
                             INPUT-OUTPUT iWidth, 
                             INPUT-OUTPUT iHeight, 
                             INPUT-OUTPUT iX, 
                             INPUT-OUTPUT iY) NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN
            MESSAGE "Erro ao carregar Interface de NCM." VIEW-AS ALERT-BOX ERROR.
    END.
    
    WHEN "CFOP" THEN DO:
        /* Abre a interface de consulta de CFOP */
        RUN interface_cfop.w (INPUT pUsuarioNome, 
                              INPUT-OUTPUT iState, 
                              INPUT-OUTPUT iWidth, 
                              INPUT-OUTPUT iHeight, 
                              INPUT-OUTPUT iX, 
                              INPUT-OUTPUT iY) NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN
            MESSAGE "Erro ao carregar Interface de CFOP." VIEW-AS ALERT-BOX ERROR.
    END.
    
    WHEN "REGRAS" THEN DO:
        /* Abre a interface de consulta de Regras Fiscais */
        RUN interface_regrafiscal.w (INPUT pUsuarioNome, 
                                     INPUT-OUTPUT iState, 
                                     INPUT-OUTPUT iWidth, 
                                     INPUT-OUTPUT iHeight, 
                                     INPUT-OUTPUT iX, 
                                     INPUT-OUTPUT iY) NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN
            MESSAGE "Erro ao carregar Interface de Regras Fiscais." VIEW-AS ALERT-BOX ERROR.
    END.
    
    WHEN "CARGA_DADOS" THEN DO:
        RUN carga_fiscal_dados.p (INPUT pUsuarioNome).
    END.
END CASE.
