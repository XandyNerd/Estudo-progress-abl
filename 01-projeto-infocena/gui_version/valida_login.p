/* 
   ARQUIVO DE LÓGICA DE LOGIN
   Este arquivo agora processa a validação para a tela interface_login.w
*/

/* --- INTERFACE ANTIGA COMENTADA (PARA ESTUDO) ---
DEFINE VARIABLE cEmail   AS CHARACTER FORMAT "x(40)" LABEL "Email" NO-UNDO.
DEFINE VARIABLE cSenha   AS CHARACTER FORMAT "x(20)" LABEL "Senha" NO-UNDO.

DEFINE BUTTON btn-ok     LABEL "Entrar"    SIZE 15 BY 1.14.
DEFINE BUTTON btn-reg    LABEL "Registrar" SIZE 15 BY 1.14.
DEFINE BUTTON btn-cancel LABEL "Sair"      SIZE 15 BY 1.14.

DEFINE FRAME f-login 
    SKIP(1)
    cEmail   AT ROW 2 COL 15 COLON-ALIGNED
    cSenha   AT ROW 3.2 COL 15 COLON-ALIGNED VIEW-AS FILL-IN BLANK
    SKIP(1)
    "Esqueci a minha senha" AT ROW 5.2 COL 22
    SKIP(1)
    btn-ok     AT ROW 7.5 COL 5
    btn-reg    AT ROW 7.5 COL 22
    btn-cancel AT ROW 7.5 COL 40
    WITH VIEW-AS DIALOG-BOX TITLE "Portal de Acesso" 
         SIDE-LABELS SIZE 60 BY 9.5
         BGCOLOR 15 FGCOLOR 0 
         DEFAULT-BUTTON btn-ok CANCEL-BUTTON btn-cancel.
-------------------------------------------------- */

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
