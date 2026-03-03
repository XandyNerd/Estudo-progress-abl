&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 

/*------------------------------------------------------------------------
  File: interface_suprimentos.w
  Description: Módulo Suprimentos ERP Infocena
------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWindowState AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioWidth AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioHeight AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioX AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pioY AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE yes

&Scoped-define FRAME-NAME fMain

&Scoped-Define ENABLED-OBJECTS LogoInfocena btn-produtos btn-fornecedor btn-compras btn-nfe btn-estoque btn-voltar 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE iCurrentProdID AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iCurrentForneID AS INTEGER NO-UNDO INITIAL 0.

/* Variáveis Cadastro de Produtos */
DEFINE VARIABLE cDescricao AS CHARACTER FORMAT "X(100)" NO-UNDO.

/* Variáveis Cadastro de Fornecedores */
DEFINE VARIABLE cRazaoSocial AS CHARACTER FORMAT "X(60)" NO-UNDO.
DEFINE VARIABLE cFantasia    AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE cCNPJ_Forne  AS CHARACTER FORMAT "X(18)" NO-UNDO.
DEFINE VARIABLE cEmail_Forne AS CHARACTER FORMAT "X(60)" NO-UNDO.
DEFINE VARIABLE cTel_Forne   AS CHARACTER FORMAT "X(15)" NO-UNDO.
DEFINE VARIABLE cEnd_Forne   AS CHARACTER FORMAT "X(60)" NO-UNDO.
DEFINE VARIABLE cCid_Forne   AS CHARACTER FORMAT "X(30)" NO-UNDO.
DEFINE VARIABLE cUF_Forne    AS CHARACTER FORMAT "X(2)" NO-UNDO.
DEFINE VARIABLE cCEP_Forne   AS CHARACTER FORMAT "X(9)" NO-UNDO.
/* Novos campos de endereco para Fornecedor */
DEFINE VARIABLE cNum_Forne   AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE cComp_Forne  AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE cBairro_Forne AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE cRef_Forne   AS CHARACTER FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE cUnidade   AS CHARACTER FORMAT "X(3)" NO-UNDO VIEW-AS COMBO-BOX LIST-ITEMS "UN","PC","KG","MT","LT","CX","DZ" INNER-LINES 5.
DEFINE VARIABLE cCodBarras AS CHARACTER FORMAT "X(14)" NO-UNDO.
DEFINE VARIABLE dPrecoCusto AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dPrecoVenda AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE cNCM       AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEFINE VARIABLE cCEST      AS CHARACTER FORMAT "X(7)" NO-UNDO.
DEFINE VARIABLE cMarca     AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VARIABLE dEstoqueMin AS DECIMAL   FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE lAtivo     AS LOGICAL   INITIAL YES NO-UNDO.
DEFINE VARIABLE cURLImagem AS CHARACTER FORMAT "X(256)" NO-UNDO.
DEFINE VARIABLE cLimiteAPI AS CHARACTER FORMAT "X(30)" NO-UNDO.

/* Variáveis Pedido de Compra */
DEFINE VARIABLE iNumPedido     AS INTEGER   FORMAT ">>>>>>>9" NO-UNDO.
DEFINE VARIABLE cStatusPedido  AS CHARACTER FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE dDataPedido    AS DATE      FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE iFornePedido   AS INTEGER   FORMAT ">>>>>>>9" NO-UNDO.
DEFINE VARIABLE cNomeFornePed  AS CHARACTER FORMAT "X(60)"    NO-UNDO.
DEFINE VARIABLE cCondPagto     AS CHARACTER FORMAT "X(40)"    NO-UNDO.
DEFINE VARIABLE dTotalPedido   AS DECIMAL   FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE cCompradorPed  AS CHARACTER FORMAT "X(40)"    NO-UNDO.

/* Variáveis Lançamento de Itens */
DEFINE VARIABLE iBuscaProd     AS INTEGER   FORMAT ">>>>>>>9" NO-UNDO.
DEFINE VARIABLE cDescProd      AS CHARACTER FORMAT "X(60)"    NO-UNDO.
DEFINE VARIABLE dItemQtd       AS DECIMAL   FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dItemPreco     AS DECIMAL   FORMAT "->>>,>>9.99" NO-UNDO.

/* Variáveis de Inteligência (Fase C) */
DEFINE VARIABLE cAlertaEstoque  AS CHARACTER FORMAT "X(40)"    NO-UNDO LABEL "".
DEFINE VARIABLE cVariacaoPreco  AS CHARACTER FORMAT "X(40)"    NO-UNDO LABEL "".
DEFINE VARIABLE lSincronizar    AS LOGICAL   INITIAL YES       NO-UNDO LABEL "Sincronizar Custo no Cadastro".
DEFINE VARIABLE dPrecoOrigProd  AS DECIMAL   NO-UNDO.

/* Tabela Temporária de Itens do Pedido */
DEFINE TEMP-TABLE ttItensPedido NO-UNDO
    FIELD Id_Pedido  AS INTEGER
    FIELD Sequencia  AS INTEGER
    FIELD Id_Produto AS INTEGER
    FIELD Descricao  AS CHARACTER FORMAT "X(40)"
    FIELD Quantidade AS DECIMAL   FORMAT "->>>,>>9.99"
    FIELD Preco_Unit AS DECIMAL   FORMAT "->>>,>>9.99"
    FIELD Total_Item AS DECIMAL   FORMAT "->>>,>>>,>>9.99"
    INDEX idx_seq IS PRIMARY Id_Pedido Sequencia.

/* Tabela Temporária de Itens do NFe Importado */
DEFINE TEMP-TABLE ttItensNFe NO-UNDO
    FIELD Sequencia    AS INTEGER
    FIELD Id_Produto   AS INTEGER
    FIELD Descricao    AS CHARACTER FORMAT "X(40)"
    FIELD Quantidade   AS DECIMAL   FORMAT "->>>,>>9.99"
    FIELD ValorUnitario AS DECIMAL   FORMAT "->>,>>9.99"
    FIELD ValorTotal   AS DECIMAL   FORMAT "->>>,>>>,>>9.99"
    INDEX idx_seq_nfe IS PRIMARY Sequencia.

DEFINE QUERY qItensNFe FOR ttItensNFe SCROLLING.

DEFINE VARIABLE lEmEdicao    AS LOGICAL   INITIAL NO NO-UNDO.

DEFINE BUTTON btnSalvarProd    LABEL "Salvar"   SIZE 15 BY 1.5.
DEFINE BUTTON btnVoltarProd    LABEL "Voltar"   SIZE 15 BY 1.5.


DEFINE BUTTON btnSalvarForne    LABEL "Salvar"   SIZE 15 BY 1.5.
DEFINE BUTTON btnVoltarForne    LABEL "Voltar"   SIZE 15 BY 1.5.

DEFINE BUTTON btnConsultarAPI   LABEL "Consultar API" SIZE 18 BY 1.1.
DEFINE IMAGE imgProduto         SIZE 18 BY 4 STRETCH-TO-FIT.
DEFINE RECTANGLE rectFotoProd   SIZE 20 BY 5 BGCOLOR 15.

DEFINE RECTANGLE rectDadosProd  SIZE 144 BY 5.5.
DEFINE RECTANGLE rectValProd    SIZE 71  BY 5.
DEFINE RECTANGLE rectFiscProd   SIZE 71  BY 5.
DEFINE RECTANGLE RectTopoProd   SIZE 150 BY 4.5 BGCOLOR 1 FGCOLOR 15.

DEFINE RECTANGLE rectDadosForne SIZE 124 BY 5.5.
DEFINE RECTANGLE rectEndForne   SIZE 124 BY 5.
DEFINE RECTANGLE RectTopoForne  SIZE 200 BY 4.5 BGCOLOR 1 FGCOLOR 15.

/* Objetos Pedido de Compra */
DEFINE BUTTON btnBuscaForne LABEL "Buscar" SIZE 12 BY 1.
DEFINE BUTTON btnNovoPed     LABEL "Novo Pedido" SIZE 18 BY 1.5.
DEFINE BUTTON btnSalvarPed   LABEL "Salvar"      SIZE 18 BY 1.5.
DEFINE BUTTON btnVoltarPed   LABEL "Voltar"      SIZE 18 BY 1.5.

DEFINE RECTANGLE RectTopoCompras SIZE 130 BY 4 BGCOLOR 1 FGCOLOR 15.
DEFINE RECTANGLE rectCabecalhoPed SIZE 122 BY 8.
DEFINE RECTANGLE rectItensPed     SIZE 122 BY 14.

DEFINE BUTTON btnAdicItem LABEL "Adicionar Item" SIZE 20 BY 1.2.
DEFINE BUTTON btnRemItem  LABEL "Remover Item"   SIZE 20 BY 1.2.

/* Queries devem ser definidas antes dos Browses */
DEFINE QUERY qProdutos FOR Produto SCROLLING.
DEFINE QUERY qItensPedido FOR ttItensPedido SCROLLING.

DEFINE BROWSE brItensPedido
    QUERY qItensPedido
    DISPLAY ttItensPedido.Sequencia COLUMN-LABEL "Seq"
            ttItensPedido.Id_Produto COLUMN-LABEL "Cod"
            ttItensPedido.Descricao  COLUMN-LABEL "Descricao"
            ttItensPedido.Quantidade COLUMN-LABEL "Qtd"
            ttItensPedido.Preco_Unit COLUMN-LABEL "Preco Unit"
            ttItensPedido.Total_Item COLUMN-LABEL "Total Item"
    WITH 10 DOWN NO-LABELS SIZE 114 BY 6 FIT-LAST-COLUMN.

DEFINE BROWSE brItensNFe QUERY qItensNFe
    DISPLAY ttItensNFe.Sequencia COLUMN-LABEL "Seq"
            ttItensNFe.Id_Produto COLUMN-LABEL "Cod"
            ttItensNFe.Descricao FORMAT "X(40)" COLUMN-LABEL "Produto"
            ttItensNFe.Quantidade COLUMN-LABEL "Qtd"
            ttItensNFe.ValorUnitario COLUMN-LABEL "Vl Unit"
            ttItensNFe.ValorTotal COLUMN-LABEL "Vl Total"
    WITH 10 DOWN NO-LABELS SIZE 114 BY 8 FIT-LAST-COLUMN.

DEFINE BROWSE brProdutos QUERY qProdutos
       DISPLAY Produto.Id_Produto FORMAT "->>>,>>9" LABEL "ID"
               Produto.Descricao  FORMAT "X(40)"      LABEL "Descricao"
               Produto.Marca      FORMAT "X(20)"      LABEL "Marca"
               Produto.Unidade    FORMAT "X(3)"       LABEL "UN"
               Produto.Preco_Custo FORMAT "->>,>>9.99" LABEL "Pr. Custo"
               Produto.Preco_Venda FORMAT "->>,>>9.99" LABEL "Pr. Venda"
               Produto.NCM        FORMAT "X(8)"       LABEL "NCM"
               Produto.CEST       FORMAT "X(7)"       LABEL "CEST"
               Produto.Estoque_Minimo FORMAT "->>,>>9.99" LABEL "Est. Min"
               Produto.Ativo      FORMAT "Sim/Nao"    LABEL "Ativo"
       WITH NO-ROW-MARKERS SEPARATORS SIZE 144 BY 8 FIT-LAST-COLUMN.

/* Menu de Contexto para a Browse de Produtos */
DEFINE MENU mPopupProd
    MENU-ITEM mEditar  LABEL "Editar Produto"
    MENU-ITEM mExcluir LABEL "Excluir Produto".

