@echo off
set DLC=C:\Progress\OpenEdge
set PATH=%DLC%\bin;%PATH%

:: ============================================================
:: CONFIGURACAO DE CONEXAO
:: ============================================================
:: Mude o IP abaixo para o IP do seu Servidor.
:: Se estiver na mesma rede local, use: 192.168.1.8
:: Se estiver usando Radmin VPN, use o IP que aparece no Radmin do Servidor.
set SERVER_IP=192.168.1.8
set SERVER_PORT=5555
:: ============================================================

echo Conectando ao Banco de Dados Infocena em %SERVER_IP%:%SERVER_PORT%...

prowin.exe -db infocena -H %SERVER_IP% -S %SERVER_PORT% -N TCP -p 01-projeto-infocena\gui_version\interface_login.w

if %errorlevel% neq 0 (
    echo.
    echo ERRO: Nao foi possivel conectar ao servidor.
    echo 1. Verifique se o banco de dados esta rodando no servidor.
    echo 2. Verifique se o Firewall do servidor permite a porta %SERVER_PORT%.
    echo 3. Verifique se os computadores estao na mesma rede/Radmin.
    pause
)
