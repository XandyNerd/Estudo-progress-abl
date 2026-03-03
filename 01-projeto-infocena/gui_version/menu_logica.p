/* logica_menu.p */
DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pAcao        AS CHARACTER NO-UNDO.

/*
 * Menu Actions Controller
 * Recebe o clique do usuario na Interface_Menu.w e processa a regra de negocio
 */

/* Variaveis para controle de tela modular */
DEFINE VARIABLE iState  AS INTEGER NO-UNDO.
DEFINE VARIABLE iWidth  AS INTEGER NO-UNDO.
DEFINE VARIABLE iHeight AS INTEGER NO-UNDO.
DEFINE VARIABLE iX      AS INTEGER NO-UNDO.
DEFINE VARIABLE iY      AS INTEGER NO-UNDO.

CASE pAcao:
    WHEN "SUPRIMENTOS" THEN DO:
        MESSAGE "Modulo de SUPRIMENTOS em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "QUALIDADE" THEN DO:
        MESSAGE "Modulo de QUALIDADE em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "MANUFATURA" THEN DO:
        MESSAGE "Modulo de MANUFATURA em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "SERVICOS" THEN DO:
        MESSAGE "Modulo de SERVICOS em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "COMERCIAL" THEN DO:
        MESSAGE "Modulo de COMERCIAL em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "FINANCAS" THEN DO:
        /* Redireciona para a nova interface modular */
        RUN interface_financas.w (INPUT pUsuarioNome, 
                                  INPUT-OUTPUT iState, 
                                  INPUT-OUTPUT iWidth, 
                                  INPUT-OUTPUT iHeight, 
                                  INPUT-OUTPUT iX, 
                                  INPUT-OUTPUT iY) NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN
            MESSAGE "Erro ao carregar Interface de Financas. Verifique se o arquivo existe." VIEW-AS ALERT-BOX ERROR.
    END.
    
    WHEN "CONTROLLER" THEN DO:
        MESSAGE "Modulo de CONTROLADORIA E CUSTOS em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "ORGANIZACIONAL" THEN DO:
        MESSAGE "Modulo de ORGANIZACIONAL em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "TECNOLOGIA" THEN DO:
        MESSAGE "Modulo de INTEGRACAO E TECNOLOGIA em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "SOLUCOES" THEN DO:
        MESSAGE "Modulo de SOLUCOES INTEGRADAS em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    OTHERWISE DO:
        MESSAGE "Acao invalida ou nao implementada: " + pAcao VIEW-AS ALERT-BOX ERROR.
    END.
END CASE.
