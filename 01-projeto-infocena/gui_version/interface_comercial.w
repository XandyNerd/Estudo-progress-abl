&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 

/* Variáveis de Controle de Clientes */
DEFINE VARIABLE lModoEdicao AS LOGICAL NO-UNDO INITIAL FALSE.
/*------------------------------------------------------------------------
  File: interface_comercial.w
  Description: Módulo Comercial ERP Infocena
------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWindowState AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWidth AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioHeight AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioX AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioY AS INTEGER NO-UNDO.

/* Buffers Adicionais para evitar conflitos de Lock */
DEFINE BUFFER bCliID FOR Cliente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define FRAME-NAME fMain

&Scoped-Define ENABLED-OBJECTS LogoInfocena btn-cliente btn-pedido btn-nfe btn-voltar 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

DEFINE BUTTON btn-cliente 
     LABEL "CADASTRO DE CLIENTE" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-pedido 
     LABEL "PEDIDO DE VENDA" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-nfe 
     LABEL "EMISSAO NF-e SIMPLIFICADA" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-voltar 
     LABEL "Voltar" 
     SIZE 15 BY 1.52.

DEFINE IMAGE LogoInfocena
     FILENAME "..\LogoInfocena.jpg":U
     STRETCH-TO-FIT
     SIZE 74 BY 6.

/* --- OBJETOS DO CADASTRO DE CLIENTES --- */

/* Browse */
DEFINE QUERY qClientes FOR Cliente SCROLLING.
DEFINE BROWSE brClientes QUERY qClientes NO-LOCK 
    DISPLAY Cliente.CodCliente LABEL "Cod" WIDTH 8
            Cliente.Nome       LABEL "Nome / Razao Social" WIDTH 35
            Cliente.CNPJ-CPF   LABEL "CNPJ / CPF" WIDTH 20
            Cliente.Cidade     LABEL "Cidade" WIDTH 15
            Cliente.Estado     LABEL "UF" WIDTH 5
    WITH NO-ROW-MARKERS SEPARATORS SIZE 124 BY 8 FIT-LAST-COLUMN.

/* Botoes de Clientes */
DEFINE BUTTON btnNovo     LABEL "&Novo"     SIZE 15 BY 1.14.
DEFINE BUTTON btnSalvar   LABEL "&Salvar"   SIZE 15 BY 1.14.
DEFINE BUTTON btnExcluir  LABEL "&Excluir"  SIZE 15 BY 1.14.
DEFINE BUTTON btnCancelar LABEL "&Cancelar" SIZE 15 BY 1.14.
DEFINE BUTTON btnVoltarCli LABEL "&Voltar"   SIZE 15 BY 1.14.

/* Campos de Edicao */
DEFINE VARIABLE iCod        AS INTEGER   FORMAT ">>>>9" LABEL "Codigo"    VIEW-AS FILL-IN SIZE 10 BY 1 NO-UNDO.
DEFINE VARIABLE cNome       AS CHARACTER FORMAT "x(60)" LABEL "Nome"      VIEW-AS FILL-IN SIZE 85 BY 1 NO-UNDO.
DEFINE VARIABLE cEmail      AS CHARACTER FORMAT "x(60)" LABEL "Email"     VIEW-AS FILL-IN SIZE 50 BY 1 NO-UNDO.
DEFINE VARIABLE cTelefone   AS CHARACTER FORMAT "x(20)" LABEL "Telefone"  VIEW-AS FILL-IN SIZE 20 BY 1 NO-UNDO.
DEFINE VARIABLE cCNPJ       AS CHARACTER FORMAT "x(20)" LABEL "CNPJ/CPF"  VIEW-AS FILL-IN SIZE 25 BY 1 NO-UNDO.
DEFINE VARIABLE dLimite     AS DECIMAL   FORMAT ">>,>>9.99" LABEL "Limite" VIEW-AS FILL-IN SIZE 15 BY 1 NO-UNDO.
DEFINE VARIABLE cTipo       AS CHARACTER INITIAL "CPF"  LABEL "Tipo"   VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS "Fisica (CPF)", "CPF", "Juridica (CNPJ)", "CNPJ" SIZE 45 BY 1 NO-UNDO.

