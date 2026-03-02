/* ver_tabelas.p */
OUTPUT TO "lista_tabelas_final.txt".
FOR EACH _file NO-LOCK WHERE _file-number > 0 AND _file-number < 32767:
    PUT UNFORMATTED _file-name SKIP.
END.
OUTPUT CLOSE.
QUIT.
