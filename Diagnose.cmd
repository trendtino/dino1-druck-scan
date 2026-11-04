@echo off
REM DiNo1 Druck und Scan - Diagnose (aendert nichts, erstellt Bericht auf dem Desktop)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Diagnose.ps1"
