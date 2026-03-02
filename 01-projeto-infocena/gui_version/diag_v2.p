OUTPUT TO "diag_v2.txt".
FOR EACH _File NO-LOCK WHERE _File._File-name NOT BEGINS "_":
    DISPLAY _File._File-name WITH STREAM-IO.
END.
OUTPUT CLOSE.
QUIT.
