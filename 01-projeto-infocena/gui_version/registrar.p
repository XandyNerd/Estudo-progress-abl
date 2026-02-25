/* registrar.p - Tela de Registro Temporaria (users.txt) */

DEFINE VARIABLE hWindow AS HANDLE NO-UNDO.

CREATE WINDOW hWindow
    ASSIGN 
        TITLE        = "Novo Usuario"
        WIDTH-CHARS  = 80
        HEIGHT-CHARS = 20
        BGCOLOR      = 8 /* Cinza */
        MESSAGE-AREA = FALSE
        STATUS-AREA  = FALSE.

CURRENT-WINDOW = hWindow.
hWindow:VISIBLE = FALSE.

DEFINE VARIABLE cNome      AS CHARACTER FORMAT "x(30)" LABEL "Nome      " NO-UNDO.
DEFINE VARIABLE cEmail     AS CHARACTER FORMAT "x(40)" LABEL "Email     " NO-UNDO.
DEFINE VARIABLE cSenha     AS CHARACTER FORMAT "x(20)" LABEL "Senha     " NO-UNDO.
DEFINE VARIABLE cConfSenha AS CHARACTER FORMAT "x(20)" LABEL "Confirmar " NO-UNDO.

DEFINE BUTTON btn-save   LABEL "Registrar" SIZE 15 BY 1.14.
DEFINE BUTTON btn-cancel LABEL "Cancelar"  SIZE 15 BY 1.14.

DEFINE FRAME f-registro
    SKIP(1)
    cNome      AT ROW 2 COL 15 COLON-ALIGNED
    cEmail     AT ROW 3.2 COL 15 COLON-ALIGNED
    cSenha     AT ROW 4.4 COL 15 COLON-ALIGNED VIEW-AS FILL-IN BLANK
    cConfSenha AT ROW 5.6 COL 15 COLON-ALIGNED VIEW-AS FILL-IN BLANK
    SKIP(1.5)
    btn-save   AT ROW 8 COL 10
    btn-cancel AT ROW 8 COL 35
    WITH VIEW-AS DIALOG-BOX TITLE "Cadastro de Novo Usuario" 
         SIDE-LABELS SIZE 60 BY 10
         DEFAULT-BUTTON btn-save CANCEL-BUTTON btn-cancel.

/* Conectar ao banco local se ainda nao estiver conectado */
IF NOT CONNECTED("infocena") THEN
    CONNECT "data/infocena.db" -1.

ON CHOOSE OF btn-save IN FRAME f-registro
DO:
    ASSIGN cNome cEmail cSenha cConfSenha.

    IF cNome = "" OR cEmail = "" OR cSenha = "" THEN DO:
        MESSAGE "Preencha todos os campos!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    IF cSenha <> cConfSenha THEN DO:
        MESSAGE "As senhas nao batem!" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cConfSenha.
        RETURN NO-APPLY.
    END.

    /* Validacao Basica de Email */
    IF NOT (cEmail MATCHES "*@*.*") THEN DO:
        MESSAGE "Por favor, informe um email valido!" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cEmail.
        RETURN NO-APPLY.
    END.

    /* Validar se o email ja existe no banco de dados */
    FIND FIRST Usuario WHERE Usuario.Email = cEmail NO-LOCK NO-ERROR.
    IF AVAILABLE(Usuario) THEN DO:
        MESSAGE "Este Email ja esta cadastrado no sistema!" VIEW-AS ALERT-BOX WARNING.
        APPLY "ENTRY" TO cEmail.
        RETURN NO-APPLY.
    END.

    /* Criar novo registro na tabela oficial do banco! */
    CREATE Usuario.
    ASSIGN 
        Usuario.Nome  = cNome
        Usuario.Email = cEmail
        Usuario.Senha = cSenha.

    MESSAGE "Usuario: " Usuario.Nome " registrado com sucesso no Banco de Dados!" VIEW-AS ALERT-BOX INFORMATION.
    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

ON CHOOSE OF btn-cancel IN FRAME f-registro
DO:
    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

ENABLE ALL WITH FRAME f-registro.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
DELETE WIDGET hWindow.
