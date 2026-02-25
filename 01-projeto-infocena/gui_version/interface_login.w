&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          infocena         PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME winLogin

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Usuario

/* Definitions for FRAME winLogin                                       */
&Scoped-define FIELDS-IN-QUERY-winLogin Usuario.Email Usuario.Senha 
&Scoped-define ENABLED-FIELDS-IN-QUERY-winLogin Usuario.Email Usuario.Senha 
&Scoped-define ENABLED-TABLES-IN-QUERY-winLogin Usuario
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-winLogin Usuario
&Scoped-define QUERY-STRING-winLogin FOR EACH Usuario SHARE-LOCK
&Scoped-define OPEN-QUERY-winLogin OPEN QUERY winLogin FOR EACH Usuario SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-winLogin Usuario
&Scoped-define FIRST-TABLE-IN-QUERY-winLogin Usuario


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Usuario.Email Usuario.Senha 
&Scoped-define ENABLED-TABLES Usuario
&Scoped-define FIRST-ENABLED-TABLE Usuario
&Scoped-Define ENABLED-OBJECTS IMAGE-1 bntRegistrar bntLogin bntsair 
&Scoped-Define DISPLAYED-FIELDS Usuario.Email Usuario.Senha 
&Scoped-define DISPLAYED-TABLES Usuario
&Scoped-define FIRST-DISPLAYED-TABLE Usuario


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
     SIZE 15 BY 1.14.

DEFINE BUTTON bntRegistrar 
     LABEL "Registrar" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bntsair 
     LABEL "Sair" 
     SIZE 15 BY 1.14.

DEFINE IMAGE IMAGE-1
     FILENAME "adeicon/blank":U
     SIZE 12.8 BY 3.05.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY winLogin FOR 
      Usuario SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME winLogin
     Usuario.Email AT ROW 6.95 COL 50 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 17 BY 1 TOOLTIP "Insira seu email"
     Usuario.Senha AT ROW 8.38 COL 50 COLON-ALIGNED WIDGET-ID 8 BLANK 
          VIEW-AS FILL-IN 
          SIZE 17 BY 1 TOOLTIP "Insira sua senha"
     bntRegistrar AT ROW 10.05 COL 44 WIDGET-ID 16
     bntLogin AT ROW 10.05 COL 61 WIDGET-ID 12
     bntsair AT ROW 11.71 COL 53 WIDGET-ID 18
     IMAGE-1 AT ROW 2.67 COL 51 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 149.4 BY 25.81 WIDGET-ID 100.


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
         TITLE              = "<insert window title>"
         HEIGHT             = 25.81
         WIDTH              = 149.4
         MAX-HEIGHT         = 33.19
         MAX-WIDTH          = 273.2
         VIRTUAL-HEIGHT     = 33.19
         VIRTUAL-WIDTH      = 273.2
         RESIZE             = yes
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

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME winLogin
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME winLogin
/* Query rebuild information for FRAME winLogin
     _TblList          = "infocena.Usuario"
     _Query            is OPENED
*/  /* FRAME winLogin */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME winLogin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL winLogin C-Win
ON GO OF FRAME winLogin
DO:
  APPLY "CHOOSE" TO bntLogin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bntLogin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bntLogin C-Win
ON CHOOSE OF bntLogin IN FRAME winLogin /* Login */
DO:
  DEFINE VARIABLE lSucesso AS LOGICAL NO-UNDO.

  /* Captura os valores digitados na tela */
  ASSIGN Usuario.Email Usuario.Senha.

  /* Chama o arquivo de lógica passando os dados */
  RUN valida_login.p (INPUT Usuario.Email, 
                      INPUT Usuario.Senha, 
                      OUTPUT lSucesso).

  IF lSucesso THEN DO:
      /* Busca o registro do usuário para pegar o Nome real */
      FIND FIRST Usuario WHERE Usuario.Email = Usuario.Email NO-LOCK NO-ERROR.
      
      MESSAGE "Login realizado com sucesso! Bem-vindo(a), " + (IF AVAILABLE Usuario THEN Usuario.Nome ELSE Usuario.Email) + "." 
              VIEW-AS ALERT-BOX INFORMATION.
      
      /* Abre o menu passando o nome real */
      RUN menu.p (INPUT (IF AVAILABLE Usuario THEN Usuario.Nome ELSE Usuario.Email)). 
      
      APPLY "CLOSE" TO THIS-PROCEDURE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bntRegistrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bntRegistrar C-Win
ON CHOOSE OF bntRegistrar IN FRAME winLogin /* Registrar */
DO:
  RUN registrar.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bntsair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bntsair C-Win
ON CHOOSE OF bntsair IN FRAME winLogin /* Sair */
DO:
  QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
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

  {&OPEN-QUERY-winLogin}
  GET FIRST winLogin.
  IF AVAILABLE Usuario THEN 
    DISPLAY Usuario.Email Usuario.Senha 
      WITH FRAME winLogin IN WINDOW C-Win.
  ENABLE IMAGE-1 Usuario.Email Usuario.Senha bntRegistrar bntLogin bntsair 
      WITH FRAME winLogin IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-winLogin}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

