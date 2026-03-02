/* Definitive Load Script */
RUN prodict/load_df.p ("../data/nfe_only.df").
MESSAGE "LOAD_COMPLETE" VIEW-AS ALERT-BOX.
QUIT.
