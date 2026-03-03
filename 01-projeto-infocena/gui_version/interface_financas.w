&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------
  File: interface_financas.w
  Description: Módulo Unificado de Finanças e Fiscal ERP Infocena
------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWindowState AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWidth AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioHeight AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioX AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioY AS INTEGER NO-UNDO.

/* Variaveis de controle */
DEFINE VARIABLE iState  AS INTEGER NO-UNDO.
DEFINE VARIABLE iWidth  AS INTEGER NO-UNDO.
DEFINE VARIABLE iHeight AS INTEGER NO-UNDO.
DEFINE VARIABLE iX      AS INTEGER NO-UNDO.
DEFINE VARIABLE iY      AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 
&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no
&Scoped-define FRAME-NAME fMain
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* --- Botoes Main --- */
DEFINE BUTTON btn-receber LABEL "CONTAS A RECEBER" SIZE 35 BY 2.
DEFINE BUTTON btn-fiscal LABEL "CONFIGURACAO FISCAL" SIZE 35 BY 2.
DEFINE BUTTON btn-voltar LABEL "Voltar ao Menu" SIZE 15 BY 1.5.

/* --- Botoes Fiscal --- */
DEFINE BUTTON btn-ncm LABEL "CADASTRO NCM" SIZE 35 BY 2.
DEFINE BUTTON btn-cfop LABEL "CADASTRO CFOP" SIZE 35 BY 2.
DEFINE BUTTON btn-regras LABEL "REGRAS DE IMPOSTOS" SIZE 35 BY 2.
DEFINE BUTTON btn-fisc-back LABEL "Voltar ao Financeiro" SIZE 25 BY 1.5.

/* --- Componentes NCM --- */
DEFINE QUERY qr-ncm FOR NCM SCROLLING.
DEFINE BROWSE br-ncm QUERY qr-ncm NO-LOCK DISPLAY 
    NCM.CodNCM COLUMN-LABEL "NCM" WIDTH 12
    NCM.Descricao COLUMN-LABEL "Descricao" WIDTH 50
    NCM.AliqIPI COLUMN-LABEL "% IPI" WIDTH 8
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 12.

DEFINE BUTTON btn-ncm-novo LABEL "Novo NCM" SIZE 15 BY 1.5.
DEFINE BUTTON btn-ncm-excluir LABEL "Excluir" SIZE 15 BY 1.5.
DEFINE BUTTON btn-ncm-voltar LABEL "Voltar ao Fiscal" SIZE 20 BY 1.5.

/* Campos de Edicao NCM (Integrados) */
DEFINE VARIABLE fiNCM_Cod  AS CHARACTER FORMAT "X(8)" LABEL "Codigo NCM" VIEW-AS FILL-IN SIZE 15 BY 1 NO-UNDO.
DEFINE VARIABLE fiNCM_Desc AS CHARACTER FORMAT "X(60)" LABEL "Descricao" VIEW-AS FILL-IN SIZE 50 BY 1 NO-UNDO.
DEFINE VARIABLE fiNCM_Aliq AS DECIMAL   FORMAT ">>9.99" LABEL "% IPI" VIEW-AS FILL-IN SIZE 10 BY 1 NO-UNDO.
DEFINE BUTTON btn-ncm-salvar   LABEL "SALVAR"   SIZE 15 BY 1.14.
DEFINE BUTTON btn-ncm-cancelar LABEL "CANCELAR" SIZE 15 BY 1.14.

/* --- Componentes CFOP --- */
DEFINE QUERY qr-cfop FOR CFOP SCROLLING.
DEFINE BROWSE br-cfop QUERY qr-cfop NO-LOCK DISPLAY 
    CFOP.CodCFOP COLUMN-LABEL "CFOP" WIDTH 10
    CFOP.Descricao COLUMN-LABEL "Descricao" WIDTH 55
    CFOP.GeraFinanceiro COLUMN-LABEL "Financeiro?" WIDTH 10
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 12.
DEFINE BUTTON btn-cfop-novo LABEL "Novo CFOP" SIZE 15 BY 1.5.
DEFINE BUTTON btn-cfop-excluir LABEL "Excluir" SIZE 15 BY 1.5.
DEFINE BUTTON btn-cfop-voltar LABEL "Voltar ao Fiscal" SIZE 20 BY 1.5.

