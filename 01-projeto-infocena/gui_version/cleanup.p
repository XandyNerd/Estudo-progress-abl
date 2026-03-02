/* cleanup.p */
/* Tenta deletar as tabelas caso estejam em algum estado fantasma */

FOR EACH _file WHERE _file-name = "NotaFiscal" OR _file-name = "ItemNotaFiscal":
    DELETE _file.
END.

/* Nota: No Progress, deletar os indices orfaos diretamente via _Index e mais arriscado, 
   mas vamos tentar listar se eles existem sem tabela */
OUTPUT TO "diag_orfaos.txt".
FOR EACH _Index NO-LOCK:
    FIND _File WHERE _File._File-number = _Index._File-number NO-LOCK NO-ERROR.
    IF NOT AVAILABLE _File THEN
        PUT UNFORMATTED "Orfao Index: " _Index-name SKIP.
END.
OUTPUT CLOSE.
QUIT.
