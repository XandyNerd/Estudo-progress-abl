/* produtos_logica.p */
DEFINE INPUT PARAMETER pAcao        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pId          AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pDescricao   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pUnidade     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCodBarras   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCusto       AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pVenda       AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pNCM         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCEST        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pMarca       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pEstoqueMin  AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pAtivo       AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER pURLImagem   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pMessage    AS CHARACTER NO-UNDO.

IF pAcao = "SALVAR" THEN DO ON ERROR UNDO, THROW:
    DEFINE VARIABLE iProxID AS INTEGER NO-UNDO.

    DO TRANSACTION ON ERROR UNDO, THROW:
        /* Atualização de Registro Existente */
        IF pId <> 0 THEN DO:
            FIND FIRST Produto WHERE Produto.Id_Produto = pId EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Produto THEN DO:
                pMessage = "ERRO: Produto não encontrado para atualização.".
                RETURN.
            END.
        END.
        /* Inserção de Novo Registro */
        ELSE DO:
            FIND LAST Produto USE-INDEX idx_IdProduto NO-LOCK NO-ERROR.
            iProxID = (IF AVAILABLE Produto THEN Produto.Id_Produto + 1 ELSE 1).
            CREATE Produto.
            ASSIGN Produto.Id_Produto = iProxID.
        END.

        /* Atribuição de Campos */
        ASSIGN Produto.Descricao    = pDescricao
               Produto.Unidade      = pUnidade
               Produto.Cod_Barras   = pCodBarras
               Produto.Preco_Custo  = pCusto
               Produto.Preco_Venda  = pVenda
               Produto.NCM          = pNCM
               Produto.CEST         = pCEST
               Produto.Marca        = pMarca
               Produto.Estoque_Minimo = pEstoqueMin
               Produto.Ativo        = pAtivo
               Produto.URL_Imagem   = pURLImagem.

        /* Tratamento de Imagem: Se for um caminho de arquivo valido, anexa ao Banco de Dados (BLOB) */
        IF pURLImagem <> "" AND SEARCH(pURLImagem) <> ? THEN DO:
            /* Copia o arquivo fisico para o campo BLOB do registro */
            COPY-LOB FROM FILE pURLImagem TO Produto.Foto_Blob NO-ERROR.
            
            IF ERROR-STATUS:ERROR THEN DO:
                pMessage = "AVISO: Registro salvo, mas erro ao anexar imagem: " + ERROR-STATUS:GET-MESSAGE(1).
            END.
        END.
    END.
    pMessage = "SUCESSO".

    CATCH e AS Progress.Lang.Error:
        pMessage = "ERRO AO SALVAR: " + e:GetMessage(1).
    END CATCH.
END.
ELSE IF pAcao = "EXCLUIR" THEN DO ON ERROR UNDO, THROW:
    IF pId <> 0 THEN DO TRANSACTION ON ERROR UNDO, THROW:
        FIND FIRST Produto WHERE Produto.Id_Produto = pId EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE Produto THEN DO:
            DELETE Produto.
            pMessage = "SUCESSO".
        END.
        ELSE DO:
            pMessage = "ERRO: Produto não encontrado para exclusão.".
        END.
    END.
    ELSE pMessage = "ERRO: Nenhum ID informado.".

    CATCH e AS Progress.Lang.Error:
        pMessage = "ERRO AO EXCLUIR: " + e:GetMessage(1).
    END CATCH.
END.
