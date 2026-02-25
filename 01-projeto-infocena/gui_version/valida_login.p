/* 2. CRIA A JANELINHA DE LOGIN (POR CIMA DO FUNDO) */
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

/* Chama a tela de registro */
ON CHOOSE OF btn-reg IN FRAME f-login
DO:
    RUN registrar.p.
END.

/* Conectar ao banco local se ainda nao estiver conectado */
IF NOT CONNECTED("infocena") THEN
    CONNECT "data/infocena.db" -1.

ON CHOOSE OF btn-ok IN FRAME f-login
DO:
    ASSIGN cEmail cSenha.

    IF cEmail = "" THEN DO:
        MESSAGE "Por favor, informe o email!" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cEmail.
        RETURN NO-APPLY.
    END.

    /* Validar as credenciais no banco de dados Progress */
    FIND FIRST Usuario WHERE Usuario.Email = cEmail  NO-LOCK NO-ERROR.
    
    IF AVAILABLE(Usuario) AND Usuario.Senha = cSenha THEN DO:
        /* Esconde a tela de login imediatamente */
        FRAME f-login:VISIBLE = FALSE.
        
        /* Abre o Menu Principal e passa o nome do usuario */
        RUN menu.p (INPUT Usuario.Nome).
        
        /* Fecha o processo do login em background */
        APPLY "CLOSE" TO THIS-PROCEDURE.
    END.
    ELSE DO:
        MESSAGE "Email ou senha incorretos." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cEmail.
        RETURN NO-APPLY.
    END.
END.

ON CHOOSE OF btn-cancel IN FRAME f-login
DO:
    MESSAGE "Operacao cancelada." VIEW-AS ALERT-BOX WARNING.
    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* Ativa a telinha de login */
ENABLE ALL WITH FRAME f-login.

/* Pausa a execucao ate o usuario fechar a caixinha de login */
WAIT-FOR CLOSE OF THIS-PROCEDURE.
