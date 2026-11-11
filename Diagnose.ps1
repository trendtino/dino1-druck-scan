<#
    Diagnose.ps1 - DiNo1 Druck & Scan: Fehlersuche
    Aendert NICHTS am PC, sammelt nur Informationen und legt einen Bericht
    "PaperPort-Diagnose.txt" auf den Desktop.
#>
$bericht = Join-Path ([Environment]::GetFolderPath("Desktop")) "PaperPort-Diagnose.txt"
$zeilen = New-Object System.Collections.Generic.List[string]
function Z($t) { [void]$zeilen.Add("$t") }
function Abschnitt($t) { Z ""; Z "===== $t =====" }

Abschnitt "System"
try { $os = Get-CimInstance Win32_OperatingSystem; Z "Windows: $($os.Caption) $($os.Version) ($($os.OSArchitecture))" } catch { Z "Windows: ? ($_)" }
Z "PowerShell: $($PSVersionTable.PSVersion)"
Z "Benutzer: $env:USERDOMAIN\$env:USERNAME"
$istAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Z "Laeuft als Administrator: $istAdmin"
Z "Skriptordner: $PSScriptRoot"
try { Z "Sprachmodus: $($ExecutionContext.SessionState.LanguageMode)" } catch {}

Abschnitt "Ausfuehrungsrichtlinie"
try { Get-ExecutionPolicy -List | ForEach-Object { Z "$($_.Scope): $($_.ExecutionPolicy)" } } catch { Z "? $_" }

