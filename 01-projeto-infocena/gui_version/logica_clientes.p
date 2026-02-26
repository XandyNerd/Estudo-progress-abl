/* logica_clientes.p */
DEFINE INPUT        PARAMETER pAcao     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pCod      AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pNome     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pCNPJ     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pCidade   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pEstado   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pLimite   AS DECIMAL   NO-UNDO.

/* Conexao Preventiva */
IF NOT CONNECTED("infocena") THEN 
    CONNECT "..\data\infocena.db" -1.

CASE pAcao:
    
    WHEN "SALVAR" THEN DO:
        
        IF pNome = "" OR pCNPJ = "" THEN DO:
            MESSAGE "Nome e CNPJ sao campos obrigatorios!" VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.

        /* Se Codigo for 0, e novo registro */
        IF pCod = 0 THEN DO:
            FIND LAST Cliente NO-LOCK NO-ERROR.
            pCod = (IF AVAILABLE Cliente THEN Cliente.CodCliente + 1 ELSE 1).
            
            CREATE Cliente.
            ASSIGN Cliente.CodCliente = pCod.
        END.
        ELSE DO:
            FIND FIRST Cliente WHERE Cliente.CodCliente = pCod EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Cliente THEN DO:
                MESSAGE "Erro ao localizar cliente para edicao!" VIEW-AS ALERT-BOX ERROR.
                RETURN.
            END.
        END.

        ASSIGN Cliente.Nome          = pNome
               Cliente.CNPJ-CPF       = pCNPJ
               Cliente.Cidade        = pCidade
               Cliente.Estado        = pEstado
               Cliente.LimiteCredito = pLimite.
        
        RELEASE Cliente.
        MESSAGE "Cliente " + pNome + " salvo com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
    END.

    WHEN "EXCLUIR" THEN DO:
        FIND FIRST Cliente WHERE Cliente.CodCliente = pCod EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE Cliente THEN DO:
            DELETE Cliente.
            MESSAGE "Cliente excluido com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
        END.
    END.

END CASE.
