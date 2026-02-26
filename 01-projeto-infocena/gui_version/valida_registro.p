/* valida_registro.p */
DEFINE INPUT PARAMETER pNome      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pEmail     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pSenha     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pConfSenha AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pSucesso  AS LOGICAL NO-UNDO.

pSucesso = FALSE.

/* Conectar ao banco local se ainda nao estiver conectado */
IF NOT CONNECTED("infocena") THEN
    CONNECT "..\data\infocena.db" -1.

IF pNome = "" OR pEmail = "" OR pSenha = "" THEN DO:
    MESSAGE "Preencha todos os campos!" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

IF pSenha <> pConfSenha THEN DO:
    MESSAGE "As senhas nao batem!" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Validacao Basica de Email */
IF NOT (pEmail MATCHES "*@*.*") THEN DO:
    MESSAGE "Por favor, informe um email valido!" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Validar se o email ja existe no banco de dados */
FIND FIRST Usuario WHERE Usuario.Email = pEmail NO-LOCK NO-ERROR.
IF AVAILABLE(Usuario) THEN DO:
    MESSAGE "Este Email ja esta cadastrado no sistema!" VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* Criar novo registro na tabela oficial do banco! */
CREATE Usuario.
ASSIGN 
    Usuario.Nome  = pNome
    Usuario.Email = pEmail
    Usuario.Senha = pSenha.

MESSAGE "Usuario: " Usuario.Nome " registrado com sucesso no Banco de Dados!" VIEW-AS ALERT-BOX INFORMATION.

pSucesso = TRUE.