DEFINE QUERY qFornecedores FOR Fornecedor SCROLLING.
DEFINE BROWSE brFornecedores QUERY qFornecedores
       DISPLAY Fornecedor.Id_Fornecedor FORMAT ">>>>>>>9" LABEL "ID"
               Fornecedor.Razao_Social  FORMAT "X(40)"    LABEL "Razao Social"
               Fornecedor.CNPJ          FORMAT "X(18)"    LABEL "CNPJ"
               Fornecedor.Email         FORMAT "X(30)"    LABEL "Email"
               Fornecedor.Telefone      FORMAT "X(15)"    LABEL "Telefone"
               Fornecedor.Cidade        FORMAT "X(20)"    LABEL "Cidade"
               Fornecedor.Estado        FORMAT "X(2)"     LABEL "UF"
               Fornecedor.CEP           FORMAT "X(10)"    LABEL "CEP"
               (Fornecedor.Endereco + " - " + Fornecedor.Numero) FORMAT "X(50)" LABEL "Endereco"
               Fornecedor.Complemento   FORMAT "X(20)"    LABEL "Comp."
               Fornecedor.Bairro        FORMAT "X(20)"    LABEL "Bairro"
               Fornecedor.PontoReferencia FORMAT "X(30)"  LABEL "Pto. Ref."
       WITH NO-ROW-MARKERS SEPARATORS SIZE 194 BY 10 FIT-LAST-COLUMN.

/* Gestão de Estoque */
DEFINE QUERY qEstoque FOR Produto SCROLLING.
DEFINE VARIABLE iTotalItens AS INTEGER NO-UNDO.
DEFINE VARIABLE dValorEstoque AS DECIMAL NO-UNDO.
DEFINE VARIABLE lSomenteCritico AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE cBuscaEstoque AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE BROWSE brEstoque QUERY qEstoque
    DISPLAY Produto.Id_Produto COLUMN-LABEL "Cod" FORMAT ">>>>>>9"
            Produto.Descricao  COLUMN-LABEL "Produto" FORMAT "X(60)"
            Produto.Marca      COLUMN-LABEL "Marca"   FORMAT "X(20)"
            Produto.Quantidade_Estoque COLUMN-LABEL "Saldo"  FORMAT "->>>,>>9.99"
            Produto.Estoque_Minimo COLUMN-LABEL "Minimo" FORMAT "->>>,>>9.99"
            (IF Produto.Quantidade_Estoque <= Produto.Estoque_Minimo THEN "REPOR" ELSE "OK") COLUMN-LABEL "Status" FORMAT "X(10)"
    WITH NO-ROW-MARKERS SEPARATORS SIZE 174 BY 15 FIT-LAST-COLUMN.


DEFINE BUTTON btn-produtos 
     LABEL "CADASTRO DE PRODUTOS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-fornecedor 
     LABEL "CADASTRO DE FORNECEDORES" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-compras 
     LABEL "COMPRAS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-nfe 
     LABEL "ENTRADA DE NOTAS FISCAIS" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-estoque 
     LABEL "GESTAO DE ESTOQUE" 
     SIZE 35 BY 2.

DEFINE BUTTON btn-voltar 
     LABEL "Voltar" 
     SIZE 15 BY 1.52.

DEFINE BUTTON btnVoltarEstoque LABEL "Voltar" SIZE 15 BY 1.2.
DEFINE RECTANGLE RectTopoEstoque SIZE 180 BY 4 BGCOLOR 1 FGCOLOR 15.

/* Variaveis e Botoes Nota Fiscal */
DEFINE VARIABLE cChaveAcesso    AS CHARACTER FORMAT "X(44)" NO-UNDO.
DEFINE VARIABLE cNumeroNF       AS CHARACTER FORMAT "X(10)" NO-UNDO.
DEFINE VARIABLE cNomeFornecedor AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE dTotalNFe       AS DECIMAL   FORMAT "->>,>>9.99" NO-UNDO.
DEFINE VARIABLE tVincPedido     AS INTEGER NO-UNDO.

DEFINE BUTTON btnImportarXML LABEL "1. Importar XML" SIZE 20 BY 1.5.
DEFINE BUTTON btnVincularPed LABEL "2. Ligar Pedido" SIZE 15 BY 1.
DEFINE BUTTON btnEfetivarNFe LABEL "3. EFETIVAR NF" SIZE 20 BY 2 BGCOLOR 10 FGCOLOR 15 FONT 6.
DEFINE BUTTON btnVoltarNFe   LABEL "Voltar" SIZE 15 BY 1.5.

DEFINE RECTANGLE rectCabecalhoNFe SIZE 122 BY 6.
DEFINE RECTANGLE rectItensNFe   SIZE 122 BY 12.

DEFINE IMAGE LogoInfocena
     FILENAME "..\LogoInfocena.jpg":U
     STRETCH-TO-FIT
     SIZE 74 BY 6.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btn-produtos AT ROW 9 COL 32.5
     btn-fornecedor AT ROW 11.5 COL 32.5
     btn-compras AT ROW 14 COL 32.5
     btn-nfe AT ROW 16.5 COL 32.5
     btn-estoque AT ROW 19 COL 32.5
     btn-voltar AT ROW 22 COL 42.5
     LogoInfocena AT ROW 1.71 COL 11 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 100 BY 25 WIDGET-ID 100.

/* Variáveis de Controle de Fornecedores */
DEFINE VARIABLE lEmEdicaoForne AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE VARIABLE iCodForne      AS INTEGER NO-UNDO.

/* Menu de Contexto para Fornecedores */
DEFINE MENU mPopupForne
    MENU-ITEM mEditarForne  LABEL "Editar Fornecedor"
    MENU-ITEM mExcluirForne LABEL "Excluir Fornecedor".
DEFINE FRAME fProdutos
    RectTopoProd    AT ROW 1 COL 1
    "MODULO SUPRIMENTOS - CADASTRO DE PRODUTOS" VIEW-AS TEXT
      SIZE 60 BY 1 AT ROW 2.5 COL 52.5 FONT 6 BGCOLOR 1 FGCOLOR 15

    brProdutos      AT ROW 5 COL 3
    
    "DADOS GERAIS"  AT ROW 13.5 COL 5 FONT 6
    rectDadosProd   AT ROW 14 COL 3
    cDescricao      AT ROW 15.0 COL 15 COLON-ALIGNED LABEL "Descricao" VIEW-AS FILL-IN SIZE 65 BY 1
    cUnidade        AT ROW 16.5 COL 15 COLON-ALIGNED LABEL "Unidade"
    cCodBarras      AT ROW 16.5 COL 65 COLON-ALIGNED LABEL "Cod. Barras"
    
    "VALORES"       AT ROW 19.5 COL 5 FONT 6
    rectValProd     AT ROW 20.0 COL 3
    dPrecoCusto     AT ROW 21.5 COL 15 COLON-ALIGNED LABEL "Custo (R$)"
    dPrecoVenda     AT ROW 23.0 COL 15 COLON-ALIGNED LABEL "Venda (R$)"
    
    "FISCAL"        AT ROW 19.5 COL 78 FONT 6
    rectFiscProd    AT ROW 20.0 COL 76
    cNCM            AT ROW 21.5 COL 86 COLON-ALIGNED LABEL "NCM"
    cCEST           AT ROW 23.0 COL 86 COLON-ALIGNED LABEL "CEST"
    
    cMarca          AT ROW 15.0 COL 90 COLON-ALIGNED LABEL "Marca" VIEW-AS FILL-IN SIZE 20 BY 1
    dEstoqueMin     AT ROW 21.5 COL 116 COLON-ALIGNED LABEL "Est. Min"
    lAtivo          AT ROW 23.0 COL 116 COLON-ALIGNED LABEL "Ativo" VIEW-AS TOGGLE-BOX
    
    btnConsultarAPI AT ROW 16.5 COL 95
    cLimiteAPI      AT ROW 18.0 COL 85 NO-LABEL
    rectFotoProd    AT ROW 14.2 COL 123
    imgProduto      AT ROW 14.7 COL 124

    btnSalvarProd   AT ROW 25.5 COL 5
    btnVoltarProd   AT ROW 25.5 COL 130

    WITH 1 DOWN NO-BOX OVERLAY THREE-D 
         SIDE-LABELS NO-UNDERLINE
         AT COLUMN 1 ROW 1
         SIZE 150 BY 28.

/* Frame de Entrada de NFe */
DEFINE FRAME fNFeEntrada
    RectTopoCompras AT ROW 1.5 COL 1
    "MODULO SUPRIMENTOS - ENTRADA DE NOTA FISCAL" VIEW-AS TEXT
      SIZE 70 BY 1 AT ROW 3.0 COL 30 FONT 6 BGCOLOR 1 FGCOLOR 15

    "DADOS DA NFe (IMPORTADOS)" AT ROW 7.0 COL 7 FONT 6
    rectCabecalhoNFe AT ROW 7.5 COL 4
    
    cChaveAcesso AT ROW 8.5 COL 18 COLON-ALIGNED LABEL "Chave Acesso" VIEW-AS FILL-IN SIZE 50 BY 1
    cNumeroNF    AT ROW 10.0 COL 18 COLON-ALIGNED LABEL "Numero NF" VIEW-AS FILL-IN SIZE 15 BY 1
    cNomeFornecedor AT ROW 10.0 COL 55 COLON-ALIGNED LABEL "Fornecedor" VIEW-AS FILL-IN SIZE 40 BY 1
    dTotalNFe    AT ROW 11.5 COL 18 COLON-ALIGNED LABEL "Total NFe (R$)" FORMAT "->>,>>9.99" VIEW-AS FILL-IN SIZE 15 BY 1
    
    btnImportarXML AT ROW 10.0 COL 100

    "ITENS DA NOTA FISCAL" AT ROW 14.5 COL 7 FONT 6
    rectItensNFe AT ROW 15.0 COL 4
    
    brItensNFe AT ROW 16.0 COL 8
    
    tVincPedido AT ROW 29.0 COL 22 COLON-ALIGNED LABEL "Nº Pedido Compra" VIEW-AS FILL-IN SIZE 12 BY 1
    btnVincularPed AT ROW 29.0 COL 35
    
    btnVoltarNFe   AT ROW 31.8 COL 6
    btnEfetivarNFe AT ROW 31.0 COL 100

    WITH 1 DOWN NO-BOX OVERLAY THREE-D SIDE-LABELS NO-UNDERLINE AT COLUMN 1 ROW 1 SIZE 130 BY 34.

/* Frame Vazio de Estoque */
/* Frame de Gestao de Estoque */
DEFINE FRAME fEstoque
    RectTopoEstoque AT ROW 1.5 COL 1
    "MODULO SUPRIMENTOS - GESTAO DE ESTOQUE" VIEW-AS TEXT
      SIZE 70 BY 1 AT ROW 3.0 COL 30 FONT 6 BGCOLOR 1 FGCOLOR 15
    
    "FILTROS DE VISUALIZACAO" AT ROW 7.0 COL 7 FONT 6
    lSomenteCritico AT ROW 8.0 COL 8 VIEW-AS TOGGLE-BOX LABEL "Mostrar somente Itens Críticos (Abaixo do Mínimo)"
    cBuscaEstoque AT ROW 8.0 COL 85 COLON-ALIGNED LABEL "Pesquisar (Nome/Marca)"
    
    brEstoque AT ROW 10.0 COL 5
    
    "RESUMO DO PATRIMONIO EM ESTOQUE" AT ROW 26.5 COL 7 FONT 6
    "Total Itens Unicos:" AT ROW 28.0 COL 7
    iTotalItens AT ROW 28.0 COL 25 NO-LABEL VIEW-AS FILL-IN SIZE 10 BY 1
    "Valor Total (Custo):" AT ROW 28.0 COL 45
    dValorEstoque AT ROW 28.0 COL 65 NO-LABEL VIEW-AS FILL-IN SIZE 20 BY 1
    
    btnVoltarEstoque AT ROW 28.0 COL 150
    
    WITH 1 DOWN NO-BOX OVERLAY THREE-D SIDE-LABELS NO-UNDERLINE AT COLUMN 1 ROW 1 SIZE 180 BY 32.

