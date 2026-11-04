@echo off
REM DiNo1 Druck und Scan - Uebersicht aller PCs (per Doppelklick, kein Admin noetig)
REM Zeigt die Statusdateien aller PCs aus dem Status-Ordner auf HiDrive an.

powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0Uebersicht.ps1" %*
