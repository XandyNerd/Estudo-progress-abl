@echo off
set DLC=C:\Progress\OpenEdge
set CATALINA_HOME=%DLC%\servers\pasoe
set JAVA_HOME=%DLC%\jdk
set PATH=%DLC%\bin;%CATALINA_HOME%\bin;%PATH%

echo Creating PASOE instance via PowerShell...
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { $env:DLC='C:\Progress\OpenEdge'; $env:CATALINA_HOME='C:\Progress\OpenEdge\servers\pasoe'; $env:JAVA_HOME='C:\Progress\OpenEdge\jdk'; & 'C:\Progress\OpenEdge\servers\pasoe\bin\tcmanager.ps1' create -v -p 8810 -P 8811 -s 8812 pasoe_dev 'C:\Users\xandy\Desktop\Estudo infocena\pasoe_dev' }"

if %errorlevel% neq 0 (
    echo Error creating PASOE instance.
    exit /b %errorlevel%
)

echo PASOE instance created successfully.
