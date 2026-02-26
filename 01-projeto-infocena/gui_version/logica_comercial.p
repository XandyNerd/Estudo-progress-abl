/* logica_comercial.p */
DEFINE INPUT PARAMETER pUsuarioNome AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pAcao        AS CHARACTER NO-UNDO.

/*
 * Comercial Actions Controller
 * Recebe o clique do usuario na Interface_Comercial.w e processa a regra de negocio
 */

CASE pAcao:
    WHEN "CLIENTES" THEN DO:
        /* Agora chamado diretamente pela interface_comercial.w para melhor controle de janelas */
    END.
    
    WHEN "PEDIDOS" THEN DO:
        MESSAGE "Módulo de PEDIDO DE VENDA em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    WHEN "NFE" THEN DO:
        MESSAGE "Módulo de EMISSAO NF-e SIMPLIFICADA em desenvolvimento..." VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    OTHERWISE DO:
        MESSAGE "Acao invalida ou nao implementada no módulo Comercial: " + pAcao VIEW-AS ALERT-BOX ERROR.
    END.
END CASE.