/* Campos de Endereco */
DEFINE VARIABLE cCEP        AS CHARACTER FORMAT "x(10)" LABEL "CEP"        VIEW-AS FILL-IN SIZE 12 BY 1 NO-UNDO.
DEFINE VARIABLE cEnd        AS CHARACTER FORMAT "x(80)" LABEL "Endereco"   VIEW-AS FILL-IN SIZE 85 BY 1 NO-UNDO.
DEFINE VARIABLE cNum        AS CHARACTER FORMAT "x(10)" LABEL "Numero"     VIEW-AS FILL-IN SIZE 10 BY 1 NO-UNDO.
DEFINE VARIABLE cComp       AS CHARACTER FORMAT "x(40)" LABEL "Comp."      VIEW-AS FILL-IN SIZE 30 BY 1 NO-UNDO.
DEFINE VARIABLE cBairro     AS CHARACTER FORMAT "x(40)" LABEL "Bairro"     VIEW-AS FILL-IN SIZE 30 BY 1 NO-UNDO.
DEFINE VARIABLE cCid        AS CHARACTER FORMAT "x(30)" LABEL "Cidade"     VIEW-AS FILL-IN SIZE 30 BY 1 NO-UNDO.
DEFINE VARIABLE cUF         AS CHARACTER FORMAT "x(2)"  LABEL "UF"         
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"
     SIZE 10 BY 1 NO-UNDO.
DEFINE VARIABLE cRef        AS CHARACTER FORMAT "x(100)" LABEL "Pto. Ref." VIEW-AS FILL-IN SIZE 50 BY 1 NO-UNDO.


DEFINE RECTANGLE rectDados   SIZE 124 BY 5.5.
DEFINE RECTANGLE rectEnd     SIZE 124 BY 5.

DEFINE RECTANGLE rectFundo SIZE 126 BY 20.
DEFINE RECTANGLE RectTopo  SIZE 130 BY 4.5 BGCOLOR 1.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btn-cliente AT ROW 10 COL 32.5
     btn-pedido AT ROW 13 COL 32.5
     btn-nfe AT ROW 16 COL 32.5
     btn-voltar AT ROW 19 COL 42.5
     LogoInfocena AT ROW 1.71 COL 11 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 100 BY 23 WIDGET-ID 100.

DEFINE FRAME fClientes
    brClientes  AT ROW 5 COL 3
    
    "DADOS BASICOS" AT ROW 13.5 COL 5 FONT 6
    rectDados   AT ROW 14 COL 3
    cTipo       AT ROW 15.0 COL 12 COLON-ALIGNED
    cCNPJ       AT ROW 15.0 COL 65 COLON-ALIGNED
    cNome       AT ROW 16.0 COL 12 COLON-ALIGNED
    cTelefone   AT ROW 17.0 COL 12 COLON-ALIGNED
    cEmail      AT ROW 17.0 COL 50 COLON-ALIGNED
    dLimite     AT ROW 17.0 COL 95 COLON-ALIGNED
    
    "ENDERECO"  AT ROW 19.5 COL 5 FONT 6
    rectEnd     AT ROW 20.0 COL 3
    cCEP        AT ROW 21.0 COL 12 COLON-ALIGNED
    cEnd        AT ROW 21.0 COL 35 COLON-ALIGNED
    cNum        AT ROW 22.0 COL 12 COLON-ALIGNED
    cComp       AT ROW 22.0 COL 35 COLON-ALIGNED
    cBairro     AT ROW 22.0 COL 80 COLON-ALIGNED
    cCid        AT ROW 23.0 COL 12 COLON-ALIGNED
    cUF         AT ROW 23.0 COL 55 COLON-ALIGNED
    cRef        AT ROW 23.0 COL 70 COLON-ALIGNED

    btnNovo      AT ROW 25.5 COL 5
    btnSalvar    AT ROW 25.5 COL 22
    btnExcluir   AT ROW 25.5 COL 39
    btnCancelar  AT ROW 25.5 COL 56
    btnVoltarCli AT ROW 25.5 COL 110

    RectTopo    AT ROW 1 COL 1
    "MODULO COMERCIAL - CADASTRO DE CLIENTES" VIEW-AS TEXT
      SIZE 50 BY 1 AT ROW 2.5 COL 55 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 130 BY 28.

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
         TITLE              = "Sistema ERP Infocena - Modulo Comercial"
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
ON WINDOW-RESIZED OF C-Win /* Sistema ERP Infocena - Modulo Comercial */
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
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cliente C-Win
ON CHOOSE OF btn-cliente IN FRAME fMain /* CADASTRO DE CLIENTE */
DO:
  /* Esconde o Menu e mostra Clientes */
  HIDE FRAME fMain.
  RUN enable_fClientes.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-pedido C-Win
