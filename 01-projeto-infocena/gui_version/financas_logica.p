/* financas_logica.p */
DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pAcao        AS CHARACTER NO-UNDO.

/* 
 * Finanças Business Logic
 * Centraliza as regras de faturamento e financeiro
 */

/* Variaveis para controle de tela modular */
DEFINE VARIABLE iState  AS INTEGER NO-UNDO.
DEFINE VARIABLE iWidth  AS INTEGER NO-UNDO.
DEFINE VARIABLE iHeight AS INTEGER NO-UNDO.
DEFINE VARIABLE iX      AS INTEGER NO-UNDO.
DEFINE VARIABLE iY      AS INTEGER NO-UNDO.
DEFINE VARIABLE cMsg    AS CHARACTER NO-UNDO.

CASE pAcao:
    WHEN "FATURAMENTO" THEN DO:
        MESSAGE "O Faturamento foi movido para o Módulo Comercial." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "FISCAL" THEN DO:
        /* Agora controlado internamente por Frames na interface_financas.w */
    END.
    
    WHEN "RECEBER" THEN DO:
        MESSAGE "Abrindo Contas a Receber..." VIEW-AS ALERT-BOX INFORMATION.
    END.
END CASE.
