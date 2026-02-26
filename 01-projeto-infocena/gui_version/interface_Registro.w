&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------
  File: interface_Registro.w
  Description: Cadastro de Novo Usuario
------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

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

&Scoped-define FRAME-NAME f-registro

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 cNome cEmail cSenha cConfSenha btn-save btn-cancel 
&Scoped-Define DISPLAYED-OBJECTS cNome cEmail cSenha cConfSenha 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-cancel 
     LABEL "Cancelar" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn-save 
     LABEL "Registrar" 
     SIZE 15 BY 1.14.

DEFINE IMAGE IMAGE-1
     STRETCH-TO-FIT
     FILENAME "..\LogoInfocena.jpg":U
     SIZE 50 BY 6.

DEFINE VARIABLE cConfSenha AS CHARACTER FORMAT "x(20)":U 
     LABEL "Confirmar " 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE cEmail AS CHARACTER FORMAT "x(40)":U 
     LABEL "Email     "
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "Insira seu email" NO-UNDO.

DEFINE VARIABLE cNome AS CHARACTER FORMAT "x(30)":U 
     LABEL "Nome      " 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE cSenha AS CHARACTER FORMAT "x(20)":U 
     LABEL "Senha     " 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-registro
     IMAGE-1 AT ROW 1.5 COL 10 WIDGET-ID 22
     cNome AT ROW 8 COL 35 COLON-ALIGNED WIDGET-ID 8
     cEmail AT ROW 10 COL 35 COLON-ALIGNED WIDGET-ID 6
     cSenha AT ROW 12 COL 35 COLON-ALIGNED BLANK WIDGET-ID 10
     cConfSenha AT ROW 14 COL 35 COLON-ALIGNED BLANK WIDGET-ID 2
     btn-save AT ROW 17 COL 25 WIDGET-ID 12
     btn-cancel AT ROW 17 COL 55 WIDGET-ID 4
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
         TITLE              = "Cadastro de Novo Usuario"
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
&ANALYZE-RESUME


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win 
DO:
  /* Mantem o quadro centralizado se a janela mudar de tamanho */
  IF VALID-HANDLE(FRAME f-registro:HANDLE) THEN DO:
      ASSIGN FRAME f-registro:X = (C-Win:WIDTH-PIXELS - FRAME f-registro:WIDTH-PIXELS) / 2
             FRAME f-registro:Y = (C-Win:HEIGHT-PIXELS - FRAME f-registro:HEIGHT-PIXELS) / 2.
  END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Cadastro de Novo Usuario */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Cadastro de Novo Usuario */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancel C-Win
ON CHOOSE OF btn-cancel IN FRAME f-registro /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-save C-Win
ON CHOOSE OF btn-save IN FRAME f-registro /* Registrar */
DO:
  DEFINE VARIABLE lSucesso AS LOGICAL NO-UNDO.
  
  ASSIGN cNome cEmail cSenha cConfSenha.
  
  RUN valida_registro.p (INPUT cNome,
                         INPUT cEmail,
                         INPUT cSenha,
                         INPUT cConfSenha,
                         OUTPUT lSucesso).
                         
  IF lSucesso THEN DO:
      APPLY "CLOSE":U TO THIS-PROCEDURE.
      RETURN.
  END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 
/* ***************************  Main Block  *************************** */

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
  
  /* Força a centralização do quadro dentro da tela cheia */
  IF VALID-HANDLE(FRAME f-registro:HANDLE) THEN
    ASSIGN FRAME f-registro:X = (C-Win:WIDTH-PIXELS - FRAME f-registro:WIDTH-PIXELS) / 2
           FRAME f-registro:Y = (C-Win:HEIGHT-PIXELS - FRAME f-registro:HEIGHT-PIXELS) / 2.

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
  DISPLAY cNome cEmail cSenha cConfSenha WITH FRAME f-registro IN WINDOW C-Win.
  ENABLE IMAGE-1 cNome cEmail cSenha cConfSenha btn-save btn-cancel WITH FRAME f-registro IN WINDOW C-Win.
  VIEW C-Win.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
