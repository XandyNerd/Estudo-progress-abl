Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "c:\Progress\OpenEdge\bin\prowin.exe -db """"01-projeto-infocena\data\infocena"""" -1 -p """"01-projeto-infocena\carga_venda.p""""", 0, True