Abschnitt "Setup-Dateien im selben Ordner"
foreach ($f in "Setup.cmd","Setup.ps1","Watcher.ps1","Install-DiNo1DruckScan.ps1") {
    $p = Join-Path $PSScriptRoot $f
    $motw = ""
    if (Test-Path $p) { try { if (Get-Item $p -Stream Zone.Identifier -ErrorAction Stop) { $motw = " (aus dem Internet markiert)" } } catch {} }
    Z "$f : $(if (Test-Path $p) {'vorhanden'} else {'FEHLT'})$motw"
}
if ($PSScriptRoot -match '\\Temp\\|\\AppData\\Local\\Temp') { Z "WARNUNG: Ordner liegt im Temp-Verzeichnis - wurde evtl. direkt aus dem RAR/ZIP gestartet, ohne zu entpacken." }
try {
    $lw = (Split-Path $PSScriptRoot -Qualifier)
    $typ = (Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$lw'").DriveType
    Z "Laufwerk $lw Typ: $typ (3=lokal, 4=Netzlaufwerk)"
    if ($typ -eq 4) { Z "WARNUNG: Setup liegt auf einem Netzlaufwerk - das mit Admin-Rechten neu gestartete Setup sieht dieses Laufwerk meist NICHT." }
} catch {}

Abschnitt "Installation C:\PaperPortErsatz"
foreach ($p in "C:\PaperPortErsatz","C:\PaperPortErsatz\Watcher.ps1","C:\PaperPortErsatz\Ablage","C:\PaperPortErsatz\Log.txt","C:\PaperPortErsatz\Log_alt.txt") {
    Z "$p : $(if (Test-Path $p) {'vorhanden'} else {'FEHLT'})"
}
$w = "C:\PaperPortErsatz\Watcher.ps1"
if (Test-Path $w) {
    $t = $null; $e = $null
    [System.Management.Automation.Language.Parser]::ParseFile($w, [ref]$t, [ref]$e) | Out-Null
    Z "Syntaxfehler in Watcher.ps1: $($e.Count)"
    $e | Select-Object -First 10 | ForEach-Object { Z "  Zeile $($_.Extent.StartLineNumber): $($_.Message)" }
    Get-Content $w | Select-String -Pattern '^\$(StandortName|ZielBasis|ShopOrdner|KassenOrdner|ScanDruckerListe|ScanFarbmodus|AuchNichtHinterlegteScanner|ScanDirektAlsPdf|ScanStandardDpi|PdfBildQualitaet|DuplexStandard|LeereSeitenEntfernen|LeereSeiteSchwelle|MaxSeitenProScan|BezeichnungenMerken|LogMaxMB|AusfuehrlichesScanLog|PruefIntervall)\s*=' | ForEach-Object { Z "  $($_.Line)" }
}

Abschnitt "Geplante Aufgabe"
try {
    $task = Get-ScheduledTask -TaskName "PaperPort Ersatz Watcher" -ErrorAction Stop
    $info = $task | Get-ScheduledTaskInfo
    Z "Status: $($task.State)"
    Z "Laeuft als Benutzer: $($task.Principal.UserId)"
    if ($task.Principal.UserId -notmatch [regex]::Escape($env:USERNAME)) { Z "WARNUNG: Aufgabe gehoert einem ANDEREN Benutzer als dem angemeldeten - startet dann nicht bei dessen Anmeldung." }
    Z "Aktion: $($task.Actions[0].Execute) $($task.Actions[0].Arguments)"
    Z "Letzter Start: $($info.LastRunTime)  Ergebnis: 0x$('{0:X}' -f $info.LastTaskResult)"
} catch { Z "Aufgabe NICHT gefunden ($($_.Exception.Message))" }

Abschnitt "Laufende Watcher-Prozesse"
try {
    $pr = Get-CimInstance Win32_Process -Filter "Name='powershell.exe' OR Name='conhost.exe'" | Where-Object { $_.CommandLine -match 'Watcher\.ps1' }
    if ($pr) { $pr | ForEach-Object { Z "PID $($_.ProcessId): $($_.CommandLine)" } } else { Z "Kein Watcher-Prozess laeuft." }
} catch { Z "? $_" }

Abschnitt "Drucker"
try { Get-Printer | ForEach-Object { Z "$($_.Name)  ->  $($_.PortName)" } } catch { Z "? $_" }

Abschnitt "Scanner (WIA - fuer 'Jetzt scannen')"
try {
    $wia = New-Object -ComObject WIA.DeviceManager
    $anzahl = 0
    foreach ($di in $wia.DeviceInfos) {
        $n = "?"; try { $n = $di.Properties.Item("Name").Value } catch {}
        $typText = if ($di.Type -eq 1) { "Scanner" } elseif ($di.Type -eq 2) { "Kamera" } else { "Typ $($di.Type)" }
        Z "$typText : '$n'  (DeviceID=$($di.DeviceID))"
        if ($di.Type -eq 1) { $anzahl++ }
    }
    if ($anzahl -eq 0) { Z "KEIN WIA-Scanner gefunden - 'Jetzt scannen' kann keinen Scanner anbieten." }
} catch { Z "WIA nicht abfragbar: $($_.Exception.Message)" }
if (Test-Path "C:\PaperPortErsatz\Watcher.ps1") {
    $wt = Get-Content "C:\PaperPortErsatz\Watcher.ps1" -Raw
    if ($wt -match '(?s)\$ScannerListe\s*=\s*\[ordered\]@\{(.*?)\}') {
        $eintr = [regex]::Matches($matches[1], '"([^"]*)"\s*=\s*"([^"]*)"')
        if ($eintr.Count -eq 0) { Z "Hinterlegte Scanner: keine (alle gefundenen werden angeboten)" }
        foreach ($e in $eintr) { Z "Hinterlegt: '$($e.Groups[1].Value)' -> sucht '$($e.Groups[2].Value)'" }
    } else { Z "Hinterlegte Scanner: (aeltere Watcher-Version ohne Scanner-Liste)" }
}
if (Test-Path "C:\PaperPortErsatz\ScannerEinstellungen.json") { Z "Gemerkte Scan-Optionen je Scanner:"; Get-Content "C:\PaperPortErsatz\ScannerEinstellungen.json" | ForEach-Object { Z "  $_" } }
$ueb = @(Get-ChildItem "C:\PaperPortErsatz\Uebersprungen" -Filter *.pdf -ErrorAction SilentlyContinue).Count
$abl = @(Get-ChildItem "C:\PaperPortErsatz\Ablage" -Filter *.pdf -ErrorAction SilentlyContinue).Count
Z "Dokumente im Ablage-Ordner: $abl  /  zurueckgestellt (Uebersprungen): $ueb"
if (Test-Path "C:\PaperPortErsatz\LetzterScanner.txt") { Z "Zuletzt benutzt: $((Get-Content 'C:\PaperPortErsatz\LetzterScanner.txt' -Raw).Trim())" }

Abschnitt "Bildgeraete laut Geraete-Manager (inkl. TWAIN-/nicht eingerichteter Scanner)"
try {
    $pnp = Get-PnpDevice -Class Image -ErrorAction Stop
    foreach ($d in $pnp) { Z "$($d.Status) : $($d.FriendlyName)" }
} catch { Z "(keine oder nicht abfragbar)" }
foreach ($tw in "$env:WINDIR\twain_32","$env:WINDIR\twain_64") {
    if (Test-Path $tw) {
        $q = Get-ChildItem $tw -Recurse -Filter *.ds -ErrorAction SilentlyContinue
        foreach ($f in $q) { Z "TWAIN-Quelle: $($f.FullName)" }
    }
}

Abschnitt "PDF24"
$pdf24 = @("$env:ProgramFiles\PDF24","${env:ProgramFiles(x86)}\PDF24") | Where-Object { Test-Path $_ }
Z "PDF24-Ordner: $(if ($pdf24) { $pdf24 -join ', ' } else { 'nicht gefunden' })"

Abschnitt "Log.txt (letzte 40 Zeilen)"
if (Test-Path "C:\PaperPortErsatz\Log.txt") { Get-Content "C:\PaperPortErsatz\Log.txt" -Tail 40 | ForEach-Object { Z $_ } } else { Z "(keine Log-Datei)" }

Abschnitt "Test: Watcher-Start sichtbar (5 Sekunden)"
if ($pr) {
    Z "(uebersprungen, Watcher laeuft bereits)"
} elseif (Test-Path $w) {
    $out = Join-Path $env:TEMP "ppe_test_out.txt"; $err = Join-Path $env:TEMP "ppe_test_err.txt"
    $p = Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$w`"" -PassThru -RedirectStandardOutput $out -RedirectStandardError $err -WindowStyle Hidden
    Start-Sleep -Seconds 5
    if ($p.HasExited) { Z "Watcher hat sich nach <5 s BEENDET (Exitcode $($p.ExitCode)) - Fehlerausgabe:" } else { Z "Watcher laeuft nach 5 s noch (gut). Testprozess wird wieder beendet."; Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue }
    foreach ($f in $out,$err) { if (Test-Path $f) { Get-Content $f | ForEach-Object { Z "  $_" }; Remove-Item $f -Force -ErrorAction SilentlyContinue } }
} else { Z "(uebersprungen, Watcher.ps1 nicht installiert)" }

$zeilen | Set-Content -Path $bericht -Encoding UTF8

# Zusaetzlich in den Shop-Ordner auf HiDrive legen ("<Shop-Ordner>\DiNo1-Druck-Scan-Status\Logs")
try {
    $wt = [System.IO.File]::ReadAllText("C:\PaperPortErsatz\Watcher.ps1")
    $statusOrdner = ""
    if ($wt -match '(?m)^\$StatusOrdner\s*=\s*"([^"]+)"') { $statusOrdner = $matches[1] }
    elseif ($wt -match '(?m)^\$ShopOrdner\s*=\s*"([^"]+)"') { $statusOrdner = Join-Path $matches[1] "DiNo1-Druck-Scan-Status" }
    if ($statusOrdner -and $statusOrdner -ne "-" -and (Test-Path (Split-Path $statusOrdner -Parent))) {
        $logOrdner = Join-Path $statusOrdner "Logs"
        if (-not (Test-Path $logOrdner)) { New-Item -ItemType Directory -Path $logOrdner -Force | Out-Null }
        $ziel = Join-Path $logOrdner ("$($env:COMPUTERNAME)_$($env:USERNAME)_Diagnose_" + (Get-Date -Format 'yyyy-MM-dd_HHmm') + ".txt")
        Copy-Item -Path $bericht -Destination $ziel -Force -ErrorAction Stop
        Write-Host "Diagnose zusaetzlich abgelegt: $ziel"
    }
} catch { Write-Host "Diagnose konnte nicht in den Shop-Ordner gelegt werden: $($_.Exception.Message)" }
Start-Process notepad.exe -ArgumentList "`"$bericht`""
