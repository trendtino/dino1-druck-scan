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

# Texterkennung (OCR, in Windows 10/11 eingebaut, arbeitet ohne Internet):
# Gescannte PDFs werden durchsuchbar (Text suchen/markieren/kopieren), und das
# Erfassungsfenster schlaegt einen schon einmal verwendeten Kundennamen vor,
# wenn er im Dokument vorkommt. $false = aus.
$OcrAktiv = $true

# Kleine Vorschau der ersten Seite im Erfassungsfenster anzeigen ($false = aus)
$VorschauAktiv = $true

# Ordner, in den dieser PC alle paar Minuten eine kleine Statusdatei schreibt
# (Version, letzte Ablage, Fehler, wartende Dateien). Uebersicht.cmd zeigt
# daraus alle PCs auf einen Blick. Leer lassen = Ordner
# "DiNo1-Druck-Scan" im Shop-Ordner (z.B. "Y:\o2 shops\o2 Partnershop
# Vechta\DiNo1-Druck-Scan"). "-" = keine Statusdatei schreiben.
$StatusOrdner = ""

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

# ======================= DESIGN (wie im Programm: Logo, Orange, flache Knoepfe) =======================
$script:FarbeAkzent      = [System.Drawing.Color]::FromArgb(246, 130, 31)
$script:FarbeAkzentDunkel = [System.Drawing.Color]::FromArgb(222, 110, 15)
$script:FarbeAkzentHell  = [System.Drawing.Color]::FromArgb(254, 241, 228)
$script:FarbeText        = [System.Drawing.Color]::FromArgb(33, 29, 30)
$script:FarbeGrau        = [System.Drawing.Color]::FromArgb(110, 110, 116)
$script:FarbeFlaeche     = [System.Drawing.Color]::FromArgb(245, 245, 247)
$script:FarbeRahmen      = [System.Drawing.Color]::FromArgb(220, 220, 225)
$script:FarbeGruen       = [System.Drawing.Color]::FromArgb(16, 124, 16)
$script:FarbeRot         = [System.Drawing.Color]::FromArgb(196, 43, 28)

$script:LogoBase64 = "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"
$script:IconBase64 = "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"
$script:LogoBild = $null
function Hole-Logo {
    if ($null -eq $script:LogoBild) {
        try {
            $ms = New-Object System.IO.MemoryStream(,[Convert]::FromBase64String($script:LogoBase64))
            $script:LogoBild = [System.Drawing.Image]::FromStream($ms)
        } catch {}
    }
    return $script:LogoBild
}

# Programmsymbol (Dino-Kopf auf Orange). Groesse 0 = Standard (Fenster).
$script:DinoIcons = @{}
function Hole-DinoIcon([int]$groesse = 0) {
    if (-not $script:DinoIcons.ContainsKey($groesse)) {
        $icon = $null
        try {
            $ms = New-Object System.IO.MemoryStream(,[Convert]::FromBase64String($script:IconBase64))
            if ($groesse -gt 0) { $icon = New-Object System.Drawing.Icon($ms, $groesse, $groesse) }
            else { $icon = New-Object System.Drawing.Icon($ms) }
        } catch {}
        $script:DinoIcons[$groesse] = $icon
    }
    return $script:DinoIcons[$groesse]
}