/* --- Componentes Regras --- */
DEFINE QUERY qr-regras FOR RegraFiscal SCROLLING.
DEFINE BROWSE br-regras QUERY qr-regras NO-LOCK DISPLAY 
    RegraFiscal.UF_Origem COLUMN-LABEL "De" WIDTH 6
    RegraFiscal.UF_Destino COLUMN-LABEL "Para" WIDTH 6
    RegraFiscal.AliqICMS COLUMN-LABEL "% ICMS" WIDTH 10
    RegraFiscal.CodCFOP COLUMN-LABEL "CFOP" WIDTH 10
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 12.
DEFINE BUTTON btn-regras-novo LABEL "Nova Regra" SIZE 15 BY 1.5.
DEFINE BUTTON btn-regras-excluir LABEL "Excluir" SIZE 15 BY 1.5.
DEFINE BUTTON btn-regras-auto LABEL "Carga Inicial SP" SIZE 20 BY 1.5.
DEFINE BUTTON btn-regras-voltar LABEL "Voltar ao Fiscal" SIZE 20 BY 1.5.

DEFINE IMAGE LogoInfocena FILENAME "..\LogoInfocena.jpg":U STRETCH-TO-FIT SIZE 74 BY 6.

/* ************************  Frame Definitions  *********************** */
DEFINE FRAME fMain
    btn-receber AT ROW 10 COL 32.5
    btn-fiscal AT ROW 13 COL 32.5
    btn-voltar AT ROW 16 COL 42.5
    LogoInfocena AT ROW 1.71 COL 11
    WITH 1 DOWN NO-BOX OVERLAY AT COLUMN 1 ROW 1 SIZE 100 BY 23.

DEFINE FRAME fFiscal
    btn-ncm AT ROW 10 COL 32.5
    btn-cfop AT ROW 13 COL 32.5
    btn-regras AT ROW 16 COL 32.5
    btn-fisc-back AT ROW 19 COL 37.5
    LogoInfocena AT ROW 1.71 COL 11
    WITH 1 DOWN NO-BOX OVERLAY AT COLUMN 1 ROW 1 SIZE 100 BY 23.

DEFINE FRAME fNCM_List
    "GERENCIAMENTO DE NCMS" AT ROW 1.5 COL 5
    br-ncm AT ROW 3 COL 5
    btn-ncm-novo AT ROW 16 COL 5
    btn-ncm-excluir AT ROW 16 COL 22
    btn-ncm-voltar AT ROW 16 COL 75
    WITH 1 DOWN NO-BOX OVERLAY AT COLUMN 1 ROW 1 SIZE 100 BY 23.

DEFINE FRAME fNCM_Edit
    "CADASTRO / EDICAO DE NCM" AT ROW 1.5 COL 5
    fiNCM_Cod AT ROW 5 COL 18 COLON-ALIGNED
    fiNCM_Desc AT ROW 7 COL 18 COLON-ALIGNED
    fiNCM_Aliq AT ROW 9 COL 18 COLON-ALIGNED
    btn-ncm-salvar AT ROW 12 COL 20
    btn-ncm-cancelar AT ROW 12 COL 37
    WITH 1 DOWN NO-BOX OVERLAY AT COLUMN 1 ROW 1 SIZE 100 BY 23.

DEFINE FRAME fCFOP
    "CONSULTA DE CFOPS" AT ROW 1 COL 5
    br-cfop AT ROW 3 COL 5
    btn-cfop-novo AT ROW 16 COL 5
    btn-cfop-excluir AT ROW 16 COL 22
    btn-cfop-voltar AT ROW 16 COL 75
    WITH 1 DOWN NO-BOX OVERLAY AT COLUMN 1 ROW 1 SIZE 100 BY 23.

DEFINE FRAME fRegras
    "REGRAS DE IMPOSTO (ICMS)" AT ROW 1 COL 5
    br-regras AT ROW 3 COL 5
    btn-regras-novo AT ROW 16 COL 5
    btn-regras-excluir AT ROW 16 COL 22
    btn-regras-auto AT ROW 16 COL 39
    btn-regras-voltar AT ROW 16 COL 75
    WITH 1 DOWN NO-BOX OVERLAY AT COLUMN 1 ROW 1 SIZE 100 BY 23.