ON CHOOSE OF btn-pedido IN FRAME fMain /* PEDIDO DE VENDA */
DO:
  RUN logica_comercial.p (INPUT pUsuarioNome, INPUT "PEDIDOS").
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-nfe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-nfe C-Win
ON CHOOSE OF btn-nfe IN FRAME fMain /* EMISSAO NF-e SIMPLIFICADA */
DO:
  RUN logica_comercial.p (INPUT pUsuarioNome, INPUT "NFE").
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-voltar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-voltar C-Win
ON CHOOSE OF btn-voltar IN FRAME fMain /* Voltar */
DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* GATILHOS DE MASCARAS */
ON VALUE-CHANGED OF cTipo IN FRAME fClientes DO:
    ASSIGN cCNPJ:SCREEN-VALUE IN FRAME fClientes = "".
    APPLY "ENTRY" TO cCNPJ IN FRAME fClientes.
END.

ON ANY-PRINTABLE OF cCNPJ IN FRAME fClientes DO:
    DEFINE VARIABLE cVal AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFinal AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMax AS INTEGER NO-UNDO.
    
    /* Bloqueia letras */
    IF LAST-EVENT:FUNCTION < "0" OR LAST-EVENT:FUNCTION > "9" THEN RETURN NO-APPLY.

    iMax = (IF cTipo:SCREEN-VALUE IN FRAME fClientes = "CPF" THEN 11 ELSE 14).
    cVal = REPLACE(REPLACE(REPLACE(SELF:SCREEN-VALUE,".",""),"-",""),"/","").
    
    /* Limita tamanho */
    IF LENGTH(cVal) >= iMax THEN RETURN NO-APPLY.

    cVal = cVal + LAST-EVENT:FUNCTION.
    
    IF cTipo:SCREEN-VALUE IN FRAME fClientes = "CPF" THEN DO:
        IF LENGTH(cVal) = 11 THEN DO:
            cFinal = SUBSTRING(cVal,1,3) + "." + SUBSTRING(cVal,4,3) + "." + SUBSTRING(cVal,7,3) + "-" + SUBSTRING(cVal,10,2).
            SELF:SCREEN-VALUE = cFinal.
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO: /* CNPJ */
        IF LENGTH(cVal) = 14 THEN DO:
            cFinal = SUBSTRING(cVal,1,2) + "." + SUBSTRING(cVal,3,3) + "." + SUBSTRING(cVal,6,3) + "/" + SUBSTRING(cVal,9,4) + "-" + SUBSTRING(cVal,13,2).
            SELF:SCREEN-VALUE = cFinal.
            RETURN NO-APPLY.
        END.
    END.
END.

ON ANY-PRINTABLE OF cTelefone IN FRAME fClientes DO:
    DEFINE VARIABLE cVal AS CHARACTER NO-UNDO.
    
    /* Bloqueia letras */
    IF LAST-EVENT:FUNCTION < "0" OR LAST-EVENT:FUNCTION > "9" THEN RETURN NO-APPLY.

    cVal = REPLACE(REPLACE(REPLACE(REPLACE(SELF:SCREEN-VALUE,"(",""),")",""),"-","")," ","").
    
    /* Limita tamanho (11 digitos) */
    IF LENGTH(cVal) >= 11 THEN RETURN NO-APPLY.

    cVal = cVal + LAST-EVENT:FUNCTION.
    
    IF LENGTH(cVal) = 11 THEN DO:
        SELF:SCREEN-VALUE = "(" + SUBSTRING(cVal,1,2) + ") " + 
                            SUBSTRING(cVal,3,1) + " " + 
                            SUBSTRING(cVal,4,4) + "-" + 
                            SUBSTRING(cVal,8,4).
        RETURN NO-APPLY.
    END.