/* Frame de Compras */
DEFINE FRAME fCompras
    RectTopoCompras AT ROW 1.5 COL 1
    "MODULO SUPRIMENTOS - PEDIDO DE COMPRA" VIEW-AS TEXT
      SIZE 60 BY 1 AT ROW 3.0 COL 35 FONT 6 BGCOLOR 1 FGCOLOR 15

    "CABECALHO DO PEDIDO" AT ROW 7.0 COL 7 FONT 6
    rectCabecalhoPed AT ROW 7.5 COL 4
    
    iNumPedido     AT ROW 9.0 COL 18 COLON-ALIGNED LABEL "Numero"       VIEW-AS FILL-IN SIZE 12 BY 1
    dDataPedido    AT ROW 9.0 COL 52 COLON-ALIGNED LABEL "Data"         VIEW-AS FILL-IN SIZE 16 BY 1
    cStatusPedido  AT ROW 9.0 COL 90 COLON-ALIGNED LABEL "Status"       VIEW-AS COMBO-BOX 
                   LIST-ITEMS "ABERTO","FINALIZADO","CANCELADO" SIZE 20 BY 1
    
    iFornePedido   AT ROW 11.0 COL 18 COLON-ALIGNED LABEL "Fornecedor"  VIEW-AS FILL-IN SIZE 10 BY 1
    cNomeFornePed  AT ROW 11.0 COL 30 NO-LABEL VIEW-AS FILL-IN SIZE 65 BY 1
    btnBuscaForne  AT ROW 11.0 COL 97 
    
    cCondPagto     AT ROW 13.0 COL 18 COLON-ALIGNED LABEL "Cond. Pagto" VIEW-AS COMBO-BOX
                   LIST-ITEMS "A VISTA","30 DIAS","30/60 DIAS","BOLETO","PIX" SIZE 25 BY 1
    dTotalPedido   AT ROW 13.0 COL 85 COLON-ALIGNED LABEL "Total Pedido" VIEW-AS FILL-IN SIZE 20 BY 1
    
    "LANCAMENTO DE ITENS" AT ROW 16.5 COL 7 FONT 6
    rectItensPed   AT ROW 17.0 COL 4
    
    iBuscaProd     AT ROW 18.5 COL 12 COLON-ALIGNED LABEL "Produto"       VIEW-AS FILL-IN SIZE 12 BY 1
    cDescProd      AT ROW 18.5 COL 27 NO-LABEL VIEW-AS FILL-IN SIZE 40 BY 1
    dItemQtd       AT ROW 18.5 COL 75 COLON-ALIGNED LABEL "Qtd"           VIEW-AS FILL-IN SIZE 10 BY 1
    dItemPreco     AT ROW 18.5 COL 95 COLON-ALIGNED LABEL "Preco"        VIEW-AS FILL-IN SIZE 12 BY 1
    
    cAlertaEstoque AT ROW 19.8 COL 12 NO-LABEL VIEW-AS FILL-IN SIZE 40 BY 1 FONT 6 FGCOLOR 12
    cVariacaoPreco AT ROW 19.8 COL 95 NO-LABEL VIEW-AS FILL-IN SIZE 30 BY 1 FONT 6 FGCOLOR 1
    
    lSincronizar   AT ROW 20.0 COL 60 VIEW-AS TOGGLE-BOX
    
    btnAdicItem    AT ROW 21.0 COL 15
    btnRemItem     AT ROW 21.0 COL 37
    
    brItensPedido  AT ROW 23.5 COL 8
    
    btnNovoPed     AT ROW 31.8 COL 30 
    btnSalvarPed   AT ROW 31.8 COL 52 
    btnVoltarPed   AT ROW 31.8 COL 74 
    
    WITH 1 DOWN NO-BOX OVERLAY THREE-D 
         SIDE-LABELS NO-UNDERLINE
         AT COLUMN 1 ROW 1
         SIZE 130 BY 34. /* Reduzido de 36 para 34 */


/* Frame de Fornecedores */
DEFINE FRAME fFornecedores
    RectTopoForne   AT ROW 1 COL 1
    "MODULO SUPRIMENTOS - CADASTRO DE FORNECEDORES" VIEW-AS TEXT
      SIZE 60 BY 1 AT ROW 2.5 COL 70 FONT 6 BGCOLOR 1 FGCOLOR 15

    brFornecedores AT ROW 5 COL 3

    "DADOS BASICOS" AT ROW 15.5 COL 40 FONT 6
    rectDadosForne AT ROW 16 COL 38
    cRazaoSocial   AT ROW 17.0 COL 55 COLON-ALIGNED LABEL "Razao Social" VIEW-AS FILL-IN SIZE 50 BY 1
    cFantasia      AT ROW 17.0 COL 120 COLON-ALIGNED LABEL "Fantasia"     VIEW-AS FILL-IN SIZE 37 BY 1
    cCNPJ_Forne    AT ROW 18.0 COL 55 COLON-ALIGNED LABEL "CNPJ"
    cEmail_Forne   AT ROW 18.0 COL 100 COLON-ALIGNED LABEL "Email"        VIEW-AS FILL-IN SIZE 57 BY 1
    cTel_Forne     AT ROW 19.0 COL 55 COLON-ALIGNED LABEL "Telefone"     VIEW-AS FILL-IN SIZE 20 BY 1
    iCodForne      AT ROW 19.0 COL 140 COLON-ALIGNED LABEL "Codigo"      VIEW-AS FILL-IN SIZE 10 BY 1

    "ENDERECO"     AT ROW 21.5 COL 40 FONT 6
    rectEndForne   AT ROW 22.0 COL 38
    cCEP_Forne     AT ROW 23.0 COL 45 COLON-ALIGNED LABEL "CEP"
    cEnd_Forne     AT ROW 23.0 COL 70 COLON-ALIGNED LABEL "Endereco"     VIEW-AS FILL-IN SIZE 85 BY 1
    cNum_Forne     AT ROW 24.0 COL 45 COLON-ALIGNED LABEL "Numero"       VIEW-AS FILL-IN SIZE 10 BY 1
    cComp_Forne    AT ROW 24.0 COL 75 COLON-ALIGNED LABEL "Comp."        VIEW-AS FILL-IN SIZE 30 BY 1
    cBairro_Forne  AT ROW 24.0 COL 125 COLON-ALIGNED LABEL "Bairro"       VIEW-AS FILL-IN SIZE 30 BY 1
    cCid_Forne     AT ROW 25.0 COL 45 COLON-ALIGNED LABEL "Cidade"       VIEW-AS FILL-IN SIZE 30 BY 1
    cUF_Forne      AT ROW 25.0 COL 85 COLON-ALIGNED LABEL "UF"           VIEW-AS COMBO-BOX 
                   LIST-ITEMS "AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO" SIZE 10 BY 1
    cRef_Forne     AT ROW 25.0 COL 110 COLON-ALIGNED LABEL "Pto. Ref."   VIEW-AS FILL-IN SIZE 47 BY 1

    btnSalvarForne    AT ROW 28.5 COL 50
    btnVoltarForne    AT ROW 28.5 COL 145

    WITH 1 DOWN NO-BOX OVERLAY THREE-D 
         SIDE-LABELS NO-UNDERLINE
         AT COLUMN 1 ROW 1
         SIZE 200 BY 32.


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
         TITLE              = "Sistema ERP Infocena - Modulo Suprimentos"
         HEIGHT             = 32.14
         WIDTH              = 273.2
         MAX-HEIGHT         = 32.14
         MAX-WIDTH          = 273.2
         VIRTUAL-HEIGHT     = 32.14
         VIRTUAL-WIDTH      = 273.2
         RESIZE             = no
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

/* Carrega dados do produto selecionado no Browse para os campos de edicao */
PROCEDURE carregarDadosProdutos:
    IF NOT AVAILABLE Produto THEN RETURN.
    
    ASSIGN iCurrentProdID = Produto.Id_Produto.
    
    ASSIGN cDescricao:SCREEN-VALUE IN FRAME fProdutos = Produto.Descricao
           cUnidade:SCREEN-VALUE IN FRAME fProdutos   = Produto.Unidade
           cCodBarras:SCREEN-VALUE IN FRAME fProdutos = Produto.Cod_Barras
           cMarca:SCREEN-VALUE IN FRAME fProdutos     = Produto.Marca
           dPrecoCusto:SCREEN-VALUE IN FRAME fProdutos = STRING(Produto.Preco_Custo)
           dPrecoVenda:SCREEN-VALUE IN FRAME fProdutos = STRING(Produto.Preco_Venda)
           cNCM:SCREEN-VALUE IN FRAME fProdutos       = Produto.NCM
           cCEST:SCREEN-VALUE IN FRAME fProdutos      = Produto.CEST
           dEstoqueMin:SCREEN-VALUE IN FRAME fProdutos = STRING(Produto.Estoque_Minimo)
           lAtivo:CHECKED IN FRAME fProdutos          = Produto.Ativo.

    /* Limpa a imagem atual antes de tentar carregar uma nova (evita "ghosting") */
    imgProduto:LOAD-IMAGE("") NO-ERROR.

    /* Busca a foto no Banco de Dados (BLOB) se existir */
    IF Produto.Foto_Blob <> ? THEN DO:
        DEFINE VARIABLE cTempImg AS CHARACTER NO-UNDO.
        /* Criamos um cache unico por ID para evitar que um produto "puxe" a foto do outro */
        cTempImg = "uploads/cache_prod_" + STRING(Produto.Id_Produto) + ".jpg".
        
        /* Garante que a pasta existe */
        FILE-INFO:FILE-NAME = "uploads".
        IF FILE-INFO:FULL-PATHNAME = ? THEN OS-CREATE-DIR uploads.

        /* Extrai o BLOB do banco para um arquivo temporario */
        COPY-LOB FROM Produto.Foto_Blob TO FILE cTempImg NO-ERROR.
        
        IF NOT ERROR-STATUS:ERROR THEN DO:
            imgProduto:LOAD-IMAGE(cTempImg) NO-ERROR.
            ASSIGN imgProduto:HIDDEN = NO
                   rectFotoProd:HIDDEN = NO
                   cURLImagem = cTempImg.
        END.
    END.
    ELSE DO:
        ASSIGN imgProduto:HIDDEN = YES
               rectFotoProd:HIDDEN = YES
               cURLImagem = "".
    END.
END PROCEDURE.

/* Gatilhos do Menu de Contexto */
ON CHOOSE OF MENU-ITEM mEditar IN MENU mPopupProd DO:
    RUN carregarDadosProdutos.
    lEmEdicao = YES.
    RUN atualizarEstadoUI.
END.

ON CHOOSE OF MENU-ITEM mExcluir IN MENU mPopupProd DO:
    DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.

    IF iCurrentProdID = 0 THEN DO:
        MESSAGE "Selecione um produto para excluir." VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    MESSAGE "Tem certeza que deseja excluir o produto " + cDescricao:SCREEN-VALUE IN FRAME fProdutos + "?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lAcao AS LOGICAL.

    IF lAcao THEN DO:
        RUN produtos_logica.p (INPUT "EXCLUIR",
                               INPUT iCurrentProdID,
                               INPUT "", INPUT "", INPUT "", INPUT 0.0, INPUT 0.0, 
                               INPUT "", INPUT "", INPUT "", INPUT 0.0, INPUT NO, INPUT "",
                               OUTPUT cMessage).
        
        IF cMessage = "SUCESSO" THEN DO:
            MESSAGE "Produto excluido com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
            RUN limparCamposProdutos.
            OPEN QUERY qProdutos FOR EACH Produto NO-LOCK.
        END.
        ELSE DO:
            MESSAGE cMessage VIEW-AS ALERT-BOX ERROR.
        END.
    END.
END.

ON MOUSE-MENU-CLICK OF brProdutos IN FRAME fProdutos DO:
    RUN carregarDadosProdutos.
END.

ON VALUE-CHANGED OF brProdutos IN FRAME fProdutos DO:
    /* Agora nao carrega mais automatico para evitar erros visuais */
    /* RUN carregarDadosProdutos. */
END.

/* Detectar alteracoes para ativar o modo de edicao (Salvar/Cancelar) */
ON ANY-KEY OF cDescricao IN FRAME fProdutos, 
              cMarca IN FRAME fProdutos, 
              cCodBarras IN FRAME fProdutos,
              cUnidade IN FRAME fProdutos DO:
    RUN ficarEmEdicao.
END.

ON VALUE-CHANGED OF cUnidade IN FRAME fProdutos, 
                   lAtivo IN FRAME fProdutos DO:
    RUN ficarEmEdicao.
END.