/* ************************  Create Window  ************************** */
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ERP Infocena - Financas e Fiscal"
         HEIGHT             = 32.14
         WIDTH              = 273.2
         MAX-HEIGHT         = 33.19
         MAX-WIDTH          = 273.2
         VIRTUAL-HEIGHT     = 33.19
         VIRTUAL-WIDTH      = 273.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         SENSITIVE          = yes.

/* ************************  Control Triggers  ************************ */
/* ************************  Control Triggers  ************************ */
ON WINDOW-CLOSE OF C-Win 
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON WINDOW-RESIZED OF C-Win
DO:
  /* Mantem centralizado se o usuario redimensionar a janela manualmente */
  IF VALID-HANDLE(FRAME fMain:HANDLE) THEN 
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2 NO-ERROR.

  IF VALID-HANDLE(FRAME fFiscal:HANDLE) THEN 
      ASSIGN FRAME fFiscal:X = (C-Win:WIDTH-PIXELS - FRAME fFiscal:WIDTH-PIXELS) / 2
             FRAME fFiscal:Y = (C-Win:HEIGHT-PIXELS - FRAME fFiscal:HEIGHT-PIXELS) / 2 NO-ERROR.

  IF VALID-HANDLE(FRAME fNCM_List:HANDLE) THEN 
      ASSIGN FRAME fNCM_List:X = (C-Win:WIDTH-PIXELS - FRAME fNCM_List:WIDTH-PIXELS) / 2
             FRAME fNCM_List:Y = (C-Win:HEIGHT-PIXELS - FRAME fNCM_List:HEIGHT-PIXELS) / 2 NO-ERROR.

  IF VALID-HANDLE(FRAME fNCM_Edit:HANDLE) THEN 
      ASSIGN FRAME fNCM_Edit:X = (C-Win:WIDTH-PIXELS - FRAME fNCM_Edit:WIDTH-PIXELS) / 2
             FRAME fNCM_Edit:Y = (C-Win:HEIGHT-PIXELS - FRAME fNCM_Edit:HEIGHT-PIXELS) / 2 NO-ERROR.

  IF VALID-HANDLE(FRAME fCFOP:HANDLE) THEN 
      ASSIGN FRAME fCFOP:X = (C-Win:WIDTH-PIXELS - FRAME fCFOP:WIDTH-PIXELS) / 2
             FRAME fCFOP:Y = (C-Win:HEIGHT-PIXELS - FRAME fCFOP:HEIGHT-PIXELS) / 2 NO-ERROR.

  IF VALID-HANDLE(FRAME fRegras:HANDLE) THEN 
      ASSIGN FRAME fRegras:X = (C-Win:WIDTH-PIXELS - FRAME fRegras:WIDTH-PIXELS) / 2
             FRAME fRegras:Y = (C-Win:HEIGHT-PIXELS - FRAME fRegras:HEIGHT-PIXELS) / 2 NO-ERROR.
END.

/* Triggers fMain */
ON CHOOSE OF btn-receber IN FRAME fMain DO:
  MESSAGE "Contas a Receber em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
END.
ON CHOOSE OF btn-fiscal IN FRAME fMain DO:
  HIDE FRAME fMain.
  RUN enable_fFiscal.
END.
ON CHOOSE OF btn-voltar IN FRAME fMain DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* Triggers fFiscal */
ON CHOOSE OF btn-ncm IN FRAME fFiscal DO:
  HIDE FRAME fFiscal.
  RUN enable_fNCM.
END.
ON CHOOSE OF btn-cfop IN FRAME fFiscal DO:
  HIDE FRAME fFiscal.
  RUN enable_fCFOP.
END.
ON CHOOSE OF btn-regras IN FRAME fFiscal DO:
  HIDE FRAME fFiscal.
  RUN enable_fRegras.
END.
ON CHOOSE OF btn-fisc-back IN FRAME fFiscal DO:
  HIDE FRAME fFiscal.
  RUN enable_UI.
END.

