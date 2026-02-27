/* fornecedores_logica.p */
DEFINE INPUT PARAMETER pAcao        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pId          AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pRazaoSocial AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pFantasia    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCNPJ        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pEmail       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pTelefone    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pEndereco    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pNumero      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pComp        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pBairro      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCidade      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pEstado      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCEP         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pRef         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pMessage    AS CHARACTER NO-UNDO.


/* Responsavel por salvar e excluir fornecedores */

IF pAcao = "SALVAR" THEN DO:
    DEFINE VARIABLE iProxID AS INTEGER NO-UNDO.

    DO TRANSACTION ON ERROR UNDO, RETURN:
        IF pId <> 0 THEN DO:
            FIND FIRST Fornecedor WHERE Fornecedor.Id_Fornecedor = pId EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Fornecedor THEN DO:
                pMessage = "ERRO: Fornecedor nao encontrado para atualizacao.".
                RETURN.
            END.
        END.
        ELSE DO:
            FIND LAST Fornecedor USE-INDEX idx_IdFornecedor NO-LOCK NO-ERROR.
            iProxID = (IF AVAILABLE Fornecedor THEN Fornecedor.Id_Fornecedor + 1 ELSE 1).
            CREATE Fornecedor.
            ASSIGN Fornecedor.Id_Fornecedor = iProxID.
        END.

        ASSIGN Fornecedor.Razao_Social  = pRazaoSocial
               Fornecedor.Nome_Fantasia = pFantasia
               Fornecedor.CNPJ          = pCNPJ
               Fornecedor.Email         = pEmail
               Fornecedor.Telefone      = pTelefone
               Fornecedor.Endereco      = pEndereco
               Fornecedor.Numero        = pNumero
               Fornecedor.Complemento   = pComp
               Fornecedor.Bairro        = pBairro
               Fornecedor.Cidade        = pCidade
               Fornecedor.Estado        = pEstado
               Fornecedor.CEP           = pCEP
               Fornecedor.PontoReferencia = pRef.
    END.
    pMessage = "SUCESSO".
END.
ELSE IF pAcao = "EXCLUIR" THEN DO:
    IF pId <> 0 THEN DO TRANSACTION ON ERROR UNDO, RETURN:
        FIND FIRST Fornecedor WHERE Fornecedor.Id_Fornecedor = pId EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE Fornecedor THEN DO:
            DELETE Fornecedor.
            pMessage = "SUCESSO".
        END.
        ELSE DO:
            pMessage = "ERRO: Fornecedor nao encontrado para exclusao.".
        END.
    END.
    ELSE pMessage = "ERRO: Nenhum ID informado para exclusao.".
END.
