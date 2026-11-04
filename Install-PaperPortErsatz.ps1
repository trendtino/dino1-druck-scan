<#
    Install-PaperPortErsatz.ps1
    ----------------------------
    Einmalig auf jedem PC ausfuehren, auf dem der PaperPort-Ersatz laufen soll.
    Kopiert den Watcher an einen festen Ort und richtet die geplante Aufgabe ein,
    die ihn bei jeder Anmeldung automatisch und unsichtbar startet.

    WICHTIG: Vorher in "Watcher.ps1" (im selben Ordner wie dieses Skript) den
    Abschnitt "KONFIGURATION" anpassen (Standortname, HiDrive-Pfad, Mitarbeiter).

    Ausfuehren mit:
      powershell -ExecutionPolicy Bypass -File "Install-PaperPortErsatz.ps1"
#>

$ZielVerzeichnis = "C:\PaperPortErsatz"
$TaskName        = "PaperPort Ersatz Watcher"

$QuellSkript = Join-Path $PSScriptRoot "Watcher.ps1"

if (-not (Test-Path $QuellSkript)) {
    Write-Host "FEHLER: Watcher.ps1 wurde nicht im selben Ordner gefunden ($PSScriptRoot)." -ForegroundColor Red
    Write-Host "Bitte sicherstellen, dass Watcher.ps1 neben diesem Installationsskript liegt."
    exit 1
}

if (-not (Test-Path $ZielVerzeichnis)) {
    New-Item -ItemType Directory -Path $ZielVerzeichnis -Force | Out-Null
}
if (-not (Test-Path (Join-Path $ZielVerzeichnis "Ablage"))) {
    New-Item -ItemType Directory -Path (Join-Path $ZielVerzeichnis "Ablage") -Force | Out-Null
}

Copy-Item -Path $QuellSkript -Destination (Join-Path $ZielVerzeichnis "Watcher.ps1") -Force

# Vorhandene Aufgabe (falls vorhanden) entfernen und Prozesse stoppen
Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue | Stop-ScheduledTask -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

# Ueber "conhost.exe --headless" gestartet, damit NIE ein sichtbares Konsolen-
# oder Windows-Terminal-Fenster aufploppt - unabhaengig davon, welche
# "Standard-Terminalanwendung" auf diesem PC eingestellt ist (das war auf
# manchen PCs sonst ein sichtbares, leeres Terminalfenster nach jedem Start).
$action = New-ScheduledTaskAction -Execute "conhost.exe" `
    -Argument "--headless powershell.exe -ExecutionPolicy Bypass -File `"$ZielVerzeichnis\Watcher.ps1`""

$trigger = New-ScheduledTaskTrigger -AtLogOn

# Angemeldeten Benutzer verwenden, nicht ein evtl. abweichendes Admin-Konto,
# mit dem PowerShell gestartet wurde.
$ZielBenutzer = $null
try { $ZielBenutzer = (Get-CimInstance Win32_ComputerSystem -ErrorAction Stop).UserName } catch {}
if ([string]::IsNullOrWhiteSpace($ZielBenutzer)) { $ZielBenutzer = "$env:USERDOMAIN\$env:USERNAME" }
try { & icacls.exe $ZielVerzeichnis /grant "$($ZielBenutzer):(OI)(CI)M" /T /C /Q | Out-Null } catch {}

$principal = New-ScheduledTaskPrincipal -UserId $ZielBenutzer -LogonType Interactive

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -MultipleInstances IgnoreNew `
    -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

try {
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
        -Principal $principal -Settings $settings `
        -Description "PaperPort-Ersatz: ueberwacht Ablageordner und ordnet Dokumente automatisch dem richtigen Standort/Mitarbeiter zu" `
        -ErrorAction Stop | Out-Null
} catch {
    Write-Host ""
    Write-Host "FEHLER: Geplante Aufgabe konnte nicht eingerichtet werden:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Haeufigste Ursache: PowerShell wurde NICHT als Administrator gestartet," -ForegroundColor Yellow
    Write-Host "waehrend fuer diese Aufgabe bereits eine aeltere Version mit anderen" -ForegroundColor Yellow
    Write-Host "Rechten existierte. Bitte PowerShell als Administrator oeffnen und dieses" -ForegroundColor Yellow
    Write-Host "Skript erneut ausfuehren." -ForegroundColor Yellow
    exit 1
}

Start-ScheduledTask -TaskName $TaskName

Write-Host ""
Write-Host "Fertig!" -ForegroundColor Green
Write-Host "Watcher installiert unter: $ZielVerzeichnis\Watcher.ps1"
Write-Host "Geplante Aufgabe '$TaskName' eingerichtet und gestartet."
Write-Host ""
Write-Host "Naechster Schritt: In PDF24 (Einstellungen -> PDF Drucker -> Automatisches" -ForegroundColor Yellow
Write-Host "Speichern -> 'Dokumente nach dem Drucken automatisch speichern') als Ordner" -ForegroundColor Yellow
Write-Host "genau diesen Pfad eintragen:" -ForegroundColor Yellow
Write-Host "$ZielVerzeichnis\Ablage" -ForegroundColor Yellow
