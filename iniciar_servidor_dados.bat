@echo off
set DLC=C:\Progress\OpenEdge
set PATH=%DLC%\bin;%PATH%
cd /d "%~dp001-projeto-infocena\data"

echo Iniciando Servidor de Dados Infocena (Porta 5555)...
proserve infocena.db -S 5555 -H 0.0.0.0 -N TCP

if %errorlevel% neq 0 (
    echo.
    echo ERRO: Nao foi possivel iniciar o servidor. 
    echo Verifique se o banco ja nao esta aberto por outro programa.
    pause
) else (
    echo.
    echo Servidor de dados iniciado com SUCESSO! 
    echo Mantenha esta janela aberta enquanto estiver desenvolvendo.
    echo.
    pause
)