END.

ON ANY-PRINTABLE OF cCEP IN FRAME fClientes DO:
    /* Bloqueia letras */
    IF LAST-EVENT:FUNCTION < "0" OR LAST-EVENT:FUNCTION > "9" THEN RETURN NO-APPLY.
    
    /* Limita 8 digitos */
    IF LENGTH(REPLACE(SELF:SCREEN-VALUE, "-", "")) >= 8 THEN RETURN NO-APPLY.
END.

/* GATILHOS DO FRAME DE CLIENTES */
ON CHOOSE OF btnVoltarCli IN FRAME fClientes DO:
    HIDE FRAME fClientes.
    RUN enable_UI.
END.

ON CHOOSE OF btnNovo IN FRAME fClientes DO:
    ASSIGN lModoEdicao = TRUE.
    RUN habilita_campos.
    RUN limpa_campos.
    APPLY "ENTRY" TO cNome IN FRAME fClientes.
END.

ON CHOOSE OF btnSalvar IN FRAME fClientes DO:
    RUN salvar_cliente.
END.

ON CHOOSE OF btnExcluir IN FRAME fClientes DO:
    MESSAGE "Deseja realmente excluir este cliente?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lResposta AS LOGICAL.
    IF lResposta THEN RUN excluir_cliente.
END.

ON CHOOSE OF btnCancelar IN FRAME fClientes DO:
    ASSIGN lModoEdicao = FALSE.
    RUN habilita_campos.
    RUN limpa_campos.
END.

ON LEAVE OF cCEP IN FRAME fClientes DO:
    IF SELF:SCREEN-VALUE <> "" THEN RUN busca_cep.
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
  
  /* Força a centralização dos FRAMES dentro da Janela */
  IF VALID-HANDLE(FRAME fMain:HANDLE) THEN
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2.

  IF VALID-HANDLE(FRAME fClientes:HANDLE) THEN
      ASSIGN FRAME fClientes:X = (C-Win:WIDTH-PIXELS - FRAME fClientes:WIDTH-PIXELS) / 2
             FRAME fClientes:Y = (C-Win:HEIGHT-PIXELS - FRAME fClientes:HEIGHT-PIXELS) / 2.

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
  ENABLE LogoInfocena btn-cliente btn-pedido btn-nfe btn-voltar 
      WITH FRAME fMain IN WINDOW C-Win.
  VIEW C-Win.
END PROCEDURE.

PROCEDURE enable_fClientes:
    OPEN QUERY qClientes FOR EACH Cliente.
    ENABLE brClientes btnNovo btnSalvar btnExcluir btnCancelar btnVoltarCli 
           cTipo cNome cCNPJ cEmail cTelefone dLimite
           cCEP cEnd cNum cComp cBairro cCid cUF cRef
           WITH FRAME fClientes IN WINDOW C-Win.
    
    /* Exibe o frame redesenhado */
    VIEW FRAME fClientes.
    
    /* Centraliza se for a primeira vez ou se redimensionar */
    ASSIGN FRAME fClientes:X = (C-Win:WIDTH-PIXELS - FRAME fClientes:WIDTH-PIXELS) / 2
           FRAME fClientes:Y = (C-Win:HEIGHT-PIXELS - FRAME fClientes:HEIGHT-PIXELS) / 2 NO-ERROR.
END PROCEDURE.

