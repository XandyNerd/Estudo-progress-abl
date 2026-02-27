USING Progress.Json.ObjectModel.*.

DEFINE INPUT PARAMETER pEAN         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pDescricao  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pMarca      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pNCM        AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pCEST       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pURLImagem  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pUnidade    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pStatus     AS CHARACTER NO-UNDO.

DEFINE VARIABLE cToken     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCmd       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cJsonFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cImgFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE oParser    AS ObjectModelParser NO-UNDO.
DEFINE VARIABLE oBody      AS JsonObject NO-UNDO.
DEFINE VARIABLE lExists    AS LOGICAL NO-UNDO.

pStatus = "ERRO".
cJsonFile = SEARCH("api_res.json").
IF cJsonFile = ? THEN cJsonFile = "api_res.json".
cImgFile = "prod_temp.jpg".

/* API RESPONSALVEL POR FAZER A BUSCA DO PRODUTO!*/

/* 1. Busca Token do .env */
RUN env_reader.p (INPUT "API_KEY_FISCAL", OUTPUT cToken).

IF cToken = "" OR cToken = "SUA_CHAVE_AQUI" THEN DO:
    pStatus = "ERRO: Token de API nao configurado no arquivo .env".
    RETURN.
END.

/* 2. Remove arquivos temporarios antigos */
OS-DELETE VALUE(cJsonFile).
OS-DELETE VALUE(cImgFile).

/* 3. Chama o Proxy via PowerShell (Bypassa SSL do Progress) */
cCmd = "powershell -ExecutionPolicy Bypass -File api_fetcher.ps1 " + 
       "-ean " + pEAN + " -token " + cToken + 
       " -jsonPath " + cJsonFile + " -imgPath " + cImgFile.

OS-COMMAND SILENT VALUE(cCmd).

/* 4. Processa o Resultado */
FILE-INFO:FILE-NAME = cJsonFile.
IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
    pStatus = "ERRO: Ocorreu uma falha na comunicacao externa (PowerShell).".
    RETURN.
END.

oParser = NEW ObjectModelParser().
oBody = CAST(oParser:ParseFile(cJsonFile), JsonObject) NO-ERROR.

IF ERROR-STATUS:ERROR OR NOT VALID-OBJECT(oBody) THEN DO:
    /* Se falhou o parse, o arquivo pode conter a mensagem de erro do PowerShell ou da API */
    DEFINE VARIABLE cMsgErro AS LONGCHAR NO-UNDO.
    COPY-LOB FROM FILE cJsonFile TO cMsgErro NO-ERROR.
    
    IF cMsgErro MATCHES "*recurso solicitado nao existe*" OR cMsgErro MATCHES "*not found*" THEN 
        pStatus = "ERRO: Produto nao encontrado na base da Bluesoft.".
    ELSE IF cMsgErro <> "" THEN 
        pStatus = "ERRO API: " + TRIM(STRING(SUBSTRING(cMsgErro, 1, 100))).
    ELSE
        pStatus = "ERRO na API: Resposta invalida ou Produto nao encontrado.".
    RETURN.
END.

IF oBody:Has("description") THEN DO:
    ASSIGN pDescricao = oBody:GetCharacter("description")
           pMarca     = (IF oBody:Has("brand") THEN oBody:GetJsonObject("brand"):GetCharacter("name") ELSE "")
           pNCM       = (IF oBody:Has("ncm") THEN oBody:GetJsonObject("ncm"):GetCharacter("code") ELSE "")
           pCEST      = (IF oBody:Has("cest") THEN oBody:GetJsonObject("cest"):GetCharacter("code") ELSE "")
           pUnidade   = "UN".
           
    /* Busca Unidade Comercial se existir */
    IF oBody:Has("gtins") THEN DO:
        DEFINE VARIABLE oGtins AS JsonArray NO-UNDO.
        DEFINE VARIABLE oGtin  AS JsonObject NO-UNDO.
        oGtins = oBody:GetJsonArray("gtins").
        IF oGtins:Length > 0 THEN DO:
            oGtin = oGtins:GetJsonObject(1).
            IF oGtin:Has("commercial_unit") AND oGtin:GetJsonObject("commercial_unit"):Has("type_packaging") THEN DO:
                CASE oGtin:GetJsonObject("commercial_unit"):GetCharacter("type_packaging"):
                    WHEN "Quilo" OR WHEN "Kg" THEN pUnidade = "KG".
                    WHEN "Gramas" THEN pUnidade = "GR".
                    WHEN "Litro" THEN pUnidade = "LT".
                    WHEN "Caixa" THEN pUnidade = "CX".
                    OTHERWISE pUnidade = "UN".
                END CASE.
            END.
        END.
    END.

    pStatus = "SUCESSO".
           
    /* Se a imagem foi baixada, retorna o caminho local */
    FILE-INFO:FILE-NAME = cImgFile.
    IF FILE-INFO:FULL-PATHNAME <> ? THEN 
        pURLImagem = FILE-INFO:FULL-PATHNAME.
END.
ELSE DO:
    pStatus = "ERRO: Dados invalidos retornados pela API.".
END.

CATCH e AS Progress.Lang.Error:
    pStatus = "ERRO TECNICO: " + e:GetMessage(1).
END CATCH.
