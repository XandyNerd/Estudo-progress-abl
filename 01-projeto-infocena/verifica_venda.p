CONNECT -db "01-projeto-infocena\data\infocena" -1 NO-ERROR.

OUTPUT TO "01-projeto-infocena\resultado_venda.txt".

FOR EACH Venda NO-LOCK:
    DISPLAY Venda.Id_Venda Venda.CodCliente Venda.DataVenda Venda.ValorTotal Venda.StatusVenda.
END.

FOR EACH ItemVenda NO-LOCK:
    DISPLAY ItemVenda.Id_Venda ItemVenda.Sequencia ItemVenda.Id_Produto ItemVenda.Quantidade ItemVenda.Preco_Unit ItemVenda.Total_Item.
END.

FOR EACH Produto WHERE Produto.Id_Produto = 4 NO-LOCK:
    DISPLAY Produto.Id_Produto Produto.Nome Produto.Quantidade_Estoque.
END.

OUTPUT CLOSE.
QUIT.
