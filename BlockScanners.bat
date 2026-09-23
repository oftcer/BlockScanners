@echo off
:: BlockScanners launcher — oftcer — https://oftcer.com
:: Eleva para Administrador e aplica as regras de firewall.

setlocal
title BlockScanners
cd /d "%~dp0"

set "SCRIPT=Block-Scanners.ps1"

if not exist "%~dp0%SCRIPT%" (
    echo [!] Arquivo nao encontrado: %SCRIPT%
    echo     Coloque BlockScanners.bat e Block-Scanners.ps1 na mesma pasta.
    pause
    exit /b 1
)

:: Verifica se ja esta em modo administrador
net session >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [!] Reexecutando como Administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo  BlockScanners — oftcer — https://oftcer.com
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0%SCRIPT%"
set "EXITCODE=%ERRORLEVEL%"

echo.
pause
exit /b %EXITCODE%
