@echo off
REM PaperPort-Ersatz - Diagnose (aendert nichts, erstellt Bericht auf dem Desktop)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Diagnose.ps1"
