&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------
  File: interface_login.w
  Description: Tela de Acesso 
------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME winLogin

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 cEmail cSenha bntRegistrar bntLogin ~
bntsair 
&Scoped-Define DISPLAYED-OBJECTS cEmail cSenha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bntLogin 
     LABEL "Login" 
     SIZE 22 BY 1.14.

DEFINE BUTTON bntRegistrar 
     LABEL "Registrar" 
     SIZE 24 BY 1.14.

DEFINE BUTTON bntsair 
     LABEL "Sair" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cEmail AS CHARACTER FORMAT "x(40)":U 
     LABEL "Email" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.14 TOOLTIP "Insira seu email" NO-UNDO.

DEFINE VARIABLE cSenha AS CHARACTER FORMAT "x(20)":U 
     LABEL "Senha" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.14 TOOLTIP "Insira sua senha" NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "..\LogoInfocena.jpg":U
     STRETCH-TO-FIT
     SIZE 80 BY 4.76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME winLogin
     IMAGE-1 AT ROW 1.5 COL 10 WIDGET-ID 22
     cEmail AT ROW 9 COL 35 COLON-ALIGNED WIDGET-ID 2
     cSenha AT ROW 11 COL 35 COLON-ALIGNED BLANK WIDGET-ID 8
     bntRegistrar AT ROW 14 COL 25 WIDGET-ID 16
     bntLogin AT ROW 14 COL 51 WIDGET-ID 12
     bntsair AT ROW 19 COL 42 WIDGET-ID 18
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
         TITLE              = "Login do Sistema"
         HEIGHT             = 23
         WIDTH              = 100
         MAX-HEIGHT         = 33.19
         MAX-WIDTH          = 273.2
         VIRTUAL-HEIGHT     = 33.19
         VIRTUAL-WIDTH      = 273.2
         RESIZE             = yes
         MAX-BUTTON         = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Login do Sistema */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Login do Sistema */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Login do Sistema */
DO:
  /* Mantem o quadro de login centralizado se a janela mudar de tamanho */
  IF VALID-HANDLE(FRAME winLogin:HANDLE) THEN DO:
      ASSIGN FRAME winLogin:X = (C-Win:WIDTH-PIXELS - FRAME winLogin:WIDTH-PIXELS) / 2
             FRAME winLogin:Y = (C-Win:HEIGHT-PIXELS - FRAME winLogin:HEIGHT-PIXELS) / 2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON "F2":U ANYWHERE 
DO:
  /* Bloqueia o F2 se a tela de login ja estiver oculta/processando */
  IF C-Win:HIDDEN = YES THEN RETURN NO-APPLY.
  /* Captura dimensoes da tela atual do Login */
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

  /* Bypass de Login (F2) */
  ASSIGN C-Win:VISIBLE = NO
         C-Win:HIDDEN  = YES.
  
  RUN interface_menu.w (INPUT "Desenvolvedor",
                        INPUT-OUTPUT iState,
                        INPUT-OUTPUT iWidth,
                        INPUT-OUTPUT iHeight,
                        INPUT-OUTPUT iX,
                        INPUT-OUTPUT iY). 
  
  /* Restaura a janela com o clone da posicao que o Menu foi fechado */
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
  IF VALID-HANDLE(FRAME winLogin:HANDLE) THEN
      ASSIGN FRAME winLogin:X = (C-Win:WIDTH-PIXELS - FRAME winLogin:WIDTH-PIXELS) / 2
             FRAME winLogin:Y = (C-Win:HEIGHT-PIXELS - FRAME winLogin:HEIGHT-PIXELS) / 2 NO-ERROR.
  
  APPLY "ENTRY" TO cEmail IN FRAME winLogin.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME winLogin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL winLogin C-Win
ON GO OF FRAME winLogin
DO:
  /* Absorve a tecla ENTER caso os campos estejam vazios, evitando bleed-through (teclas fantasmas de alertas anteriores) */
  IF cEmail:SCREEN-VALUE IN FRAME winLogin = "" THEN RETURN NO-APPLY.
  
  APPLY "CHOOSE" TO bntLogin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bntLogin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bntLogin C-Win
