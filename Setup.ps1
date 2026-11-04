<#
    Setup.ps1 - DiNo1 Druck & Scan: Alles-in-einem-Einrichtung
    ------------------------------------------------------
    Zum Doppelklicken: "Setup.cmd" im selben Ordner ausfuehren (dieses
    Skript startet sich darueber automatisch mit Administrator-Rechten -
    die Windows-Sicherheitsabfrage dafuer erscheint von selbst).

    Was dieses Skript macht, in einem Rutsch:
      1. Zeigt ein Eingabefenster fuer die Standort-Einstellungen
         (Standortname, HiDrive-Pfade, Mitarbeiterliste, Drucker, Scanner).
         Wurde hier schon einmal eingerichtet (oder liegt eine bereits
         angepasste Watcher.ps1 im selben Ordner), werden die Felder
         automatisch damit vorausgefuellt.
      2. Schreibt daraus die fertige Watcher.ps1 nach C:\PaperPortErsatz.
      3. Richtet auf Wunsch "Dino1 Drucker" als Ausweich-Drucker ein
         (Microsoft Print to PDF, umgeleitet in den Ablage-Ordner).
      4. Richtet die geplante Aufgabe ein, die den Watcher bei jeder
         Anmeldung automatisch und unsichtbar startet, und startet ihn
         gleich mit.

    Einziger manueller Schritt, der danach noch bleibt (kann nicht per
    Skript gesetzt werden, da PDF24 eine fremde Software ist): PDF24 auf
    automatisches Speichern in C:\PaperPortErsatz\Ablage einstellen -
    siehe ANLEITUNG.txt, SCHRITT 2.
#>

# Wird beim automatischen Neustart mit Administrator-Rechten mitgegeben: der
# Benutzer, der Setup.cmd urspruenglich gestartet hat. Grund: Gibt man bei der
# Windows-Sicherheitsabfrage das Passwort eines ANDEREN (Admin-)Kontos ein,
# laeuft das neu gestartete Skript unter diesem Admin-Konto - die geplante
# Aufgabe wurde dann frueher faelschlich fuer das Admin-Konto angelegt und der
# Watcher startete beim eigentlichen Mitarbeiter-Konto nie.
param([string]$ZielBenutzer = "")

# ======================= GRUNDEINSTELLUNGEN =======================

$ZielVerzeichnis = "C:\PaperPortErsatz"
$WatcherZielPfad = Join-Path $ZielVerzeichnis "Watcher.ps1"
$TaskName        = "PaperPort Ersatz Watcher"
$AblageOrdner    = Join-Path $ZielVerzeichnis "Ablage"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ======================= ADMIN-RECHTE SICHERSTELLEN =======================
# Fuer Drucker-Einrichtung und geplante Aufgabe zwingend noetig. Falls das
# Skript ohne Admin-Rechte gestartet wurde, startet es sich selbst per UAC-
# Abfrage neu - der Benutzer muss nur noch "Ja" klicken.

$istAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $istAdmin) {
    try {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -ZielBenutzer `"$env:USERDOMAIN\$env:USERNAME`"" `
            -Verb RunAs | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Fuer die Einrichtung werden Administrator-Rechte benoetigt. Die Sicherheitsabfrage wurde aber abgebrochen oder abgelehnt.`n`nBitte 'Setup.cmd' erneut per Doppelklick starten und im erscheinenden Windows-Dialog 'Ja' auswaehlen.",
            "Administrator-Rechte erforderlich",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
    }
    exit
}

# Benutzer, fuer den der Watcher eingerichtet wird. Falls Setup direkt "als
# Administrator" gestartet wurde (ohne Weitergabe), wird der an der Konsole
# angemeldete Benutzer verwendet - nicht das Admin-Konto, das gerade das
# Skript ausfuehrt.
if ([string]::IsNullOrWhiteSpace($ZielBenutzer)) {
    try { $ZielBenutzer = (Get-CimInstance Win32_ComputerSystem -ErrorAction Stop).UserName } catch {}
}
if ([string]::IsNullOrWhiteSpace($ZielBenutzer)) { $ZielBenutzer = "$env:USERDOMAIN\$env:USERNAME" }

# ======================= KONFIGURATIONS-VORLAGE =======================
# Setup.ps1 enthaelt NICHT mehr den ganzen Watcher, sondern nur noch den
# Abschnitt KONFIGURATION mit Platzhaltern (__WIE_DAS__). Der Programmcode
# kommt immer aus der mitgelieferten Watcher.ps1 im selben Ordner - so gibt
# es nur noch EINE Stelle, an der der Watcher geaendert werden muss. Beim
# Einrichten wird der KONFIGURATION-Abschnitt der Watcher.ps1 durch diese
# ausgefuellte Vorlage ersetzt.

$WatcherQuellPfad = Join-Path $PSScriptRoot "Watcher.ps1"
if (-not (Test-Path $WatcherQuellPfad)) {
    [System.Windows.Forms.MessageBox]::Show("Watcher.ps1 wurde nicht im selben Ordner wie Setup gefunden:`n$PSScriptRoot`n`nBitte das Paket komplett entpacken (alle Dateien in einen Ordner) und Setup.cmd von dort starten.", "Watcher.ps1 fehlt", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    exit 1
}

$KonfigVorlage = @'
# ======================= KONFIGURATION =======================

# Name des Standorts (nur fuer die Fenstertitel/Logs, informativ)
$StandortName = "__STANDORT__"

# Lokaler Ordner, in den PDF24 automatisch speichert (siehe PDF24-Einstellungen)
$WatchFolder = "C:\PaperPortErsatz\Ablage"

# Lokaler Ordner fuer temporaere Scan-Dateien (wird automatisch geleert)
$ScanTempOrdner = "C:\PaperPortErsatz\ScanTemp"

# Liste der Drucker, an die ein Scan geschickt werden darf (exakte Namen wie
# unter "Einstellungen -> Drucker und Scanner"). Wird nur benutzt, wenn
# $ScanDirektAlsPdf (siehe unten) ausgeschaltet ist - oder als Ausweich,
# falls das direkte Speichern als PDF einmal fehlschlaegt. Bei genau EINEM
# Eintrag wird direkt dorthin gedruckt; bei MEHREREN erscheint eine kurze
# Auswahl.
#
# WICHTIG: Hier NUR Drucker eintragen, die automatisch/still in den Ablage-
# Ordner speichern (PDF24, "Dino1 Drucker" - siehe SCHRITT 4B). NICHT einen
# echten "PaperPort"-Druckertreiber eintragen, falls auf dem PC noch einer
# vorhanden ist - der oeffnet beim Drucken sofort die alte PaperPort-Software
# statt die Datei still abzulegen, und wuerde diesen Ablauf blockieren.
$ScanDruckerListe = @(__SCANDRUCKERLISTE__)

# Vorgabe Farbmodus im Fenster "Scan-Optionen": "Farbe", "Graustufen" oder
# "Schwarzweiss". Manche Scanner-Treiber waehlen ohne ausdrueckliche
# Vorgabe von sich aus Graustufen (schneller, kleinere Datei) - hier wird
# das ausdruecklich festgelegt.
$ScanFarbmodus = "__SCANFARBMODUS__"

# Hinterlegte Scanner fuer den "Jetzt scannen"-Button. Sie erscheinen im
# Fenster "Scan-Optionen" in einem Auswahlfeld; der zuletzt benutzte Scanner
# ist beim naechsten Mal automatisch vorausgewaehlt.
# Links: Anzeigename im Auswahlfeld (frei waehlbar, z.B. "Buero Theke").
# Rechts: Geraetename, wie Windows ihn meldet - oder ein eindeutiger Teil
# davon (Gross-/Kleinschreibung egal), z.B. "M2070" fuer "Samsung M2070
# Series". Die genauen Namen stehen im Log (Abschnitt "Gefundene WIA-
# Scanner") bzw. lassen sich im Setup ueber "Gefundene Scanner einlesen"
# automatisch eintragen.
# Leer lassen = einfach alle gefundenen Scanner anbieten.
$ScannerListe = [ordered]@{
__SCANNERBLOCK__
}

# $true = zusaetzlich zu den hinterlegten auch alle anderen gefundenen
# Scanner zur Auswahl anbieten (unter ihrem Windows-Namen).
# $false = NUR die hinterlegten Scanner anbieten.
$AuchNichtHinterlegteScanner = __AUCHNICHTHINTERLEGTE__

# ---------------------- Scan-Einstellungen ----------------------
# Die folgenden Werte sind die VORGABEN im Fenster "Scan-Optionen". Was ein
# Mitarbeiter dort fuer einen Scanner zuletzt gewaehlt hat, merkt sich das
# Programm pro Scanner (Datei ScannerEinstellungen.json) und schlaegt es beim
# naechsten Mal wieder vor.

# Gescannte Seiten direkt als PDF in den Ablage-Ordner speichern ($true,
# empfohlen: schneller, kleinere Dateien, kein Drucker noetig) oder wie
# frueher ueber einen Drucker aus $ScanDruckerListe ausgeben ($false).
# Klappt das direkte Speichern einmal nicht, wird automatisch auf einen
# Drucker aus $ScanDruckerListe ausgewichen.
$ScanDirektAlsPdf = __SCANDIREKTALSPDF__

# Vorgabe Aufloesung in dpi: 150 (schnell/klein), 200 (Standard), 300 (fein)
$ScanStandardDpi = __SCANSTANDARDDPI__

# Bildqualitaet in der PDF (JPEG-Qualitaet 30-95). Hoeher = schaerfer, aber
# groessere Datei. 75 ist ein guter Mittelweg fuer Dokumente.
$PdfBildQualitaet = __PDFBILDQUALITAET__

# Vorgabe "Beidseitig scannen (Duplex)" beim automatischen Einzug - nur
# wirksam, wenn der Scanner das kann.
$DuplexStandard = __DUPLEXSTANDARD__

# Vorgabe "Leere Seiten entfernen" (z.B. leere Rueckseiten beim Duplex-Scan)
$LeereSeitenEntfernen = __LEERESEITENENTFERNEN__

# Ab wann eine Seite als leer gilt: Anteil dunkler Bildpunkte in Prozent.
# Zum Vergleich: eine normale Textseite hat ca. 1-8 %, ein einzelner
# Unterschriftsstrich ca. 0.05 %. Werden Seiten mit wenig Inhalt faelschlich
# entfernt, Wert verkleinern (z.B. 0.01); bleiben leere Seiten mit Schmutz/
# durchscheinender Rueckseite drin, Wert vergroessern (z.B. 0.04). Der
# gemessene Wert jeder Seite steht im Log.
$LeereSeiteSchwelle = __LEERESEITESCHWELLE__

# Sicherheitsgrenze: hoechstens so viele Blatt pro Einzug-Scan (bei Duplex
# doppelt so viele Seiten). Schuetzt vor Endlos-Scans, falls ein Treiber
# "Einzug leer" nicht meldet.
$MaxSeitenProScan = __MAXSEITENPROSCAN__

# ---------------------- Erfassung / Ablage ----------------------

# Ordner fuer Dokumente, die im Erfassungsfenster mit "Ueberspringen"
# zurueckgestellt wurden. Ueber das Tray-Menue "Uebersprungene Dokumente
# erfassen" lassen sie sich spaeter erneut zuordnen.
$UebersprungenOrdner = "C:\PaperPortErsatz\Uebersprungen"

# Wie viele zuletzt eingegebene Bezeichnungen/Kundennamen beim Tippen
# vorgeschlagen werden (0 = Funktion aus)
$BezeichnungenMerken = __BEZEICHNUNGENMERKEN__

# ---------------------- Log / Fehlersuche ----------------------

# Maximale Groesse der Log-Datei in MB. Wird sie groesser, wird sie in
# "Log_alt.txt" umbenannt (die vorherige alte Datei wird dabei ersetzt).
$LogMaxMB = __LOGMAXMB__

# $true = bei jedem Scan alle technischen Scanner-Eigenschaften ins Log
# schreiben (nur zur Fehlersuche einschalten - macht das Log sehr gross)
$AusfuehrlichesScanLog = __AUSFUEHRLICHESSCANLOG__

# HiDrive-BASISordner, der die einzelnen Mitarbeiter-Ordner enthaelt
# (NICHT der Ordner eines einzelnen Mitarbeiters selbst!). Laufwerksbuchstabe
# ggf. anpassen, je nachdem wie HiDrive auf diesem PC eingebunden ist.
# Beispiel: wenn der Ordner von Max "X:\Mitarbeiter\1234567 (Max Mustermann)" ist,
# dann ist $ZielBasis = "X:\Mitarbeiter" und der Ordnername unten in
# $MitarbeiterOrdner ist "1234567 (Max Mustermann)".
$ZielBasis = "__ZIELBASIS__"

# Gemeinsamer HiDrive-Ordner fuer Shop-Dokumente (ein Ordner fuer den ganzen
# Standort, nicht nach Mitarbeiter unterteilt)
$ShopOrdner = "__SHOPORDNER__"

# Gemeinsamer HiDrive-Ordner fuer Kassen-Dokumente (ein Ordner fuer den ganzen
# Standort, nicht nach Mitarbeiter unterteilt)
$KassenOrdner = "__KASSENORDNER__"

# Lokaler Ordner auf DIESEM PC fuer Dokumente, die NICHT auf HiDrive sollen
# (Auswahl "Nur lokal (PC)" im Erfassungsfenster). Leer lassen = Ordner
# "Scans" in den Dokumenten des angemeldeten Benutzers.
$LokalerOrdner = "__LOKALERORDNER__"

# Update-Quelle: Internet-Adresse (nur https://) einer Watcher.ps1, z.B. von
# GitHub: "https://raw.githubusercontent.com/<Konto>/<Projekt>/main/Watcher.ps1"
# - oder alternativ ein Ordner (z.B. "X:\PaperPortErsatz-Update"). Ist dort
# geaenderter Programmcode, uebernimmt dieser PC ihn automatisch (die
# Einstellungen in diesem Abschnitt bleiben erhalten) und startet neu.
# Leer lassen = keine automatischen Updates.
$UpdateQuelle = "__UPDATEQUELLE__"

# Lokaler Ausweich-Ordner, falls HiDrive gerade nicht erreichbar ist
# (Datei geht dann NICHT verloren, sondern liegt hier zur manuellen Pruefung)
$AusweichOrdner = "C:\PaperPortErsatz\Nicht_uebertragen"

# Logdatei fuer Fehlersuche
$LogDatei = "C:\PaperPortErsatz\Log.txt"

# Zuordnung Mitarbeiter -> sein bereits vorhandener Ordner auf HiDrive.
# Der Text links ist das, was im Dropdown angezeigt wird; der Text rechts
# ist der EXAKTE Ordnername, wie er schon auf HiDrive existiert (Gross-/
# Kleinschreibung und Schreibweise muessen genau passen!).
$MitarbeiterOrdner = [ordered]@{
__MITARBEITERBLOCK__
}

# Wie oft (in Sekunden) der Ordner auf neue Dateien geprueft wird
$PruefIntervall = __PRUEFINTERVALL__

# ======================= ENDE KONFIGURATION =======================
'@

# Setzt die ausgefuellte Konfiguration in den Programmcode der Watcher.ps1 ein.
function Erzeuge-WatcherInhalt($quellPfad, $konfigText) {
    $code = Get-Content -Path $quellPfad -Raw -ErrorAction Stop
    $start = $code.IndexOf('# ======================= KONFIGURATION =======================')
    $endeMarke = '# ======================= ENDE KONFIGURATION ======================='
    $ende = $code.IndexOf($endeMarke)
    if ($start -lt 0 -or $ende -lt $start) {
        throw "In $quellPfad wurde der Abschnitt KONFIGURATION nicht gefunden - ist das die richtige Watcher.ps1?"
    }
    $ende += $endeMarke.Length
    return $code.Substring(0, $start) + $konfigText + $code.Substring($ende)
}

# ======================= VORHANDENE KONFIGURATION EINLESEN =======================
# Falls hier schon einmal eingerichtet wurde (C:\PaperPortErsatz\Watcher.ps1)
# oder eine bereits angepasste Watcher.ps1 neben Setup.ps1 liegt, werden die
# Werte daraus ausgelesen und das Eingabefenster damit vorausgefuellt -
# Standort-Einstellungen gehen bei einem Update also NICHT mehr verloren.

function Lese-VorhandeneKonfiguration($pfad) {
    $ergebnis = [PSCustomObject]@{
        Standort     = ""
        ZielBasis    = ""
        ShopOrdner   = ""
        KassenOrdner = ""
        LokalerOrdner = ""
        UpdateQuelle = ""
        Mitarbeiter  = @()
        ScanDrucker  = @()
        Scanner      = @()
        AuchNichtHinterlegteScanner = $true
        Werte        = @{}
    }

    if ([string]::IsNullOrWhiteSpace($pfad) -or -not (Test-Path $pfad)) { return $ergebnis }

    try {
        $text = Get-Content -Path $pfad -Raw -ErrorAction Stop
    } catch {
        return $ergebnis
    }

    if ($text -match '\$StandortName\s*=\s*"([^"]*)"') { $ergebnis.Standort = $matches[1] }
    if ($text -match '\$ZielBasis\s*=\s*"([^"]*)"') { $ergebnis.ZielBasis = $matches[1] }
    if ($text -match '\$ShopOrdner\s*=\s*"([^"]*)"') { $ergebnis.ShopOrdner = $matches[1] }
    if ($text -match '\$KassenOrdner\s*=\s*"([^"]*)"') { $ergebnis.KassenOrdner = $matches[1] }
    if ($text -match '\$LokalerOrdner\s*=\s*"([^"]*)"') { $ergebnis.LokalerOrdner = $matches[1] }
    if ($text -match '\$UpdateQuelle\s*=\s*"([^"]*)"') { $ergebnis.UpdateQuelle = $matches[1] }

    if ($text -match '\$ScanDruckerListe\s*=\s*@\(([^)]*)\)') {
        $treffer = [regex]::Matches($matches[1], '"([^"]*)"')
        $ergebnis.ScanDrucker = @($treffer | ForEach-Object { $_.Groups[1].Value })
    }

    if ($text -match '(?s)\$MitarbeiterOrdner\s*=\s*\[ordered\]@\{(.*?)\}') {
        $block = $matches[1]
        $paare = [regex]::Matches($block, '"([^"]*)"\s*=\s*"([^"]*)"')
        $liste = New-Object System.Collections.Generic.List[object]
        foreach ($p in $paare) {
            [void]$liste.Add([PSCustomObject]@{ Name = $p.Groups[1].Value; Ordner = $p.Groups[2].Value })
        }
        $ergebnis.Mitarbeiter = $liste.ToArray()
    }

    if ($text -match '(?s)\$ScannerListe\s*=\s*\[ordered\]@\{(.*?)\}') {
        $block = $matches[1]
        $paare = [regex]::Matches($block, '"([^"]*)"\s*=\s*"([^"]*)"')
        $liste = New-Object System.Collections.Generic.List[object]
        foreach ($p in $paare) {
            [void]$liste.Add([PSCustomObject]@{ Name = $p.Groups[1].Value; Geraet = $p.Groups[2].Value })
        }
        $ergebnis.Scanner = $liste.ToArray()
    }
    if ($text -match '\$AuchNichtHinterlegteScanner\s*=\s*\$(true|false)') {
        $ergebnis.AuchNichtHinterlegteScanner = ($matches[1] -eq "true")
    }

    # Einfache Einzelwerte (Zahl, $true/$false oder Text in "") - werden im
    # Reiter "Scan & Erweitert" vorausgefuellt
    foreach ($name in @("ScanFarbmodus", "ScanDirektAlsPdf", "ScanStandardDpi", "PdfBildQualitaet",
                        "DuplexStandard", "LeereSeitenEntfernen", "LeereSeiteSchwelle", "MaxSeitenProScan",
                        "BezeichnungenMerken", "LogMaxMB", "AusfuehrlichesScanLog", "PruefIntervall")) {
        if ($text -match ('(?m)^\$' + $name + '\s*=\s*"?([^"\r\n]*?)"?\s*$')) {
            $ergebnis.Werte[$name] = $matches[1].Trim()
        }
    }

    return $ergebnis
}

$vorhandeneKonfig = Lese-VorhandeneKonfiguration $WatcherZielPfad
if ([string]::IsNullOrWhiteSpace($vorhandeneKonfig.Standort)) {
    # Noch keine bestehende Installation gefunden - versuchsweise eine evtl.
    # neben Setup.ps1 liegende, schon angepasste Watcher.ps1 verwenden.
    $vorhandeneKonfig = Lese-VorhandeneKonfiguration (Join-Path $PSScriptRoot "Watcher.ps1")
}

# Platzhalterwerte aus der urspruenglichen Vorlage nicht als "vorhanden" werten
if ($vorhandeneKonfig.Standort -eq "STANDORT_HIER_EINTRAGEN") { $vorhandeneKonfig.Standort = "" }
$vorhandeneKonfig.Mitarbeiter = @($vorhandeneKonfig.Mitarbeiter | Where-Object {
    $_.Name -notmatch '^Mitarbeiter \d+$' -or $_.Ordner -notmatch '^Ordnername_Mitarbeiter_\d+$'
})

# ======================= EINGABEFENSTER =======================
# Drei Reiter: "Standort & Mitarbeiter", "Drucker & Scanner",
# "Scan & Erweitert". Alle Felder sind mit den bisherigen Werten dieses PCs
# vorausgefuellt (bzw. mit den Standardwerten bei einer Neueinrichtung).

# Liefert einen bisherigen Einzelwert aus der vorhandenen Watcher.ps1 oder
# den Standardwert, falls es ihn (noch) nicht gibt
function Hole-Wert($name, $standard) {
    if ($vorhandeneKonfig.Werte.ContainsKey($name) -and -not [string]::IsNullOrWhiteSpace($vorhandeneKonfig.Werte[$name])) {
        return $vorhandeneKonfig.Werte[$name]
    }
    return $standard
}
function Hole-WertBool($name, $standard) {
    $v = Hole-Wert $name ""
    if ($v -eq '$true') { return $true }
    if ($v -eq '$false') { return $false }
    return $standard
}
function Hole-WertZahl($name, $standard, $min, $max) {
    $v = Hole-Wert $name ""
    $d = 0.0
    if (-not [double]::TryParse([string]$v, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$d)) { $d = $standard }
    if ($d -lt $min) { $d = $min }
    if ($d -gt $max) { $d = $max }
    return [decimal]$d
}
function Neue-Zahlenfeld($x, $y, $min, $max, $wert, $nachkomma, $schritt) {
    $n = New-Object System.Windows.Forms.NumericUpDown
    $n.Location = New-Object System.Drawing.Point($x, $y)
    $n.Width = 90
    $n.DecimalPlaces = $nachkomma
    $n.Increment = [decimal]$schritt
    $n.Minimum = [decimal]$min
    $n.Maximum = [decimal]$max
    $n.Value = [decimal]$wert
    return $n
}
function Neues-Label($text, $x, $y, $breite, $hoehe, $grau) {
    $l = New-Object System.Windows.Forms.Label
    $l.Text = $text
    $l.Location = New-Object System.Drawing.Point($x, $y)
    if ($breite) { $l.AutoSize = $false; $l.Size = New-Object System.Drawing.Size($breite, $hoehe) } else { $l.AutoSize = $true }
    if ($grau) { $l.ForeColor = [System.Drawing.Color]::DimGray }
    return $l
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "DiNo1 Druck & Scan einrichten"
# ClientSize statt Size: legt die tatsaechlich nutzbare Flaeche fest (ohne
# Titelleiste/Rahmen), damit die Buttons unten unabhaengig von Windows-
# Design/Skalierung nicht abgeschnitten werden.
$form.ClientSize = New-Object System.Drawing.Size(640, 600)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.Topmost = $true

$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(10, 10)
$tabs.Size = New-Object System.Drawing.Size(620, 535)
$form.Controls.Add($tabs)

$tabStandort = New-Object System.Windows.Forms.TabPage
$tabStandort.Text = "Standort & Mitarbeiter"
$tabStandort.AutoScroll = $true
$tabGeraete = New-Object System.Windows.Forms.TabPage
$tabGeraete.Text = "Drucker & Scanner"
$tabGeraete.AutoScroll = $true
$tabScan = New-Object System.Windows.Forms.TabPage
$tabScan.Text = "Scan & Erweitert"
$tabScan.AutoScroll = $true
$tabs.TabPages.Add($tabStandort)
$tabs.TabPages.Add($tabGeraete)
$tabs.TabPages.Add($tabScan)

# ---------------------- Reiter 1: Standort & Mitarbeiter ----------------------
$y = 12

$tabStandort.Controls.Add((Neues-Label "PDF24 Creator sollte bereits installiert sein (siehe ANLEITUNG.txt). Alles Weitere richtet dieses Fenster ein - bitte alle drei Reiter pruefen." 10 $y 580 30 $false))
$y += 38

$tabStandort.Controls.Add((Neues-Label "Standortname:" 10 $y $null $null $false))
$txtStandort = New-Object System.Windows.Forms.TextBox
$txtStandort.Location = New-Object System.Drawing.Point(200, ($y - 3))
$txtStandort.Width = 390
$txtStandort.Text = $vorhandeneKonfig.Standort
$tabStandort.Controls.Add($txtStandort)
$y += 32

$tabStandort.Controls.Add((Neues-Label "HiDrive-Basisordner Mitarbeiter:" 10 $y $null $null $false))
$txtZielBasis = New-Object System.Windows.Forms.TextBox
$txtZielBasis.Location = New-Object System.Drawing.Point(200, ($y - 3))
$txtZielBasis.Width = 390
$txtZielBasis.Text = $vorhandeneKonfig.ZielBasis
$tabStandort.Controls.Add($txtZielBasis)
$y += 22
$tabStandort.Controls.Add((Neues-Label "(Ordner, der ALLE Mitarbeiterordner enthaelt, z.B. X:\Mitarbeiter - nicht der Ordner eines einzelnen Mitarbeiters)" 200 $y 390 30 $true))
$y += 36

$tabStandort.Controls.Add((Neues-Label "HiDrive-Ordner Shop:" 10 $y $null $null $false))
$txtShop = New-Object System.Windows.Forms.TextBox
$txtShop.Location = New-Object System.Drawing.Point(200, ($y - 3))
$txtShop.Width = 390
$txtShop.Text = $vorhandeneKonfig.ShopOrdner
$tabStandort.Controls.Add($txtShop)
$y += 32

$tabStandort.Controls.Add((Neues-Label "HiDrive-Ordner Kasse:" 10 $y $null $null $false))
$txtKasse = New-Object System.Windows.Forms.TextBox
$txtKasse.Location = New-Object System.Drawing.Point(200, ($y - 3))
$txtKasse.Width = 390
$txtKasse.Text = $vorhandeneKonfig.KassenOrdner
$tabStandort.Controls.Add($txtKasse)
$y += 32

$tabStandort.Controls.Add((Neues-Label "Lokaler Ordner (optional):" 10 $y $null $null $false))
$txtLokal = New-Object System.Windows.Forms.TextBox
$txtLokal.Location = New-Object System.Drawing.Point(200, ($y - 3))
$txtLokal.Width = 390
$txtLokal.Text = $vorhandeneKonfig.LokalerOrdner
$tabStandort.Controls.Add($txtLokal)
$tipLokal = New-Object System.Windows.Forms.ToolTip
$tipLokal.SetToolTip($txtLokal, "Fuer 'Nur lokal (PC)' im Erfassungsfenster. Leer = Dokumente\Scans des Benutzers.")
$y += 32

$tabStandort.Controls.Add((Neues-Label "Update-Quelle (optional):" 10 $y $null $null $false))
$txtUpdate = New-Object System.Windows.Forms.TextBox
$txtUpdate.Location = New-Object System.Drawing.Point(200, ($y - 3))
$txtUpdate.Width = 390
# Ohne bisherigen Eintrag automatisch die offizielle Update-Quelle (GitHub)
# vorschlagen - kann im Feld geaendert oder geleert werden.
$StandardUpdateQuelle = "https://raw.githubusercontent.com/trendtino/dino1-druck-scan/main/Watcher.ps1"
$txtUpdate.Text = if ([string]::IsNullOrWhiteSpace($vorhandeneKonfig.UpdateQuelle)) { $StandardUpdateQuelle } else { $vorhandeneKonfig.UpdateQuelle }
$tabStandort.Controls.Add($txtUpdate)
$tipUpdate = New-Object System.Windows.Forms.ToolTip
$tipUpdate.SetToolTip($txtUpdate, "https://-Adresse der Watcher.ps1 (z.B. raw.githubusercontent.com/...) oder ein Ordner. Bei geaendertem Programmcode aktualisiert sich dieser PC automatisch. Leer = keine automatischen Updates.")
$y += 36

$tabStandort.Controls.Add((Neues-Label "Mitarbeiter (Anzeigename -> bereits vorhandener HiDrive-Ordnername, Zeile ueber Doppelklick/Enter hinzufuegen, markieren + Entf zum Loeschen):" 10 $y 580 30 $false))
$y += 32

$dgv = New-Object System.Windows.Forms.DataGridView
$dgv.Location = New-Object System.Drawing.Point(10, $y)
$dgv.Size = New-Object System.Drawing.Size(580, 176)
$dgv.AllowUserToAddRows = $true
$dgv.AllowUserToDeleteRows = $true
$dgv.RowHeadersVisible = $false
$dgv.ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize

$colName = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colName.Name = "Anzeigename"
$colName.HeaderText = "Anzeigename (im Dropdown)"
$colName.Width = 260

$colOrdner = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colOrdner.Name = "Ordnername"
$colOrdner.HeaderText = "HiDrive-Ordnername (exakt)"
$colOrdner.Width = 290

[void]$dgv.Columns.Add($colName)
[void]$dgv.Columns.Add($colOrdner)

foreach ($m in $vorhandeneKonfig.Mitarbeiter) {
    [void]$dgv.Rows.Add($m.Name, $m.Ordner)
}
if ($dgv.Rows.Count -eq 0) {
    [void]$dgv.Rows.Add("", "")
}
$tabStandort.Controls.Add($dgv)

# ---------------------- Reiter 2: Drucker & Scanner ----------------------
$y = 12

$grpDrucker = New-Object System.Windows.Forms.GroupBox
$grpDrucker.Text = "Drucker (Ausweich fuer Scans, bzw. wenn 'Scans direkt als PDF' aus ist)"
$grpDrucker.Location = New-Object System.Drawing.Point(10, $y)
$grpDrucker.Size = New-Object System.Drawing.Size(580, 75)
$tabGeraete.Controls.Add($grpDrucker)

$chkPDF24 = New-Object System.Windows.Forms.CheckBox
$chkPDF24.Text = "PDF24"
$chkPDF24.AutoSize = $true
$chkPDF24.Location = New-Object System.Drawing.Point(15, 25)
$vorherPDF24 = ($vorhandeneKonfig.ScanDrucker.Count -eq 0) -or ($vorhandeneKonfig.ScanDrucker -contains "PDF24")
$chkPDF24.Checked = $vorherPDF24
$grpDrucker.Controls.Add($chkPDF24)

$chkDino1 = New-Object System.Windows.Forms.CheckBox
$chkDino1.Text = "Dino1 Drucker (Ausweich, wird unten automatisch eingerichtet)"
$chkDino1.AutoSize = $true
$chkDino1.Location = New-Object System.Drawing.Point(120, 25)
$vorherDino1 = ($vorhandeneKonfig.ScanDrucker.Count -eq 0) -or ($vorhandeneKonfig.ScanDrucker -contains "Dino1 Drucker")
$chkDino1.Checked = $vorherDino1
$grpDrucker.Controls.Add($chkDino1)

$grpDrucker.Controls.Add((Neues-Label "Weitere (kommagetrennt, optional):" 15 50 $null $null $false))
$txtWeitere = New-Object System.Windows.Forms.TextBox
$txtWeitere.Location = New-Object System.Drawing.Point(220, 47)
$txtWeitere.Width = 340
$weitereDrucker = @($vorhandeneKonfig.ScanDrucker | Where-Object { $_ -ne "PDF24" -and $_ -ne "Dino1 Drucker" })
$txtWeitere.Text = ($weitereDrucker -join ", ")
$grpDrucker.Controls.Add($txtWeitere)
$y += 85

$chkDino1Einrichten = New-Object System.Windows.Forms.CheckBox
$chkDino1Einrichten.Text = "'Dino1 Drucker' jetzt automatisch als Ausweich einrichten/aktualisieren (Microsoft Print to PDF wird dafuer umbenannt und umgeleitet)"
$chkDino1Einrichten.AutoSize = $false
$chkDino1Einrichten.Size = New-Object System.Drawing.Size(580, 35)
$chkDino1Einrichten.Location = New-Object System.Drawing.Point(10, $y)
$chkDino1Einrichten.Checked = $true
$tabGeraete.Controls.Add($chkDino1Einrichten)
$y += 48

$tabGeraete.Controls.Add((Neues-Label "Scanner fuer 'Jetzt scannen' (Anzeigename -> Geraetename laut Windows oder ein eindeutiger Teil davon). Leer lassen = alle gefundenen Scanner anbieten:" 10 $y 580 30 $false))
$y += 32

$dgvScanner = New-Object System.Windows.Forms.DataGridView
$dgvScanner.Location = New-Object System.Drawing.Point(10, $y)
$dgvScanner.Size = New-Object System.Drawing.Size(580, 190)
$dgvScanner.AllowUserToAddRows = $true
$dgvScanner.AllowUserToDeleteRows = $true
$dgvScanner.RowHeadersVisible = $false
$dgvScanner.ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize

$colScannerName = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colScannerName.Name = "Anzeigename"
$colScannerName.HeaderText = "Anzeigename (z.B. Buero Theke)"
$colScannerName.Width = 230

$colScannerGeraet = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colScannerGeraet.Name = "Geraetename"
$colScannerGeraet.HeaderText = "Geraetename laut Windows"
$colScannerGeraet.Width = 320

[void]$dgvScanner.Columns.Add($colScannerName)
[void]$dgvScanner.Columns.Add($colScannerGeraet)

foreach ($sc in $vorhandeneKonfig.Scanner) {
    [void]$dgvScanner.Rows.Add($sc.Name, $sc.Geraet)
}
$tabGeraete.Controls.Add($dgvScanner)
$y += 198

$btnScannerSuchen = New-Object System.Windows.Forms.Button
$btnScannerSuchen.Text = "Gefundene Scanner einlesen"
$btnScannerSuchen.Size = New-Object System.Drawing.Size(190, 28)
$btnScannerSuchen.Location = New-Object System.Drawing.Point(10, $y)
$tabGeraete.Controls.Add($btnScannerSuchen)

$chkAuchAndere = New-Object System.Windows.Forms.CheckBox
$chkAuchAndere.Text = "Auch nicht hinterlegte, gefundene Scanner zur Auswahl anbieten"
$chkAuchAndere.AutoSize = $true
$chkAuchAndere.Location = New-Object System.Drawing.Point(215, ($y + 5))
$chkAuchAndere.Checked = $vorhandeneKonfig.AuchNichtHinterlegteScanner
$tabGeraete.Controls.Add($chkAuchAndere)

# Liest alle Scanner ein, die Windows auf diesem PC kennt (WIA), und traegt
# die noch nicht vorhandenen in die Tabelle ein. Der Anzeigename kann danach
# frei geaendert werden (z.B. "Buero Theke").
$btnScannerSuchen.Add_Click({
    $gefunden = New-Object System.Collections.Generic.List[string]
    try {
        $manager = New-Object -ComObject WIA.DeviceManager
        foreach ($di in $manager.DeviceInfos) {
            if ($di.Type -ne 1) { continue }
            $name = ""
            try { $name = [string]$di.Properties.Item("Name").Value } catch {}
            if (-not [string]::IsNullOrWhiteSpace($name)) { [void]$gefunden.Add($name) }
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show($form, "Die Scanner-Liste von Windows konnte nicht abgefragt werden:`n`n$($_.Exception.Message)", "Scanner einlesen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        return
    }

    if ($gefunden.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show($form, "Auf diesem PC wurde kein Scanner gefunden.`n`nBitte pruefen, ob der Scanner eingeschaltet ist und in Windows als Scanner eingerichtet ist (unter 'Drucker und Scanner' bzw. mit dem Treiber des Herstellers).", "Scanner einlesen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return
    }

    $vorhanden = @{}
    foreach ($row in $dgvScanner.Rows) {
        if ($row.IsNewRow) { continue }
        $g = "$($row.Cells[1].Value)".Trim()
        if ($g) { $vorhanden[$g.ToLower()] = $true }
    }
    $neu = 0
    foreach ($name in $gefunden) {
        if ($vorhanden.ContainsKey($name.ToLower())) { continue }
        [void]$dgvScanner.Rows.Add($name, $name)
        $vorhanden[$name.ToLower()] = $true
        $neu++
    }
    $info = "Gefundene Scanner: $($gefunden.Count)`nNeu in die Tabelle eingetragen: $neu"
    if ($neu -gt 0) { $info += "`n`nDen Anzeigenamen (linke Spalte) kann man beliebig aendern, z.B. 'Buero Theke'. Nicht benoetigte Zeilen markieren und mit Entf loeschen." }
    [System.Windows.Forms.MessageBox]::Show($form, $info, "Scanner einlesen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
})

# ---------------------- Reiter 3: Scan & Erweitert ----------------------
$y = 12

$grpScan = New-Object System.Windows.Forms.GroupBox
$grpScan.Text = "Scannen - Vorgaben im Fenster 'Scan-Optionen' (je Scanner merkt sich das Programm die zuletzt gewaehlten Werte)"
$grpScan.Location = New-Object System.Drawing.Point(10, $y)
$grpScan.Size = New-Object System.Drawing.Size(580, 230)
$tabScan.Controls.Add($grpScan)

$chkDirektPdf = New-Object System.Windows.Forms.CheckBox
$chkDirektPdf.Text = "Scans direkt als PDF speichern (empfohlen - ohne Umweg ueber einen Drucker)"
$chkDirektPdf.AutoSize = $true
$chkDirektPdf.Location = New-Object System.Drawing.Point(15, 25)
$chkDirektPdf.Checked = (Hole-WertBool "ScanDirektAlsPdf" $true)
$grpScan.Controls.Add($chkDirektPdf)

$grpScan.Controls.Add((Neues-Label "Farbe:" 15 58 $null $null $false))
$cmbSetupFarbe = New-Object System.Windows.Forms.ComboBox
$cmbSetupFarbe.Location = New-Object System.Drawing.Point(230, 55)
$cmbSetupFarbe.Width = 200
$cmbSetupFarbe.DropDownStyle = "DropDownList"
$setupFarbWerte = @("Farbe", "Graustufen", "Schwarzweiss")
foreach ($f in $setupFarbWerte) { [void]$cmbSetupFarbe.Items.Add($f) }
$fi = [array]::IndexOf($setupFarbWerte, [string](Hole-Wert "ScanFarbmodus" "Farbe"))
$cmbSetupFarbe.SelectedIndex = if ($fi -ge 0) { $fi } else { 0 }
$grpScan.Controls.Add($cmbSetupFarbe)

$grpScan.Controls.Add((Neues-Label "Qualitaet:" 15 88 $null $null $false))
$cmbSetupDpi = New-Object System.Windows.Forms.ComboBox
$cmbSetupDpi.Location = New-Object System.Drawing.Point(230, 85)
$cmbSetupDpi.Width = 200
$cmbSetupDpi.DropDownStyle = "DropDownList"
$setupDpiWerte = @(150, 200, 300)
[void]$cmbSetupDpi.Items.Add("Schnell (150 dpi)")
[void]$cmbSetupDpi.Items.Add("Standard (200 dpi)")
[void]$cmbSetupDpi.Items.Add("Fein (300 dpi)")
$dpiIdx = [array]::IndexOf($setupDpiWerte, [int](Hole-WertZahl "ScanStandardDpi" 200 150 300))
$cmbSetupDpi.SelectedIndex = if ($dpiIdx -ge 0) { $dpiIdx } else { 1 }
$grpScan.Controls.Add($cmbSetupDpi)

$grpScan.Controls.Add((Neues-Label "Bildqualitaet in der PDF (30-95):" 15 118 $null $null $false))
$numPdfQualitaet = Neue-Zahlenfeld 230 115 30 95 (Hole-WertZahl "PdfBildQualitaet" 75 30 95) 0 5
$grpScan.Controls.Add($numPdfQualitaet)
$grpScan.Controls.Add((Neues-Label "hoeher = schaerfer, groessere Datei" 330 118 $null $null $true))

$chkSetupDuplex = New-Object System.Windows.Forms.CheckBox
$chkSetupDuplex.Text = "Beidseitig scannen (Duplex) vorauswaehlen, wenn der Scanner das kann"
$chkSetupDuplex.AutoSize = $true
$chkSetupDuplex.Location = New-Object System.Drawing.Point(15, 148)
$chkSetupDuplex.Checked = (Hole-WertBool "DuplexStandard" $false)
$grpScan.Controls.Add($chkSetupDuplex)

$chkSetupLeer = New-Object System.Windows.Forms.CheckBox
$chkSetupLeer.Text = "Leere Seiten entfernen vorauswaehlen"
$chkSetupLeer.AutoSize = $true
$chkSetupLeer.Location = New-Object System.Drawing.Point(15, 173)
$chkSetupLeer.Checked = (Hole-WertBool "LeereSeitenEntfernen" $true)
$grpScan.Controls.Add($chkSetupLeer)

$grpScan.Controls.Add((Neues-Label "Leerseiten-Schwelle (% dunkle Punkte):" 15 201 $null $null $false))
$numLeerSchwelle = Neue-Zahlenfeld 230 198 0 2 (Hole-WertZahl "LeereSeiteSchwelle" 0.02 0 2) 2 0.01
$grpScan.Controls.Add($numLeerSchwelle)
$grpScan.Controls.Add((Neues-Label "kleiner = vorsichtiger (Standard 0,02)" 330 201 $null $null $true))
$y += 240

$grpErweitert = New-Object System.Windows.Forms.GroupBox
$grpErweitert.Text = "Erweitert (normalerweise nicht aendern)"
$grpErweitert.Location = New-Object System.Drawing.Point(10, $y)
$grpErweitert.Size = New-Object System.Drawing.Size(580, 200)
$tabScan.Controls.Add($grpErweitert)

$grpErweitert.Controls.Add((Neues-Label "Hoechstens Blatt pro Einzug-Scan:" 15 28 $null $null $false))
$numMaxSeiten = Neue-Zahlenfeld 300 25 1 500 (Hole-WertZahl "MaxSeitenProScan" 40 1 500) 0 5
$grpErweitert.Controls.Add($numMaxSeiten)
$grpErweitert.Controls.Add((Neues-Label "Schutz vor Endlos-Scans" 400 28 $null $null $true))

$grpErweitert.Controls.Add((Neues-Label "Gemerkte Bezeichnungen (0 = aus):" 15 58 $null $null $false))
$numBezeichnungen = Neue-Zahlenfeld 300 55 0 5000 (Hole-WertZahl "BezeichnungenMerken" 300 0 5000) 0 50
$grpErweitert.Controls.Add($numBezeichnungen)
$grpErweitert.Controls.Add((Neues-Label "Vorschlaege beim Tippen" 400 58 $null $null $true))

$grpErweitert.Controls.Add((Neues-Label "Ablage-Ordner pruefen alle (Sekunden):" 15 88 $null $null $false))
$numPruefIntervall = Neue-Zahlenfeld 300 85 1 60 (Hole-WertZahl "PruefIntervall" 3 1 60) 0 1
$grpErweitert.Controls.Add($numPruefIntervall)

$grpErweitert.Controls.Add((Neues-Label "Log-Datei hoechstens (MB):" 15 118 $null $null $false))
$numLogMB = Neue-Zahlenfeld 300 115 1 100 (Hole-WertZahl "LogMaxMB" 5 1 100) 0 1
$grpErweitert.Controls.Add($numLogMB)

$chkAusfuehrlichLog = New-Object System.Windows.Forms.CheckBox
$chkAusfuehrlichLog.Text = "Ausfuehrliches Scan-Log (alle technischen Scanner-Werte - nur zur Fehlersuche)"
$chkAusfuehrlichLog.AutoSize = $true
$chkAusfuehrlichLog.Location = New-Object System.Drawing.Point(15, 150)
$chkAusfuehrlichLog.Checked = (Hole-WertBool "AusfuehrlichesScanLog" $false)
$grpErweitert.Controls.Add($chkAusfuehrlichLog)

# ---------------------- Buttons ----------------------
$btnEinrichten = New-Object System.Windows.Forms.Button
$btnEinrichten.Text = "Einrichten"
$btnEinrichten.Size = New-Object System.Drawing.Size(140, 34)
$btnEinrichten.Location = New-Object System.Drawing.Point(360, 555)
$form.Controls.Add($btnEinrichten)

$btnAbbrechen = New-Object System.Windows.Forms.Button
$btnAbbrechen.Text = "Abbrechen"
$btnAbbrechen.Size = New-Object System.Drawing.Size(120, 34)
$btnAbbrechen.Location = New-Object System.Drawing.Point(510, 555)
$btnAbbrechen.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.Controls.Add($btnAbbrechen)

$form.AcceptButton = $btnEinrichten
$form.CancelButton = $btnAbbrechen

$lblCopyright = New-Object System.Windows.Forms.Label
$lblCopyright.Text = "Copyright DiNo1 GmbH und Andre Meschke"
$lblCopyright.AutoSize = $true
$lblCopyright.ForeColor = [System.Drawing.Color]::DimGray
$lblCopyright.Font = New-Object System.Drawing.Font($lblCopyright.Font.FontFamily, 7.5)
$lblCopyright.Location = New-Object System.Drawing.Point(12, 565)
$form.Controls.Add($lblCopyright)

# ======================= HILFSFUNKTIONEN FUER DIE EINRICHTUNG =======================

# Beendet NUR die Prozesse des Ablage-Watchers (erkannt an "Watcher.ps1" in der
# Befehlszeile) - NIEMALS den eigenen Einrichtungs-Assistenten, der ebenfalls als
# powershell.exe laeuft. Ein blindes "Get-Process powershell | Stop-Process" wuerde
# sich sonst selbst mitten in der Ausfuehrung beenden, noch bevor die neue
# Watcher.ps1 geschrieben und die geplante Aufgabe neu registriert wird - das war
# ueber laengere Zeit die (nie entdeckte) Ursache dafuer, dass der Assistent nach
# Klick auf "Einrichten" scheinbar nichts tat, obwohl die Admin-Bestaetigung kam.
function Stop-LaufendenWatcher($watcherPfad) {
    try {
        Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe' OR Name = 'conhost.exe'" -ErrorAction SilentlyContinue |
            Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -match [regex]::Escape("Watcher.ps1") } |
            ForEach-Object {
                try { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue } catch {}
            }
    } catch {}
}

function Richte-Dino1Drucker-Ein($ablageOrdner) {
    try {
        $zielDatei = Join-Path $ablageOrdner "Dino1Drucker_Ausgabe.pdf"

        $vorhandenerName = $null
        if (Get-Printer -Name "Dino1 Drucker" -ErrorAction SilentlyContinue) {
            $vorhandenerName = "Dino1 Drucker"
        } elseif (Get-Printer -Name "Microsoft Print to PDF" -ErrorAction SilentlyContinue) {
            $vorhandenerName = "Microsoft Print to PDF"
        }

        if ($null -eq $vorhandenerName) {
            return "Weder 'Dino1 Drucker' noch 'Microsoft Print to PDF' wurde auf diesem PC gefunden - der Ausweich-Drucker wurde NICHT eingerichtet. Bitte pruefen, ob die Windows-Funktion 'Microsoft Print to PDF' aktiviert ist (Einstellungen -> Apps -> Optionale Features)."
        }

        if (-not (Get-PrinterPort -Name $zielDatei -ErrorAction SilentlyContinue)) {
            Add-PrinterPort -Name $zielDatei
        }
        Set-Printer -Name $vorhandenerName -PortName $zielDatei
        if ($vorhandenerName -ne "Dino1 Drucker") {
            Rename-Printer -Name $vorhandenerName -NewName "Dino1 Drucker"
        }
        return $null
    } catch {
        return "Fehler beim Einrichten von 'Dino1 Drucker': $_"
    }
}

function Registriere-GeplanteAufgabe($taskName, $watcherPfad) {
    try {
        Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue | Stop-ScheduledTask -ErrorAction SilentlyContinue
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
        Stop-LaufendenWatcher $watcherPfad

        $action = New-ScheduledTaskAction -Execute "conhost.exe" `
            -Argument "--headless powershell.exe -ExecutionPolicy Bypass -File `"$watcherPfad`""
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $principal = New-ScheduledTaskPrincipal -UserId $ZielBenutzer -LogonType Interactive
        $settings = New-ScheduledTaskSettingsSet `
            -AllowStartIfOnBatteries `
            -DontStopIfGoingOnBatteries `
            -StartWhenAvailable `
            -MultipleInstances IgnoreNew `
            -ExecutionTimeLimit ([TimeSpan]::Zero) `
            -RestartCount 3 `
            -RestartInterval (New-TimeSpan -Minutes 1)

        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger `
            -Principal $principal -Settings $settings `
            -Description "DiNo1 Druck & Scan: ueberwacht Ablageordner und ordnet Dokumente automatisch dem richtigen Standort/Mitarbeiter zu" `
            -ErrorAction Stop | Out-Null

        Start-ScheduledTask -TaskName $taskName
        return $null
    } catch {
        return "Geplante Aufgabe konnte nicht eingerichtet werden: $($_.Exception.Message)"
    }
}

$btnEinrichten.Add_Click({
    $standort  = $txtStandort.Text.Trim()
    $zielBasis = $txtZielBasis.Text.Trim()
    $shop      = $txtShop.Text.Trim()
    $kasse     = $txtKasse.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($standort) -or [string]::IsNullOrWhiteSpace($zielBasis) -or
        [string]::IsNullOrWhiteSpace($shop) -or [string]::IsNullOrWhiteSpace($kasse)) {
        $tabs.SelectedTab = $tabStandort
        [System.Windows.Forms.MessageBox]::Show($form, "Bitte Standortname, HiDrive-Basisordner Mitarbeiter, Shop-Ordner und Kassen-Ordner ausfuellen.", "Angaben fehlen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        return
    }

    $mitarbeiterZeilen = New-Object System.Collections.Generic.List[string]
    foreach ($row in $dgv.Rows) {
        if ($row.IsNewRow) { continue }
        $name = "$($row.Cells[0].Value)".Trim()
        $ordner = "$($row.Cells[1].Value)".Trim()
        if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($ordner)) { continue }
        $nameSicher = $name.Replace('"', '""')
        $ordnerSicher = $ordner.Replace('"', '""')
        [void]$mitarbeiterZeilen.Add("    `"$nameSicher`" = `"$ordnerSicher`"")
    }

    if ($mitarbeiterZeilen.Count -eq 0) {
        $tabs.SelectedTab = $tabStandort
        [System.Windows.Forms.MessageBox]::Show($form, "Bitte mindestens einen Mitarbeiter mit Anzeigename und HiDrive-Ordnername eintragen.", "Angaben fehlen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        return
    }

    $druckerListe = New-Object System.Collections.Generic.List[string]
    if ($chkPDF24.Checked) { [void]$druckerListe.Add('"PDF24"') }
    if ($chkDino1.Checked) { [void]$druckerListe.Add('"Dino1 Drucker"') }
    foreach ($d in ($txtWeitere.Text -split ",")) {
        $dTrim = $d.Trim()
        if (-not [string]::IsNullOrWhiteSpace($dTrim)) {
            [void]$druckerListe.Add('"' + $dTrim.Replace('"', '""') + '"')
        }
    }
    if ($druckerListe.Count -eq 0) { [void]$druckerListe.Add('"PDF24"') }

    # Hinterlegte Scanner. Anfuehrungszeichen, $ und ` werden entfernt, da sie
    # in der erzeugten Watcher.ps1 sonst als PowerShell-Code wirken wuerden.
    $scannerZeilen = New-Object System.Collections.Generic.List[string]
    $scannerNamen = @{}
    foreach ($row in $dgvScanner.Rows) {
        if ($row.IsNewRow) { continue }
        $sName = ("$($row.Cells[0].Value)" -replace '["`$]', '').Trim()
        $sGeraet = ("$($row.Cells[1].Value)" -replace '["`$]', '').Trim()
        if ([string]::IsNullOrWhiteSpace($sName) -and [string]::IsNullOrWhiteSpace($sGeraet)) { continue }
        if ([string]::IsNullOrWhiteSpace($sGeraet)) {
            $tabs.SelectedTab = $tabGeraete
            [System.Windows.Forms.MessageBox]::Show($form, "Beim Scanner '$sName' fehlt der Geraetename.`n`nTipp: 'Gefundene Scanner einlesen' traegt die Namen automatisch ein.", "Angaben fehlen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            return
        }
        if ([string]::IsNullOrWhiteSpace($sName)) { $sName = $sGeraet }
        if ($scannerNamen.ContainsKey($sName.ToLower())) {
            $tabs.SelectedTab = $tabGeraete
            [System.Windows.Forms.MessageBox]::Show($form, "Der Scanner-Anzeigename '$sName' kommt doppelt vor. Bitte jedem Scanner einen eigenen Namen geben.", "Angaben pruefen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            return
        }
        $scannerNamen[$sName.ToLower()] = $true
        [void]$scannerZeilen.Add("    `"$sName`" = `"$sGeraet`"")
    }
    if ($scannerZeilen.Count -eq 0 -and -not $chkAuchAndere.Checked) {
        [System.Windows.Forms.MessageBox]::Show($form, "Es ist kein Scanner hinterlegt und 'Auch nicht hinterlegte Scanner anbieten' ist abgeschaltet - dann koennte 'Jetzt scannen' keinen Scanner anbieten.`n`nBitte einen Scanner eintragen oder den Haken wieder setzen.", "Angaben pruefen", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        return
    }

    $form.Enabled = $false
    $btnEinrichten.Text = "Bitte warten..."

    try {
        if (-not (Test-Path $ZielVerzeichnis)) { New-Item -ItemType Directory -Path $ZielVerzeichnis -Force | Out-Null }
        if (-not (Test-Path $AblageOrdner)) { New-Item -ItemType Directory -Path $AblageOrdner -Force | Out-Null }

        # Der Watcher laeuft unter $ZielBenutzer und muss in C:\PaperPortErsatz
        # schreiben koennen (Log, Ablage, ScanTemp) - auch wenn der Ordner hier
        # von einem anderen Admin-Konto angelegt wurde.
        try { & icacls.exe $ZielVerzeichnis /grant "$($ZielBenutzer):(OI)(CI)M" /T /C /Q | Out-Null } catch {}

        # Laufenden Watcher vorher stoppen, damit die Datei problemlos ueberschrieben
        # werden kann und keine zwei Instanzen gleichzeitig laufen. WICHTIG: Nur den
        # Watcher-Prozess beenden, NICHT diesen Assistenten selbst (siehe Stop-LaufendenWatcher).
        Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue | Stop-ScheduledTask -ErrorAction SilentlyContinue
        Stop-LaufendenWatcher $WatcherZielPfad

        $inhalt = $KonfigVorlage
        $inhalt = $inhalt.Replace('__STANDORT__', $standort)
        $inhalt = $inhalt.Replace('__ZIELBASIS__', $zielBasis)
        $inhalt = $inhalt.Replace('__SHOPORDNER__', $shop)
        $inhalt = $inhalt.Replace('__KASSENORDNER__', $kasse)
        $inhalt = $inhalt.Replace('__LOKALERORDNER__', $txtLokal.Text.Trim().Replace('"', ''))
        $inhalt = $inhalt.Replace('__UPDATEQUELLE__', $txtUpdate.Text.Trim().Replace('"', ''))
        $inhalt = $inhalt.Replace('__SCANDRUCKERLISTE__', ($druckerListe -join ", "))
        $inhalt = $inhalt.Replace('__MITARBEITERBLOCK__', ($mitarbeiterZeilen -join "`r`n"))
        $inhalt = $inhalt.Replace('__SCANNERBLOCK__', ($scannerZeilen -join "`r`n"))
        $inv = [System.Globalization.CultureInfo]::InvariantCulture
        $inhalt = $inhalt.Replace('__SCANFARBMODUS__', $setupFarbWerte[$cmbSetupFarbe.SelectedIndex])
        $inhalt = $inhalt.Replace('__SCANDIREKTALSPDF__', $(if ($chkDirektPdf.Checked) { '$true' } else { '$false' }))
        $inhalt = $inhalt.Replace('__SCANSTANDARDDPI__', [string]$setupDpiWerte[$cmbSetupDpi.SelectedIndex])
        $inhalt = $inhalt.Replace('__PDFBILDQUALITAET__', ([int]$numPdfQualitaet.Value).ToString($inv))
        $inhalt = $inhalt.Replace('__DUPLEXSTANDARD__', $(if ($chkSetupDuplex.Checked) { '$true' } else { '$false' }))
        $inhalt = $inhalt.Replace('__LEERESEITENENTFERNEN__', $(if ($chkSetupLeer.Checked) { '$true' } else { '$false' }))
        $inhalt = $inhalt.Replace('__LEERESEITESCHWELLE__', ([decimal]$numLeerSchwelle.Value).ToString("0.00", $inv))
        $inhalt = $inhalt.Replace('__MAXSEITENPROSCAN__', ([int]$numMaxSeiten.Value).ToString($inv))
        $inhalt = $inhalt.Replace('__BEZEICHNUNGENMERKEN__', ([int]$numBezeichnungen.Value).ToString($inv))
        $inhalt = $inhalt.Replace('__PRUEFINTERVALL__', ([int]$numPruefIntervall.Value).ToString($inv))
        $inhalt = $inhalt.Replace('__LOGMAXMB__', ([int]$numLogMB.Value).ToString($inv))
        $inhalt = $inhalt.Replace('__AUSFUEHRLICHESSCANLOG__', $(if ($chkAusfuehrlichLog.Checked) { '$true' } else { '$false' }))
        $inhalt = $inhalt.Replace('__AUCHNICHTHINTERLEGTE__', $(if ($chkAuchAndere.Checked) { '$true' } else { '$false' }))
        $inhalt = Erzeuge-WatcherInhalt $WatcherQuellPfad $inhalt

        Set-Content -Path $WatcherZielPfad -Value $inhalt -Encoding UTF8 -Force

        $warnungen = New-Object System.Collections.Generic.List[string]

        if ($chkDino1Einrichten.Checked) {
            $fehler = Richte-Dino1Drucker-Ein $AblageOrdner
            if ($fehler) { [void]$warnungen.Add($fehler) }
        }

        $taskFehler = Registriere-GeplanteAufgabe $TaskName $WatcherZielPfad
        if ($taskFehler) { [void]$warnungen.Add($taskFehler) }

        $meldung = "Einrichtung abgeschlossen fuer Standort '$standort'.`n`n"
        $meldung += "Watcher installiert: $WatcherZielPfad`n"
        $meldung += "Geplante Aufgabe '$TaskName' eingerichtet und gestartet (fuer Benutzer: $ZielBenutzer).`n`n"

        if ($warnungen.Count -gt 0) {
            $meldung += "ACHTUNG - bitte pruefen:`n"
            foreach ($w in $warnungen) { $meldung += "- $w`n" }
            $meldung += "`n"
        }

        $meldung += "Letzter Schritt fuer das DRUCKEN ueber PDF24 (nur einmal noetig, kann nicht automatisch gesetzt werden):`n"
        $meldung += "In PDF24 -> Einstellungen -> PDF Drucker -> Automatisches Speichern als Ordner eintragen:`n"
        $meldung += "$AblageOrdner"

        $symbol = if ($warnungen.Count -gt 0) { [System.Windows.Forms.MessageBoxIcon]::Warning } else { [System.Windows.Forms.MessageBoxIcon]::Information }
        [System.Windows.Forms.MessageBox]::Show($form, $meldung, "DiNo1 Druck & Scan", [System.Windows.Forms.MessageBoxButtons]::OK, $symbol) | Out-Null

        $form.Tag = "fertig"
        $form.Close()
    } catch {
        [System.Windows.Forms.MessageBox]::Show($form, "Unerwarteter Fehler bei der Einrichtung:`n`n$_", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        $form.Enabled = $true
        $btnEinrichten.Text = "Einrichten"
    }
})

# Fenster beim Start nach vorne holen (sonst landet es u.U. hinter dem
# Administrator-Konsolenfenster)
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
