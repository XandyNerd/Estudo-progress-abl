&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------
  File: interface_menu.w
  Description: Menu Principal ERP Infocena
------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWindowState AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWidth AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioHeight AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioX AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioY AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS LogoInfocena btn-sup btn-fin btn-tec btn-com ~
btn-sair 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-com 
     LABEL "COMERCIAL" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-ctr 
     LABEL "CONTROLADORIA E CUSTOS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-fin 
     LABEL "FINANCAS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-man 
     LABEL "MANUFATURA" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-org 
     LABEL "ORGANIZACIONAL" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-qua 
     LABEL "QUALIDADE" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-sair 
     LABEL "Sair" 
     SIZE 15 BY 1.52.

DEFINE BUTTON btn-ser 
     LABEL "SERVICOS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-sol 
     LABEL "SOLUCOES INTEGRADAS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-sup 
     LABEL "SUPRIMENTOS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-tec 
     LABEL "INTEGRACAO E TECNOLOGIA" 
     SIZE 35 BY 2.

DEFINE IMAGE LogoInfocena
     FILENAME "..\LogoInfocena.jpg":U
     STRETCH-TO-FIT
     SIZE 74 BY 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btn-sup AT ROW 8.62 COL 10
     btn-fin AT ROW 8.62 COL 50
     btn-qua AT ROW 11.14 COL 10
     btn-ctr AT ROW 11.14 COL 50
     btn-man AT ROW 13.62 COL 10
     btn-org AT ROW 13.62 COL 50
     btn-ser AT ROW 16.14 COL 10
     btn-tec AT ROW 16.14 COL 50
     btn-com AT ROW 18.62 COL 10
     btn-sol AT ROW 18.62 COL 50
     btn-sair AT ROW 22.14 COL 42
     LogoInfocena AT ROW 1.71 COL 11 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 100 BY 23 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Sistema ERP Infocena - Menu Principal"
         HEIGHT             = 32.14
         WIDTH              = 273.2
         MAX-HEIGHT         = 33.19
         MAX-WIDTH          = 273.2
         VIRTUAL-HEIGHT     = 33.19
         VIRTUAL-WIDTH      = 273.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Sistema ERP Infocena - Menu Principal */
DO:
  /* Mantem centralizado se o usuario redimensionar a janela manualmente */
  IF VALID-HANDLE(FRAME fMain:HANDLE) THEN DO:
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2.
  END.
END.

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win 
DO:
  DEFINE VARIABLE lSair AS LOGICAL NO-UNDO.
  
  MESSAGE "Deseja realmente sair do sistema?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      TITLE "Sair do Sistema"
      UPDATE lSair.
      
  IF NOT lSair THEN RETURN NO-APPLY.
  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-com C-Win
ON CHOOSE OF btn-com IN FRAME fMain /* COMERCIAL */
DO:
  /* Captura dimensoes da tela atual do Menu */
  DEFINE VARIABLE iState  AS INTEGER NO-UNDO.
  DEFINE VARIABLE iWidth  AS INTEGER NO-UNDO.
  DEFINE VARIABLE iHeight AS INTEGER NO-UNDO.
  DEFINE VARIABLE iX      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iY      AS INTEGER NO-UNDO.
  
  ASSIGN iState  = C-Win:WINDOW-STATE
         iWidth  = C-Win:WIDTH-PIXELS
         iHeight = C-Win:HEIGHT-PIXELS
         iX      = C-Win:X
         iY      = C-Win:Y NO-ERROR.

  ASSIGN C-Win:VISIBLE = NO
         C-Win:HIDDEN  = YES.
         
  RUN interface_comercial.w (INPUT pUsuarioNome,
                             INPUT-OUTPUT iState,
                             INPUT-OUTPUT iWidth,
                             INPUT-OUTPUT iHeight,
                             INPUT-OUTPUT iX,
                             INPUT-OUTPUT iY).
                             
  /* Restaura a janela com o clone da posicao que o modulo foi fechado */
  ASSIGN C-Win:WINDOW-STATE = iState NO-ERROR.
  IF iState <> 3 THEN DO:
      ASSIGN C-Win:WIDTH-PIXELS  = iWidth
             C-Win:HEIGHT-PIXELS = iHeight
             C-Win:X             = iX
             C-Win:Y             = iY NO-ERROR.
  END.
  
  ASSIGN C-Win:VISIBLE = YES
         C-Win:HIDDEN  = NO.
         
  /* Recentraliza os campos */
  IF VALID-HANDLE(FRAME fMain:HANDLE) THEN
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2 NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-ctr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ctr C-Win
ON CHOOSE OF btn-ctr IN FRAME fMain /* CONTROLADORIA E CUSTOS */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "CONTROLLER").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-fin C-Win
ON CHOOSE OF btn-fin IN FRAME fMain /* FINANCAS */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "FINANCAS").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-man C-Win
ON CHOOSE OF btn-man IN FRAME fMain /* MANUFATURA */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "MANUFATURA").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-org
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-org C-Win
ON CHOOSE OF btn-org IN FRAME fMain /* ORGANIZACIONAL */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "ORGANIZACIONAL").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-qua
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-qua C-Win
ON CHOOSE OF btn-qua IN FRAME fMain /* QUALIDADE */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "QUALIDADE").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-sair C-Win
ON CHOOSE OF btn-sair IN FRAME fMain /* Sair */
DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.  /* Chama o gatilho acima para confirmar */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-ser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ser C-Win
ON CHOOSE OF btn-ser IN FRAME fMain /* SERVICOS */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "SERVICOS").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-sol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-sol C-Win
ON CHOOSE OF btn-sol IN FRAME fMain /* SOLUCOES INTEGRADAS */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "SOLUCOES").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-sup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-sup C-Win
ON CHOOSE OF btn-sup IN FRAME fMain /* SUPRIMENTOS */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "SUPRIMENTOS").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-tec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-tec C-Win
ON CHOOSE OF btn-tec IN FRAME fMain /* INTEGRACAO E TECNOLOGIA */
DO:
  RUN menu_logica.p (INPUT pUsuarioNome, INPUT "TECNOLOGIA").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  RUN enable_UI.
  
  /* Aplica o tamanho herdado da tela antiga ou maximiza por padrao */
  IF pioWidth > 0 AND pioHeight > 0 THEN DO:
      ASSIGN C-Win:WINDOW-STATE = pioWindowState NO-ERROR.
      IF pioWindowState <> 3 THEN
          ASSIGN C-Win:WIDTH-PIXELS  = pioWidth
                 C-Win:HEIGHT-PIXELS = pioHeight
                 C-Win:X             = pioX
                 C-Win:Y             = pioY NO-ERROR.
  END.
  ELSE DO:
      ASSIGN C-Win:WINDOW-STATE = 3 NO-ERROR.
  END.
  PROCESS EVENTS.
  
  /* Força a centralização do FRAME dentro da Janela */
  IF VALID-HANDLE(FRAME fMain:HANDLE) THEN
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win) THEN DO:
      /* Grava o tamanho em que a janela foi fechada pelo usuario */
      ASSIGN pioWindowState = C-Win:WINDOW-STATE
             pioWidth       = C-Win:WIDTH-PIXELS
             pioHeight      = C-Win:HEIGHT-PIXELS
             pioX           = C-Win:X
             pioY           = C-Win:Y NO-ERROR.

      DELETE WIDGET C-Win.
  END.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE LogoInfocena btn-sup btn-fin btn-tec btn-com btn-sair 
      WITH FRAME fMain IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

