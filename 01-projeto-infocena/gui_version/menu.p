/* menu.p - Menu Principal do Sistema */

/* Recebe o nome do usuario logado como parametro */
DEFINE INPUT PARAMETER p-usuario-nome AS CHARACTER NO-UNDO.

DEFINE VARIABLE hWindow AS HANDLE NO-UNDO.

/* 1. Criar a Janela Principal */
CREATE WINDOW hWindow
    ASSIGN 
        TITLE        = "Sistema Infocena - Menu Principal"
        BGCOLOR      = 15   /* Branco */
        RESIZE       = TRUE /* OBRIGATORIO para permitir Maximizar */
        MESSAGE-AREA = FALSE
        STATUS-AREA  = FALSE.

CURRENT-WINDOW = hWindow.

/* 2. Definir Elementos de UI */
DEFINE VARIABLE cWelcome AS CHARACTER NO-UNDO.
cWelcome = "Bem-vindo(a), " + p-usuario-nome + "!".

DEFINE BUTTON btn-cad   LABEL "   [ Cadastros ]   " SIZE 35 BY 2.5.
DEFINE BUTTON btn-ope   LABEL "   [ Operacoes ]   " SIZE 35 BY 2.5.
DEFINE BUTTON btn-rel   LABEL "   [ Relatorios ]  " SIZE 35 BY 2.5.
DEFINE BUTTON btn-sair  LABEL "      Sair       "  SIZE 15 BY 1.2.

/* Frame que contem o menu (sera centralizado na tela) */
DEFINE FRAME f-menu
    "SISTEMA INFOCENA"         AT ROW 2 COL 23 FONT 6
    cWelcome                   FORMAT "x(40)" VIEW-AS TEXT AT ROW 4 COL 11
    "--------------------------------------------------" AT ROW 5 COL 11
    SKIP(1)
    "Selecione uma opcao abaixo:" AT ROW 7 COL 18
    SKIP(1)
    btn-cad    AT ROW 9  COL 13
    btn-ope    AT ROW 12 COL 13
    btn-rel    AT ROW 15 COL 13
    SKIP(2)
    btn-sair   AT ROW 19 COL 23
    WITH NO-BOX NO-LABELS KEEP-TAB-ORDER
         SIZE 60 BY 22
         BGCOLOR 15 FGCOLOR 0.

/* 3. Logica de Posicionamento (Centralizacao) */
/* Centraliza o Frame baseado nos pixels da janela maximizada */
ON 'WINDOW-RESIZED':U OF hWindow
DO:
    IF VALID-HANDLE(FRAME f-menu:HANDLE) THEN DO:
        FRAME f-menu:X = (hWindow:WIDTH-PIXELS - FRAME f-menu:WIDTH-PIXELS) / 2.
        FRAME f-menu:Y = (hWindow:HEIGHT-PIXELS - FRAME f-menu:HEIGHT-PIXELS) / 2.
    END.
END.

/* 4. Eventos */
ON CHOOSE OF btn-cad IN FRAME f-menu
DO:
    MESSAGE "Modulo de Cadastros em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
END.

ON CHOOSE OF btn-ope IN FRAME f-menu
DO:
    MESSAGE "Modulo de Operacoes em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
END.

ON CHOOSE OF btn-rel IN FRAME f-menu
DO:
    MESSAGE "Modulo de Relatorios em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
END.

ON CHOOSE OF btn-sair IN FRAME f-menu
DO:
    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* 5. Exibir Tudo */
hWindow:VISIBLE = TRUE.
hWindow:WINDOW-STATE = 3. /* Forca o modo Maximizado apos ficar visivel */

DISPLAY cWelcome WITH FRAME f-menu.
ENABLE ALL WITH FRAME f-menu.

/* Forca o posicionamento inicial do centralizador */
APPLY 'WINDOW-RESIZED':U TO hWindow.

WAIT-FOR CLOSE OF THIS-PROCEDURE.
DELETE WIDGET hWindow.
