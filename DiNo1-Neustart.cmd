@echo off
title DiNo1 Druck und Scan - Neustart
echo DiNo1 Druck und Scan wird beendet und neu gestartet ...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process -Filter \"Name='powershell.exe' OR Name='conhost.exe'\" | Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -like '*Watcher.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Start-Sleep -Seconds 2; Start-Process conhost.exe -ArgumentList '--headless powershell.exe -ExecutionPolicy Bypass -File C:\PaperPortErsatz\Watcher.ps1'"
echo Fertig. Das Symbol erscheint in wenigen Sekunden unten rechts.
timeout /t 4 >nul
