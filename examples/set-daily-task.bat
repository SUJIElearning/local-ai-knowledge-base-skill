@echo off
title Daily KB Task Setup
echo ========================================
echo   One-click schedule setup (daily 22:00)
echo ========================================
echo.
echo Calling PowerShell setup script...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-task.ps1"

echo.
pause