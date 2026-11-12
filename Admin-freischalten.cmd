@echo off
REM DiNo1 Druck und Scan - diesen PC als Admin-PC freischalten
REM (zeigt im Tray-Menue "Alle Shops: Nutzer und Tagesberichte").
REM Wieder sperren: Datei C:\PaperPortErsatz\Admin.txt loeschen.
echo Admin-PC freigeschaltet am %date% %time% > "C:\PaperPortErsatz\Admin.txt"
if exist "C:\PaperPortErsatz\Admin.txt" (echo Dieser PC ist jetzt als Admin-PC freigeschaltet. Der Eintrag erscheint beim naechsten Oeffnen des Tray-Menues.) else (echo Freischalten fehlgeschlagen - existiert C:\PaperPortErsatz?)
pause