/* Valida e formata o campo decimal ao sair */
PROCEDURE validarEFormatar:
    DEFINE INPUT PARAMETER hField AS HANDLE NO-UNDO.
    DEFINE VARIABLE dValor AS DECIMAL NO-UNDO.
    
    /* Tenta converter o que foi digitado para decimal */
    dValor = DECIMAL(hField:SCREEN-VALUE) NO-ERROR.
    
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "Valor invalido digitado." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO hField.
        RETURN.
    END.
    
    /* Aplica a mascara padrao do Progress definida na variavel */
    hField:SCREEN-VALUE = STRING(dValor, hField:FORMAT).
END PROCEDURE.

ON ANY-KEY OF dPrecoCusto IN FRAME fProdutos, 
              dPrecoVenda IN FRAME fProdutos, 
              dEstoqueMin IN FRAME fProdutos DO:
    
    /* Permite apenas numeros, virgula, ponto e backspace */
    IF NOT ((LAST-EVENT:LABEL >= "0" AND LAST-EVENT:LABEL <= "9") 
       OR LAST-EVENT:LABEL = "," 
       OR LAST-EVENT:LABEL = "." 
       OR LASTKEY = 8) THEN 
        RETURN NO-APPLY.
END.

/* Formata ao sair do campo */
ON LEAVE OF dPrecoCusto IN FRAME fProdutos, 
            dPrecoVenda IN FRAME fProdutos, 
            dEstoqueMin IN FRAME fProdutos DO:
    RUN validarEFormatar (INPUT SELF:HANDLE).
END.

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Sistema ERP Infocena - Modulo Suprimentos */
DO:
  /* Mantem centralizado se o usuario redimensionar a janela manualmente */
  IF FRAME fMain:VISIBLE THEN
      ASSIGN FRAME fMain:X = (C-Win:WIDTH-PIXELS - FRAME fMain:WIDTH-PIXELS) / 2
             FRAME fMain:Y = (C-Win:HEIGHT-PIXELS - FRAME fMain:HEIGHT-PIXELS) / 2.
  IF FRAME fProdutos:VISIBLE THEN
      ASSIGN FRAME fProdutos:X = (C-Win:WIDTH-PIXELS - FRAME fProdutos:WIDTH-PIXELS) / 2
             FRAME fProdutos:Y = (C-Win:HEIGHT-PIXELS - FRAME fProdutos:HEIGHT-PIXELS) / 2.
  IF FRAME fFornecedores:VISIBLE THEN
      ASSIGN FRAME fFornecedores:X = (C-Win:WIDTH-PIXELS - FRAME fFornecedores:WIDTH-PIXELS) / 2
             FRAME fFornecedores:Y = (C-Win:HEIGHT-PIXELS - FRAME fFornecedores:HEIGHT-PIXELS) / 2.
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

&Scoped-define SELF-NAME btn-produtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-produtos C-Win
ON CHOOSE OF btn-produtos IN FRAME fMain /* CADASTRO DE PRODUTOS */
DO:
  HIDE FRAME fMain.
  VIEW FRAME fProdutos.
  ENABLE ALL WITH FRAME fProdutos.
  ASSIGN brProdutos:POPUP-MENU IN FRAME fProdutos = MENU mPopupProd:HANDLE.
  OPEN QUERY qProdutos FOR EACH Produto NO-LOCK.
  RUN limparCamposProdutos.
  RUN atualizarLimite.
  ASSIGN FRAME fProdutos:X = (C-Win:WIDTH-PIXELS - FRAME fProdutos:WIDTH-PIXELS) / 2
         FRAME fProdutos:Y = (C-Win:HEIGHT-PIXELS - FRAME fProdutos:HEIGHT-PIXELS) / 2 NO-ERROR.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME brProdutos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProdutos C-Win
/* O carregamento automatico foi movido para o menu popup (Editar) */
ON VALUE-CHANGED OF brProdutos IN FRAME fProdutos
DO:
    /* Apenas marca o ID mas nao carrega visualmente nada */
    IF AVAILABLE Produto THEN iCurrentProdID = Produto.Id_Produto.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btnNovoProd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnNovoProd C-Win
PROCEDURE ficarEmEdicao:
    IF NOT lEmEdicao THEN DO:
        lEmEdicao = YES.
        RUN atualizarEstadoUI.
    END.
END PROCEDURE.

PROCEDURE atualizarEstadoUI:
    IF lEmEdicao THEN DO:
        ASSIGN btnSalvarProd:HIDDEN IN FRAME fProdutos = NO
               btnVoltarProd:LABEL  IN FRAME fProdutos = "Cancelar".
    END.
    ELSE DO:
        ASSIGN btnSalvarProd:HIDDEN IN FRAME fProdutos = YES
               btnVoltarProd:LABEL  IN FRAME fProdutos = "Voltar".
    END.
END PROCEDURE.

PROCEDURE limparCamposProdutos:
    ASSIGN iCurrentProdID = 0
           cDescricao:SCREEN-VALUE IN FRAME fProdutos = ""
           cUnidade:SCREEN-VALUE   IN FRAME fProdutos = "UN"
           cCodBarras:SCREEN-VALUE IN FRAME fProdutos = ""
           dPrecoCusto:SCREEN-VALUE IN FRAME fProdutos = "0"
           dPrecoVenda:SCREEN-VALUE IN FRAME fProdutos = "0"
           cNCM:SCREEN-VALUE       IN FRAME fProdutos = ""
           cCEST:SCREEN-VALUE      IN FRAME fProdutos = ""
           cMarca:SCREEN-VALUE     IN FRAME fProdutos = ""
           dEstoqueMin:SCREEN-VALUE IN FRAME fProdutos = "0"
           lAtivo:CHECKED          IN FRAME fProdutos = YES
           cURLImagem              = ""
           lEmEdicao               = NO.
    
    RUN atualizarEstadoUI.
    
    /* Limpa a imagem visualmente */
    imgProduto:LOAD-IMAGE("") NO-ERROR.
    ASSIGN imgProduto:HIDDEN IN FRAME fProdutos = YES
           rectFotoProd:HIDDEN IN FRAME fProdutos = YES.
    
    APPLY "ENTRY" TO cDescricao.
END PROCEDURE.

/* Botoes Novo, Excluir e Cancelar foram removidos por sugestao do usuario */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btnSalvarProd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSalvarProd C-Win
ON CHOOSE OF btnSalvarProd IN FRAME fProdutos /* Salvar Produto */
DO:
  DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
  ASSIGN cDescricao cUnidade cCodBarras dPrecoCusto dPrecoVenda cNCM cCEST cMarca dEstoqueMin lAtivo.

  IF cDescricao = "" THEN DO:
      MESSAGE "A descricao do produto e obrigatoria!" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  RUN produtos_logica.p (INPUT "SALVAR",
                         INPUT iCurrentProdID,
                         INPUT cDescricao,
                         INPUT cUnidade,
                         INPUT cCodBarras,
                         INPUT dPrecoCusto,
                         INPUT dPrecoVenda,
                         INPUT cNCM,
                         INPUT cCEST,
                         INPUT cMarca,
                         INPUT dEstoqueMin,
                         INPUT lAtivo,
                         INPUT cURLImagem,
                         OUTPUT cMessage).

  IF cMessage = "SUCESSO" THEN DO:
      MESSAGE "Produto salvo com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
      OPEN QUERY qProdutos FOR EACH Produto NO-LOCK.
      
      /* Limpa a tela para o proximo produto conforme solicitado pelo usuario */
      RUN limparCamposProdutos.
      
      /* Deixa o browse pronto para selecao mas sem carregar dados automaticos */
      APPLY "VALUE-CHANGED" TO brProdutos.
  END.
  ELSE DO:
      MESSAGE cMessage VIEW-AS ALERT-BOX ERROR.
  END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

ON CHOOSE OF btnVoltarProd IN FRAME fProdutos /* Botao Dinamico: Voltar ou Cancelar */
DO:
    IF lEmEdicao THEN DO:
        /* Modo Cancelar */
        RUN limparCamposProdutos.
    END.
    ELSE DO:
        /* Modo Voltar - Volta para o Menu Principal */
        HIDE FRAME fProdutos.
        VIEW FRAME fMain.
    END.
END.

/* Removido btnExcluirProd por simplificacao de UI */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btnConsultarAPI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnConsultarAPI C-Win
ON CHOOSE OF btnConsultarAPI IN FRAME fProdutos /* Consultar API */
DO:
  DEFINE VARIABLE cEAN       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRest      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lConfirma  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cStatusAPI AS CHARACTER NO-UNDO.
  
  /* Limpa a imagem anterior antes de comecar a nova busca para evitar travar o arquivo */
  imgProduto:LOAD-IMAGE("") NO-ERROR.
  ASSIGN imgProduto:HIDDEN = YES
         rectFotoProd:HIDDEN = YES.
  
  cEAN = TRIM(cCodBarras:SCREEN-VALUE IN FRAME fProdutos).
  
  IF cEAN = "" THEN DO:
      MESSAGE "Digite um Codigo de Barras para consultar!" VIEW-AS ALERT-BOX WARNING.
      APPLY "ENTRY" TO cCodBarras.
      RETURN NO-APPLY.
  END.

  /* 1. Verificacao Local: Evita gastar credito se ja existe */
  FIND FIRST Produto WHERE Produto.Cod_Barras = cEAN NO-LOCK NO-ERROR.
  IF AVAILABLE Produto THEN DO:
      MESSAGE "Este produto ja esta cadastrado no seu banco de dados!" SKIP
              "Descricao: " Produto.Descricao
              VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  /* 2. Verifica Limite de Uso */
  RUN api_usage_control.p (INPUT "CHECK", OUTPUT iRest).
  
  IF iRest <= 0 THEN DO:
      MESSAGE "Seu limite diario de 25 consultas foi atingido." SKIP
              "Tente novamente amanha!" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  /* 3. Confirmacao do Usuario */
  MESSAGE "Deseja utilizar 1 credito de consulta para este produto?" SKIP
          "Limite restante: (" + STRING(iRest) + ")"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lConfirma.
          
  IF NOT lConfirma THEN RETURN NO-APPLY.

  /* 4. Chamada Real para a API */
  RUN api_fiscal_real.p (INPUT cEAN,
                         OUTPUT cDescricao,
                         OUTPUT cMarca,
                         OUTPUT cNCM,
                         OUTPUT cCEST,
                         OUTPUT cURLImagem,
                         OUTPUT cUnidade,
                         OUTPUT cStatusAPI).

  IF cStatusAPI = "SUCESSO" THEN DO:
      /* Decrementa o limite apenas em sucesso */
      RUN api_usage_control.p (INPUT "DECREMENT", OUTPUT iRest).
      cLimiteAPI:SCREEN-VALUE = "Limite de API: (" + STRING(iRest) + ") restantes".
      
      DISPLAY cDescricao cMarca cNCM cCEST cUnidade WITH FRAME fProdutos.
      
      IF cURLImagem <> "" THEN DO:
          imgProduto:LOAD-IMAGE(cURLImagem) NO-ERROR.
          ASSIGN imgProduto:HIDDEN = NO
                 rectFotoProd:HIDDEN = NO.
      END.
      ELSE ASSIGN imgProduto:HIDDEN = YES
                   rectFotoProd:HIDDEN = YES.
                   
      MESSAGE "Dados carregados com sucesso da Bluesoft Cosmos!" VIEW-AS ALERT-BOX INFORMATION.
  END.
  ELSE DO:
      MESSAGE cStatusAPI VIEW-AS ALERT-BOX ERROR.
      /* Se for erro de configuracao, avisa sobre o .env */
      IF cStatusAPI BEGINS "ERRO: Token" THEN 
          MESSAGE "Certifique-se de colocar sua chave no arquivo .env na raiz do projeto." VIEW-AS ALERT-BOX WARNING.
  END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* Atualizacao do rotulo de limite ao abrir a tela */
PROCEDURE atualizarLimite:
  DEFINE VARIABLE iRest AS INTEGER NO-UNDO.
  RUN api_usage_control.p (INPUT "CHECK", OUTPUT iRest).
  cLimiteAPI:SCREEN-VALUE IN FRAME fProdutos = "Limite de API: (" + STRING(iRest) + ") restantes".
