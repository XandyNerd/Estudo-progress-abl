CONNECT -db data/infocena -1 NO-ERROR.

IF CONNECTED("infocena") THEN DO:
    CREATE ALIAS DICTDB FOR DATABASE infocena.
    
    /* CRIANDO TABELA VENDA */
    FIND _File WHERE _File._File-Name = "Venda" NO-ERROR.
    IF NOT AVAILABLE _File THEN DO:
        CREATE _File.
        ASSIGN _File._File-Name = "Venda"
               _File._Desc      = "Cabecalho de Vendas".
               
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Id_Venda" _Field._Data-Type = "integer" _Field._Format = "->,>>>,>>9" _Field._Order = 10.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "CodCliente" _Field._Data-Type = "integer" _Field._Format = "->,>>>,>>9" _Field._Order = 20.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "DataVenda" _Field._Data-Type = "date" _Field._Format = "99/99/9999" _Field._Order = 30.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "ValorTotal" _Field._Data-Type = "decimal" _Field._Format = ">,>>>,>>9.99" _Field._Decimals = 2 _Field._Order = 40.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Status" _Field._Data-Type = "character" _Field._Format = "x(20)" _Field._Order = 50.

        CREATE _Index. ASSIGN _Index._File-recid = RECID(_File) _Index._Index-Name = "Id_Venda" _Index._Unique = YES _Index._Primary = YES.
        CREATE _Index-Field. ASSIGN _Index-Field._Index-recid = RECID(_Index) _Index-Field._Field-recid = (FIND _Field WHERE _Field._Field-Name = "Id_Venda" AND _Field._File-recid = RECID(_File)).
    END.

    /* CRIANDO TABELA ITEMVENDA */
    FIND _File WHERE _File._File-Name = "ItemVenda" NO-ERROR.
    IF NOT AVAILABLE _File THEN DO:
        CREATE _File.
        ASSIGN _File._File-Name = "ItemVenda"
               _File._Desc      = "Itens da Venda".

        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Id_Venda" _Field._Data-Type = "integer" _Field._Format = "->,>>>,>>9" _Field._Order = 10.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Sequencia" _Field._Data-Type = "integer" _Field._Format = "->,>>>,>>9" _Field._Order = 20.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Id_Produto" _Field._Data-Type = "integer" _Field._Format = "->,>>>,>>9" _Field._Order = 30.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Quantidade" _Field._Data-Type = "decimal" _Field._Format = "->>,>>9.99" _Field._Decimals = 2 _Field._Order = 40.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Preco_Unit" _Field._Data-Type = "decimal" _Field._Format = ">,>>>,>>9.99" _Field._Decimals = 2 _Field._Order = 50.
        CREATE _Field. ASSIGN _Field._File-recid = RECID(_File) _Field._Field-Name = "Total_Item" _Field._Data-Type = "decimal" _Field._Format = ">,>>>,>>9.99" _Field._Decimals = 2 _Field._Order = 60.

        CREATE _Index. ASSIGN _Index._File-recid = RECID(_File) _Index._Index-Name = "Idx_ItemVenda" _Index._Unique = YES _Index._Primary = YES.
        CREATE _Index-Field. ASSIGN _Index-Field._Index-recid = RECID(_Index) _Index-Field._Field-recid = (FIND _Field WHERE _Field._Field-Name = "Id_Venda" AND _Field._File-recid = RECID(_File)) _Index-Field._Index-seq = 1.
        CREATE _Index-Field. ASSIGN _Index-Field._Index-recid = RECID(_Index) _Index-Field._Field-recid = (FIND _Field WHERE _Field._Field-Name = "Sequencia" AND _Field._File-recid = RECID(_File)) _Index-Field._Index-seq = 2.
    END.

    OUTPUT TO "carga_manual_log.txt".
    PUT UNFORMATTED "Tabelas Venda e ItemVenda verificadas/criadas via _File diretamente!" SKIP.
    OUTPUT CLOSE.

    DISCONNECT infocena.
END.
QUIT.
