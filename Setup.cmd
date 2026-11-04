@echo off
REM DiNo1 Druck und Scan - Einrichtung starten (per Doppelklick)
REM Startet Setup.ps1, das sich bei Bedarf selbst mit Administrator-Rechten
REM neu startet (Windows-Sicherheitsabfrage erscheint automatisch).

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Setup.ps1"

if errorlevel 1 (
    echo.
    echo Es ist ein Fehler aufgetreten. Fenster bitte nicht schliessen und
    echo Rueckmeldung an die IT geben.
    pause
)