END PROCEDURE.

&Scoped-define SELF-NAME btn-estoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-estoque C-Win
ON CHOOSE OF btn-estoque IN FRAME fMain /* GESTAO DE ESTOQUE */
DO:
  HIDE FRAME fMain.
  VIEW FRAME fEstoque.
  ASSIGN FRAME fEstoque:X = (C-Win:WIDTH-PIXELS - FRAME fEstoque:WIDTH-PIXELS) / 2
         FRAME fEstoque:Y = (C-Win:HEIGHT-PIXELS - FRAME fEstoque:HEIGHT-PIXELS) / 2 NO-ERROR.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-compras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-compras C-Win
ON CHOOSE OF btn-compras IN FRAME fMain /* COMPRAS */
DO:
  HIDE FRAME fMain.
  VIEW FRAME fCompras.
  ENABLE btnNovoPed btnVoltarPed WITH FRAME fCompras.
  ASSIGN FRAME fCompras:X = (C-Win:WIDTH-PIXELS - FRAME fCompras:WIDTH-PIXELS) / 2
         FRAME fCompras:Y = (C-Win:HEIGHT-PIXELS - FRAME fCompras:HEIGHT-PIXELS) / 2 NO-ERROR.
  RUN carregarItensVazios. /* Prepara a grade futura */
END.

ON CHOOSE OF btnVoltarPed IN FRAME fCompras DO:
    HIDE FRAME fCompras.
    VIEW FRAME fMain.
END.

ON CHOOSE OF btnNovoPed IN FRAME fCompras DO:
    RUN novoPedido.
END.

PROCEDURE novoPedido:
    DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPreco AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstMin AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstAtu AS DECIMAL NO-UNDO.
    
    RUN compras_logica.p (INPUT "PROXIMO_ID", 
                          INPUT 0, 
                          INPUT 0, 
                          INPUT ?, 
                          INPUT "", 
                          INPUT "", 
                          INPUT "", 
                          INPUT 0, /* Total */
                          INPUT 0, /* Qtd */
                          INPUT 0, /* Preco */
                          OUTPUT iNumPedido, 
                          OUTPUT cNomeFornePed, 
                          OUTPUT dPreco,
                          OUTPUT dEstMin,
                          OUTPUT dEstAtu,
                          OUTPUT cMsg).
    
    EMPTY TEMP-TABLE ttItensPedido.
    OPEN QUERY qItensPedido FOR EACH ttItensPedido.
    
    ASSIGN dDataPedido = TODAY
           cStatusPedido = "ABERTO"
           iFornePedido = 0
           cNomeFornePed = ""
           cCondPagto = "A VISTA"
           dTotalPedido = 0
           iBuscaProd = 0
           cDescProd = ""
           dItemQtd = 0
           dItemPreco = 0
           cAlertaEstoque = ""
           cVariacaoPreco = ""
           lSincronizar = YES.
           
    DISPLAY iNumPedido dDataPedido cStatusPedido iFornePedido cNomeFornePed cCondPagto dTotalPedido 
            iBuscaProd cDescProd dItemQtd dItemPreco cAlertaEstoque cVariacaoPreco lSincronizar WITH FRAME fCompras.
            
    ENABLE iFornePedido btnBuscaForne cStatusPedido cCondPagto 
           iBuscaProd dItemQtd dItemPreco lSincronizar btnAdicItem btnRemItem brItensPedido
           btnSalvarPed btnVoltarPed WITH FRAME fCompras.
END PROCEDURE.

PROCEDURE carregarItensVazios:
    /* Placeholder para a Fase B */
END PROCEDURE.

ON LEAVE OF iFornePedido IN FRAME fCompras DO:
    DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iDummy AS INTEGER NO-UNDO.
    DEFINE VARIABLE cNome  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPreco AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstMin AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstAtu AS DECIMAL NO-UNDO.

    IF SELF:SCREEN-VALUE = "0" OR SELF:SCREEN-VALUE = "" THEN RETURN.
    
    RUN compras_logica.p (INPUT "BUSCAR_FORNECEDOR", 
                          INPUT 0, 
                          INPUT INTEGER(SELF:SCREEN-VALUE), 
                          INPUT ?, 
                          INPUT "", 
                          INPUT "", 
                          INPUT "", 
                          INPUT 0, /* Total */
                          INPUT 0, /* Qtd */
                          INPUT 0, /* Preco */
                          OUTPUT iDummy, 
                          OUTPUT cNome, 
                          OUTPUT dPreco,
                          OUTPUT dEstMin,
                          OUTPUT dEstAtu,
                          OUTPUT cMsg).

    IF cMsg = "SUCESSO" THEN 
        cNomeFornePed:SCREEN-VALUE IN FRAME fCompras = cNome.
    ELSE DO:
        MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
        cNomeFornePed:SCREEN-VALUE IN FRAME fCompras = "".
    END.
END.

ON CHOOSE OF btnBuscaForne IN FRAME fCompras DO:
    APPLY "LEAVE" TO iFornePedido IN FRAME fCompras.
END.

ON CHOOSE OF btnSalvarPed IN FRAME fCompras DO:
    DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iDummy AS INTEGER NO-UNDO.
    DEFINE VARIABLE cDummy AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dDummy AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstMin AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstAtu AS DECIMAL NO-UNDO.
    
    IF iFornePedido:SCREEN-VALUE IN FRAME fCompras = "0" OR iFornePedido:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Selecione um Fornecedor!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN compras_logica.p (INPUT "SALVAR_CABECALHO", 
                          INPUT iNumPedido, 
                          INPUT INTEGER(iFornePedido:SCREEN-VALUE IN FRAME fCompras), 
                          INPUT DATE(dDataPedido:SCREEN-VALUE IN FRAME fCompras), 
                          INPUT cStatusPedido:SCREEN-VALUE IN FRAME fCompras, 
                          INPUT cCondPagto:SCREEN-VALUE IN FRAME fCompras, 
                          INPUT "", /* Comprador - placeholder */
                          INPUT DECIMAL(dTotalPedido:SCREEN-VALUE IN FRAME fCompras),
                          INPUT 0, /* Qtd */
                          INPUT 0, /* Preco */
                          OUTPUT iDummy, 
                          OUTPUT cDummy, 
                          OUTPUT dDummy,
                          OUTPUT dEstMin,
                          OUTPUT dEstAtu,
                          OUTPUT cMsg).
                          
    IF cMsg = "SUCESSO" THEN DO:
        /* Salva cada item da grade no banco */
        FOR EACH ttItensPedido:
            RUN compras_logica.p (INPUT "SALVAR_ITEM",
                                  INPUT ttItensPedido.Id_Pedido,
                                  INPUT ttItensPedido.Id_Produto,
                                  INPUT ?, 
                                  INPUT "",
                                  INPUT "",
                                  INPUT "",
                                  INPUT 0, 
                                  INPUT ttItensPedido.Quantidade,
                                  INPUT ttItensPedido.Preco_Unit,
                                  OUTPUT iDummy,
                                  OUTPUT cDummy,
                                  OUTPUT dDummy,
                                  OUTPUT dEstMin,
                                  OUTPUT dEstAtu,
                                  OUTPUT cMsg).
            
            /* Sincroniza custo no cadastro se marcado */
            IF lSincronizar:CHECKED IN FRAME fCompras THEN DO:
                RUN compras_logica.p (INPUT "SINCRONIZAR_CUSTO",
                                      INPUT 0,
                                      INPUT ttItensPedido.Id_Produto, /* id_produto */
                                      INPUT ?,
                                      INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT ttItensPedido.Preco_Unit,
                                      OUTPUT iDummy,
                                      OUTPUT cDummy,
                                      OUTPUT dDummy,
                                      OUTPUT dEstMin,
                                      OUTPUT dEstAtu,
                                      OUTPUT cMsg).
            END.
        END.
        MESSAGE "Pedido e Itens Salvos com Sucesso!" VIEW-AS ALERT-BOX INFORMATION.
    END.
    ELSE
        MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
END.

/* --- LOGICA DE ITENS (FASE B) --- */

ON LEAVE OF iBuscaProd IN FRAME fCompras DO:
    DEFINE VARIABLE cMsg   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iDummy AS INTEGER NO-UNDO.
    DEFINE VARIABLE cNome  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPreco AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstMin AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dEstAtu AS DECIMAL NO-UNDO.

    IF SELF:SCREEN-VALUE = "0" OR SELF:SCREEN-VALUE = "" THEN RETURN.

    RUN compras_logica.p (INPUT "BUSCAR_PRODUTO",
                          INPUT INTEGER(SELF:SCREEN-VALUE),
                          INPUT 0,
                          INPUT ?,
                          INPUT "",
                          INPUT "",
                          INPUT "",
                          INPUT 0, /* Total */
                          INPUT 0, /* Qtd */
                          INPUT 0, /* Preco */
                          OUTPUT iDummy,
                          OUTPUT cNome,
                          OUTPUT dPreco,
                          OUTPUT dEstMin,
                          OUTPUT dEstAtu,
                          OUTPUT cMsg).

    IF cMsg = "SUCESSO" THEN DO:
        cDescProd:SCREEN-VALUE IN FRAME fCompras = cNome.
        dItemPreco:SCREEN-VALUE IN FRAME fCompras = STRING(dPreco).
        dPrecoOrigProd = dPreco. /* Guarda o preco do cadastro */
        
        /* Inteligencia de Estoque */
        IF dEstAtu < dEstMin THEN 
            cAlertaEstoque:SCREEN-VALUE IN FRAME fCompras = "ALERTA: ESTOQUE BAIXO (" + STRING(dEstAtu) + ")".
        ELSE
            cAlertaEstoque:SCREEN-VALUE IN FRAME fCompras = "".
            
        APPLY "ENTRY" TO dItemQtd IN FRAME fCompras.
    END.
    ELSE DO:
        MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
        cDescProd:SCREEN-VALUE IN FRAME fCompras = "".
        dItemPreco:SCREEN-VALUE IN FRAME fCompras = "0".
        cAlertaEstoque:SCREEN-VALUE IN FRAME fCompras = "".
        cVariacaoPreco:SCREEN-VALUE IN FRAME fCompras = "".
        dPrecoOrigProd = 0.
    END.
END.

ON VALUE-CHANGED OF dItemPreco IN FRAME fCompras DO:
    DEFINE VARIABLE dDigitado AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dDiff     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dPerc     AS DECIMAL NO-UNDO.
    
    IF dPrecoOrigProd = 0 OR SELF:SCREEN-VALUE = "" THEN RETURN.
    
    dDigitado = DECIMAL(SELF:SCREEN-VALUE).
    
    IF dDigitado = dPrecoOrigProd THEN DO:
        cVariacaoPreco:SCREEN-VALUE IN FRAME fCompras = "".
        RETURN.
    END.
    
    /* Protecao contra divisao por zero se o produto ainda nao tem custo cadastrado */
    IF dPrecoOrigProd = 0 THEN DO:
        cVariacaoPreco:SCREEN-VALUE IN FRAME fCompras = "Novo Custo Base".
        RETURN.
    END.
    
    dDiff = dDigitado - dPrecoOrigProd.
    dPerc = (dDiff / dPrecoOrigProd) * 100.
    
    IF dPerc > 0 THEN 
        cVariacaoPreco:SCREEN-VALUE IN FRAME fCompras = "+" + STRING(dPerc, ">>>,>>9.99") + "% (Aumento)".
    ELSE 
        cVariacaoPreco:SCREEN-VALUE IN FRAME fCompras = STRING(dPerc, "->>>,>>9.99") + "% (Desconto)".
END.


