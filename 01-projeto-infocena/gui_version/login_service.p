/*------------------------------------------------------------------------
    File: login_service.p
    Description: Servico de Login para autenticacao de usuarios
------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER ipcEmail AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER ipcSenha AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER oplSucesso AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER opcNome    AS CHARACTER NO-UNDO.

/* 
   Este codigo roda localmente, assumindo que o banco de dados ja esta conectado.
   Nao precisamos de CONNECT aqui.
*/

FIND FIRST Usuario WHERE Usuario.Email = ipcEmail 
                     AND Usuario.Senha = ipcSenha NO-LOCK NO-ERROR.

IF AVAILABLE Usuario THEN DO:
    ASSIGN oplSucesso = YES
           opcNome    = Usuario.Nome.
END.
ELSE DO:
    ASSIGN oplSucesso = NO
           opcNome    = "".
END.
