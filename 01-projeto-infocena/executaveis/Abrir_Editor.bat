@echo off
set DLC=C:\Progress\OpenEdge
set PATH=%DLC%\bin;%PATH%
cd /d "%~dp0.."
start "" "%DLC%\bin\prowin.exe" -db data\infocena.db -1 -p _editor.p
exit