ON CHOOSE OF btnAdicItem IN FRAME fCompras DO:
    DEFINE VARIABLE iProxSeq AS INTEGER NO-UNDO.
    
    IF iBuscaProd:SCREEN-VALUE IN FRAME fCompras = "0" OR dItemQtd:SCREEN-VALUE = "0" THEN DO:
        MESSAGE "Informe Produto e Quantidade!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    IF cDescProd:SCREEN-VALUE IN FRAME fCompras = "" THEN DO:
        MESSAGE "Busque um produto valido antes de adicionar!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    FIND LAST ttItensPedido NO-LOCK NO-ERROR.
    iProxSeq = (IF AVAILABLE ttItensPedido THEN ttItensPedido.Sequencia + 1 ELSE 1).

    CREATE ttItensPedido.
    ASSIGN ttItensPedido.Id_Pedido  = iNumPedido
           ttItensPedido.Sequencia  = iProxSeq
           ttItensPedido.Id_Produto = INTEGER(iBuscaProd:SCREEN-VALUE IN FRAME fCompras)
           ttItensPedido.Descricao  = cDescProd:SCREEN-VALUE IN FRAME fCompras
           ttItensPedido.Quantidade = DECIMAL(dItemQtd:SCREEN-VALUE IN FRAME fCompras)
           ttItensPedido.Preco_Unit = DECIMAL(dItemPreco:SCREEN-VALUE IN FRAME fCompras)
           ttItensPedido.Total_Item = ttItensPedido.Quantidade * ttItensPedido.Preco_Unit.

    RUN atualizarTotalPedido.
    
    /* Limpa campos de lançamento */
    ASSIGN iBuscaProd:SCREEN-VALUE = "0"
           cDescProd:SCREEN-VALUE = ""
           dItemQtd:SCREEN-VALUE = "0"
           dItemPreco:SCREEN-VALUE = "0".
           
    OPEN QUERY qItensPedido FOR EACH ttItensPedido.
    APPLY "ENTRY" TO iBuscaProd IN FRAME fCompras.
END.

ON CHOOSE OF btnRemItem IN FRAME fCompras DO:
    IF NOT AVAILABLE ttItensPedido THEN RETURN.
    
    DELETE ttItensPedido.
    RUN atualizarTotalPedido.
    OPEN QUERY qItensPedido FOR EACH ttItensPedido.
END.

PROCEDURE atualizarTotalPedido:
    DEFINE VARIABLE dTotal AS DECIMAL INITIAL 0 NO-UNDO.
    
    FOR EACH ttItensPedido:
        dTotal = dTotal + ttItensPedido.Total_Item.
    END.
    
    dTotalPedido:SCREEN-VALUE IN FRAME fCompras = STRING(dTotal).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-nfe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-nfe C-Win
ON CHOOSE OF btn-nfe IN FRAME fMain /* ENTRADA DE NOTAS FISCAIS */
DO:
  HIDE FRAME fMain.
  VIEW FRAME fNFeEntrada.
  ASSIGN FRAME fNFeEntrada:X = (C-Win:WIDTH-PIXELS - FRAME fNFeEntrada:WIDTH-PIXELS) / 2
         FRAME fNFeEntrada:Y = (C-Win:HEIGHT-PIXELS - FRAME fNFeEntrada:HEIGHT-PIXELS) / 2 NO-ERROR.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-fornecedor C-Win
ON CHOOSE OF btn-fornecedor IN FRAME fMain /* CADASTRO DE FORNECEDORES */
DO:
  HIDE FRAME fMain.
  RUN enable_fFornecedores.
END.

PROCEDURE enable_fFornecedores:
    OPEN QUERY qFornecedores FOR EACH Fornecedor.
    ENABLE brFornecedores btnSalvarForne btnVoltarForne
           cRazaoSocial cFantasia cCNPJ_Forne cEmail_Forne cTel_Forne
           cCEP_Forne cEnd_Forne cNum_Forne cComp_Forne cBairro_Forne 
           cCid_Forne cUF_Forne cRef_Forne
           WITH FRAME fFornecedores IN WINDOW C-Win.
    
    RUN limparCamposFornecedores.
    VIEW FRAME fFornecedores.
    
    ASSIGN FRAME fFornecedores:X = (C-Win:WIDTH-PIXELS - FRAME fFornecedores:WIDTH-PIXELS) / 2
           FRAME fFornecedores:Y = (C-Win:HEIGHT-PIXELS - FRAME fFornecedores:HEIGHT-PIXELS) / 2 NO-ERROR.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME brFornecedores
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFornecedores C-Win
ON VALUE-CHANGED OF brFornecedores IN FRAME fFornecedores
DO:
  IF AVAILABLE Fornecedor THEN DO:
      ASSIGN iCurrentForneID = Fornecedor.Id_Fornecedor
             iCodForne:SCREEN-VALUE IN FRAME fFornecedores = STRING(Fornecedor.Id_Fornecedor)
             cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores = Fornecedor.Razao_Social
             cFantasia:SCREEN-VALUE IN FRAME fFornecedores    = Fornecedor.Nome_Fantasia
             cCNPJ_Forne:SCREEN-VALUE IN FRAME fFornecedores  = Fornecedor.CNPJ
             cEmail_Forne:SCREEN-VALUE IN FRAME fFornecedores = Fornecedor.Email
             cTel_Forne:SCREEN-VALUE IN FRAME fFornecedores   = Fornecedor.Telefone
             cEnd_Forne:SCREEN-VALUE IN FRAME fFornecedores   = Fornecedor.Endereco
             cNum_Forne:SCREEN-VALUE IN FRAME fFornecedores   = Fornecedor.Numero
             cComp_Forne:SCREEN-VALUE IN FRAME fFornecedores  = Fornecedor.Complemento
             cBairro_Forne:SCREEN-VALUE IN FRAME fFornecedores = Fornecedor.Bairro
             cCid_Forne:SCREEN-VALUE IN FRAME fFornecedores   = Fornecedor.Cidade
             cUF_Forne:SCREEN-VALUE IN FRAME fFornecedores    = Fornecedor.Estado
             cCEP_Forne:SCREEN-VALUE IN FRAME fFornecedores   = Fornecedor.CEP
             cRef_Forne:SCREEN-VALUE IN FRAME fFornecedores   = Fornecedor.PontoReferencia.
      RUN ficarEmEdicaoForne.
      RUN habilita_campos_forne(TRUE).
  END.
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* Gatilhos do Menu de Contexto para Fornecedores */
ON CHOOSE OF MENU-ITEM mEditarForne IN MENU mPopupForne DO:
    IF AVAILABLE Fornecedor THEN DO:
        APPLY "VALUE-CHANGED" TO brFornecedores IN FRAME fFornecedores.
        lEmEdicaoForne = YES.
        RUN atualizarEstadoUIForne.
    END.
END.

ON CHOOSE OF MENU-ITEM mExcluirForne IN MENU mPopupForne DO:
    DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.

    IF iCurrentForneID = 0 THEN DO:
        MESSAGE "Selecione um fornecedor para excluir." VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    MESSAGE "Tem certeza que deseja excluir o fornecedor " + cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores + "?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lAcao AS LOGICAL.

    IF lAcao THEN DO:
        RUN fornecedores_logica.p (INPUT "EXCLUIR", INPUT iCurrentForneID, 
                                 "", "", "", "", "", "", "", "", "", "", "", "", "",
                                 OUTPUT cMessage).
        IF cMessage = "SUCESSO" THEN DO:
            MESSAGE "Fornecedor excluido!" VIEW-AS ALERT-BOX INFORMATION.
            OPEN QUERY qFornecedores FOR EACH Fornecedor NO-LOCK.
            RUN limparCamposFornecedores.
        END.
        ELSE MESSAGE cMessage VIEW-AS ALERT-BOX ERROR.
    END.
END.

/* Procedimentos para Fornecedores */
PROCEDURE habilita_campos_forne:
    DEFINE INPUT PARAMETER plHabilita AS LOGICAL NO-UNDO.
    
    ASSIGN cRazaoSocial:SENSITIVE IN FRAME fFornecedores = YES
           cFantasia:SENSITIVE    IN FRAME fFornecedores = YES
           cCNPJ_Forne:SENSITIVE  IN FRAME fFornecedores = YES
           cEmail_Forne:SENSITIVE IN FRAME fFornecedores = YES
           cTel_Forne:SENSITIVE   IN FRAME fFornecedores = YES
           cCEP_Forne:SENSITIVE   IN FRAME fFornecedores = YES
           cEnd_Forne:SENSITIVE   IN FRAME fFornecedores = YES
           cNum_Forne:SENSITIVE   IN FRAME fFornecedores = YES
           cComp_Forne:SENSITIVE  IN FRAME fFornecedores = YES
           cBairro_Forne:SENSITIVE IN FRAME fFornecedores = YES
           cCid_Forne:SENSITIVE   IN FRAME fFornecedores = YES
           cUF_Forne:SENSITIVE    IN FRAME fFornecedores = YES
           cRef_Forne:SENSITIVE    IN FRAME fFornecedores = YES.
           
    ASSIGN brFornecedores:SENSITIVE IN FRAME fFornecedores = YES.
END PROCEDURE.
PROCEDURE limparCamposFornecedores:
    ASSIGN iCurrentForneID = 0
           iCodForne:SCREEN-VALUE IN FRAME fFornecedores = "0"
           cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores = ""
           cFantasia:SCREEN-VALUE IN FRAME fFornecedores    = ""
           cCNPJ_Forne:SCREEN-VALUE IN FRAME fFornecedores  = ""
           cEmail_Forne:SCREEN-VALUE IN FRAME fFornecedores = ""
           cTel_Forne:SCREEN-VALUE IN FRAME fFornecedores   = ""
           cEnd_Forne:SCREEN-VALUE IN FRAME fFornecedores   = ""
           cNum_Forne:SCREEN-VALUE IN FRAME fFornecedores   = ""
           cComp_Forne:SCREEN-VALUE IN FRAME fFornecedores  = ""
           cBairro_Forne:SCREEN-VALUE IN FRAME fFornecedores = ""
           cCid_Forne:SCREEN-VALUE IN FRAME fFornecedores   = ""
           cUF_Forne:SCREEN-VALUE IN FRAME fFornecedores    = ""
           cCEP_Forne:SCREEN-VALUE IN FRAME fFornecedores   = ""
           cRef_Forne:SCREEN-VALUE IN FRAME fFornecedores   = ""
           lEmEdicaoForne = NO.
    RUN atualizarEstadoUIForne.
    RUN habilita_campos_forne(TRUE).
    APPLY "ENTRY" TO cRazaoSocial IN FRAME fFornecedores.
END PROCEDURE.

PROCEDURE atualizarEstadoUIForne:
    IF lEmEdicaoForne THEN DO:
        ASSIGN btnSalvarForne:HIDDEN IN FRAME fFornecedores = NO
               btnVoltarForne:LABEL IN FRAME fFornecedores  = "Cancelar".
    END.
    ELSE DO:
        ASSIGN btnSalvarForne:HIDDEN IN FRAME fFornecedores = YES
               btnVoltarForne:LABEL IN FRAME fFornecedores  = "Voltar".
    END.
END PROCEDURE.

PROCEDURE ficarEmEdicaoForne:
    IF NOT lEmEdicaoForne THEN DO:
        lEmEdicaoForne = YES.
        RUN atualizarEstadoUIForne.
    END.
END PROCEDURE.

ON ANY-KEY OF cCNPJ_Forne IN FRAME fFornecedores,
              cTel_Forne IN FRAME fFornecedores,
              cCEP_Forne IN FRAME fFornecedores,
              cNum_Forne IN FRAME fFornecedores DO:
    
    DEFINE VARIABLE cRawValue AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxDigits AS INTEGER NO-UNDO.

    /* Permite teclas de controle basicas sempre */
    IF LOOKUP(KEYFUNCTION(LASTKEY), "BACKSPACE,DELETE,CURSOR-LEFT,CURSOR-RIGHT,TAB,RETURN") > 0 THEN DO:
        RUN ficarEmEdicaoForne.
        RETURN.
    END.

    /* Se nao for numero, bloqueia agora */
    IF NOT (LAST-EVENT:LABEL >= "0" AND LAST-EVENT:LABEL <= "9") THEN RETURN NO-APPLY.

    /* Define o limite baseado no campo (apenas digitos puros) */
    CASE SELF:NAME:
        WHEN "cCEP_Forne"  THEN iMaxDigits = 8.
        WHEN "cCNPJ_Forne" THEN iMaxDigits = 14.
        WHEN "cTel_Forne"  THEN iMaxDigits = 11.
        WHEN "cNum_Forne"  THEN iMaxDigits = 10.
    END CASE.

    /* Conta apenas os digitos atuais (removendo qualquer mascara que possa existir) */
    cRawValue = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SELF:SCREEN-VALUE, ".", ""), "/", ""), "-", ""), "(", ""), ")", "").
    cRawValue = REPLACE(cRawValue, " ", "").

    /* Se ja atingiu o limite de digitos puros, nao permite mais */
    IF LENGTH(cRawValue) >= iMaxDigits THEN RETURN NO-APPLY.

    RUN ficarEmEdicaoForne.