PROCEDURE habilita_campos:
    /* Ativa campos apenas em modo de edicao */
    ASSIGN cNome:SENSITIVE IN FRAME fClientes     = lModoEdicao
           cCNPJ:SENSITIVE IN FRAME fClientes     = lModoEdicao
           cEmail:SENSITIVE IN FRAME fClientes    = lModoEdicao
           cTelefone:SENSITIVE IN FRAME fClientes = lModoEdicao
           dLimite:SENSITIVE IN FRAME fClientes   = lModoEdicao
           cCEP:SENSITIVE IN FRAME fClientes      = lModoEdicao
           cEnd:SENSITIVE IN FRAME fClientes      = lModoEdicao
           cNum:SENSITIVE IN FRAME fClientes      = lModoEdicao
           cComp:SENSITIVE IN FRAME fClientes     = lModoEdicao
           cBairro:SENSITIVE IN FRAME fClientes   = lModoEdicao
           cCid:SENSITIVE IN FRAME fClientes      = lModoEdicao
           cUF:SENSITIVE IN FRAME fClientes       = lModoEdicao
           cRef:SENSITIVE IN FRAME fClientes      = lModoEdicao
           cTipo:SENSITIVE IN FRAME fClientes     = lModoEdicao.
    
    /* Controla Botoes */
    ASSIGN btnSalvar:SENSITIVE IN FRAME fClientes    = lModoEdicao
           btnCancelar:SENSITIVE IN FRAME fClientes  = lModoEdicao
           btnNovo:SENSITIVE IN FRAME fClientes      = NOT lModoEdicao
           btnExcluir:SENSITIVE IN FRAME fClientes   = NOT lModoEdicao
           btnVoltarCli:SENSITIVE IN FRAME fClientes  = NOT lModoEdicao
           brClientes:SENSITIVE IN FRAME fClientes   = NOT lModoEdicao.
END PROCEDURE.

PROCEDURE limpa_campos:
    ASSIGN cNome:SCREEN-VALUE IN FRAME fClientes     = ""
           cCNPJ:SCREEN-VALUE IN FRAME fClientes     = ""
           cEmail:SCREEN-VALUE IN FRAME fClientes    = ""
           cTelefone:SCREEN-VALUE IN FRAME fClientes = ""
           dLimite:SCREEN-VALUE IN FRAME fClientes   = "0.00"
           cCEP:SCREEN-VALUE IN FRAME fClientes      = ""
           cEnd:SCREEN-VALUE IN FRAME fClientes      = ""
           cNum:SCREEN-VALUE IN FRAME fClientes      = ""
           cComp:SCREEN-VALUE IN FRAME fClientes     = ""
           cBairro:SCREEN-VALUE IN FRAME fClientes   = ""
           cCid:SCREEN-VALUE IN FRAME fClientes      = ""
           cUF:SCREEN-VALUE IN FRAME fClientes       = ""
           cRef:SCREEN-VALUE IN FRAME fClientes      = "".
END PROCEDURE.

PROCEDURE salvar_cliente:
    DEFINE VARIABLE iProxID AS INTEGER NO-UNDO.
    DEFINE VARIABLE cMail   AS CHARACTER NO-UNDO.

    /* Validacoes */
    ASSIGN cMail = cEmail:SCREEN-VALUE IN FRAME fClientes.
    
    IF cNome:SCREEN-VALUE IN FRAME fClientes = "" OR
       cCNPJ:SCREEN-VALUE IN FRAME fClientes = "" OR
       cTelefone:SCREEN-VALUE IN FRAME fClientes = "" THEN DO:
        MESSAGE "Nome, CPF/CNPJ e Telefone sao obrigatórios!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    IF INDEX(cMail, "@") = 0 OR INDEX(cMail, ".") = 0 THEN DO:
        MESSAGE "Email invalido! Informe um email no formato nome@dominio.com" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cEmail IN FRAME fClientes.
        RETURN.
    END.

    IF cCEP:SCREEN-VALUE IN FRAME fClientes = "" OR
       cEnd:SCREEN-VALUE IN FRAME fClientes = "" OR
       cNum:SCREEN-VALUE IN FRAME fClientes = "" THEN DO:
        MESSAGE "CEP, Endereo e Numero sao obrigatorios!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    /* 1. Busca o proximo ID */
    FIND LAST bCliID USE-INDEX pk_cliente NO-LOCK NO-ERROR.
    ASSIGN iProxID = (IF AVAILABLE bCliID THEN bCliID.CodCliente + 1 ELSE 1).

    /* 2. Cria o registro */
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        CREATE Cliente.
        ASSIGN Cliente.CodCliente = iProxID
               Cliente.Nome       = cNome:SCREEN-VALUE   IN FRAME fClientes
               Cliente.CNPJ-CPF   = cCNPJ:SCREEN-VALUE   IN FRAME fClientes
               Cliente.Email      = cEmail:SCREEN-VALUE  IN FRAME fClientes
               Cliente.Telefone   = cTelefone:SCREEN-VALUE IN FRAME fClientes
               Cliente.LimiteCredito = DECIMAL(dLimite:SCREEN-VALUE IN FRAME fClientes)
               Cliente.CEP        = cCEP:SCREEN-VALUE    IN FRAME fClientes
               Cliente.Endereco   = cEnd:SCREEN-VALUE    IN FRAME fClientes
               Cliente.Numero     = cNum:SCREEN-VALUE    IN FRAME fClientes
               Cliente.Complemento = cComp:SCREEN-VALUE   IN FRAME fClientes
               Cliente.Bairro      = cBairro:SCREEN-VALUE IN FRAME fClientes
               Cliente.Cidade      = cCid:SCREEN-VALUE    IN FRAME fClientes
               Cliente.Estado      = cUF:SCREEN-VALUE     IN FRAME fClientes
               Cliente.PontoReferencia = cRef:SCREEN-VALUE IN FRAME fClientes.
    END.

    MESSAGE "Cliente salvo com sucesso! Codigo: " iProxID VIEW-AS ALERT-BOX INFORMATION.
    
    ASSIGN lModoEdicao = FALSE.
    RUN habilita_campos.
    RUN enable_fClientes.
