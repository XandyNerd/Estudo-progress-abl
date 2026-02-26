/* Parâmetros recebidos da interface_login.w */
DEFINE INPUT PARAMETER pEmail AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pSenha AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pSucesso AS LOGICAL NO-UNDO.

/* Conectar ao banco local se ainda nao estiver conectado */
IF NOT CONNECTED("infocena") THEN
    CONNECT "01-projeto-infocena/data/infocena.db" -1.

/* LÓGICA DE VALIDAÇÃO */
pSucesso = FALSE.

IF pEmail = "" THEN DO:
    MESSAGE "Por favor, informe o email!" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Validar as credenciais no banco de dados Progress */
FIND FIRST Usuario WHERE Usuario.Email = pEmail NO-LOCK NO-ERROR.

IF AVAILABLE(Usuario) AND Usuario.Senha = pSenha THEN DO:
    pSucesso = TRUE.
END.
ELSE DO:
    MESSAGE "Email ou senha incorretos." VIEW-AS ALERT-BOX ERROR.
END.
