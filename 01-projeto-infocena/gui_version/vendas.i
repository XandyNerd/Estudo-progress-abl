/* vendas.i - Definição da Temp-Table de Itens de Venda */
DEFINE TEMP-TABLE ttItensVenda NO-UNDO
    FIELD Sequencia    AS INTEGER
    FIELD Id_Produto   AS INTEGER
    FIELD Descricao    AS CHARACTER FORMAT "X(40)"
    FIELD Marca        AS CHARACTER FORMAT "X(20)"
    FIELD Unidade      AS CHARACTER FORMAT "X(3)"
    FIELD Quantidade   AS DECIMAL   FORMAT "->>>,>>9.99"
    FIELD Preco_Unit   AS DECIMAL   FORMAT "->>>,>>9.99"
    FIELD Total_Item   AS DECIMAL   FORMAT "->>>,>>>,>>9.99"
    INDEX idx_seq_venda IS PRIMARY Sequencia.
