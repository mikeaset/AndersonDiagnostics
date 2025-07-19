@echo off
title QuickBooks Diagnostic Toolkit - Anderson Urgent Computer Care

echo Running QB_DiagnosticToolkit...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File QB_DiagnosticToolkit2.ps1

echo.
echo Toolkit Complete. Press any key to exit.
pause >nul