/* Triggers Voltar */
ON CHOOSE OF btn-ncm-voltar IN FRAME fNCM_List DO: HIDE FRAME fNCM_List. RUN enable_fFiscal. END.
ON CHOOSE OF btn-cfop-voltar IN FRAME fCFOP DO: HIDE FRAME fCFOP. RUN enable_fFiscal. END.
ON CHOOSE OF btn-regras-voltar IN FRAME fRegras DO: HIDE FRAME fRegras. RUN enable_fFiscal. END.

/* Triggers Ação NCM */
ON CHOOSE OF btn-ncm-novo IN FRAME fNCM_List DO:
    ASSIGN fiNCM_Cod:SCREEN-VALUE IN FRAME fNCM_Edit = ""
           fiNCM_Desc:SCREEN-VALUE IN FRAME fNCM_Edit = ""
           fiNCM_Aliq:SCREEN-VALUE IN FRAME fNCM_Edit = "0".
    
    HIDE FRAME fNCM_List.
    RUN enable_fNCM_Edit.
END.

ON CHOOSE OF btn-ncm-salvar IN FRAME fNCM_Edit DO:
    ASSIGN fiNCM_Cod fiNCM_Desc fiNCM_Aliq.
    
    IF fiNCM_Cod = "" THEN DO:
        MESSAGE "Codigo NCM e obrigatorio." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    
    FIND NCM WHERE NCM.CodNCM = fiNCM_Cod EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE NCM THEN DO:
        CREATE NCM.
        ASSIGN NCM.CodNCM = fiNCM_Cod.
    END.
    
    ASSIGN NCM.Descricao = fiNCM_Desc
           NCM.AliqIPI   = fiNCM_Aliq.
    
    MESSAGE "NCM salvo com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
    APPLY "CHOOSE" TO btn-ncm-cancelar.
END.

ON CHOOSE OF btn-ncm-cancelar IN FRAME fNCM_Edit DO:
    HIDE FRAME fNCM_Edit.
    RUN enable_fNCM.
END.

ON CHOOSE OF btn-ncm-excluir IN FRAME fNCM_List DO:
    IF AVAILABLE NCM THEN DO:
        MESSAGE "Confirmar exclusao do NCM " + NCM.CodNCM + "?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lExec AS LOGICAL.
        IF lExec THEN DO:
            FIND CURRENT NCM EXCLUSIVE-LOCK.
            DELETE NCM.
            {&OPEN-QUERY-br-ncm}
        END.
    END.
END.

/* Triggers Ação CFOP */
ON CHOOSE OF btn-cfop-novo IN FRAME fCFOP DO:
    MESSAGE "Funcionalidade de Novo CFOP em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
END.

ON CHOOSE OF btn-cfop-excluir IN FRAME fCFOP DO:
    IF AVAILABLE CFOP THEN DO:
        MESSAGE "Confirmar exclusao do CFOP " + CFOP.CodCFOP + "?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lExec AS LOGICAL.
    END.
END.

/* Triggers Ação Regras */
ON CHOOSE OF btn-regras-novo IN FRAME fRegras DO:
    MESSAGE "Funcionalidade de Nova Regra em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
END.

ON CHOOSE OF btn-regras-excluir IN FRAME fRegras DO:
    IF AVAILABLE RegraFiscal THEN DO:
        MESSAGE "Confirmar exclusao da Regra " + RegraFiscal.UF_Origem + " -> " + RegraFiscal.UF_Destino + "?" 
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lExec AS LOGICAL.
    END.
END.

ON CHOOSE OF btn-regras-auto IN FRAME fRegras DO:
    MESSAGE "Isso ira carregar a tabela de ICMS Padrao saindo de SP para todos os Estados. Deseja continuar?" 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lExec AS LOGICAL.
    IF lExec THEN DO:
        RUN ../data/carga_fiscal_total.p.
        {&OPEN-QUERY-br-regras}
    END.
END.

/* ************************  Main Block  *********************** */
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

  /* Força a centralização do FRAME fMain inicial */
  IF VALID-HANDLE(FRAME fMain:HANDLE) THEN
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2 NO-ERROR.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* **********************  Internal Procedures  *********************** */
PROCEDURE disable_UI:
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

PROCEDURE enable_UI:
  ENABLE btn-receber btn-fiscal btn-voltar LogoInfocena WITH FRAME fMain IN WINDOW C-Win.
  
  /* Centraliza o frame dinamicamente */
  IF VALID-HANDLE(FRAME fMain:HANDLE) THEN
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2 NO-ERROR.

  VIEW FRAME fMain.
  VIEW C-Win.