# Wendet das Design auf ein Fenster an (wird beim Laden jedes Fensters aufgerufen).
# Aendert nur Farben/Knopfstil - keine Groessen, damit nichts abgeschnitten wird.
function Setze-Design($ctl) {
    try {
        if ($ctl -is [System.Windows.Forms.Form]) {
            if ($ctl.BackColor.ToArgb() -eq [System.Drawing.SystemColors]::Control.ToArgb()) { $ctl.BackColor = $script:FarbeFlaeche }
            $ic = Hole-DinoIcon
            if ($ic) { $ctl.Icon = $ic }
        }
        $standardKnopf = $null
        try { $standardKnopf = $ctl.FindForm().AcceptButton } catch {}
        foreach ($c in @($ctl.Controls)) {
            if ($c -is [System.Windows.Forms.Button]) {
                $c.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
                $c.Cursor = [System.Windows.Forms.Cursors]::Hand
                $c.UseVisualStyleBackColor = $false
                if ($standardKnopf -and [object]::ReferenceEquals($c, $standardKnopf)) {
                    $c.BackColor = $script:FarbeAkzent
                    $c.ForeColor = [System.Drawing.Color]::White
                    $c.FlatAppearance.BorderColor = $script:FarbeAkzent
                    $c.FlatAppearance.MouseOverBackColor = $script:FarbeAkzentDunkel
                    $c.FlatAppearance.MouseDownBackColor = $script:FarbeAkzentDunkel
                } else {
                    $c.BackColor = [System.Drawing.Color]::White
                    $c.ForeColor = $script:FarbeText
                    $c.FlatAppearance.BorderColor = $script:FarbeRahmen
                    $c.FlatAppearance.MouseOverBackColor = $script:FarbeAkzentHell
                    $c.FlatAppearance.MouseDownBackColor = $script:FarbeAkzentHell
                }
            } elseif ($c -is [System.Windows.Forms.DataGridView]) {
                $c.BackgroundColor = [System.Drawing.Color]::White
                $c.BorderStyle = [System.Windows.Forms.BorderStyle]::None
                $c.GridColor = $script:FarbeRahmen
                $c.EnableHeadersVisualStyles = $false
                $c.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::SingleHorizontal
                $c.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
                $c.ColumnHeadersDefaultCellStyle.BackColor = $script:FarbeFlaeche
                $c.ColumnHeadersDefaultCellStyle.ForeColor = $script:FarbeGrau
                $c.ColumnHeadersDefaultCellStyle.SelectionBackColor = $script:FarbeFlaeche
                $c.DefaultCellStyle.SelectionBackColor = $script:FarbeAkzentHell
                $c.DefaultCellStyle.SelectionForeColor = $script:FarbeText
                $c.RowTemplate.Height = 26
            } elseif ($c -is [System.Windows.Forms.GroupBox]) {
                $c.ForeColor = $script:FarbeGrau
            }
            if ($c.HasChildren -and -not ($c -is [System.Windows.Forms.DataGridView])) { Setze-Design $c }
        }
    } catch {}
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "DiNo1 Druck & Scan einrichten"
# ClientSize statt Size: legt die tatsaechlich nutzbare Flaeche fest (ohne
# Titelleiste/Rahmen), damit die Buttons unten unabhaengig von Windows-
# Design/Skalierung nicht abgeschnitten werden.
$form.ClientSize = New-Object System.Drawing.Size(640, 690)
$form.BackColor = $script:FarbeFlaeche
$form.Add_Load({ Setze-Design $this })

# Kopfbereich mit Logo
$kopf = New-Object System.Windows.Forms.Panel
$kopf.Location = New-Object System.Drawing.Point(0, 0)
$kopf.Size = New-Object System.Drawing.Size(640, 84)
$kopf.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($kopf)
$kopfLogo = Hole-Logo
$kopfLinks = 20
if ($kopfLogo) {
    $pb = New-Object System.Windows.Forms.PictureBox
    $pb.Image = $kopfLogo
    $pb.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pb.Location = New-Object System.Drawing.Point(12, 6)
    $pb.Size = New-Object System.Drawing.Size(146, 72)
    $kopf.Controls.Add($pb)
    $kopfLinks = 172
}
$kopfTitel = New-Object System.Windows.Forms.Label
$kopfTitel.Text = "Druck & Scan einrichten"
$kopfTitel.UseMnemonic = $false
$kopfTitel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 16)
$kopfTitel.ForeColor = $script:FarbeText
$kopfTitel.Location = New-Object System.Drawing.Point($kopfLinks, 16)
$kopfTitel.AutoSize = $true
$kopf.Controls.Add($kopfTitel)
$kopfUnter = New-Object System.Windows.Forms.Label
$kopfUnter.Text = "Ordner, Mitarbeiter, Drucker und Scanner fuer diesen PC festlegen"
$kopfUnter.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$kopfUnter.ForeColor = $script:FarbeGrau
$kopfUnter.Location = New-Object System.Drawing.Point(($kopfLinks + 2), 52)
$kopfUnter.AutoSize = $true
$kopf.Controls.Add($kopfUnter)
$kopfStreifen = New-Object System.Windows.Forms.Panel
$kopfStreifen.Location = New-Object System.Drawing.Point(0, 84)
$kopfStreifen.Size = New-Object System.Drawing.Size(640, 4)
$kopfStreifen.BackColor = $script:FarbeAkzent
$form.Controls.Add($kopfStreifen)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.Topmost = $true

$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(10, 98)
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
# Alte Adresse (GitHub-Projekt hiess frueher "paperport-ersatz") automatisch ersetzen
if ($vorhandeneKonfig.UpdateQuelle -match '^https://raw\.githubusercontent\.com/trendtino/paperport-ersatz/') {
    $vorhandeneKonfig.UpdateQuelle = $StandardUpdateQuelle
}
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
$btnEinrichten.Location = New-Object System.Drawing.Point(360, 643)
$form.Controls.Add($btnEinrichten)

$btnAbbrechen = New-Object System.Windows.Forms.Button
$btnAbbrechen.Text = "Abbrechen"
$btnAbbrechen.Size = New-Object System.Drawing.Size(120, 34)
$btnAbbrechen.Location = New-Object System.Drawing.Point(510, 643)
$btnAbbrechen.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.Controls.Add($btnAbbrechen)

$form.AcceptButton = $btnEinrichten
$form.CancelButton = $btnAbbrechen

$lblCopyright = New-Object System.Windows.Forms.Label
$lblCopyright.Text = "Copyright DiNo1 GmbH und Andre Meschke"
$lblCopyright.AutoSize = $true
$lblCopyright.ForeColor = [System.Drawing.Color]::DimGray
$lblCopyright.Font = New-Object System.Drawing.Font($lblCopyright.Font.FontFamily, 7.5)
$lblCopyright.Location = New-Object System.Drawing.Point(12, 653)
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