END PROCEDURE.

PROCEDURE busca_cep:
    /* Integracao via PowerShell para buscar CEP (ViaCEP) */
    DEFINE VARIABLE cCmd AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cBuscaCEP AS CHARACTER NO-UNDO.
    
    cBuscaCEP = REPLACE(cCEP:SCREEN-VALUE IN FRAME fClientes, "-","").
    IF LENGTH(cBuscaCEP) <> 8 THEN RETURN.
    
    /* Executa busca via PowerShell e salva em arquivo temporario */
    cCmd = "powershell -Command ""Invoke-RestMethod -Uri 'https://viacep.com.br/ws/" + cBuscaCEP + "/json/' | ConvertTo-Json | Out-File -FilePath 'cep_tmp.json' -Encoding utf8""".
    OS-COMMAND SILENT VALUE(cCmd).
    
    /* Le o arquivo JSON (Progress 11+ parse simplificado ou via leitura de texto) */
    DEFINE VARIABLE cLinha AS CHARACTER NO-UNDO.
    INPUT FROM "cep_tmp.json".
    REPEAT:
        IMPORT UNFORMATTED cLinha.
        IF INDEX(cLinha, """logradouro"":") > 0 THEN DO:
            cLinha = ENTRY(2, cLinha, ":").
            cEnd:SCREEN-VALUE IN FRAME fClientes = TRIM(cLinha, " ""{},").
        END.
        IF INDEX(cLinha, """bairro"":") > 0 THEN DO:
            cLinha = ENTRY(2, cLinha, ":").
            cBairro:SCREEN-VALUE IN FRAME fClientes = TRIM(cLinha, " ""{},").
        END.
        IF INDEX(cLinha, """localidade"":") > 0 THEN DO:
            cLinha = ENTRY(2, cLinha, ":").
            cCid:SCREEN-VALUE IN FRAME fClientes = TRIM(cLinha, " ""{},").
        END.
        IF INDEX(cLinha, """uf"":") > 0 THEN DO:
            cLinha = ENTRY(2, cLinha, ":").
            cLinha = TRIM(cLinha, " ""{},").
            IF LENGTH(cLinha) > 2 THEN cLinha = SUBSTRING(cLinha, 1, 2).
            cUF:SCREEN-VALUE IN FRAME fClientes = cLinha.
        END.
    END.
    INPUT CLOSE.
    
    /* Remove arquivo temporario */
    OS-DELETE VALUE("cep_tmp.json").
END PROCEDURE.

PROCEDURE excluir_cliente:
    /* Para excluir, precisamos achar o registro com EXCLUSIVE-LOCK */
    IF AVAILABLE Cliente THEN DO:
        DO TRANSACTION:
            FIND CURRENT Cliente EXCLUSIVE-LOCK.
            DELETE Cliente.
        END.
        RUN enable_fClientes.
        MESSAGE "Cliente excluido!" VIEW-AS ALERT-BOX INFORMATION.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