END PROCEDURE.

PROCEDURE enable_fFiscal:
  ENABLE btn-ncm btn-cfop btn-regras btn-fisc-back LogoInfocena WITH FRAME fFiscal IN WINDOW C-Win.
  
  /* Centraliza o frame dinamicamente */
  IF VALID-HANDLE(FRAME fFiscal:HANDLE) THEN
      ASSIGN FRAME fFiscal:X = (C-Win:WIDTH-PIXELS - FRAME fFiscal:WIDTH-PIXELS) / 2
             FRAME fFiscal:Y = (C-Win:HEIGHT-PIXELS - FRAME fFiscal:HEIGHT-PIXELS) / 2 NO-ERROR.

  VIEW FRAME fFiscal.
END PROCEDURE.

PROCEDURE enable_fNCM:
  ENABLE br-ncm btn-ncm-novo btn-ncm-excluir btn-ncm-voltar WITH FRAME fNCM_List IN WINDOW C-Win.
  
  /* Centraliza o frame dinamicamente */
  IF VALID-HANDLE(FRAME fNCM_List:HANDLE) THEN
      ASSIGN FRAME fNCM_List:X = (C-Win:WIDTH-PIXELS - FRAME fNCM_List:WIDTH-PIXELS) / 2
             FRAME fNCM_List:Y = (C-Win:HEIGHT-PIXELS - FRAME fNCM_List:HEIGHT-PIXELS) / 2 NO-ERROR.

  OPEN QUERY qr-ncm FOR EACH NCM NO-LOCK.
  VIEW FRAME fNCM_List.
END PROCEDURE.

PROCEDURE enable_fNCM_Edit:
  ENABLE fiNCM_Cod fiNCM_Desc fiNCM_Aliq btn-ncm-salvar btn-ncm-cancelar WITH FRAME fNCM_Edit IN WINDOW C-Win.
  
  /* Centraliza o frame dinamicamente */
  IF VALID-HANDLE(FRAME fNCM_Edit:HANDLE) THEN
      ASSIGN FRAME fNCM_Edit:X = (C-Win:WIDTH-PIXELS - FRAME fNCM_Edit:WIDTH-PIXELS) / 2
             FRAME fNCM_Edit:Y = (C-Win:HEIGHT-PIXELS - FRAME fNCM_Edit:HEIGHT-PIXELS) / 2 NO-ERROR.

  VIEW FRAME fNCM_Edit.
END PROCEDURE.

PROCEDURE enable_fCFOP:
  ENABLE br-cfop btn-cfop-novo btn-cfop-excluir btn-cfop-voltar WITH FRAME fCFOP IN WINDOW C-Win.
  
  /* Centraliza o frame dinamicamente */
  IF VALID-HANDLE(FRAME fCFOP:HANDLE) THEN
      ASSIGN FRAME fCFOP:X = (C-Win:WIDTH-PIXELS - FRAME fCFOP:WIDTH-PIXELS) / 2
             FRAME fCFOP:Y = (C-Win:HEIGHT-PIXELS - FRAME fCFOP:HEIGHT-PIXELS) / 2 NO-ERROR.

  OPEN QUERY qr-cfop FOR EACH CFOP NO-LOCK.
  VIEW FRAME fCFOP.
END PROCEDURE.

PROCEDURE enable_fRegras:
  ENABLE br-regras btn-regras-novo btn-regras-excluir btn-regras-auto btn-regras-voltar WITH FRAME fRegras IN WINDOW C-Win.
  
  /* Centraliza o frame dinamicamente */
  IF VALID-HANDLE(FRAME fRegras:HANDLE) THEN
      ASSIGN FRAME fRegras:X = (C-Win:WIDTH-PIXELS - FRAME fRegras:WIDTH-PIXELS) / 2
             FRAME fRegras:Y = (C-Win:HEIGHT-PIXELS - FRAME fRegras:HEIGHT-PIXELS) / 2 NO-ERROR.

  OPEN QUERY qr-regras FOR EACH RegraFiscal NO-LOCK.
  VIEW FRAME fRegras.
END PROCEDURE.