END.

ON ANY-KEY OF cRazaoSocial IN FRAME fFornecedores,
              cFantasia IN FRAME fFornecedores,
              cEmail_Forne IN FRAME fFornecedores,
              cEnd_Forne IN FRAME fFornecedores,
              cComp_Forne IN FRAME fFornecedores,
              cBairro_Forne IN FRAME fFornecedores,
              cCid_Forne IN FRAME fFornecedores,
              cUF_Forne IN FRAME fFornecedores,
              cRef_Forne IN FRAME fFornecedores DO:
    RUN ficarEmEdicaoForne.
END.

ON LEAVE OF cCEP_Forne IN FRAME fFornecedores DO:
    DEFINE VARIABLE cCEPLimpo AS CHARACTER NO-UNDO.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    
    /* Formata CEP: 00000-000 */
    cCEPLimpo = REPLACE(SELF:SCREEN-VALUE, "-", "").
    IF LENGTH(cCEPLimpo) = 8 THEN 
        SELF:SCREEN-VALUE = SUBSTRING(cCEPLimpo, 1, 5) + "-" + SUBSTRING(cCEPLimpo, 6, 3).
        
    RUN buscarCEP (INPUT cCEPLimpo).
END.

ON LEAVE OF cTel_Forne IN FRAME fFornecedores DO:
    DEFINE VARIABLE cTelLimpo AS CHARACTER NO-UNDO.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    
    /* Limpa formatacao anterior */
    cTelLimpo = REPLACE(REPLACE(REPLACE(REPLACE(SELF:SCREEN-VALUE, "(", ""), ")", ""), " ", ""), "-", "").
    
    /* Formata Celular: (00) 00000-0000 */
    IF LENGTH(cTelLimpo) = 11 THEN 
        SELF:SCREEN-VALUE = "(" + SUBSTRING(cTelLimpo, 1, 2) + ") " + SUBSTRING(cTelLimpo, 3, 5) + "-" + SUBSTRING(cTelLimpo, 8, 4).
    /* Formata Fixo: (00) 0000-0000 */
    ELSE IF LENGTH(cTelLimpo) = 10 THEN 
        SELF:SCREEN-VALUE = "(" + SUBSTRING(cTelLimpo, 1, 2) + ") " + SUBSTRING(cTelLimpo, 3, 4) + "-" + SUBSTRING(cTelLimpo, 7, 4).
END.

ON LEAVE OF cCNPJ_Forne IN FRAME fFornecedores DO:
    DEFINE VARIABLE lValido AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cCNPJLimpo AS CHARACTER NO-UNDO.

    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    /* Limpa caracteres nao numericos */
    cCNPJLimpo = REPLACE(REPLACE(REPLACE(SELF:SCREEN-VALUE, ".", ""), "/", ""), "-", "").

    /* Valida matematicamente usando o novo utilitario */
    RUN utils_validacao.p (INPUT "VALIDAR_CNPJ", INPUT cCNPJLimpo, OUTPUT lValido).
    
    IF NOT lValido THEN DO:
        MESSAGE "CNPJ Matematicamente Invalido! Verifique o numero digitado." 
            VIEW-AS ALERT-BOX ERROR TITLE "Validacao de Documento".
        APPLY "ENTRY" TO SELF.
        RETURN NO-APPLY.
    END.

    /* Formata o CNPJ apenas se estiver preenchido com 14 digitos */
    IF LENGTH(cCNPJLimpo) = 14 THEN 
        SELF:SCREEN-VALUE = SUBSTRING(cCNPJLimpo, 1, 2) + "." +
                           SUBSTRING(cCNPJLimpo, 3, 3) + "." +
                           SUBSTRING(cCNPJLimpo, 6, 3) + "/" +
                           SUBSTRING(cCNPJLimpo, 9, 4) + "-" +
                           SUBSTRING(cCNPJLimpo, 13, 2).

    /* Se for um novo cadastro e o CNPJ for valido, busca os dados na API */
    IF iCurrentForneID = 0 AND (cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores = "" OR cRazaoSocial:SCREEN-VALUE = ?) THEN 
        RUN buscarCNPJ(INPUT cCNPJLimpo).
END.

/* Botoes legado removidos por dinamismo */

&Scoped-define SELF-NAME btnSalvarForne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSalvarForne C-Win
ON CHOOSE OF btnSalvarForne IN FRAME fFornecedores /* Salvar Fornecedor */
DO:
  DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
  
  IF cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores = "" THEN DO:
      MESSAGE "A Razao Social e obrigatoria!" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  RUN fornecedores_logica.p (INPUT "SALVAR",
                             INPUT iCurrentForneID,
                             INPUT cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cFantasia:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cCNPJ_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cEmail_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cTel_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cEnd_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cNum_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cComp_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cBairro_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cCid_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cUF_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cCEP_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cRef_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             OUTPUT cMessage).

  IF cMessage = "SUCESSO" THEN DO:
      MESSAGE "Fornecedor salvo com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
      OPEN QUERY qFornecedores FOR EACH Fornecedor NO-LOCK.
      RUN limparCamposFornecedores.
      APPLY "VALUE-CHANGED" TO brFornecedores.
  END.
  ELSE MESSAGE cMessage VIEW-AS ALERT-BOX ERROR.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* Gatilho btnExcluirForne removido - Logica movida para o menu mPopupForne */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btnVoltarForne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnVoltarForne C-Win
ON CHOOSE OF btnVoltarForne IN FRAME fFornecedores /* Voltar / Cancelar */
DO:
  IF lEmEdicaoForne THEN DO:
      RUN limparCamposFornecedores.
  END.
  ELSE DO:
      HIDE FRAME fFornecedores.
      VIEW FRAME fMain.
  END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btn-voltar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-voltar C-Win
ON CHOOSE OF btn-voltar IN FRAME fMain /* Voltar */
DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

ON CHOOSE OF btn-nfe IN FRAME fMain /* Abrir Modulo NFe */
DO:
    HIDE FRAME fMain.
    VIEW FRAME fNFeEntrada.
    ENABLE ALL EXCEPT cChaveAcesso cNumeroNF cNomeFornecedor dTotalNFe WITH FRAME fNFeEntrada.
END.

ON CHOOSE OF btn-estoque IN FRAME fMain DO:
    RUN abrirEstoque.
END.

PROCEDURE abrirEstoque:
    HIDE FRAME fMain.
    RUN atualizarDadosEstoque.
    ENABLE ALL WITH FRAME fEstoque IN WINDOW C-Win.
    VIEW FRAME fEstoque.
    
    ASSIGN FRAME fEstoque:X = (C-Win:WIDTH-PIXELS - FRAME fEstoque:WIDTH-PIXELS) / 2
           FRAME fEstoque:Y = (C-Win:HEIGHT-PIXELS - FRAME fEstoque:HEIGHT-PIXELS) / 2 NO-ERROR.
END PROCEDURE.

PROCEDURE atualizarDadosEstoque:
    IF VALID-HANDLE(FRAME fEstoque:HANDLE) THEN
        ASSIGN lSomenteCritico = lSomenteCritico:CHECKED IN FRAME fEstoque
               cBuscaEstoque   = cBuscaEstoque:SCREEN-VALUE IN FRAME fEstoque.
    
    IF lSomenteCritico THEN
        OPEN QUERY qEstoque FOR EACH Produto WHERE Produto.Quantidade_Estoque <= Produto.Estoque_Minimo
                                               AND (Produto.Descricao MATCHES ("*" + cBuscaEstoque + "*")
                                                OR Produto.Marca     MATCHES ("*" + cBuscaEstoque + "*")) NO-LOCK.
    ELSE
        OPEN QUERY qEstoque FOR EACH Produto WHERE (Produto.Descricao MATCHES ("*" + cBuscaEstoque + "*")
                                                OR  Produto.Marca     MATCHES ("*" + cBuscaEstoque + "*")) NO-LOCK.
        
    RUN atualizarResumoEstoque.
END PROCEDURE.

PROCEDURE atualizarResumoEstoque:
    DEFINE VARIABLE cMsgLogica AS CHARACTER NO-UNDO.
    
    /* Chamada da logica separada (Arquitetura Profissional) */
    RUN estoque_logica.p (INPUT "CALCULAR_RESUMO",
                          OUTPUT iTotalItens,
                          OUTPUT dValorEstoque,
                          OUTPUT cMsgLogica).
    
    IF VALID-HANDLE(FRAME fEstoque:HANDLE) THEN
        ASSIGN iTotalItens:SCREEN-VALUE IN FRAME fEstoque   = STRING(iTotalItens)
               dValorEstoque:SCREEN-VALUE IN FRAME fEstoque = STRING(dValorEstoque, "->>>,>>>,>>9.99").
END PROCEDURE.

ON CHOOSE OF btnVoltarEstoque IN FRAME fEstoque DO:
    HIDE FRAME fEstoque.
    VIEW FRAME fMain.
END.

ON VALUE-CHANGED OF lSomenteCritico IN FRAME fEstoque DO:
    RUN atualizarDadosEstoque.
END.

ON ANY-KEY OF cBuscaEstoque IN FRAME fEstoque DO:
    /* Pequeno delay ou aguardar Enter para nao sobrecarregar o banco em cada tecla */
    IF LASTKEY = 13 THEN /* ENTER */
        RUN atualizarDadosEstoque.
END.

ON ROW-DISPLAY OF brEstoque IN FRAME fEstoque DO:
    /* Coloracao de alerta para itens criticos */
    IF Produto.Quantidade_Estoque <= Produto.Estoque_Minimo THEN DO:
        Produto.Quantidade_Estoque:BGCOLOR IN BROWSE brEstoque = 12. 
        Produto.Quantidade_Estoque:FGCOLOR IN BROWSE brEstoque = 15.
    END.
    ELSE DO:
        Produto.Quantidade_Estoque:BGCOLOR IN BROWSE brEstoque = ?.
        Produto.Quantidade_Estoque:FGCOLOR IN BROWSE brEstoque = ?.
    END.
END.

ON CHOOSE OF btnImportarXML IN FRAME fNFeEntrada /* Importar XML */
DO:
    DEFINE VARIABLE cCabecalho AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMensagem  AS CHARACTER NO-UNDO.
    
    RUN nfe_logica.p (INPUT "LER_XML",
                      INPUT "..\data\mock_nfe.xml",
                      INPUT-OUTPUT TABLE ttItensNFe,
                      OUTPUT cCabecalho,
                      OUTPUT cMensagem).
                      
    IF cMensagem = "SUCESSO" THEN DO:
        ASSIGN 
            cChaveAcesso:SCREEN-VALUE IN FRAME fNFeEntrada    = ENTRY(1, cCabecalho, "|")
            cNumeroNF:SCREEN-VALUE IN FRAME fNFeEntrada       = ENTRY(2, cCabecalho, "|")
            cNomeFornecedor:SCREEN-VALUE IN FRAME fNFeEntrada = ENTRY(3, cCabecalho, "|")
            dTotalNFe:SCREEN-VALUE IN FRAME fNFeEntrada       = ENTRY(4, cCabecalho, "|").
            
        OPEN QUERY qItensNFe FOR EACH ttItensNFe.
        MESSAGE "XML importado com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
    END.
    ELSE MESSAGE cMensagem VIEW-AS ALERT-BOX ERROR.
END.

