COMPILE interface_suprimentos.w SAVE INTO . NO-ERROR.
IF COMPILER:ERROR THEN DO:
    OUTPUT TO comp_errors.txt.
    MESSAGE "Erro de compilacao detectado!".
    OUTPUT CLOSE.
END.
ELSE DO:
    OUTPUT TO comp_errors.txt.
    MESSAGE "Sucesso".
    OUTPUT CLOSE.
END.
QUIT.