ON CHOOSE OF bntLogin IN FRAME winLogin /* Login */
DO:
  DEFINE VARIABLE lSucesso AS LOGICAL NO-UNDO.
  
  ASSIGN cEmail cSenha. 
  
  RUN valida_login.p (INPUT cEmail, 
                      INPUT cSenha, 
                      OUTPUT lSucesso).
  
  IF lSucesso THEN DO:
      FIND FIRST infocena.Usuario WHERE infocena.Usuario.Email = cEmail NO-LOCK NO-ERROR.
      
      MESSAGE "Login realizado com sucesso! Bem-vindo(a), " + (IF AVAILABLE infocena.Usuario THEN infocena.Usuario.Nome ELSE cEmail) + "." 
              VIEW-AS ALERT-BOX INFORMATION.
      
      /* Captura dimensoes da tela atual do Login */
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
      
      RUN interface_menu.w (INPUT (IF AVAILABLE infocena.Usuario THEN infocena.Usuario.Nome ELSE cEmail),
                            INPUT-OUTPUT iState,
                            INPUT-OUTPUT iWidth,
                            INPUT-OUTPUT iHeight,
                            INPUT-OUTPUT iX,
                            INPUT-OUTPUT iY). 
      
      /* Restaura a janela com o clone da posicao que o Menu foi fechado */
      ASSIGN C-Win:WINDOW-STATE = iState NO-ERROR.
      IF iState <> 3 THEN DO:
          ASSIGN C-Win:WIDTH-PIXELS  = iWidth
                 C-Win:HEIGHT-PIXELS = iHeight
                 C-Win:X             = iX
                 C-Win:Y             = iY NO-ERROR.
      END.
      
      ASSIGN cEmail = "" cSenha = "".
      DISPLAY cEmail cSenha WITH FRAME winLogin.
      
      ASSIGN C-Win:VISIBLE = YES
             C-Win:HIDDEN  = NO.
             
      /* Recentraliza os campos */
      IF VALID-HANDLE(FRAME winLogin:HANDLE) THEN
          ASSIGN FRAME winLogin:X = (C-Win:WIDTH-PIXELS - FRAME winLogin:WIDTH-PIXELS) / 2
                 FRAME winLogin:Y = (C-Win:HEIGHT-PIXELS - FRAME winLogin:HEIGHT-PIXELS) / 2 NO-ERROR.
      
      APPLY "ENTRY" TO cEmail IN FRAME winLogin.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bntRegistrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bntRegistrar C-Win
ON CHOOSE OF bntRegistrar IN FRAME winLogin /* Registrar */
DO:
  /* Captura dimensoes da tela atual do Login */
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

  /* Oculta o login enquanto registra */
  ASSIGN C-Win:VISIBLE = NO
         C-Win:HIDDEN  = YES.
         
  RUN interface_Registro.w (INPUT-OUTPUT iState,
                            INPUT-OUTPUT iWidth,
                            INPUT-OUTPUT iHeight,
                            INPUT-OUTPUT iX,
                            INPUT-OUTPUT iY).
  
  /* Restaura a janela com o clone da posicao que o Registro foi fechado */
  ASSIGN C-Win:WINDOW-STATE = iState NO-ERROR.
  IF iState <> 3 THEN DO:
      ASSIGN C-Win:WIDTH-PIXELS  = iWidth
             C-Win:HEIGHT-PIXELS = iHeight
             C-Win:X             = iX
             C-Win:Y             = iY NO-ERROR.
  END.
  
  /* Volta a mostrar o login */
  ASSIGN C-Win:VISIBLE = YES
         C-Win:HIDDEN  = NO.
         
  /* Recentraliza os campos */
  IF VALID-HANDLE(FRAME winLogin:HANDLE) THEN
      ASSIGN FRAME winLogin:X = (C-Win:WIDTH-PIXELS - FRAME winLogin:WIDTH-PIXELS) / 2
             FRAME winLogin:Y = (C-Win:HEIGHT-PIXELS - FRAME winLogin:HEIGHT-PIXELS) / 2 NO-ERROR.
         
  APPLY "ENTRY" TO cEmail IN FRAME winLogin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bntsair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bntsair C-Win
ON CHOOSE OF bntsair IN FRAME winLogin /* Sair */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
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
  
  /* Centraliza e Maximiza a Janela de Login */
  ASSIGN C-Win:WINDOW-STATE = 3.
  PROCESS EVENTS.
  
  /* Força a centralização do quadro de campos dentro da tela cheia */
  IF VALID-HANDLE(FRAME winLogin:HANDLE) THEN
    ASSIGN FRAME winLogin:X = (C-Win:WIDTH-PIXELS - FRAME winLogin:WIDTH-PIXELS) / 2
           FRAME winLogin:Y = (C-Win:HEIGHT-PIXELS - FRAME winLogin:HEIGHT-PIXELS) / 2.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
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
  DISPLAY cEmail cSenha 
      WITH FRAME winLogin IN WINDOW C-Win.
  ENABLE IMAGE-1 cEmail cSenha bntRegistrar bntLogin bntsair 
      WITH FRAME winLogin IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-winLogin}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

