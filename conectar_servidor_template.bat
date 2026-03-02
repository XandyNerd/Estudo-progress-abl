@echo off
set DLC=C:\Progress\OpenEdge
set PATH=%DLC%\bin;%PATH%

:: Garante que o script rode a partir da pasta onde ele esta
cd /d "%~dp0"

:: ============================================================
:: CONFIGURACAO DE CONEXAO
:: ============================================================
:: Mude o IP abaixo para o IP do seu Servidor.
set SERVER_IP=192.168.1.8
set SERVER_PORT=5555
:: ============================================================

echo Conectando ao Banco de Dados Infocena em %SERVER_IP%:%SERVER_PORT%...

:: -T %TEMP%: Define onde os arquivos temporarios serao criados (resolve erro 354)
prowin.exe -db infocena -H %SERVER_IP% -S %SERVER_PORT% -N TCP -T %TEMP% -p 01-projeto-infocena\gui_version\interface_login.w

if %errorlevel% neq 0 (
    echo.
    echo ERRO: Nao foi possivel conectar ao servidor.
    echo 1. Verifique se o banco de dados esta rodando no servidor.
    echo 2. Verifique se o Firewall do servidor permite a porta %SERVER_PORT%.
    echo 3. Verifique se os computadores estao na mesma rede/Radmin.
    pause
)
