/* Diagnostico: quais tabelas existem no banco? */
OUTPUT TO "diag_tables.txt".
PUT UNFORMATTED "=== TABELAS NO BANCO ===" SKIP.
FOR EACH _File WHERE _File._File-Name NOT BEGINS "_" NO-LOCK:
    PUT UNFORMATTED _File._File-Name SKIP.
END.
PUT UNFORMATTED "========================" SKIP.
OUTPUT CLOSE.
QUIT.