ON CHOOSE OF btnVincularPed IN FRAME fNFeEntrada /* Two-Way Match */
DO:
    DEFINE VARIABLE cResultado AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMsgMatch  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPedStr    AS CHARACTER NO-UNDO.
    
    cPedStr = tVincPedido:SCREEN-VALUE IN FRAME fNFeEntrada.
    
    IF cPedStr = "" OR cPedStr = "0" OR cPedStr = ? THEN DO:
        MESSAGE "Informe o numero do Pedido de Compra para vincular." VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    
    RUN nfe_logica.p (INPUT "COMPARAR_PEDIDO",
                      INPUT cPedStr,
                      INPUT-OUTPUT TABLE ttItensNFe,
                      OUTPUT cResultado,
                      OUTPUT cMsgMatch).
                      
    IF cMsgMatch = "SUCESSO" THEN
        MESSAGE cResultado VIEW-AS ALERT-BOX INFORMATION TITLE "Conferimento NFe x Pedido".
    ELSE
        MESSAGE cMsgMatch VIEW-AS ALERT-BOX ERROR.
END.

ON CHOOSE OF btnEfetivarNFe IN FRAME fNFeEntrada /* Efetivar Recebimento */
DO:
    DEFINE VARIABLE cDadosEfet  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRetEfet    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMsgEfet    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lConfirma   AS LOGICAL   NO-UNDO.
    
    /* Valida que existe importacao */
    IF cChaveAcesso:SCREEN-VALUE IN FRAME fNFeEntrada = "" THEN DO:
        MESSAGE "Importe um XML antes de efetivar!" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    /* Valida vinculo de pedido (Melhoria de Logica) */
    IF tVincPedido:SCREEN-VALUE IN FRAME fNFeEntrada = "" OR 
       tVincPedido:SCREEN-VALUE IN FRAME fNFeEntrada = "0" THEN DO:
        MESSAGE "Atencao: Esta Nota Fiscal NAO possui um Pedido de Compra vinculado." + CHR(10)
              + "Deseja efetivar o recebimento avulso (sem pedido)?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lConfirma.
        IF NOT lConfirma THEN RETURN.
    END.
    ELSE DO:
        /* Confirmacao do usuario padrão */
        MESSAGE "Tem certeza que deseja EFETIVAR esta Nota Fiscal?" + CHR(10)
              + "Isso ira:" + CHR(10)
              + "  - Gravar a NFe no banco de dados" + CHR(10)
              + "  - Atualizar o estoque dos produtos" + CHR(10)
              + "  - Gerar um titulo no Contas a Pagar"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lConfirma.
        IF NOT lConfirma THEN RETURN.
    END.
    
    /* Monta string de parametros: Chave|NumNF|Fornecedor|Total|IdPedido */
    cDadosEfet = cChaveAcesso:SCREEN-VALUE IN FRAME fNFeEntrada + "|"
               + cNumeroNF:SCREEN-VALUE IN FRAME fNFeEntrada + "|"
               + cNomeFornecedor:SCREEN-VALUE IN FRAME fNFeEntrada + "|"
               + dTotalNFe:SCREEN-VALUE IN FRAME fNFeEntrada + "|"
               + tVincPedido:SCREEN-VALUE IN FRAME fNFeEntrada.
    
    RUN nfe_logica.p (INPUT "EFETIVAR",
                      INPUT cDadosEfet,
                      INPUT-OUTPUT TABLE ttItensNFe,
                      OUTPUT cRetEfet,
                      OUTPUT cMsgEfet).
    
    IF cMsgEfet = "SUCESSO" THEN DO:
        MESSAGE cRetEfet VIEW-AS ALERT-BOX INFORMATION TITLE "Recebimento Efetivado!".
        /* Limpa a tela apos sucesso */
        ASSIGN cChaveAcesso:SCREEN-VALUE IN FRAME fNFeEntrada    = ""
               cNumeroNF:SCREEN-VALUE IN FRAME fNFeEntrada       = ""
               cNomeFornecedor:SCREEN-VALUE IN FRAME fNFeEntrada = ""
               dTotalNFe:SCREEN-VALUE IN FRAME fNFeEntrada       = ""
               tVincPedido:SCREEN-VALUE IN FRAME fNFeEntrada     = "0".
        EMPTY TEMP-TABLE ttItensNFe.
        OPEN QUERY qItensNFe FOR EACH ttItensNFe.
    END.
    ELSE MESSAGE cMsgEfet VIEW-AS ALERT-BOX ERROR.
END.

ON CHOOSE OF btnVoltarNFe IN FRAME fNFeEntrada /* Voltar para Menu */
DO:
    HIDE FRAME fNFeEntrada.
    VIEW FRAME fMain.
END.

/* Gatilho btnVoltarProd consolidado acima para suportar modo dinamico */
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
  /* Padroniza para formato brasileiro (ponto para milhar, virgula para decimal) */
  SESSION:NUMERIC-FORMAT = "European".

  RUN enable_UI.
  
  /* Garante que a biblioteca de HTTP esteja no Propath */
  IF LOOKUP("netlib/OpenEdge.Net.pl", PROPATH) = 0 THEN
      PROPATH = PROPATH + ",C:\Progress\OpenEdge\gui\netlib\OpenEdge.Net.pl".
  
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
  
  IF VALID-HANDLE(FRAME fProdutos:HANDLE) THEN
      ASSIGN FRAME fProdutos:X = (C-Win:WIDTH-PIXELS - FRAME fProdutos:WIDTH-PIXELS) / 2
             FRAME fProdutos:Y = (C-Win:HEIGHT-PIXELS - FRAME fProdutos:HEIGHT-PIXELS) / 2.

  IF VALID-HANDLE(FRAME fFornecedores:HANDLE) THEN
      ASSIGN FRAME fFornecedores:X = (C-Win:WIDTH-PIXELS - FRAME fFornecedores:WIDTH-PIXELS) / 2
             FRAME fFornecedores:Y = (C-Win:HEIGHT-PIXELS - FRAME fFornecedores:HEIGHT-PIXELS) / 2.

  IF VALID-HANDLE(FRAME fNFeEntrada:HANDLE) THEN
      ASSIGN FRAME fNFeEntrada:X = (C-Win:WIDTH-PIXELS - FRAME fNFeEntrada:WIDTH-PIXELS) / 2
             FRAME fNFeEntrada:Y = (C-Win:HEIGHT-PIXELS - FRAME fNFeEntrada:HEIGHT-PIXELS) / 2.

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
  ENABLE LogoInfocena btn-produtos btn-fornecedor btn-compras btn-nfe btn-estoque btn-voltar 
      WITH FRAME fMain IN WINDOW C-Win.
  VIEW C-Win.
END PROCEDURE.

PROCEDURE buscarCNPJ:
    DEFINE INPUT PARAMETER pcCNPJ AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE cCommand AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cResult  AS CHARACTER NO-UNDO.

    /* Executa o script PowerShell para buscar dados na BrasilAPI */
    cCommand = "powershell -ExecutionPolicy Bypass -File api_fornecedor.ps1 -cnpj " + pcCNPJ.
    
    STATUS DEFAULT "Consultando BrasilAPI... Aguarde.".
    OS-COMMAND SILENT VALUE(cCommand).
    STATUS DEFAULT "".

    /* Verifica se o arquivo de resposta foi gerado */
    FILE-INFO:FILE-NAME = "api_fornecedor_res.json".
    IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:
        DEFINE VARIABLE cLinha AS CHARACTER NO-UNDO.
        INPUT FROM "api_fornecedor_res.json".
        REPEAT:
            IMPORT UNFORMATTED cLinha.
            /* Parsing simples via INDEX/SUBSTRING com trava de seguranca para valores nulos */
            IF INDEX(cLinha, '"razao_social":') > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN 
                ASSIGN cRazaoSocial = ENTRY(4, cLinha, '"').
            IF INDEX(cLinha, '"nome_fantasia":') > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN 
                ASSIGN cFantasia = ENTRY(4, cLinha, '"').
            IF INDEX(cLinha, '"cep":') > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN 
                ASSIGN cCEP_Forne = ENTRY(4, cLinha, '"').
            IF INDEX(cLinha, '"ddd_telefone1":') > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN 
                ASSIGN cTel_Forne = ENTRY(4, cLinha, '"').
            IF INDEX(cLinha, '"numero":') > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN 
                ASSIGN cNum_Forne = ENTRY(4, cLinha, '"').
            IF INDEX(cLinha, '"complemento":') > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN 
                ASSIGN cComp_Forne = ENTRY(4, cLinha, '"').
        END.
        INPUT CLOSE.

        DISPLAY cRazaoSocial cFantasia cCEP_Forne cTel_Forne cNum_Forne cComp_Forne
            WITH FRAME fFornecedores.
        
        RUN ficarEmEdicaoForne.
        RUN habilita_campos_forne(TRUE).
        
        /* Busca o endereco completo via CEP automaticamente */
        IF cCEP_Forne <> "" THEN RUN buscarCEP (INPUT cCEP_Forne).
    END.
END PROCEDURE.

PROCEDURE buscarCEP:
    DEFINE INPUT PARAMETER pcCEP AS CHARACTER NO-UNDO.
    
    /* Integracao via PowerShell para buscar CEP (ViaCEP) */
    DEFINE VARIABLE cCmd AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cBuscaCEP AS CHARACTER NO-UNDO.
    
    cBuscaCEP = REPLACE(pcCEP, "-","").
    IF LENGTH(cBuscaCEP) <> 8 THEN RETURN.
    
    STATUS DEFAULT "Buscando CEP...".
    
    /* Executa busca via PowerShell e salva em arquivo temporario */
    cCmd = "powershell -Command ""Invoke-RestMethod -Uri 'https://viacep.com.br/ws/" + cBuscaCEP + "/json/' | ConvertTo-Json | Out-File -FilePath 'cep_forne_tmp.json' -Encoding Default""".
    OS-COMMAND SILENT VALUE(cCmd).
    
    STATUS DEFAULT "".
    
    /* Le o arquivo JSON */
    DEFINE VARIABLE cLinha AS CHARACTER NO-UNDO.
    FILE-INFO:FILE-NAME = "cep_forne_tmp.json".
    IF FILE-INFO:FULL-PATHNAME = ? THEN RETURN.
    
    INPUT FROM "cep_forne_tmp.json".
    REPEAT:
        IMPORT UNFORMATTED cLinha.
        IF INDEX(cLinha, """logradouro"":") > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN DO:
            ASSIGN cEnd_Forne = ENTRY(4, cLinha, '"').
        END.
        IF INDEX(cLinha, """bairro"":") > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN DO:
            ASSIGN cBairro_Forne = ENTRY(4, cLinha, '"').
        END.
        IF INDEX(cLinha, """localidade"":") > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN DO:
            ASSIGN cCid_Forne = ENTRY(4, cLinha, '"').
        END.
        IF INDEX(cLinha, """uf"":") > 0 AND NUM-ENTRIES(cLinha, '"') >= 4 THEN DO:
            ASSIGN cUF_Forne = ENTRY(4, cLinha, '"').
        END.
    END.
    INPUT CLOSE.
    
    DISPLAY cEnd_Forne cBairro_Forne cCid_Forne cUF_Forne WITH FRAME fFornecedores.
    
    /* Remove arquivo temporario */
    OS-DELETE VALUE("cep_forne_tmp.json").
END PROCEDURE.

PROCEDURE salvarFornecedor:
    DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
    
    IF cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores = "" OR
       cCNPJ_Forne:SCREEN-VALUE IN FRAME fFornecedores = "" THEN DO:
        MESSAGE "Razao Social e CNPJ sao obrigatorios!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN fornecedores_logica.p (INPUT "SALVAR", 
                             INPUT iCurrentForneID,
                             INPUT cRazaoSocial:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cFantasia:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cCNPJ_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cEmail_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cTel_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cEnd_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cCid_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cUF_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             INPUT cCEP_Forne:SCREEN-VALUE IN FRAME fFornecedores,
                             OUTPUT cMessage).

    IF cMessage = "SUCESSO" THEN DO:
        MESSAGE "Fornecedor salvo com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
        OPEN QUERY qFornecedores FOR EACH Fornecedor NO-LOCK.
        RUN limparCamposFornecedores.
    END.
    ELSE MESSAGE cMessage VIEW-AS ALERT-BOX ERROR.
END PROCEDURE.
