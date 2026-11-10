<#
    DiNo1 Druck & Scan: Ablage-Watcher (Produktivversion)
    ------------------------------------------------------
    Laeuft unsichtbar im Hintergrund (per geplanter Aufgabe gestartet), mit
    einem kleinen Symbol im Infobereich (Systray) unten rechts.

    Zwei Wege, ein Dokument zu erfassen:
      1. Drucken (ueber PDF24, "Dino1 Drucker" oder einen anderen auf den
         Ablage-Ordner umgeleiteten Drucker) - die PDF landet automatisch im
         Ablage-Ordner und wird von selbst erkannt.
      2. Rechtsklick auf das Tray-Symbol -> "Jetzt scannen" - startet einen
         echten Scan ueber einen angeschlossenen Scanner (WIA). Im Fenster
         "Scan-Optionen" werden Scanner (siehe $ScannerListe), Einzug/
         Flachbett, Duplex, Farbe und Qualitaet gewaehlt. Das Ergebnis wird
         direkt als PDF im Ablage-Ordner gespeichert (oder - je nach
         Einstellung $ScanDirektAlsPdf - ueber einen Drucker ausgegeben) und
         dann genauso erkannt wie ein normaler Ausdruck.

    In beiden Faellen erscheint danach ein Fenster, in dem man auswaehlt,
    wohin die Datei soll:
      - Mitarbeiter-Ordner  (mit Mitarbeiter-Auswahl, wie bisher)
      - Shop-Ordner         (ein gemeinsamer Ordner fuer den Standort)
      - Kasse               (ein gemeinsamer Ordner fuer Kassenbelege)

    Vor dem Einsatz auf einem neuen PC: Abschnitt "KONFIGURATION" unten
    anpassen (Standortname, HiDrive-Pfade, Zuordnung Mitarbeiter -> Ordner,
    Name des PDF24-Druckers).
#>

# ======================= KONFIGURATION =======================

# Name des Standorts (nur fuer die Fenstertitel/Logs, informativ)
$StandortName = "STANDORT_HIER_EINTRAGEN"

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
$ScanDruckerListe = @("PDF24", "Dino1 Drucker")

# Vorgabe Farbmodus im Fenster "Scan-Optionen": "Farbe", "Graustufen" oder
# "Schwarzweiss". Manche Scanner-Treiber waehlen ohne ausdrueckliche
# Vorgabe von sich aus Graustufen (schneller, kleinere Datei) - hier wird
# das ausdruecklich festgelegt.
$ScanFarbmodus = "Farbe"

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
}

# $true = zusaetzlich zu den hinterlegten auch alle anderen gefundenen
# Scanner zur Auswahl anbieten (unter ihrem Windows-Namen).
# $false = NUR die hinterlegten Scanner anbieten.
$AuchNichtHinterlegteScanner = $true

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
$ScanDirektAlsPdf = $true

# Vorgabe Aufloesung in dpi: 150 (schnell/klein), 200 (Standard), 300 (fein)
$ScanStandardDpi = 200

# Bildqualitaet in der PDF (JPEG-Qualitaet 30-95). Hoeher = schaerfer, aber
# groessere Datei. 75 ist ein guter Mittelweg fuer Dokumente.
$PdfBildQualitaet = 75

# Vorgabe "Beidseitig scannen (Duplex)" beim automatischen Einzug - nur
# wirksam, wenn der Scanner das kann.
$DuplexStandard = $false

# Vorgabe "Leere Seiten entfernen" (z.B. leere Rueckseiten beim Duplex-Scan)
$LeereSeitenEntfernen = $true

# Ab wann eine Seite als leer gilt: Anteil dunkler Bildpunkte in Prozent.
# Zum Vergleich: eine normale Textseite hat ca. 1-8 %, ein einzelner
# Unterschriftsstrich ca. 0.05 %. Werden Seiten mit wenig Inhalt faelschlich
# entfernt, Wert verkleinern (z.B. 0.01); bleiben leere Seiten mit Schmutz/
# durchscheinender Rueckseite drin, Wert vergroessern (z.B. 0.04). Der
# gemessene Wert jeder Seite steht im Log.
$LeereSeiteSchwelle = 0.02

# Sicherheitsgrenze: hoechstens so viele Blatt pro Einzug-Scan (bei Duplex
# doppelt so viele Seiten). Schuetzt vor Endlos-Scans, falls ein Treiber
# "Einzug leer" nicht meldet.
$MaxSeitenProScan = 40

# ---------------------- Erfassung / Ablage ----------------------

# Ordner fuer Dokumente, die im Erfassungsfenster mit "Ueberspringen"
# zurueckgestellt wurden. Ueber das Tray-Menue "Uebersprungene Dokumente
# erfassen" lassen sie sich spaeter erneut zuordnen.
$UebersprungenOrdner = "C:\PaperPortErsatz\Uebersprungen"

# Wie viele zuletzt eingegebene Bezeichnungen/Kundennamen beim Tippen
# vorgeschlagen werden (0 = Funktion aus)
$BezeichnungenMerken = 300

# ---------------------- Log / Fehlersuche ----------------------

# Maximale Groesse der Log-Datei in MB. Wird sie groesser, wird sie in
# "Log_alt.txt" umbenannt (die vorherige alte Datei wird dabei ersetzt).
$LogMaxMB = 5

# $true = bei jedem Scan alle technischen Scanner-Eigenschaften ins Log
# schreiben (nur zur Fehlersuche einschalten - macht das Log sehr gross)
$AusfuehrlichesScanLog = $false

# HiDrive-BASISordner, der die einzelnen Mitarbeiter-Ordner enthaelt
# (NICHT der Ordner eines einzelnen Mitarbeiters selbst!). Laufwerksbuchstabe
# ggf. anpassen, je nachdem wie HiDrive auf diesem PC eingebunden ist.
# Beispiel: wenn der Ordner von Max "X:\Mitarbeiter\1234567 (Max Mustermann)" ist,
# dann ist $ZielBasis = "X:\Mitarbeiter" und der Ordnername unten in
# $MitarbeiterOrdner ist "1234567 (Max Mustermann)".
$ZielBasis = "X:\Mitarbeiter"

# Gemeinsamer HiDrive-Ordner fuer Shop-Dokumente (ein Ordner fuer den ganzen
# Standort, nicht nach Mitarbeiter unterteilt)
$ShopOrdner = "X:\Shop"

# Gemeinsamer HiDrive-Ordner fuer Kassen-Dokumente (ein Ordner fuer den ganzen
# Standort, nicht nach Mitarbeiter unterteilt)
$KassenOrdner = "X:\Kasse"

# Lokaler Ordner auf DIESEM PC fuer Dokumente, die NICHT auf HiDrive sollen
# (Auswahl "Nur lokal (PC)" im Erfassungsfenster). Leer lassen = Ordner
# "Scans" in den Dokumenten des angemeldeten Benutzers.
$LokalerOrdner = ""

# Update-Quelle: Internet-Adresse (nur https://) einer Watcher.ps1, z.B. von
# GitHub: "https://raw.githubusercontent.com/<Konto>/<Projekt>/main/Watcher.ps1"
# - oder alternativ ein Ordner (z.B. "X:\PaperPortErsatz-Update"). Ist dort
# geaenderter Programmcode, uebernimmt dieser PC ihn automatisch (die
# Einstellungen in diesem Abschnitt bleiben erhalten) und startet neu.
# Leer lassen = keine automatischen Updates.
$UpdateQuelle = "https://raw.githubusercontent.com/trendtino/dino1-druck-scan/main/Watcher.ps1"

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
# "DiNo1-Druck-Scan-Status" im Shop-Ordner (z.B. "Y:\o2 shops\o2 Partnershop
# Vechta\DiNo1-Druck-Scan-Status"). "-" = keine Statusdatei schreiben.
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
    "Max Mustermann" = "1234567 (Max Mustermann)"
    "Mitarbeiter 2" = "Ordnername_Mitarbeiter_2"
    "Mitarbeiter 3" = "Ordnername_Mitarbeiter_3"
}

# Wie oft (in Sekunden) der Ordner auf neue Dateien geprueft wird
$PruefIntervall = 3

# ======================= ENDE KONFIGURATION =======================

# Eigenes Konsolenfenster verstecken (der Erfassungsdialog bleibt davon unberuehrt)
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0) | Out-Null

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$script:LogZaehler = 0

# Benennt die Log-Datei in "<Name>_alt.txt" um, sobald sie groesser als
# $LogMaxMB ist - so waechst sie nicht endlos.
function Pruefe-LogGroesse {
    try {
        if ((Test-Path $LogDatei) -and ((Get-Item $LogDatei).Length -gt ([double]$LogMaxMB * 1MB))) {
            $altDatei = Join-Path (Split-Path $LogDatei -Parent) (([System.IO.Path]::GetFileNameWithoutExtension($LogDatei)) + "_alt.txt")
            Move-Item -Path $LogDatei -Destination $altDatei -Force -ErrorAction Stop
        }
    } catch {}
}

function Schreibe-Log($text) {
    $script:LogZaehler++
    if (($script:LogZaehler % 200) -eq 0) { Pruefe-LogGroesse }
    $zeile = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $text"
    try { Add-Content -Path $LogDatei -Value $zeile -ErrorAction SilentlyContinue } catch {}
    # fuer die Statusdatei (siehe Schreibe-Status)
    if ("$text".StartsWith("Abgelegt (")) { $script:LetzteAblage = $zeile }
    if ("$text" -cmatch 'FEHLER') { $script:LetzterFehler = $zeile }
}

# ======================= VERSION =======================
# Bei JEDER Aenderung am Programm hochzaehlen und das Datum anpassen - wird im
# Tray-Menue "Ueber", bei "Nach Updates suchen" und im Log angezeigt.
# (Ein Update wird auch ohne Hochzaehlen erkannt; die Nummer dient nur der
# Uebersicht, welcher PC welchen Stand hat.)
$script:WatcherVersion      = "20"
$script:WatcherVersionDatum = "10.11.2026"

# ======================= STANDARDWERTE FUER NEUERE EINSTELLUNGEN =======================
# Bei einem automatischen Update bleibt der Abschnitt KONFIGURATION dieses
# PCs unveraendert - Einstellungen, die erst in einer neueren Version
# hinzugekommen sind, fehlen dort also. Sie bekommen hier einen Standardwert.
# WICHTIG fuer kuenftige Aenderungen: Jede NEUE Einstellung hier ebenfalls
# mit Standardwert eintragen, sonst fehlt sie auf automatisch aktualisierten
# PCs (bis dort Setup.cmd erneut ausgefuehrt wird).
if ($null -eq $LokalerOrdner) { $LokalerOrdner = "" }
if ($null -eq $UpdateQuelle)  { $UpdateQuelle = "" }
if ($null -eq $OcrAktiv)      { $OcrAktiv = $true }
if ($null -eq $VorschauAktiv) { $VorschauAktiv = $true }
if ($null -eq $StatusOrdner)  { $StatusOrdner = "" }
# Das GitHub-Projekt hiess frueher "paperport-ersatz" - alte Adresse auf die neue umstellen
if ($UpdateQuelle -eq "https://raw.githubusercontent.com/trendtino/paperport-ersatz/main/Watcher.ps1") { $UpdateQuelle = "https://raw.githubusercontent.com/trendtino/dino1-druck-scan/main/Watcher.ps1" }

if ([string]::IsNullOrWhiteSpace($LokalerOrdner)) {
    $LokalerOrdner = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Scans"
}
if ([string]::IsNullOrWhiteSpace($StatusOrdner)) {
    try { $StatusOrdner = Join-Path $ShopOrdner "DiNo1-Druck-Scan-Status" } catch { $StatusOrdner = "-" }
}

# Ordner anlegen, falls sie noch nicht existieren
foreach ($p in @($WatchFolder, $ScanTempOrdner, $AusweichOrdner, $UebersprungenOrdner, (Split-Path $LogDatei))) {
    if (-not (Test-Path $p)) {
        New-Item -ItemType Directory -Path $p -Force | Out-Null
    }
}

Pruefe-LogGroesse

# Nur EIN Watcher pro angemeldetem Benutzer: Laeuft schon einer (z.B. ein
# "Geist"-Prozess nach einem unsauberen Neustart), beendet sich dieser
# zweite sofort wieder - sonst gaebe es zwei Tray-Symbole und jedes Dokument
# wuerde doppelt abgefragt.
$script:EinzelStartMutex = New-Object System.Threading.Mutex($false, "Local\PaperPortErsatzWatcher")
$script:IstEinzigerWatcher = $false
try {
    $script:IstEinzigerWatcher = $script:EinzelStartMutex.WaitOne(0)
} catch {
    # Vorheriger Watcher wurde hart beendet ("abandoned") - die Sperre gehoert
    # jetzt uns. Auch bei jedem anderen unerwarteten Fehler lieber starten als
    # gar keinen Watcher zu haben.
    $script:IstEinzigerWatcher = $true
}
if (-not $script:IstEinzigerWatcher) {
    Schreibe-Log "Watcher laeuft bereits fuer diesen Benutzer - zweiter Start wird beendet."
    exit
}

# Alte Vorschau-Kopien und liegengebliebene Scan-Reste aufraeumen
try {
    Get-ChildItem -Path $ScanTempOrdner -File -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) } |
        Remove-Item -Force -ErrorAction SilentlyContinue
} catch {}

# Hilfsfunktionen in C# (deutlich schneller als reines PowerShell):
#   PpeBild.LadeAlsJpeg      - Scan-Bild in JPEG umwandeln (fuer die PDF)
#   PpeBild.DunkelAnteil     - Anteil dunkler Bildpunkte (Leerseiten-Erkennung)
#   PpePdf.Schreibe          - PDF aus JPEG-Seiten erzeugen (optional mit
#                              unsichtbarer Textebene aus der Texterkennung)
#   PpePdf.TextEbene         - erkannte Woerter als unsichtbaren PDF-Text setzen
#   PpeBild.SpeichereFuerOcr - Bild fuer die Texterkennung vorbereiten
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @"
using System;
using System.IO;
using System.Text;
using System.Globalization;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.IO.Compression;

public class PpeSeite {
    public byte[] Jpeg;
    public bool Schwarzweiss;
    public int Breite;
    public int Hoehe;
    public float DpiX;
    public float DpiY;
}

public static class PpeBild {
    public static PpeSeite LadeAlsJpeg(string pfad, long qualitaet) {
        using (Image quelle = Image.FromFile(pfad)) {
            int w = quelle.Width;
            int h = quelle.Height;
            using (Bitmap ziel = new Bitmap(w, h, PixelFormat.Format24bppRgb)) {
                ziel.SetResolution(quelle.HorizontalResolution, quelle.VerticalResolution);
                using (Graphics g = Graphics.FromImage(ziel)) {
                    g.Clear(Color.White);
                    g.DrawImage(quelle, 0, 0, w, h);
                }
                ImageCodecInfo jpegCodec = null;
                foreach (ImageCodecInfo c in ImageCodecInfo.GetImageEncoders()) {
                    if (c.MimeType == "image/jpeg") { jpegCodec = c; break; }
                }
                if (qualitaet < 30) { qualitaet = 30; }
                if (qualitaet > 95) { qualitaet = 95; }
                using (EncoderParameters ep = new EncoderParameters(1))
                using (MemoryStream ms = new MemoryStream()) {
                    ep.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, qualitaet);
                    ziel.Save(ms, jpegCodec, ep);
                    PpeSeite s = new PpeSeite();
                    s.Jpeg = ms.ToArray();
                    s.Breite = w;
                    s.Hoehe = h;
                    s.DpiX = quelle.HorizontalResolution;
                    s.DpiY = quelle.VerticalResolution;
                    return s;
                }
            }
        }
    }

    // Wandelt ein Scan-Bild in echtes Schwarzweiss (1 Bit pro Bildpunkt) um
    // und komprimiert es verlustfrei (zlib/Flate) - fuer Textdokumente meist
    // deutlich kleiner als JPEG und gestochen scharf. Bildpunkte mit einer
    // Helligkeit unter "schwelle" (0-255) werden schwarz. In PpeSeite.Jpeg
    // stehen dann die komprimierten 1-Bit-Daten (Schwarzweiss = true).
    public static PpeSeite LadeAlsSchwarzweiss(string pfad, int schwelle) {
        using (Bitmap quelle = new Bitmap(pfad)) {
            int w = quelle.Width;
            int h = quelle.Height;
            int zeilenBytes = (w + 7) / 8;
            byte[] roh = new byte[zeilenBytes * h];
            BitmapData d = quelle.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);
            try {
                int laenge = Math.Abs(d.Stride);
                byte[] zeile = new byte[laenge];
                for (int y = 0; y < h; y++) {
                    Marshal.Copy(new IntPtr(d.Scan0.ToInt64() + (long)y * d.Stride), zeile, 0, laenge);
                    int basis = y * zeilenBytes;
                    for (int x = 0; x < w; x++) {
                        int i = x * 3;
                        int hell = (zeile[i] * 114 + zeile[i + 1] * 587 + zeile[i + 2] * 299) / 1000;
                        // In PDF (DeviceGray, 1 Bit) bedeutet 1 = weiss, 0 = schwarz
                        if (hell >= schwelle) { roh[basis + (x >> 3)] |= (byte)(0x80 >> (x & 7)); }
                    }
                }
            } finally {
                quelle.UnlockBits(d);
            }
            PpeSeite s = new PpeSeite();
            s.Jpeg = Zlib(roh);
            s.Schwarzweiss = true;
            s.Breite = w;
            s.Hoehe = h;
            s.DpiX = quelle.HorizontalResolution;
            s.DpiY = quelle.VerticalResolution;
            return s;
        }
    }

    // zlib-Format (wie es PDF fuer /FlateDecode erwartet): 2 Byte Kopf,
    // Deflate-Daten, Adler-32-Pruefsumme.
    static byte[] Zlib(byte[] daten) {
        using (MemoryStream ms = new MemoryStream()) {
            ms.WriteByte(0x78); ms.WriteByte(0x9C);
            using (DeflateStream ds = new DeflateStream(ms, CompressionMode.Compress, true)) {
                ds.Write(daten, 0, daten.Length);
            }
            uint a = 1, b = 0;
            foreach (byte x in daten) { a = (a + x) % 65521; b = (b + a) % 65521; }
            uint adler = (b << 16) | a;
            ms.WriteByte((byte)(adler >> 24)); ms.WriteByte((byte)(adler >> 16));
            ms.WriteByte((byte)(adler >> 8)); ms.WriteByte((byte)adler);
            return ms.ToArray();
        }
    }

    // Speichert das Bild als PNG fuer die Windows-Texterkennung. Ist es
    // groesser als "maxSeite" Bildpunkte, wird es verkleinert. Rueckgabe:
    // Verkleinerungsfaktor (1 = unveraendert), damit die erkannten
    // Wort-Positionen wieder auf das Original umgerechnet werden koennen.
    public static double SpeichereFuerOcr(string pfad, string ziel, int maxSeite) {
        using (Image quelle = Image.FromFile(pfad)) {
            int w = quelle.Width;
            int h = quelle.Height;
            double f = 1.0;
            if (maxSeite > 0 && Math.Max(w, h) > maxSeite) { f = (double)maxSeite / Math.Max(w, h); }
            int nw = Math.Max(1, (int)Math.Floor(w * f));
            int nh = Math.Max(1, (int)Math.Floor(h * f));
            using (Bitmap b = new Bitmap(nw, nh, PixelFormat.Format24bppRgb)) {
                using (Graphics g = Graphics.FromImage(b)) {
                    g.Clear(Color.White);
                    g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                    g.DrawImage(quelle, 0, 0, nw, nh);
                }
                b.Save(ziel, ImageFormat.Png);
            }
            return (double)nw / w;
        }
    }

    // Anteil (Prozent) dunkler Bildpunkte, ohne 5 % Rand ringsum (dort
    // liegen oft Schatten/Kanten vom Scanner). Jeder 2. Bildpunkt reicht.
    public static double DunkelAnteil(string pfad) {
        using (Bitmap bmp = new Bitmap(pfad)) {
            int w = bmp.Width;
            int h = bmp.Height;
            int rx = w / 20;
            int ry = h / 20;
            BitmapData d = bmp.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);
            try {
                int laenge = Math.Abs(d.Stride);
                byte[] zeile = new byte[laenge];
                long dunkel = 0;
                long gesamt = 0;
                for (int y = ry; y < h - ry; y += 2) {
                    Marshal.Copy(new IntPtr(d.Scan0.ToInt64() + (long)y * d.Stride), zeile, 0, laenge);
                    for (int x = rx; x < w - rx; x += 2) {
                        int i = x * 3;
                        int hell = (zeile[i] * 114 + zeile[i + 1] * 587 + zeile[i + 2] * 299) / 1000;
                        if (hell < 140) { dunkel++; }
                        gesamt++;
                    }
                }
                if (gesamt == 0) { return 0; }
                return dunkel * 100.0 / gesamt;
            } finally {
                bmp.UnlockBits(d);
            }
        }
    }
}

public static class PpePdf {
    static void T(Stream s, string t) {
        byte[] b = Encoding.ASCII.GetBytes(t);
        s.Write(b, 0, b.Length);
    }

    static string Z(double v) {
        return v.ToString("0.###", CultureInfo.InvariantCulture);
    }

    // Schreibt eine PDF mit einer Seite pro JPEG-Bild. Die Seitengroesse
    // ergibt sich aus Pixelzahl und Aufloesung (dpi) - eine A4-Seite wird
    // also wieder genau A4 gross.
    public static void Schreibe(string ziel, byte[][] jpegs, int[] breite, int[] hoehe, double[] dpiX, double[] dpiY) {
        Schreibe(ziel, jpegs, breite, hoehe, dpiX, dpiY, new bool[jpegs.Length]);
    }

    // schwarzweiss[i] = true: Seite i enthaelt 1-Bit-Daten (Flate) statt JPEG
    public static void Schreibe(string ziel, byte[][] jpegs, int[] breite, int[] hoehe, double[] dpiX, double[] dpiY, bool[] schwarzweiss) {
        Schreibe(ziel, jpegs, breite, hoehe, dpiX, dpiY, schwarzweiss, null);
    }

    // Baut aus den erkannten Woertern einer Seite (Positionen in Bildpunkten
    // des Seitenbildes) unsichtbaren Text (Darstellungsart 3 = unsichtbar).
    // Der Text liegt genau ueber den Woertern im Bild - so kann man in der PDF
    // suchen und Text markieren, sieht aber weiterhin nur den Scan.
    public static string TextEbene(string[] woerter, double[] x, double[] y, double[] w, double[] h, double dpiX, double dpiY, int hoehePx) {
        if (woerter == null || woerter.Length == 0) { return ""; }
        Encoding ansi;
        try { ansi = Encoding.GetEncoding(1252); } catch { ansi = Encoding.ASCII; }
        double kx = 72.0 / dpiX;
        double ky = 72.0 / dpiY;
        double hPt = hoehePx * ky;
        StringBuilder sb = new StringBuilder();
        sb.Append("BT 3 Tr\n");
        for (int i = 0; i < woerter.Length; i++) {
            string wort = woerter[i];
            if (string.IsNullOrEmpty(wort) || h[i] <= 0 || w[i] <= 0) { continue; }
            wort = wort + " ";
            double fs = h[i] * ky;
            if (fs < 1) { fs = 1; }
            // Helvetica: mittlere Zeichenbreite etwa 0.5 der Schriftgroesse
            double tz = 100.0 * (w[i] * kx) / (fs * 0.5 * wort.Length);
            if (tz < 10) { tz = 10; }
            if (tz > 500) { tz = 500; }
            double px = x[i] * kx;
            double py = hPt - (y[i] + h[i]) * ky + 0.2 * fs;
            sb.Append("/F1 " + Z(fs) + " Tf " + Z(tz) + " Tz 1 0 0 1 " + Z(px) + " " + Z(py) + " Tm (");
            foreach (byte b in ansi.GetBytes(wort)) {
                if (b < 32 || b > 126 || b == 40 || b == 41 || b == 92) {
                    sb.Append("\\" + Convert.ToString(b, 8).PadLeft(3, '0'));
                } else {
                    sb.Append((char)b);
                }
            }
            sb.Append(") Tj\n");
        }
        sb.Append("ET");
        return sb.ToString();
    }

    // textEbene[i]: unsichtbarer Text fuer Seite i (siehe TextEbene) oder null
    public static void Schreibe(string ziel, byte[][] jpegs, int[] breite, int[] hoehe, double[] dpiX, double[] dpiY, bool[] schwarzweiss, string[] textEbene) {
        int n = jpegs.Length;
        bool mitText = false;
        if (textEbene != null) {
            foreach (string te in textEbene) { if (!string.IsNullOrEmpty(te)) { mitText = true; break; } }
        }
        int schriftNr = 3 + 3 * n;
        long[] pos = new long[4 + 3 * n];
        using (FileStream s = new FileStream(ziel, FileMode.Create, FileAccess.Write)) {
            T(s, "%PDF-1.4\n");
            byte[] binaerKennung = new byte[] { 0x25, 0xE2, 0xE3, 0xCF, 0xD3, 0x0A };
            s.Write(binaerKennung, 0, binaerKennung.Length);

            pos[1] = s.Position;
            T(s, "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n");

            StringBuilder kids = new StringBuilder();
            for (int i = 0; i < n; i++) { kids.Append((3 + 3 * i).ToString(CultureInfo.InvariantCulture) + " 0 R "); }
            pos[2] = s.Position;
            T(s, "2 0 obj\n<< /Type /Pages /Kids [ " + kids.ToString() + "] /Count " + n.ToString(CultureInfo.InvariantCulture) + " >>\nendobj\n");

            for (int i = 0; i < n; i++) {
                int seiteNr = 3 + 3 * i;
                int inhaltNr = seiteNr + 1;
                int bildNr = seiteNr + 2;
                double wPt = breite[i] * 72.0 / dpiX[i];
                double hPt = hoehe[i] * 72.0 / dpiY[i];

                pos[seiteNr] = s.Position;
                string schrift = mitText ? " /Font << /F1 " + schriftNr + " 0 R >>" : "";
                T(s, seiteNr + " 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 " + Z(wPt) + " " + Z(hPt) + "] /Resources << /XObject << /Im0 " + bildNr + " 0 R >>" + schrift + " >> /Contents " + inhaltNr + " 0 R >>\nendobj\n");

                string inhalt = "q " + Z(wPt) + " 0 0 " + Z(hPt) + " 0 0 cm /Im0 Do Q";
                if (mitText && !string.IsNullOrEmpty(textEbene[i])) { inhalt += "\n" + textEbene[i]; }
                pos[inhaltNr] = s.Position;
                T(s, inhaltNr + " 0 obj\n<< /Length " + Encoding.ASCII.GetByteCount(inhalt) + " >>\nstream\n" + inhalt + "\nendstream\nendobj\n");

                pos[bildNr] = s.Position;
                string bildArt = schwarzweiss[i]
                    ? " /ColorSpace /DeviceGray /BitsPerComponent 1 /Filter /FlateDecode"
                    : " /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode";
                T(s, bildNr + " 0 obj\n<< /Type /XObject /Subtype /Image /Width " + breite[i] + " /Height " + hoehe[i] + bildArt + " /Length " + jpegs[i].Length + " >>\nstream\n");
                s.Write(jpegs[i], 0, jpegs[i].Length);
                T(s, "\nendstream\nendobj\n");
            }

            int anzahl = 3 + 3 * n;
            if (mitText) {
                pos[schriftNr] = s.Position;
                T(s, schriftNr + " 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>\nendobj\n");
                anzahl = 4 + 3 * n;
            }
            long xref = s.Position;
            T(s, "xref\n0 " + anzahl + "\n0000000000 65535 f \n");
            for (int k = 1; k < anzahl; k++) {
                T(s, pos[k].ToString("0000000000", CultureInfo.InvariantCulture) + " 00000 n \n");
            }
            T(s, "trailer\n<< /Size " + anzahl + " /Root 1 0 R >>\nstartxref\n" + xref + "\n%%EOF\n");
        }
    }
}
"@

function Sanitize-Dateiname($text) {
    $ungueltig = [System.IO.Path]::GetInvalidFileNameChars() -join ''
    $pattern = "[{0}]" -f [RegEx]::Escape($ungueltig)
    return ($text -replace $pattern, "_").Trim()
}

function Get-EindeutigerZielpfad($ordner, $basisname, $endung) {
    $ziel = Join-Path $ordner "$basisname.$endung"
    $zaehler = 1
    while (Test-Path $ziel) {
        $ziel = Join-Path $ordner "$basisname ($zaehler).$endung"
        $zaehler++
    }
    return $ziel
}

function Datei-IstFreigegeben($pfad) {
    try {
        $stream = [System.IO.File]::Open($pfad, 'Open', 'ReadWrite', 'None')
        $stream.Close()
        return $true
    } catch {
        return $false
    }
}

# Ermittelt den tatsaechlichen Zielordner fuer einen Ablagetyp: normalerweise
# der HiDrive-Pfad, bei Nichterreichbarkeit automatisch der lokale Ausweichordner.
function Ermittle-Zielordner($basisPfad, $ausweichUnterordner) {
    if (Test-Path $basisPfad -ErrorAction SilentlyContinue) {
        return $basisPfad
    } else {
        $ausweich = Join-Path $AusweichOrdner $ausweichUnterordner
        if (-not (Test-Path $ausweich)) { New-Item -ItemType Directory -Path $ausweich -Force | Out-Null }
        Schreibe-Log "WARNUNG: Zielordner '$basisPfad' nicht erreichbar, lege lokal ab: $ausweich"
        return $ausweich
    }
}

function Lese-Bezeichnungen {
    if ([int]$BezeichnungenMerken -le 0) { return @() }
    try {
        if (Test-Path $script:BezeichnungenDatei) {
            return @(Get-Content -Path $script:BezeichnungenDatei -Encoding UTF8 -ErrorAction Stop | Where-Object { $_.Trim() })
        }
    } catch {}
    return @()
}

# Merkt sich eine eingegebene Bezeichnung (neueste zuerst, ohne Doppelte)
function Merke-Bezeichnung($text) {
    if ([int]$BezeichnungenMerken -le 0) { return }
    $text = "$text".Trim()
    if (-not $text) { return }
    try {
        $liste = New-Object System.Collections.Generic.List[string]
        [void]$liste.Add($text)
        foreach ($b in (Lese-Bezeichnungen)) {
            if ($liste.Count -ge [int]$BezeichnungenMerken) { break }
            if ($b -ine $text) { [void]$liste.Add($b) }
        }
        Set-Content -Path $script:BezeichnungenDatei -Value $liste -Encoding UTF8 -Force
    } catch {}
}

# ======================= TEXTERKENNUNG (OCR) UND VORSCHAU =======================
# Nutzt die in Windows 10/11 eingebaute Texterkennung (Windows.Media.Ocr) und
# die PDF-Anzeige von Windows (Windows.Data.Pdf) - es muss nichts zusaetzlich
# installiert werden, und es geht nichts ins Internet. Fehlt etwas (z.B. kein
# deutsches Sprachpaket), laeuft alles wie bisher, nur ohne Text/Vorschau.
$script:WinRtGeprueft = $false
$script:WinRtBereit = $false
$script:AsTaskOperation = $null
$script:AsTaskAktion = $null
$script:OcrGeprueft = $false
$script:OcrEngine = $null

function Initialisiere-WinRT {
    if ($script:WinRtGeprueft) { return $script:WinRtBereit }
    $script:WinRtGeprueft = $true
    try {
        Add-Type -AssemblyName System.Runtime.WindowsRuntime
        $null = [Windows.Foundation.IAsyncOperation`1, Windows.Foundation, ContentType = WindowsRuntime]
        $null = [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime]
        $null = [Windows.Storage.FileAccessMode, Windows.Storage, ContentType = WindowsRuntime]
        $null = [Windows.Storage.Streams.IRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]
        $null = [Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]
        $null = [Windows.Graphics.Imaging.BitmapDecoder, Windows.Graphics, ContentType = WindowsRuntime]
        $null = [Windows.Graphics.Imaging.SoftwareBitmap, Windows.Graphics, ContentType = WindowsRuntime]
        $null = [Windows.Media.Ocr.OcrEngine, Windows.Foundation, ContentType = WindowsRuntime]
        $null = [Windows.Media.Ocr.OcrResult, Windows.Foundation, ContentType = WindowsRuntime]
        $null = [Windows.Globalization.Language, Windows.Globalization, ContentType = WindowsRuntime]
        $null = [Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime]
        $null = [Windows.Data.Pdf.PdfPageRenderOptions, Windows.Data.Pdf, ContentType = WindowsRuntime]
        $methoden = @([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 })
        $script:AsTaskOperation = $methoden | Where-Object { $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' } | Select-Object -First 1
        $script:AsTaskAktion = $methoden | Where-Object { $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncAction' } | Select-Object -First 1
        if ($null -eq $script:AsTaskOperation -or $null -eq $script:AsTaskAktion) { throw "AsTask nicht gefunden" }
        $script:WinRtBereit = $true
    } catch {
        Schreibe-Log "HINWEIS: Windows-Funktionen fuer Texterkennung/Vorschau nicht verfuegbar: $($_.Exception.Message)"
    }
    return $script:WinRtBereit
}

# Wartet auf eine asynchrone Windows-Funktion (max. 60 Sekunden)
function Warte-WinRT($operation, [Type]$ergebnisTyp) {
    $task = $script:AsTaskOperation.MakeGenericMethod($ergebnisTyp).Invoke($null, @($operation))
    if (-not $task.Wait(60000)) { throw "Zeitueberschreitung" }
    return $task.Result
}

function Warte-WinRTAktion($aktion) {
    $task = $script:AsTaskAktion.Invoke($null, @($aktion))
    if (-not $task.Wait(60000)) { throw "Zeitueberschreitung" }
}

function Initialisiere-Ocr {
    if ($script:OcrGeprueft) { return ($null -ne $script:OcrEngine) }
    $script:OcrGeprueft = $true
    if (-not $OcrAktiv) { return $false }
    if (-not (Initialisiere-WinRT)) { return $false }
    try {
        $engine = $null
        try { $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromLanguage([Windows.Globalization.Language]::new("de-DE")) } catch {}
        if ($null -eq $engine) { $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages() }
        if ($null -eq $engine) { throw "keine Sprache fuer die Texterkennung installiert (Windows-Einstellungen -> Sprache -> Deutsch)" }
        $script:OcrEngine = $engine
        Schreibe-Log "Texterkennung bereit (Sprache: $($engine.RecognizerLanguage.LanguageTag))."
    } catch {
        Schreibe-Log "HINWEIS: Texterkennung (OCR) nicht verfuegbar: $($_.Exception.Message) - Dokumente werden ohne Text abgelegt."
    }
    return ($null -ne $script:OcrEngine)
}

# Erkennt den Text in einem Bild. Rueckgabe: Text (zeilenweise) und die
# einzelnen Woerter mit Position in Bildpunkten des Originalbildes - oder
# $null, wenn die Texterkennung nicht verfuegbar ist bzw. fehlschlaegt.
function Erkenne-Text($bildPfad) {
    if (-not (Initialisiere-Ocr)) { return $null }
    $ocrDatei = Join-Path $ScanTempOrdner ("Ocr_" + [guid]::NewGuid().ToString("N") + ".png")
    $stream = $null
    try {
        $maxSeite = 0
        try { $maxSeite = [int][Windows.Media.Ocr.OcrEngine]::MaxImageDimension } catch {}
        if ($maxSeite -le 0) { $maxSeite = 2600 }
        $faktor = [PpeBild]::SpeichereFuerOcr($bildPfad, $ocrDatei, $maxSeite)
        $datei   = Warte-WinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($ocrDatei)) ([Windows.Storage.StorageFile])
        $stream  = Warte-WinRT ($datei.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
        $decoder = Warte-WinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
        $bitmap  = Warte-WinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
        $ergebnis = Warte-WinRT ($script:OcrEngine.RecognizeAsync($bitmap)) ([Windows.Media.Ocr.OcrResult])
        try { $bitmap.Dispose() } catch {}

        $woerter = New-Object System.Collections.Generic.List[string]
        $x = New-Object System.Collections.Generic.List[double]
        $y = New-Object System.Collections.Generic.List[double]
        $w = New-Object System.Collections.Generic.List[double]
        $h = New-Object System.Collections.Generic.List[double]
        $zeilen = New-Object System.Collections.Generic.List[string]
        foreach ($zeile in $ergebnis.Lines) {
            [void]$zeilen.Add($zeile.Text)
            foreach ($wort in $zeile.Words) {
                $r = $wort.BoundingRect
                [void]$woerter.Add($wort.Text)
                [void]$x.Add($r.X / $faktor)
                [void]$y.Add($r.Y / $faktor)
                [void]$w.Add($r.Width / $faktor)
                [void]$h.Add($r.Height / $faktor)
            }
        }
        return [PSCustomObject]@{
            Text    = ($zeilen -join "`r`n")
            Woerter = $woerter.ToArray()
            X = $x.ToArray(); Y = $y.ToArray(); W = $w.ToArray(); H = $h.ToArray()
        }
    } catch {
        Schreibe-Log "HINWEIS: Texterkennung fehlgeschlagen: $($_.Exception.Message)"
        return $null
    } finally {
        if ($stream) { try { $stream.Dispose() } catch {} }
        Remove-Item -Path $ocrDatei -Force -ErrorAction SilentlyContinue
    }
}

# Datei, in der der erkannte Text eines gescannten Dokuments bis zur
# Erfassung aufgehoben wird (dann muss fuer den Namensvorschlag nicht noch
# einmal erkannt werden)
function Get-OcrTextDatei($pdfName) {
    return (Join-Path $ScanTempOrdner ("Text_" + [System.IO.Path]::GetFileNameWithoutExtension($pdfName) + ".txt"))
}

# Erste Seite einer PDF als Bild (fuer die Vorschau und - bei Ausdrucken -
# fuer den Namensvorschlag). Rueckgabe: Bild (System.Drawing.Bitmap) und
# Text, oder $null.
function Erzeuge-Vorschau($pdfPfad) {
    if (-not $VorschauAktiv -and -not $OcrAktiv) { return $null }
    $ergebnis = [PSCustomObject]@{ Bild = $null; Text = "" }
    $textDatei = Get-OcrTextDatei ([System.IO.Path]::GetFileName($pdfPfad))
    if (Test-Path $textDatei) {
        try { $ergebnis.Text = [System.IO.File]::ReadAllText($textDatei) } catch {}
    }
    if (-not (Initialisiere-WinRT)) { return $ergebnis }
    $kennung = [guid]::NewGuid().ToString("N")
    $kopie = Join-Path $ScanTempOrdner ("Vorschau_" + $kennung + ".pdf")
    $png = Join-Path $ScanTempOrdner ("Vorschau_" + $kennung + ".png")
    $mem = $null; $seite = $null; $netz = $null
    try {
        # Kopie, damit die eigentliche Datei nicht gesperrt bleibt
        Copy-Item -Path $pdfPfad -Destination $kopie -Force -ErrorAction Stop
        $datei = Warte-WinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($kopie)) ([Windows.Storage.StorageFile])
        $dok = Warte-WinRT ([Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($datei)) ([Windows.Data.Pdf.PdfDocument])
        if ($dok.PageCount -lt 1) { return $ergebnis }
        $seite = $dok.GetPage(0)
        $mem = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
        $opt = New-Object Windows.Data.Pdf.PdfPageRenderOptions
        $opt.DestinationWidth = 1240   # etwa 150 dpi bei A4 - reicht fuer Vorschau und Texterkennung
        Warte-WinRTAktion ($seite.RenderToStreamAsync($mem, $opt))
        $mem.Seek(0)
        $netz = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($mem)
        $fs = [System.IO.File]::Create($png)
        try { $netz.CopyTo($fs) } finally { $fs.Close() }

        # Bild in den Speicher laden, damit die Datei sofort geloescht werden kann
        $bytes = [System.IO.File]::ReadAllBytes($png)
        $ms = New-Object System.IO.MemoryStream(,$bytes)
        $tmp = [System.Drawing.Image]::FromStream($ms)
        $ergebnis.Bild = New-Object System.Drawing.Bitmap $tmp
        $tmp.Dispose(); $ms.Dispose()

        if (-not $ergebnis.Text -and $OcrAktiv) {
            $erkannt = Erkenne-Text $png
            if ($erkannt) { $ergebnis.Text = $erkannt.Text }
        }
    } catch {
        Schreibe-Log "HINWEIS: Vorschau fuer '$([System.IO.Path]::GetFileName($pdfPfad))' nicht moeglich: $($_.Exception.Message)"
    } finally {
        if ($netz) { try { $netz.Dispose() } catch {} }
        if ($seite) { try { $seite.Dispose() } catch {} }
        if ($mem) { try { $mem.Dispose() } catch {} }
        Remove-Item -Path $kopie, $png -Force -ErrorAction SilentlyContinue
    }
    if (-not $VorschauAktiv -and $ergebnis.Bild) { $ergebnis.Bild.Dispose(); $ergebnis.Bild = $null }
    return $ergebnis
}

# Sucht unter den schon einmal verwendeten Bezeichnungen die laengste, die im
# erkannten Text vorkommt (z.B. ein Kundenname im Briefkopf).
function Finde-Bezeichnungsvorschlag($text) {
    if ([string]::IsNullOrWhiteSpace($text)) { return "" }
    $norm = " " + (($text -replace '\s+', ' ').ToLowerInvariant()) + " "
    $bester = ""
    foreach ($b in (Lese-Bezeichnungen)) {
        $kandidat = ("$b".Trim() -replace '\s+', ' ')
        if ($kandidat.Length -lt 4 -or $kandidat.Length -le $bester.Length) { continue }
        if ($kandidat -ieq "Scan" -or $kandidat -ieq "Kassenabschluss") { continue }
        if ($norm.Contains($kandidat.ToLowerInvariant())) { $bester = $kandidat }
    }
    return $bester
}

function Zeige-Erfassungsdialog($dateiname, $dateipfad, $vorschau) {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Dokument erfassen - $dateiname ($StandortName)"
    $mitBild = ($null -ne $vorschau -and $null -ne $vorschau.Bild)
    $form.Size = New-Object System.Drawing.Size($(if ($mitBild) { 730 } else { 480 }), 340)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.Topmost = $true

    $y = 15

    $lblInfo = New-Object System.Windows.Forms.Label
    $lblInfo.Text = "Neue Datei erkannt: $dateiname"
    $lblInfo.AutoSize = $true
    $lblInfo.Location = New-Object System.Drawing.Point(15, $y)
    $form.Controls.Add($lblInfo)
    $y += 30

    # ---- Ziel-Auswahl (Mitarbeiter-Ordner / Shop-Ordner / Kasse) ----
    $grpZiel = New-Object System.Windows.Forms.GroupBox
    $grpZiel.Text = "Wohin speichern?"
    $grpZiel.Location = New-Object System.Drawing.Point(15, $y)
    $grpZiel.Size = New-Object System.Drawing.Size(440, 50)
    $form.Controls.Add($grpZiel)

    $radMitarbeiter = New-Object System.Windows.Forms.RadioButton
    $radMitarbeiter.Text = "Mitarbeiter-Ordner"
    $radMitarbeiter.Location = New-Object System.Drawing.Point(10, 20)
    $radMitarbeiter.AutoSize = $true
    $radMitarbeiter.Checked = $true
    $grpZiel.Controls.Add($radMitarbeiter)

    $radShop = New-Object System.Windows.Forms.RadioButton
    $radShop.Text = "Shop-Ordner"
    $radShop.Location = New-Object System.Drawing.Point(145, 20)
    $radShop.AutoSize = $true
    $grpZiel.Controls.Add($radShop)

    $radKasse = New-Object System.Windows.Forms.RadioButton
    $radKasse.Text = "Kasse"
    $radKasse.Location = New-Object System.Drawing.Point(250, 20)
    $radKasse.AutoSize = $true
    $grpZiel.Controls.Add($radKasse)

    # Nur auf diesem PC speichern (Ordner $LokalerOrdner), nicht auf HiDrive
    $radLokal = New-Object System.Windows.Forms.RadioButton
    $radLokal.Text = "Nur lokal (PC)"
    $radLokal.Location = New-Object System.Drawing.Point(325, 20)
    $radLokal.AutoSize = $true
    $grpZiel.Controls.Add($radLokal)
    $tip = New-Object System.Windows.Forms.ToolTip
    $tip.SetToolTip($radLokal, "Speichert nur auf diesem PC in: $LokalerOrdner")

    $y += 60

    # ---- Mitarbeiter (nur sichtbar, wenn "Mitarbeiter-Ordner" gewaehlt ist) ----
    $lblMA = New-Object System.Windows.Forms.Label
    $lblMA.Text = "Mitarbeiter:"
    $lblMA.Location = New-Object System.Drawing.Point(15, $y)
    $lblMA.AutoSize = $true
    $form.Controls.Add($lblMA)

    $cmbMA = New-Object System.Windows.Forms.ComboBox
    $cmbMA.Location = New-Object System.Drawing.Point(200, ($y - 3))
    $cmbMA.Width = 230
    $cmbMA.DropDownStyle = "DropDownList"
    [void]$cmbMA.Items.Add("Bitte waehlen...")
    foreach ($m in $MitarbeiterOrdner.Keys) { [void]$cmbMA.Items.Add($m) }
    $cmbMA.SelectedIndex = 0
    $form.Controls.Add($cmbMA)
    $y += 35

    $lblKunde = New-Object System.Windows.Forms.Label
    $lblKunde.Text = "Kundenname/Bezeichnung:"
    $lblKunde.Location = New-Object System.Drawing.Point(15, $y)
    $lblKunde.AutoSize = $true
    $form.Controls.Add($lblKunde)

    $txtKunde = New-Object System.Windows.Forms.TextBox
    $txtKunde.Location = New-Object System.Drawing.Point(200, ($y - 3))
    $txtKunde.Width = 230
    # Zuletzt verwendete Bezeichnungen beim Tippen vorschlagen
    $bisherige = @(Lese-Bezeichnungen)
    if ($bisherige.Count -gt 0) {
        try {
            $txtKunde.AutoCompleteCustomSource.AddRange([string[]]$bisherige)
            $txtKunde.AutoCompleteMode = [System.Windows.Forms.AutoCompleteMode]::SuggestAppend
            $txtKunde.AutoCompleteSource = [System.Windows.Forms.AutoCompleteSource]::CustomSource
        } catch {}
    }
    $form.Controls.Add($txtKunde)
    # Vorschlag aus der Texterkennung: ein schon bekannter Name, der im
    # Dokument vorkommt - markiert, damit Tippen ihn sofort ersetzt
    $vorschlag = ""
    if ($null -ne $vorschau) { $vorschlag = Finde-Bezeichnungsvorschlag $vorschau.Text }
    if ($vorschlag) {
        $txtKunde.Text = $vorschlag
        $txtKunde.BackColor = [System.Drawing.Color]::LightYellow
        if (-not $tip) { $tip = New-Object System.Windows.Forms.ToolTip }
        $tip.SetToolTip($txtKunde, "Vorschlag aus dem Dokument erkannt - bitte pruefen")
        $txtKunde.Add_TextChanged({ $txtKunde.BackColor = [System.Drawing.SystemColors]::Window })
        $form.Add_Shown({ $txtKunde.Focus(); $txtKunde.SelectAll() })
        Schreibe-Log "Namensvorschlag aus Texterkennung: '$vorschlag'"
    }
    $y += 35

    $lblDatum = New-Object System.Windows.Forms.Label
    $lblDatum.Text = "Datum:"
    $lblDatum.Location = New-Object System.Drawing.Point(15, $y)
    $lblDatum.AutoSize = $true
    $form.Controls.Add($lblDatum)

    $dtpDatum = New-Object System.Windows.Forms.DateTimePicker
    $dtpDatum.Location = New-Object System.Drawing.Point(200, ($y - 3))
    $dtpDatum.Width = 230
    $dtpDatum.Format = "Short"
    $dtpDatum.Value = Get-Date
    $form.Controls.Add($dtpDatum)
    $y += 45

    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Text = "Ablegen"
    $btnOK.Size = New-Object System.Drawing.Size(100, 30)
    $btnOK.Location = New-Object System.Drawing.Point(200, $y)
    $btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($btnOK)

    # Dokument ansehen: oeffnet eine KOPIE im PDF-Programm, damit die
    # eigentliche Datei danach problemlos verschoben werden kann
    $btnAnsehen = New-Object System.Windows.Forms.Button
    $btnAnsehen.Text = "Ansehen"
    $btnAnsehen.Size = New-Object System.Drawing.Size(100, 30)
    $btnAnsehen.Location = New-Object System.Drawing.Point(15, $y)
    $btnAnsehen.Enabled = [bool]$dateipfad
    $btnAnsehen.Add_Click({
        try {
            $kopie = Join-Path $ScanTempOrdner ("Ansicht_" + (Get-Date -Format 'HHmmss') + "_" + [System.IO.Path]::GetFileName($dateipfad))
            Copy-Item -Path $dateipfad -Destination $kopie -Force
            $form.Topmost = $false
            Start-Process -FilePath $kopie
        } catch {
            [System.Windows.Forms.MessageBox]::Show($form, "Das Dokument konnte nicht geoeffnet werden: $($_.Exception.Message)", "Ansehen") | Out-Null
        }
    })
    $form.Controls.Add($btnAnsehen)

    # Vorschau der ersten Seite (Klick = Dokument ansehen)
    if ($mitBild) {
        $bild = New-Object System.Windows.Forms.PictureBox
        $bild.Location = New-Object System.Drawing.Point(470, 10)
        $bild.Size = New-Object System.Drawing.Size(235, 280)
        $bild.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $bild.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $bild.BackColor = [System.Drawing.Color]::White
        $bild.Cursor = [System.Windows.Forms.Cursors]::Hand
        $bild.Image = $vorschau.Bild
        if (-not $tip) { $tip = New-Object System.Windows.Forms.ToolTip }
        $tip.SetToolTip($bild, "Erste Seite - Klicken zum Ansehen des ganzen Dokuments")
        $bild.Add_Click({ $btnAnsehen.PerformClick() })
        $form.Controls.Add($bild)
    }

    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Ueberspringen"
    $btnCancel.AutoSize = $true
    $btnCancel.Size = New-Object System.Drawing.Size(130, 30)
    $btnCancel.Location = New-Object System.Drawing.Point(315, $y)
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($btnCancel)

    $form.AcceptButton = $btnOK
    $form.CancelButton = $btnCancel

    # Mitarbeiter-Auswahl nur einblenden, wenn "Mitarbeiter-Ordner" aktiv ist
    $aktualisiereSichtbarkeit = {
        $zeigeMA = $radMitarbeiter.Checked
        $lblMA.Visible = $zeigeMA
        $cmbMA.Visible = $zeigeMA
    }
    $radMitarbeiter.Add_CheckedChanged($aktualisiereSichtbarkeit)
    $radShop.Add_CheckedChanged($aktualisiereSichtbarkeit)
    $radKasse.Add_CheckedChanged($aktualisiereSichtbarkeit)
    $radLokal.Add_CheckedChanged($aktualisiereSichtbarkeit)
    & $aktualisiereSichtbarkeit

    $btnOK.Add_Click({
        if ($radMitarbeiter.Checked) {
            if ($cmbMA.SelectedIndex -le 0) {
                [System.Windows.Forms.MessageBox]::Show($form, "Bitte einen Mitarbeiter auswaehlen.", "Fehlende Angabe") | Out-Null
                $form.DialogResult = [System.Windows.Forms.DialogResult]::None
                return
            }
            if ([string]::IsNullOrWhiteSpace($txtKunde.Text)) {
                [System.Windows.Forms.MessageBox]::Show($form, "Bitte einen Kundennamen/eine Bezeichnung eingeben.", "Fehlende Angabe") | Out-Null
                $form.DialogResult = [System.Windows.Forms.DialogResult]::None
                return
            }
        } elseif ($radShop.Checked) {
            if ([string]::IsNullOrWhiteSpace($txtKunde.Text)) {
                [System.Windows.Forms.MessageBox]::Show($form, "Bitte eine Bezeichnung eingeben.", "Fehlende Angabe") | Out-Null
                $form.DialogResult = [System.Windows.Forms.DialogResult]::None
                return
            }
        }
        # Kasse: Bezeichnung optional (wird ggf. automatisch auf "Kassenabschluss" gesetzt)
    })

    $ergebnis = $form.ShowDialog()

    if ($ergebnis -eq [System.Windows.Forms.DialogResult]::OK) {
        $ziel = "Mitarbeiter"
        if ($radShop.Checked) { $ziel = "Shop" }
        if ($radKasse.Checked) { $ziel = "Kasse" }
        if ($radLokal.Checked) { $ziel = "Lokal" }

        $bezeichnung = $txtKunde.Text
        if ($ziel -eq "Kasse" -and [string]::IsNullOrWhiteSpace($bezeichnung)) {
            $bezeichnung = "Kassenabschluss"
        }
        if ($ziel -eq "Lokal" -and [string]::IsNullOrWhiteSpace($bezeichnung)) {
            $bezeichnung = "Scan"
        }

        return [PSCustomObject]@{
            Ziel        = $ziel
            Mitarbeiter = $cmbMA.SelectedItem
            Kunde       = $bezeichnung
            Datum       = $dtpDatum.Value.ToString("yyyy-MM-dd")
        }
    } else {
        return $null
    }
}

# Zeigt bei mehreren konfigurierten Druckern eine kurze Auswahl an, an welchen
# der Scan geschickt werden soll. Bei nur einem Eintrag in $ScanDruckerListe
# wird direkt dieser zurueckgegeben, ohne Nachfrage.
function Waehle-ScanDrucker {
    if ($ScanDruckerListe.Count -le 1) {
        return $ScanDruckerListe[0]
    }

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Drucker fuer Scan waehlen"
    $form.Size = New-Object System.Drawing.Size(360, 170)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.Topmost = $true

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "An welchen Drucker soll der Scan geschickt werden?"
    $lbl.AutoSize = $true
    $lbl.Location = New-Object System.Drawing.Point(15, 15)
    $form.Controls.Add($lbl)

    $cmb = New-Object System.Windows.Forms.ComboBox
    $cmb.Location = New-Object System.Drawing.Point(15, 45)
    $cmb.Width = 310
    $cmb.DropDownStyle = "DropDownList"
    foreach ($d in $ScanDruckerListe) { [void]$cmb.Items.Add($d) }
    $cmb.SelectedIndex = 0
    $form.Controls.Add($cmb)

    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Text = "Scannen"
    $btnOK.Size = New-Object System.Drawing.Size(110, 30)
    $btnOK.Location = New-Object System.Drawing.Point(15, 85)
    $btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($btnOK)

    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Abbrechen"
    $btnCancel.Size = New-Object System.Drawing.Size(110, 30)
    $btnCancel.Location = New-Object System.Drawing.Point(135, 85)
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($btnCancel)

    $form.AcceptButton = $btnOK
    $form.CancelButton = $btnCancel

    $ergebnis = $form.ShowDialog()
    if ($ergebnis -eq [System.Windows.Forms.DialogResult]::OK) {
        return $cmb.SelectedItem
    } else {
        return $null
    }
}

# Druckt eine oder mehrere Bilddateien still (ohne sichtbares Fenster) als EIN
# mehrseitiges Dokument auf den angegebenen Drucker, direkt ueber die .NET-
# Druckfunktion von Windows - unabhaengig von mspaint/Paint (das auf neueren
# Windows-Versionen die klassische Druck-per-Kommandozeile-Funktion nicht mehr
# unterstuetzt). $bildPfade ist eine Liste von Dateipfaden (eine Seite pro
# Eintrag, in der gewuenschten Reihenfolge) - bei nur einer Seite reicht ein
# Array mit einem Eintrag.
function Drucke-BilderStumm($bildPfade, $druckerName) {
    Add-Type -AssemblyName System.Drawing

    $doc = New-Object System.Drawing.Printing.PrintDocument
    $doc.PrinterSettings.PrinterName = $druckerName
    $doc.DocumentName = "DiNo1 Druck & Scan Scan ($($bildPfade.Count) Seite(n))"

    if (-not $doc.PrinterSettings.IsValid) {
        throw "Drucker '$druckerName' wurde auf diesem PC nicht gefunden."
    }

    # Papierformat ausdruecklich auf A4 setzen und Raender minimieren. Ohne
    # das wird die Standard-Papiergroesse des Druckers verwendet (kann z.B.
    # "Letter" sein) - das gescannte Bild wird dann zwar seitenrichtig
    # eingepasst, aber in ein falsch geformtes Seitenformat, wodurch es
    # kleiner erscheint bzw. mit Raendern versehen wird, VOELLIG UNABHAENGIG
    # von der gewaehlten Scan-Qualitaet (das erklaert, warum sich am
    # sichtbaren Ergebnis nichts aendert, obwohl der Scan selbst inzwischen
    # korrekt in voller A4-Groesse erfasst wird).
    $a4Format = $null
    foreach ($ps in $doc.PrinterSettings.PaperSizes) {
        if ($ps.Kind -eq [System.Drawing.Printing.PaperKind]::A4 -or $ps.PaperName -match "A4") {
            $a4Format = $ps
            break
        }
    }
    if ($a4Format) {
        $doc.DefaultPageSettings.PaperSize = $a4Format
    } else {
        Schreibe-Log "WARNUNG: Drucker '$druckerName' bietet kein A4-Papierformat an - verwende Standardformat des Druckers."
    }
    $doc.DefaultPageSettings.Landscape = $false
    $doc.DefaultPageSettings.Margins = New-Object System.Drawing.Printing.Margins(0, 0, 0, 0)

    $seiteInfo = $doc.DefaultPageSettings.PaperSize
    Schreibe-Log "Druck-Seitenformat: '$($seiteInfo.PaperName)' $($seiteInfo.Width)x$($seiteInfo.Height) (1/100 Zoll), Raender=0"

    # WICHTIG: Zaehler und Bilderliste ueber Skript-weite ($script:) Variablen
    # fuehren, NICHT nur per GetNewClosure() im Eventhandler einschliessen. In
    # der Praxis hat sich gezeigt, dass eine nur per Closure erfasste Variable
    # zwischen den einzelnen Aufrufen des PrintPage-Events NICHT zuverlaessig
    # ihren Wert behaelt (der Zaehler blieb effektiv immer bei 0 haengen ->
    # der Drucker bekam nie mitgeteilt, dass Schluss ist, und druckte endlos
    # weiter). $script:-Variablen sind dagegen echte, dauerhaft geteilte
    # Variablen und funktionieren zuverlaessig ueber mehrere Aufrufe hinweg.
    $script:druckSeitenIndex = 0
    $script:druckBildListe = $bildPfade

    $doc.add_PrintPage({
        param($sender, $e)
        $bild = [System.Drawing.Image]::FromFile($script:druckBildListe[$script:druckSeitenIndex])
        try {
            $seite = $e.MarginBounds
            Schreibe-Log "Druckseite $($script:druckSeitenIndex + 1): Bild=$($bild.Width)x$($bild.Height)px ($([Math]::Round($bild.HorizontalResolution))x$([Math]::Round($bild.VerticalResolution)) dpi), Druckbereich(MarginBounds)=$($seite.Width)x$($seite.Height) (1/100 Zoll)"
            $verhaeltnisBild = $bild.Width / $bild.Height
            $verhaeltnisSeite = $seite.Width / $seite.Height
            if ($verhaeltnisBild -gt $verhaeltnisSeite) {
                $breite = $seite.Width
                $hoehe = $breite / $verhaeltnisBild
            } else {
                $hoehe = $seite.Height
                $breite = $hoehe * $verhaeltnisBild
            }
            $x = $seite.X + (($seite.Width - $breite) / 2)
            $y = $seite.Y + (($seite.Height - $hoehe) / 2)
            $e.Graphics.DrawImage($bild, $x, $y, $breite, $hoehe)
        } finally {
            $bild.Dispose()
        }

        $script:druckSeitenIndex++
        $e.HasMorePages = ($script:druckSeitenIndex -lt $script:druckBildListe.Count)
    })

    $doc.Print()
}

# WIA-Property-IDs und Formatkennung (Microsoft-Standardwerte, siehe WIA-
# Dokumentation) - werden fuer den automatischen Einzug (ADF) benoetigt.
$script:WIA_DPS_DOCUMENT_HANDLING_CAPABILITIES = 3086
$script:WIA_DPS_DOCUMENT_HANDLING_STATUS       = 3087
$script:WIA_DPS_DOCUMENT_HANDLING_SELECT       = 3088
$script:WIA_EINZUG_FLAG                        = 1
$script:WIA_DUPLEX_FLAG                        = 4
$script:WIA_FLACHBETT_FLAG                     = 2
$script:WIA_EINZUG_BEREIT_FLAG                 = 1
$script:WIA_IPS_XPOS                           = 6149
$script:WIA_IPS_YPOS                           = 6150
$script:WIA_IPS_XEXTENT                        = 6151
$script:WIA_IPS_YEXTENT                        = 6152
$script:WIA_IPS_XRES                           = 6147
$script:WIA_IPS_YRES                           = 6148
# A4-Seitenmasse in Zoll (Hochformat) - dient dazu, bei jeder gewaehlten
# Aufloesung den vollen Scanbereich (nicht nur einen Ausschnitt) anzufordern.
$script:A4_BREITE_ZOLL                         = 8.27
$script:A4_HOEHE_ZOLL                          = 11.69
$script:WIA_PROP_RANGE                         = 1
$script:WIA_PROP_LIST                          = 2
# Offizielle WIA-Formatkennungen (frueher waren hier versehentlich die
# Kennungen von JPEG/PNG als BMP/TIFF eingetragen - "BMP" war also in
# Wahrheit JPEG, das z.B. kein Schwarzweiss (1 Bit) kann).
$script:WIA_FORMAT_BMP                         = "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}"
$script:WIA_FORMAT_PNG                         = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}"
$script:WIA_FORMAT_JPEG                        = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}"
$script:WIA_FORMAT_TIFF                        = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}"
$script:WIA_DPS_PAGES                          = 3096
$script:WIA_ERROR_PAPER_EMPTY                  = 0x80210003
$script:WIA_ERROR_BUSY                         = 0x80210006
# (Sicherheitsgrenze fuer Endlos-Scans: siehe $MaxSeitenProScan oben in der
# KONFIGURATION - Vorfall: Scanner hat trotz leerem Einzug immer weitergescannt.)
$script:WIA_IPA_DATATYPE                       = 4103
$script:WIA_DATA_COLOR                         = 2
$script:WIA_DATA_GRAYSCALE                     = 1
$script:WIA_IPS_CUR_INTENT                     = 6146
$script:WIA_INTENT_IMAGE_TYPE_COLOR            = 1
$script:WIA_INTENT_IMAGE_TYPE_GRAYSCALE        = 2

# Merkt sich pro Scanner (DeviceID) seine Faehigkeiten (Einzug, Duplex) -
# wird beim ersten Scan mit dem jeweiligen Geraet ermittelt und danach im
# Scan-Optionen-Fenster genutzt (Einzug/Duplex nur waehlbar, wenn vorhanden).
$script:ScannerFaehigkeiten = @{}
$script:LetzteScanDpiX = 0
# Farbmodus des gerade abgelegten Scans (fuer die Schwarzweiss-PDF) und die
# Helligkeitsgrenze (0-255), unter der ein Bildpunkt schwarz wird. Werden
# helle Schrift/Stempel verschluckt: Wert erhoehen (z.B. 170); wird der
# Hintergrund fleckig: verringern (z.B. 130).
$script:LetzteScanFarbe = ""
$script:SchwarzweissSchwelle = 150
$script:LetzteScanDpiY = 0

# Dateien fuer gemerkte Werte (liegen neben der Log-Datei)
$script:DatenOrdner                = Split-Path $LogDatei -Parent
$script:Dino1Dateiname             = "Dino1Drucker_Ausgabe.pdf"
$script:LetzterScannerDatei        = Join-Path $script:DatenOrdner "LetzterScanner.txt"
$script:ScannerEinstellungenDatei  = Join-Path $script:DatenOrdner "ScannerEinstellungen.json"
$script:BezeichnungenDatei         = Join-Path $script:DatenOrdner "Bezeichnungen.txt"

function Get-WiaEigenschaft($eigenschaften, $propId) {
    foreach ($p in $eigenschaften) {
        if ($p.PropertyID -eq $propId) { return $p }
    }
    return $null
}

# Schreibt alle WIA-Eigenschaften (ID, Name, aktueller Wert, erlaubter
# Bereich/Werteliste) ins Log. Dient NUR der Fehlersuche, wenn sich eine
# Einstellung (z.B. Aufloesung) trotz Auswahl nicht aendert - damit sieht man,
# was der jeweilige Scanner-Treiber tatsaechlich unterstuetzt bzw. meldet.
function Schreibe-WiaEigenschaftenLog($eigenschaften, $bezeichnung) {
    try {
        Schreibe-Log "--- WIA-Eigenschaften ($bezeichnung) ---"
        foreach ($p in $eigenschaften) {
            $subTyp = "?"
            try { $subTyp = $p.SubType } catch {}
            $zusatz = ""
            try {
                if ($p.SubType -eq $script:WIA_PROP_RANGE) {
                    $zusatz = " Bereich=$($p.SubTypeMin)..$($p.SubTypeMax) Schritt=$($p.SubTypeStep)"
                } elseif ($p.SubType -eq $script:WIA_PROP_LIST -and $p.SubTypeValues) {
                    $werteListe = @()
                    foreach ($v in $p.SubTypeValues) { $werteListe += $v }
                    $zusatz = " Werte=" + ($werteListe -join ",")
                }
            } catch {}
            $wert = "?"
            try { $wert = $p.Value } catch {}
            try {
                Schreibe-Log "  ID=$($p.PropertyID) Name='$($p.Name)' Wert=$wert SubType=$subTyp$zusatz"
            } catch {}
        }
    } catch {
        Schreibe-Log "  (Fehler beim Protokollieren der WIA-Eigenschaften: $($_.Exception.Message))"
    }
}

# Setzt einen WIA-Wert so, dass er tatsaechlich vom Scanner akzeptiert wird:
# bei einer Werteliste (z.B. feste Aufloesungsstufen) wird der naechstgelegene
# erlaubte Wert gewaehlt, bei einem Wertebereich wird auf Min/Max begrenzt.
# Ohne das hat sich gezeigt, dass ein nicht exakt passender Wert vom Treiber
# stillschweigend abgelehnt wird und der Scanner einfach bei seiner eigenen
# Standardeinstellung bleibt (aendert sich dann trotz Auswahl nie etwas).
function Setze-WiaWertPassend($prop, $zielWert) {
    if (-not $prop) { return }
    try {
        if ($prop.SubType -eq $script:WIA_PROP_LIST -and $prop.SubTypeValues) {
            $bester = $null
            $besterAbstand = [double]::MaxValue
            foreach ($v in $prop.SubTypeValues) {
                $abstand = [Math]::Abs([double]$v - [double]$zielWert)
                if ($abstand -lt $besterAbstand -or ($abstand -eq $besterAbstand -and [double]$v -gt [double]$bester)) { $besterAbstand = $abstand; $bester = $v }
            }
            if ($null -ne $bester) { $prop.Value = $bester; return }
        }
        if ($prop.SubType -eq $script:WIA_PROP_RANGE) {
            $wert = $zielWert
            if ($null -ne $prop.SubTypeMin -and $wert -lt $prop.SubTypeMin) { $wert = $prop.SubTypeMin }
            if ($null -ne $prop.SubTypeMax -and $wert -gt $prop.SubTypeMax) { $wert = $prop.SubTypeMax }
            $prop.Value = [int]$wert
            return
        }
        $prop.Value = [int]$zielWert
    } catch {}
}

# Legt VOR dem Scannen ausdruecklich fest, ob in Farbe, Graustufen oder
# Schwarzweiss gescannt werden soll. Ohne diese ausdrueckliche Vorgabe
# waehlen manche Scanner-Treiber von sich aus Graustufen, weil das schneller
# ist und kleinere Dateien erzeugt.
function Setze-WiaFarbmodus($item, $farbe) {
    switch ($farbe) {
        "Graustufen"   { $datenTypWert = 1; $intentWert = 2 }
        "Schwarzweiss" { $datenTypWert = 0; $intentWert = 4 }
        default        { $datenTypWert = 2; $intentWert = 1 }
    }
    try {
        $datenTyp = Get-WiaEigenschaft $item.Properties $script:WIA_IPA_DATATYPE
        if ($datenTyp) { $datenTyp.Value = $datenTypWert }
    } catch {
        Schreibe-Log "HINWEIS: Farbmodus '$farbe' wird vom Scanner evtl. nicht unterstuetzt: $($_.Exception.Message)"
    }
    try {
        $intent = Get-WiaEigenschaft $item.Properties $script:WIA_IPS_CUR_INTENT
        if ($intent) { $intent.Value = $intentWert }
    } catch {}
}

# Liefert alle Scanner, die Windows ueber WIA kennt (Name + DeviceID). Es
# wird dabei noch KEINE Verbindung zu einem Geraet aufgebaut - nur die Liste
# abgefragt, das ist auch bei Netzwerk-Scannern unkritisch.
function Get-GefundeneScanner {
    $liste = New-Object System.Collections.Generic.List[object]
    try {
        $manager = New-Object -ComObject WIA.DeviceManager
    } catch {
        Schreibe-Log "FEHLER: WIA-Geraeteverwaltung nicht verfuegbar: $($_.Exception.Message)"
        return ,$liste
    }

    Schreibe-Log "--- Gefundene WIA-Geraete ---"
    foreach ($di in $manager.DeviceInfos) {
        $name = ""
        try { $name = [string]$di.Properties.Item("Name").Value } catch {}
        Schreibe-Log "  DeviceID=$($di.DeviceID) Name='$name' Type=$($di.Type)"
        if ($di.Type -ne 1) { continue }   # 1 = Scanner
        [void]$liste.Add([PSCustomObject]@{ Name = $name; DeviceID = [string]$di.DeviceID })
    }
    return ,$liste
}

# Baut die Eintraege fuer das Scanner-Auswahlfeld zusammen:
#   1. die hinterlegten Scanner aus $ScannerListe (in der eingetragenen
#      Reihenfolge) - auch wenn sie gerade nicht gefunden werden, damit man
#      sieht, dass z.B. ein Geraet ausgeschaltet ist
#   2. falls $AuchNichtHinterlegteScanner (oder gar nichts hinterlegt ist):
#      alle weiteren gefundenen Scanner unter ihrem Windows-Namen; dabei die
#      herstellereigenen Treiber vor den generischen "WSD"-Treibern (die sind
#      bei Netzwerk-Multifunktionsgeraeten (z.B. Samsung/HP) deutlich
#      langsamer, weil sie pro Seite neu die Verbindung aushandeln).
function Ermittle-ScannerAuswahl {
    $gefunden = Get-GefundeneScanner
    $eintraege = New-Object System.Collections.Generic.List[object]
    $vergeben = @{}
    $anzeigeNamen = @{}

    foreach ($anzeige in $ScannerListe.Keys) {
        $muster = ([string]$ScannerListe[$anzeige]).Trim()
        $treffer = $null
        # Zuerst exakter Name, danach "Name enthaelt den Text"
        foreach ($g in $gefunden) {
            if ($vergeben.ContainsKey($g.DeviceID)) { continue }
            if ($g.Name -ieq $muster) { $treffer = $g; break }
        }
        if (-not $treffer -and $muster) {
            foreach ($g in $gefunden) {
                if ($vergeben.ContainsKey($g.DeviceID)) { continue }
                if ($g.Name.IndexOf($muster, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) { $treffer = $g; break }
            }
        }

        $anzeigeNamen[$anzeige] = $true
        if ($treffer) {
            $vergeben[$treffer.DeviceID] = $true
            [void]$eintraege.Add([PSCustomObject]@{ Anzeige = $anzeige; GeraeteName = $treffer.Name; DeviceID = $treffer.DeviceID; Gefunden = $true })
            Schreibe-Log "Hinterlegter Scanner '$anzeige' (Suchtext '$muster') -> gefunden: '$($treffer.Name)'"
        } else {
            [void]$eintraege.Add([PSCustomObject]@{ Anzeige = $anzeige; GeraeteName = $muster; DeviceID = $null; Gefunden = $false })
            Schreibe-Log "Hinterlegter Scanner '$anzeige' (Suchtext '$muster') -> derzeit NICHT gefunden"
        }
    }

    if ($AuchNichtHinterlegteScanner -or $ScannerListe.Count -eq 0) {
        $rest = @($gefunden | Where-Object { -not $vergeben.ContainsKey($_.DeviceID) })
        # Reihenfolge: Herstellertreiber zuerst, dann generische "WSD"-Treiber,
        # ganz zum Schluss die von Windows automatisch angelegten eSCL-/AirScan-
        # Eintraege (DeviceID "SWD\Escl\..."). Letztere koennen z.B. beim
        # Brother MFC-L3770CDW kein Schwarzweiss und brechen dann mit
        # "Interner Serverfehler (500)" ab - sie werden deshalb gekennzeichnet.
        $istEscl = { param($g) [string]$g.DeviceID -match '^SWD\\Escl' }
        $sortiert = @($rest | Where-Object { -not (& $istEscl $_) -and $_.Name -notmatch "WSD" }) +
                    @($rest | Where-Object { -not (& $istEscl $_) -and $_.Name -match "WSD" }) +
                    @($rest | Where-Object { & $istEscl $_ })
        foreach ($g in $sortiert) {
            $anzeige = if ([string]::IsNullOrWhiteSpace($g.Name)) { "Scanner" } else { $g.Name }
            $eingeschraenkt = [bool](& $istEscl $g)
            if ($eingeschraenkt) { $anzeige = "$anzeige (Windows-Treiber, eingeschraenkt)" }
            # Zwei gleichnamige Geraete (z.B. gleiches Modell zweimal) unterscheidbar machen
            $basis = $anzeige
            $nr = 2
            while ($anzeigeNamen.ContainsKey($anzeige)) { $anzeige = "$basis ($nr)"; $nr++ }
            $anzeigeNamen[$anzeige] = $true
            [void]$eintraege.Add([PSCustomObject]@{ Anzeige = $anzeige; GeraeteName = $g.Name; DeviceID = $g.DeviceID; Gefunden = $true; Eingeschraenkt = $eingeschraenkt })
        }
    }

    return ,$eintraege
}

function Lese-LetztenScanner {
    try {
        if (Test-Path $script:LetzterScannerDatei) {
            return ([string](Get-Content -Path $script:LetzterScannerDatei -Raw -ErrorAction Stop)).Trim()
        }
    } catch {}
    return ""
}

function Speichere-LetztenScanner($anzeige) {
    try { Set-Content -Path $script:LetzterScannerDatei -Value $anzeige -Encoding UTF8 -Force } catch {}
}

# Zuletzt gewaehlte Scan-Einstellungen je Scanner (Quelle, Duplex, Farbe,
# Aufloesung, Leerseiten) - werden beim naechsten Scan mit demselben Scanner
# wieder vorgeschlagen.
function Lese-ScannerEinstellungen {
    $ergebnis = @{}
    try {
        if (Test-Path $script:ScannerEinstellungenDatei) {
            $json = Get-Content -Path $script:ScannerEinstellungenDatei -Raw -ErrorAction Stop | ConvertFrom-Json
            foreach ($p in $json.PSObject.Properties) { $ergebnis[$p.Name] = $p.Value }
        }
    } catch {
        Schreibe-Log "HINWEIS: Gemerkte Scanner-Einstellungen konnten nicht gelesen werden: $($_.Exception.Message)"
    }
    return $ergebnis
}

function Speichere-ScannerEinstellungen($anzeige, $optionen) {
    try {
        $alle = Lese-ScannerEinstellungen
        $alle[$anzeige] = [PSCustomObject]@{
            Quelle      = $optionen.Quelle
            Duplex      = [bool]$optionen.Duplex
            Farbe       = $optionen.Farbe
            Dpi         = [int]$optionen.Dpi
            LeereSeiten = [bool]$optionen.LeereSeiten
            Trennen     = [bool]$optionen.Trennen
        }
        $alle | ConvertTo-Json -Depth 3 | Set-Content -Path $script:ScannerEinstellungenDatei -Encoding UTF8 -Force
    } catch {
        Schreibe-Log "HINWEIS: Scanner-Einstellungen konnten nicht gespeichert werden: $($_.Exception.Message)"
    }
}

# Verbindet sich mit dem im Scan-Optionen-Fenster ausgewaehlten Scanner
# (ueber seine DeviceID) und ermittelt, ob ein automatischer Einzug (ADF)
# und Duplex vorhanden sind.
function Verbinde-Scanner($deviceId) {
    $manager = New-Object -ComObject WIA.DeviceManager
    $deviceInfo = $null
    foreach ($di in $manager.DeviceInfos) {
        if ([string]$di.DeviceID -eq $deviceId) { $deviceInfo = $di; break }
    }
    if ($null -eq $deviceInfo) {
        throw "Der ausgewaehlte Scanner ist gerade nicht erreichbar. Bitte pruefen, ob er eingeschaltet und angeschlossen bzw. im Netzwerk ist."
    }

    $gewaehlterName = "?"
    try { $gewaehlterName = $deviceInfo.Properties.Item("Name").Value } catch {}
    Schreibe-Log "Verwendetes Scanner-Geraet: '$gewaehlterName' (DeviceID=$($deviceInfo.DeviceID))"

    $device = $deviceInfo.Connect()
    $item = $device.Items.Item(1)

    $faehigkeiten = 0
    $capProp = Get-WiaEigenschaft $device.Properties $script:WIA_DPS_DOCUMENT_HANDLING_CAPABILITIES
    if ($capProp) { try { $faehigkeiten = [int]$capProp.Value } catch {} }
    $hatEinzug = [bool]($faehigkeiten -band $script:WIA_EINZUG_FLAG)
    $hatDuplex = [bool]($faehigkeiten -band $script:WIA_DUPLEX_FLAG)
    Schreibe-Log "Faehigkeiten des Scanners: Einzug=$hatEinzug Duplex=$hatDuplex (Wert $faehigkeiten)"

    return [PSCustomObject]@{ Device = $device; Item = $item; HatEinzug = $hatEinzug; HatDuplex = $hatDuplex; Faehigkeiten = $faehigkeiten }
}

# Zeigt vor dem eigentlichen Scannen das Fenster "Scan-Optionen": Scanner,
# Quelle (Einzug/Flachbett), Duplex, Farbe, Qualitaet, Leerseiten. Vorgaben:
# zuletzt fuer diesen Scanner benutzte Werte, sonst die Werte aus der
# KONFIGURATION. Ist von einem Scanner bekannt, dass er keinen Einzug bzw.
# kein Duplex hat, ist die jeweilige Option ausgegraut.
function Zeige-ScanOptionenDialog($scannerEintraege, $vorauswahlAnzeige) {
    $gemerkt = Lese-ScannerEinstellungen
    $dpiWerte  = @(150, 200, 300)
    $farbWerte = @("Farbe", "Graustufen", "Schwarzweiss")

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Scan-Optionen"
    $form.ClientSize = New-Object System.Drawing.Size(400, 350)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.Topmost = $true

    $lblScanner = New-Object System.Windows.Forms.Label
    $lblScanner.Text = "Scanner:"
    $lblScanner.Location = New-Object System.Drawing.Point(15, 18)
    $lblScanner.AutoSize = $true
    $form.Controls.Add($lblScanner)

    $cmbScanner = New-Object System.Windows.Forms.ComboBox
    $cmbScanner.Location = New-Object System.Drawing.Point(110, 15)
    $cmbScanner.Width = 275
    $cmbScanner.DropDownStyle = "DropDownList"
    $startIndex = -1
    for ($i = 0; $i -lt $scannerEintraege.Count; $i++) {
        $e = $scannerEintraege[$i]
        $text = if ($e.Gefunden) { $e.Anzeige } else { "$($e.Anzeige)  (nicht gefunden)" }
        [void]$cmbScanner.Items.Add($text)
        if ($startIndex -lt 0 -and $e.Gefunden -and $e.Anzeige -eq $vorauswahlAnzeige) { $startIndex = $i }
    }
    # Ohne gemerkten Scanner: ersten gefundenen Scanner mit Herstellertreiber
    # vorauswaehlen, erst danach einen eingeschraenkten Windows-Treiber.
    if ($startIndex -lt 0) {
        for ($i = 0; $i -lt $scannerEintraege.Count; $i++) {
            if ($scannerEintraege[$i].Gefunden -and -not $scannerEintraege[$i].Eingeschraenkt) { $startIndex = $i; break }
        }
    }
    if ($startIndex -lt 0) {
        for ($i = 0; $i -lt $scannerEintraege.Count; $i++) {
            if ($scannerEintraege[$i].Gefunden) { $startIndex = $i; break }
        }
    }
    if ($startIndex -lt 0) { $startIndex = 0 }
    $form.Controls.Add($cmbScanner)

    $lblGeraet = New-Object System.Windows.Forms.Label
    $lblGeraet.Location = New-Object System.Drawing.Point(110, 42)
    $lblGeraet.Size = New-Object System.Drawing.Size(275, 18)
    $lblGeraet.ForeColor = [System.Drawing.Color]::DimGray
    $form.Controls.Add($lblGeraet)

    $grpQuelle = New-Object System.Windows.Forms.GroupBox
    $grpQuelle.Text = "Quelle"
    $grpQuelle.Location = New-Object System.Drawing.Point(15, 66)
    $grpQuelle.Size = New-Object System.Drawing.Size(370, 95)
    $form.Controls.Add($grpQuelle)

    $radEinzug = New-Object System.Windows.Forms.RadioButton
    $radEinzug.Text = "Automatischer Einzug (mehrere Seiten)"
    $radEinzug.Location = New-Object System.Drawing.Point(10, 20)
    $radEinzug.AutoSize = $true
    $grpQuelle.Controls.Add($radEinzug)

    $chkDuplex = New-Object System.Windows.Forms.CheckBox
    $chkDuplex.Text = "Beidseitig (Vorder- und Rueckseite)"
    $chkDuplex.Location = New-Object System.Drawing.Point(30, 42)
    $chkDuplex.AutoSize = $true
    $grpQuelle.Controls.Add($chkDuplex)

    $radFlachbett = New-Object System.Windows.Forms.RadioButton
    $radFlachbett.Text = "Flachbett (eine Seite auflegen)"
    $radFlachbett.Location = New-Object System.Drawing.Point(10, 66)
    $radFlachbett.AutoSize = $true
    $grpQuelle.Controls.Add($radFlachbett)

    $lblFarbe = New-Object System.Windows.Forms.Label
    $lblFarbe.Text = "Farbe:"
    $lblFarbe.Location = New-Object System.Drawing.Point(15, 178)
    $lblFarbe.AutoSize = $true
    $form.Controls.Add($lblFarbe)

    $cmbFarbe = New-Object System.Windows.Forms.ComboBox
    $cmbFarbe.Location = New-Object System.Drawing.Point(110, 175)
    $cmbFarbe.Width = 275
    $cmbFarbe.DropDownStyle = "DropDownList"
    [void]$cmbFarbe.Items.Add("Farbe")
    [void]$cmbFarbe.Items.Add("Graustufen")
    [void]$cmbFarbe.Items.Add("Schwarzweiss (Text, kleinste Datei)")
    $form.Controls.Add($cmbFarbe)

    $lblQualitaet = New-Object System.Windows.Forms.Label
    $lblQualitaet.Text = "Qualitaet:"
    $lblQualitaet.Location = New-Object System.Drawing.Point(15, 210)
    $lblQualitaet.AutoSize = $true
    $form.Controls.Add($lblQualitaet)

    $cmbQualitaet = New-Object System.Windows.Forms.ComboBox
    $cmbQualitaet.Location = New-Object System.Drawing.Point(110, 207)
    $cmbQualitaet.Width = 275
    $cmbQualitaet.DropDownStyle = "DropDownList"
    [void]$cmbQualitaet.Items.Add("Schnell / kleine Datei (150 dpi)")
    [void]$cmbQualitaet.Items.Add("Standard (200 dpi)")
    [void]$cmbQualitaet.Items.Add("Fein / hohe Qualitaet (300 dpi)")
    $form.Controls.Add($cmbQualitaet)

    $chkLeer = New-Object System.Windows.Forms.CheckBox
    $chkLeer.Text = "Leere Seiten automatisch entfernen"
    $chkLeer.Location = New-Object System.Drawing.Point(110, 240)
    $chkLeer.AutoSize = $true
    $form.Controls.Add($chkLeer)

    # Stapel trennen: zwischen die Dokumente jeweils ein leeres Blatt legen
    $chkTrennen = New-Object System.Windows.Forms.CheckBox
    $chkTrennen.Text = "Stapel an leeren Blaettern in Dokumente trennen"
    $chkTrennen.Location = New-Object System.Drawing.Point(110, 263)
    $chkTrennen.AutoSize = $true
    $form.Controls.Add($chkTrennen)
    $tipTrennen = New-Object System.Windows.Forms.ToolTip
    $tipTrennen.SetToolTip($chkTrennen, "Mehrere Dokumente auf einmal einlegen, dazwischen jeweils ein leeres Blatt.`nJedes Dokument wird einzeln abgelegt und abgefragt; die leeren Blaetter fallen weg.")

    $aktualisiereDuplex = {
        $idx = $cmbScanner.SelectedIndex
        $duplexMoeglich = $true
        if ($idx -ge 0) {
            $e = $scannerEintraege[$idx]
            if ($e.DeviceID -and $script:ScannerFaehigkeiten.ContainsKey($e.DeviceID)) {
                $duplexMoeglich = [bool]($script:ScannerFaehigkeiten[$e.DeviceID] -band $script:WIA_DUPLEX_FLAG)
            }
        }
        $chkDuplex.Enabled = ($radEinzug.Checked -and $radEinzug.Enabled -and $duplexMoeglich)
        if (-not $duplexMoeglich) { $chkDuplex.Checked = $false }
        $chkTrennen.Enabled = ($radEinzug.Checked -and $radEinzug.Enabled)
    }

    # Bei Scannerwechsel: Hinweiszeile, Einzug/Duplex-Verfuegbarkeit und die
    # fuer diesen Scanner gemerkten (bzw. Standard-) Einstellungen setzen
    $aktualisiere = {
        $idx = $cmbScanner.SelectedIndex
        if ($idx -lt 0) { return }
        $e = $scannerEintraege[$idx]
        if ($e.Gefunden) {
            $lblGeraet.Text = "Geraet: $($e.GeraeteName)"
            $lblGeraet.ForeColor = [System.Drawing.Color]::DimGray
        } else {
            $lblGeraet.Text = "Nicht gefunden - eingeschaltet / angeschlossen?"
            $lblGeraet.ForeColor = [System.Drawing.Color]::Firebrick
        }

        $quelle = "Einzug"; $duplex = $DuplexStandard; $farbe = $ScanFarbmodus
        $dpi = $ScanStandardDpi; $leer = $LeereSeitenEntfernen; $trennen = $false
        if ($gemerkt.ContainsKey($e.Anzeige)) {
            $g = $gemerkt[$e.Anzeige]
            if ($g.Quelle) { $quelle = $g.Quelle }
            if ($null -ne $g.Duplex) { $duplex = [bool]$g.Duplex }
            if ($g.Farbe) { $farbe = $g.Farbe }
            if ($g.Dpi) { $dpi = [int]$g.Dpi }
            if ($null -ne $g.LeereSeiten) { $leer = [bool]$g.LeereSeiten }
            if ($null -ne $g.Trennen) { $trennen = [bool]$g.Trennen }
        }

        $einzugMoeglich = $true
        if ($e.DeviceID -and $script:ScannerFaehigkeiten.ContainsKey($e.DeviceID)) {
            $einzugMoeglich = [bool]($script:ScannerFaehigkeiten[$e.DeviceID] -band $script:WIA_EINZUG_FLAG)
        }
        $radEinzug.Enabled = $einzugMoeglich
        if ($einzugMoeglich -and $quelle -eq "Einzug") { $radEinzug.Checked = $true } else { $radFlachbett.Checked = $true }
        $chkDuplex.Checked = $duplex

        $fi = [array]::IndexOf($farbWerte, [string]$farbe)
        $cmbFarbe.SelectedIndex = if ($fi -ge 0) { $fi } else { 0 }

        # naechstgelegene Aufloesungsstufe
        $bester = 1; $abstand = [int]::MaxValue
        for ($k = 0; $k -lt $dpiWerte.Count; $k++) {
            $a = [Math]::Abs($dpiWerte[$k] - [int]$dpi)
            if ($a -lt $abstand) { $abstand = $a; $bester = $k }
        }
        $cmbQualitaet.SelectedIndex = $bester
        $chkLeer.Checked = $leer
        $chkTrennen.Checked = $trennen
        & $aktualisiereDuplex
    }
    $cmbScanner.Add_SelectedIndexChanged($aktualisiere)
    $radEinzug.Add_CheckedChanged($aktualisiereDuplex)
    $cmbScanner.SelectedIndex = $startIndex
    & $aktualisiere

    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Text = "Scannen"
    $btnOK.Size = New-Object System.Drawing.Size(110, 32)
    $btnOK.Location = New-Object System.Drawing.Point(155, 303)
    $btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $btnOK.Add_Click({
        $e = $scannerEintraege[$cmbScanner.SelectedIndex]
        if (-not $e.Gefunden) {
            [System.Windows.Forms.MessageBox]::Show(
                "Der Scanner '$($e.Anzeige)' wurde auf diesem PC gerade nicht gefunden.`n`nBitte pruefen, ob er eingeschaltet und angeschlossen bzw. im Netzwerk erreichbar ist, oder einen anderen Scanner auswaehlen.",
                "Scanner nicht gefunden",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            $form.DialogResult = [System.Windows.Forms.DialogResult]::None
        }
    })
    $form.Controls.Add($btnOK)

    $btnAbbrechen = New-Object System.Windows.Forms.Button
    $btnAbbrechen.Text = "Abbrechen"
    $btnAbbrechen.Size = New-Object System.Drawing.Size(110, 32)
    $btnAbbrechen.Location = New-Object System.Drawing.Point(275, 303)
    $btnAbbrechen.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($btnAbbrechen)

    $form.AcceptButton = $btnOK
    $form.CancelButton = $btnAbbrechen

    $ergebnis = $form.ShowDialog()
    if ($ergebnis -ne [System.Windows.Forms.DialogResult]::OK) { return $null }

    $istEinzug = ($radEinzug.Checked -and $radEinzug.Enabled)
    return [PSCustomObject]@{
        Scanner     = $scannerEintraege[$cmbScanner.SelectedIndex]
        Quelle      = if ($istEinzug) { "Einzug" } else { "Flachbett" }
        Duplex      = ($istEinzug -and $chkDuplex.Checked -and $chkDuplex.Enabled)
        Farbe       = $farbWerte[$cmbFarbe.SelectedIndex]
        Dpi         = $dpiWerte[$cmbQualitaet.SelectedIndex]
        LeereSeiten = $chkLeer.Checked
        Trennen     = ($istEinzug -and $chkTrennen.Checked)
    }
}

# Setzt Quelle (Einzug/Flachbett, ggf. Duplex), Aufloesung und Farbmodus
# gemaess der im Dialog getroffenen Auswahl. Nicht unterstuetzte Werte werden
# stillschweigend uebersprungen (Geraet behaelt dann seinen Standardwert),
# damit ein einzelner nicht unterstuetzter Wert nicht den ganzen Scan zum
# Absturz bringt. Die tatsaechlich eingestellte Aufloesung wird in
# $script:LetzteScanDpiX/Y gemerkt (fuer die richtige Seitengroesse der PDF).
function Wende-ScanOptionenAn($device, $item, $optionen) {
    Schreibe-Log "Scan-Optionen gewaehlt: Quelle=$($optionen.Quelle), Duplex=$($optionen.Duplex), Farbe=$($optionen.Farbe), gewuenschte DPI=$($optionen.Dpi), LeereSeitenEntfernen=$($optionen.LeereSeiten)"
    if ($AusfuehrlichesScanLog) { Schreibe-WiaEigenschaftenLog $item.Properties "Scan-Item VOR Anwendung" }

    # Die von Windows automatisch eingerichteten eSCL-/AirScan-Treiber (DeviceID
    # "SWD\Escl\...") koennen bei vielen Geraeten (z.B. Brother MFC-L3770CDW)
    # kein echtes Schwarzweiss: der Scanner zieht das Blatt ein, liefert aber
    # kein Bild, und danach antwortet er nur noch mit "Interner Serverfehler
    # (500)". Dort wird deshalb automatisch in Graustufen gescannt.
    $farbe = $optionen.Farbe
    if ($farbe -eq "Schwarzweiss" -and [string]$optionen.Scanner.DeviceID -match '^SWD\\Escl') {
        Schreibe-Log "HINWEIS: '$($optionen.Scanner.Anzeige)' ist ein eSCL-/AirScan-Geraet - Schwarzweiss wird dort nicht zuverlaessig unterstuetzt, es wird in Graustufen gescannt."
        $farbe = "Graustufen"
    }
    Setze-WiaFarbmodus $item $farbe

    $quelleFlag = if ($optionen.Quelle -eq "Einzug") { $script:WIA_EINZUG_FLAG } else { $script:WIA_FLACHBETT_FLAG }
    if ($optionen.Quelle -eq "Einzug" -and $optionen.Duplex) { $quelleFlag = $quelleFlag -bor $script:WIA_DUPLEX_FLAG }
    try {
        $selectProp = Get-WiaEigenschaft $device.Properties $script:WIA_DPS_DOCUMENT_HANDLING_SELECT
        if ($selectProp) {
            $vorherigerWert = $selectProp.Value
            try {
                $selectProp.Value = $quelleFlag
            } catch {
                if ($quelleFlag -band $script:WIA_DUPLEX_FLAG) {
                    Schreibe-Log "WARNUNG: Duplex wurde vom Scanner abgelehnt - es wird nur einseitig gescannt."
                    $selectProp.Value = $script:WIA_EINZUG_FLAG
                } else { throw }
            }
            Schreibe-Log "Quelle (Document Handling Select) gesetzt: vorher=$vorherigerWert angefordert=$quelleFlag jetzt=$($selectProp.Value)"
        } else {
            Schreibe-Log "WARNUNG: WIA-Eigenschaft 'Document Handling Select' (ID $($script:WIA_DPS_DOCUMENT_HANDLING_SELECT)) wurde auf diesem Geraet nicht gefunden - Quelle (Einzug/Flachbett) konnte NICHT umgeschaltet werden."
        }
    } catch {
        Schreibe-Log "WARNUNG: Quelle (Document Handling Select) konnte nicht gesetzt werden: $($_.Exception.Message)"
    }

    # Aufloesung setzen - ueber Setze-WiaWertPassend, damit ein vom Scanner
    # nicht exakt unterstuetzter Wert nicht stillschweigend verworfen wird,
    # sondern der naechstgelegene erlaubte Wert verwendet wird.
    $xresProp = Get-WiaEigenschaft $item.Properties $script:WIA_IPS_XRES
    if (-not $xresProp) { Schreibe-Log "WARNUNG: WIA-Eigenschaft XRES (ID $($script:WIA_IPS_XRES)) nicht gefunden - Aufloesung kann nicht gesetzt werden." }
    Setze-WiaWertPassend $xresProp $optionen.Dpi
    $yresProp = Get-WiaEigenschaft $item.Properties $script:WIA_IPS_YRES
    if (-not $yresProp) { Schreibe-Log "WARNUNG: WIA-Eigenschaft YRES (ID $($script:WIA_IPS_YRES)) nicht gefunden - Aufloesung kann nicht gesetzt werden." }
    Setze-WiaWertPassend $yresProp $optionen.Dpi

    # Tatsaechlich uebernommene Aufloesung auslesen (kann vom Wunschwert
    # abweichen) und darauf basierend den vollen A4-Scanbereich anfordern -
    # sonst bleibt der Scanbereich beim vorherigen (u.U. kleineren) Wert und
    # es kommt nur ein Ausschnitt statt der vollen Seite heraus.
    $tatsaechlicheDpiX = if ($xresProp) { [double]$xresProp.Value } else { $optionen.Dpi }
    $tatsaechlicheDpiY = if ($yresProp) { [double]$yresProp.Value } else { $optionen.Dpi }
    $script:LetzteScanDpiX = $tatsaechlicheDpiX
    $script:LetzteScanDpiY = $tatsaechlicheDpiY
    Schreibe-Log "Aufloesung nach dem Setzen: XRES=$tatsaechlicheDpiX YRES=$tatsaechlicheDpiY (angefordert: $($optionen.Dpi))"

    try {
        $xPosProp = Get-WiaEigenschaft $item.Properties $script:WIA_IPS_XPOS
        if ($xPosProp) { $xPosProp.Value = 0 }
    } catch {}
    try {
        $yPosProp = Get-WiaEigenschaft $item.Properties $script:WIA_IPS_YPOS
        if ($yPosProp) { $yPosProp.Value = 0 }
    } catch {}

    $xExtentProp = Get-WiaEigenschaft $item.Properties $script:WIA_IPS_XEXTENT
    if (-not $xExtentProp) { Schreibe-Log "WARNUNG: WIA-Eigenschaft XEXTENT (ID $($script:WIA_IPS_XEXTENT)) nicht gefunden - Scanbereich kann nicht gesetzt werden." }
    $zielXExtent = [int]([Math]::Round($script:A4_BREITE_ZOLL * $tatsaechlicheDpiX))
    Setze-WiaWertPassend $xExtentProp $zielXExtent
    $yExtentProp = Get-WiaEigenschaft $item.Properties $script:WIA_IPS_YEXTENT
    if (-not $yExtentProp) { Schreibe-Log "WARNUNG: WIA-Eigenschaft YEXTENT (ID $($script:WIA_IPS_YEXTENT)) nicht gefunden - Scanbereich kann nicht gesetzt werden." }
    $zielYExtent = [int]([Math]::Round($script:A4_HOEHE_ZOLL * $tatsaechlicheDpiY))
    Setze-WiaWertPassend $yExtentProp $zielYExtent

    $tatsaechlicherXExtent = if ($xExtentProp) { $xExtentProp.Value } else { "?" }
    $tatsaechlicherYExtent = if ($yExtentProp) { $yExtentProp.Value } else { "?" }
    Schreibe-Log "Scanbereich nach dem Setzen: XEXTENT=$tatsaechlicherXExtent YEXTENT=$tatsaechlicherYExtent (angefordert: $zielXExtent x $zielYExtent)"

    if ($AusfuehrlichesScanLog) { Schreibe-WiaEigenschaftenLog $item.Properties "Scan-Item NACH Anwendung" }
}

# Holt EIN Bild vom Scanner. Manche Treiber (z.B. die von Windows automatisch
# eingerichteten eSCL-/AirScan-Netzwerktreiber wie "Brother MFC-L3770CDW
# series") liefern bei $item.Transfer() keinen Fehler, sondern einfach NICHTS
# ($null) - frueher fuehrte das zu "Es ist nicht moeglich, eine Methode fuer
# einen Ausdruck aufzurufen, der den NULL hat". Deshalb hier mehrere Wege
# nacheinander: BMP, PNG, JPEG, zuletzt ueber WIA.CommonDialog (ohne
# sichtbares Fenster). Liefert $null, wenn der Scanner auf keinem Weg ein
# Bild herausgibt.
# $folgeseite = $true: es wurde in diesem Scan schon mindestens eine Seite
# eingelesen. Dann meldet z.B. der Samsung-Treiber bei leerem Einzug nicht
# "Einzug leer", sondern "WIA-Geraet ist ausgelastet" - das wird dann als
# Ende des Stapels gewertet (keine weiteren Formate, kein Windows-
# Scanfenster, das sonst haengen bleiben kann).
function Hole-WiaBild($item, [bool]$folgeseite) {
    $versuche = @(
        @{ Name = "Transfer BMP";     Format = $script:WIA_FORMAT_BMP;  Dialog = $false },
        @{ Name = "Transfer PNG";     Format = $script:WIA_FORMAT_PNG;  Dialog = $false },
        @{ Name = "Transfer JPEG";    Format = $script:WIA_FORMAT_JPEG; Dialog = $false }
    )
    if (-not $folgeseite) { $versuche += @{ Name = "CommonDialog BMP"; Format = $script:WIA_FORMAT_BMP; Dialog = $true } }
    $letzterFehler = $null
    foreach ($v in $versuche) {
        $bild = $null
        try {
            if ($v.Dialog) {
                $dlg = New-Object -ComObject WIA.CommonDialog
                $bild = $dlg.ShowTransfer($item, $v.Format, $false)
            } else {
                $bild = $item.Transfer($v.Format)
            }
        } catch {
            $hr = $_.Exception.HResult
            if (-not $hr -and $_.Exception.InnerException) { $hr = $_.Exception.InnerException.HResult }
            # "Einzug leer" sofort weiterreichen - nicht mit anderen Formaten weiterprobieren
            if ($hr -eq $script:WIA_ERROR_PAPER_EMPTY -or $_.Exception.Message -match "0x80210003") { throw }
            $istBesetzt = ($hr -eq $script:WIA_ERROR_BUSY -or $_.Exception.Message -match "0x80210006|ausgelastet|busy")
            if ($istBesetzt -and $folgeseite) {
                Schreibe-Log "Scan-Abholung '$($v.Name)': Scanner meldet 'ausgelastet' nach der letzten Seite - Einzug gilt als leer."
                throw
            }
            if ($istBesetzt) {
                # Beim ersten Blatt: Scanner kurz in Ruhe lassen, dann einmal neu versuchen
                Schreibe-Log "Scan-Abholung '$($v.Name)': Scanner ausgelastet - neuer Versuch in 3 Sekunden."
                Start-Sleep -Seconds 3
                try {
                    $bild = $item.Transfer($v.Format)
                    if ($null -ne $bild) { return $bild }
                } catch {}
            }
            $letzterFehler = $_
            Schreibe-Log "Scan-Abholung '$($v.Name)' fehlgeschlagen: $($_.Exception.Message)"
            continue
        }
        if ($null -ne $bild) {
            if ($v.Name -ne "Transfer BMP") { Schreibe-Log "Scan-Abholung erfolgreich ueber '$($v.Name)'." }
            return $bild
        }
        # Kein Fehler, aber auch kein Bild: Der Scanner hat das Blatt dann
        # meist schon eingezogen und ist danach in einem Fehlerzustand (weitere
        # Versuche enden nur mit "Interner Serverfehler (500)" bzw. ziehen
        # womoeglich weitere Blaetter ein) - deshalb hier NICHT weiterprobieren.
        Schreibe-Log "Scan-Abholung '$($v.Name)': Scanner hat kein Bild geliefert (NULL) - keine weiteren Versuche."
        return $null
    }
    if ($letzterFehler) { throw $letzterFehler }
    return $null
}

# Liest ueber den automatischen Einzug ALLE eingelegten Seiten nacheinander
# ein, bis der Einzug leer ist - ohne nachzufragen und ohne Seitenzahl-
# Eingabe. Prueft aktiv den Einzugsstatus vor jeder weiteren Seite und
# bricht zusaetzlich spaetestens bei der Sicherheitsgrenze ab, falls ein
# Scanner-Treiber "leer" nicht zuverlaessig meldet. Bei Duplex liefert jeder
# Transfer eine Seite (Vorderseite, Rueckseite, naechste Vorderseite ...).
function Scanne-MitEinzug($device, $item, $maxSeiten) {
    # HINWEIS: Ein Versuch, alle Seiten in einem Rutsch als mehrseitiges TIFF
    # anzufordern (WIA_DPS_PAGES=0), wurde getestet, um die Geschwindigkeit
    # der Original-Hersteller-Software nachzubilden. Das hat sich bei diesem
    # Scanner (Samsung Universal Scan Driver) leider NICHT sicher verhalten:
    # der fehlgeschlagene Versuch hat die Verbindung zum Geraet in einen
    # ungueltigen Zustand versetzt, sodass danach auch der bewaehrte Seite-
    # fuer-Seite-Weg fehlschlug ("Falscher Parameter"). Deshalb bewusst
    # zurueckgebaut auf den einfachen, zuverlaessigen Seite-fuer-Seite-Ablauf.
    $ergebnisDateien = New-Object System.Collections.Generic.List[string]
    $seitenNr = 0
    $weiter = $true

    while ($weiter) {
        if ($seitenNr -gt 0) {
            $statusProp = Get-WiaEigenschaft $device.Properties $script:WIA_DPS_DOCUMENT_HANDLING_STATUS
            if ($statusProp -and (-not ([int]$statusProp.Value -band $script:WIA_EINZUG_BEREIT_FLAG))) {
                break   # Einzug meldet: kein Papier mehr eingelegt
            }
        }

        if ($seitenNr -ge $maxSeiten) {
            Schreibe-Log "WARNUNG: Sicherheitsgrenze von $maxSeiten Seiten erreicht - Scan wurde automatisch gestoppt (Einzugsstatus wurde vom Scanner-Treiber evtl. nicht korrekt gemeldet)."
            break
        }

        # Zeitmessung getrennt fuer Transfer (Scanner-Hardware/Treiber) und
        # Speichern (unser eigener Code) - damit sich klaeren laesst, ob eine
        # spuerbare Verzoegerung am Scanner/Treiber liegt (nicht per Software
        # beeinflussbar) oder an unserem Skript (dann behebbar).
        $zeitmesser = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            $bild = Hole-WiaBild $item ($seitenNr -gt 0)
        } catch {
            $hResult = $_.Exception.HResult
            if (-not $hResult -and $_.Exception.InnerException) { $hResult = $_.Exception.InnerException.HResult }
            if ($seitenNr -gt 0 -and ($hResult -eq $script:WIA_ERROR_PAPER_EMPTY -or $_.Exception.Message -match "0x80210003")) {
                break   # Einzug ist leer - alle Seiten wurden erfasst
            }
            if ($seitenNr -eq 0) { throw }
            Schreibe-Log "Einzug: nach $seitenNr Seite(n) keine weitere Seite ($($_.Exception.Message)) - Scan beendet."
            break
        }
        if ($null -eq $bild) {
            if ($seitenNr -gt 0) { break }   # kein weiteres Bild -> Einzug vermutlich leer
            throw "Der Scanner hat kein Bild geliefert. Bitte als Farbe 'Graustufen' oder 'Farbe' statt 'Schwarzweiss' waehlen oder einen anderen Eintrag fuer diesen Scanner nehmen (z.B. '... LAN' statt '... series' - das ist der Herstellertreiber). Details im Log."
        }
        $transferSekunden = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1)

        $zeitmesser.Restart()
        $seitenNr++
        $tempBild = Join-Path $ScanTempOrdner "scan_$(Get-Date -Format 'yyyyMMdd_HHmmss')_seite$seitenNr.bmp"
        $bild.SaveFile($tempBild)
        [void]$ergebnisDateien.Add($tempBild)
        $speichernSekunden = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1)
        Schreibe-Log "Seite $seitenNr erfasst: $tempBild (Scan/Transfer: ${transferSekunden}s, Speichern: ${speichernSekunden}s)"
    }

    # WICHTIG: Komma-Operator davor! Ohne ihn wickelt PowerShell eine Liste
    # mit GENAU EINEM Element beim Zurueckgeben automatisch aus, sodass der
    # Aufrufer statt einer Liste nur noch die nackte Zeichenkette (den Datei-
    # pfad) erhaelt. Das fuehrte bei Einzelseiten-Scans zu dem Fehler
    # "FromFile mit 1 Argument(en): C" (Index [0] griff dann auf den ersten
    # BUCHSTABEN des Pfades zu statt auf den Pfad selbst).
    return ,$ergebnisDateien
}

# Liest eine Seite vom Flachbett ein und fragt danach, ob eine weitere Seite
# aufgelegt werden soll (Flachbett kann technisch immer nur eine Seite pro
# Durchgang lesen).
function Scanne-VonFlachbett($item) {
    $ergebnisDateien = New-Object System.Collections.Generic.List[string]
    $seitenNr = 0
    $weiter = $true

    while ($weiter) {
        $zeitmesser = [System.Diagnostics.Stopwatch]::StartNew()
        $bild = Hole-WiaBild $item
        if ($null -eq $bild) {
            throw "Der Scanner hat kein Bild geliefert. Bitte als Farbe 'Graustufen' oder 'Farbe' statt 'Schwarzweiss' waehlen oder einen anderen Eintrag fuer diesen Scanner nehmen (z.B. '... LAN' statt '... series' - das ist der Herstellertreiber). Details im Log."
        }
        $transferSekunden = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1)

        $zeitmesser.Restart()
        $seitenNr++
        $tempBild = Join-Path $ScanTempOrdner "scan_$(Get-Date -Format 'yyyyMMdd_HHmmss')_seite$seitenNr.bmp"
        $bild.SaveFile($tempBild)
        [void]$ergebnisDateien.Add($tempBild)
        $speichernSekunden = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1)
        Schreibe-Log "Seite $seitenNr erfasst: $tempBild (Scan/Transfer: ${transferSekunden}s, Speichern: ${speichernSekunden}s)"

        $antwort = [System.Windows.Forms.MessageBox]::Show(
            "Seite $seitenNr wurde gescannt.`n`nNoch eine Seite auflegen und scannen (z.B. bei einem mehrseitigen Vertrag)?",
            "Weitere Seite scannen?",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question)
        $weiter = ($antwort -eq [System.Windows.Forms.DialogResult]::Yes)
    }

    # Siehe Kommentar in Scanne-MitEinzug: Komma-Operator noetig, damit eine
    # Liste mit nur einem Element nicht zu einer nackten Zeichenkette wird.
    return ,$ergebnisDateien
}

# Entfernt leere Seiten (z.B. leere Rueckseiten beim Duplex-Scan). Gemessen
# wird der Anteil dunkler Bildpunkte; liegt er unter $LeereSeiteSchwelle
# (Prozent), gilt die Seite als leer. Sicherheitsnetz: Waeren ALLE Seiten
# leer, wird nichts entfernt (dann lieber eine leere PDF als gar keine).
function Entferne-LeereSeiten($seitenDateien) {
    $behalten = New-Object System.Collections.Generic.List[string]
    $entfernen = New-Object System.Collections.Generic.List[string]
    $nr = 0
    foreach ($f in $seitenDateien) {
        $nr++
        $anteil = 100.0
        try { $anteil = [PpeBild]::DunkelAnteil($f) } catch { Schreibe-Log "Leerseiten-Pruefung Seite ${nr} fehlgeschlagen: $($_.Exception.Message) - Seite bleibt erhalten." }
        $istLeer = ($anteil -lt [double]$LeereSeiteSchwelle)
        Schreibe-Log ("Leerseiten-Pruefung Seite {0}: {1:N3} % dunkle Bildpunkte (Schwelle {2}) -> {3}" -f $nr, $anteil, $LeereSeiteSchwelle, $(if ($istLeer) { "LEER, wird entfernt" } else { "behalten" }))
        if ($istLeer) { [void]$entfernen.Add($f) } else { [void]$behalten.Add($f) }
    }
    if ($behalten.Count -eq 0) {
        Schreibe-Log "Alle Seiten wirken leer - es wird zur Sicherheit KEINE Seite entfernt."
        return ,$seitenDateien
    }
    foreach ($f in $entfernen) { Remove-Item -Path $f -Force -ErrorAction SilentlyContinue }
    return ,$behalten
}

# Teilt einen Stapel an leeren Blaettern in mehrere Dokumente. Bei
# beidseitigem Scan zaehlt ein Blatt nur als Trennblatt, wenn Vorder- UND
# Rueckseite leer sind; leere Rueckseiten innerhalb eines Dokuments fallen
# weg. Rueckgabe: Liste von Seitenlisten (eine pro Dokument).
function Teile-Stapel($seitenDateien, $duplex) {
    $dateien = @($seitenDateien)
    $leer = New-Object System.Collections.Generic.List[bool]
    $nr = 0
    foreach ($f in $dateien) {
        $nr++
        $anteil = 100.0
        try { $anteil = [PpeBild]::DunkelAnteil($f) } catch { Schreibe-Log "Trennblatt-Pruefung Seite ${nr} fehlgeschlagen: $($_.Exception.Message)" }
        [void]$leer.Add($anteil -lt [double]$LeereSeiteSchwelle)
    }
    $schritt = if ($duplex) { 2 } else { 1 }
    $gruppen = New-Object System.Collections.Generic.List[object]
    $aktuell = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $dateien.Count; $i += $schritt) {
        $ende = [Math]::Min($i + $schritt, $dateien.Count) - 1
        $blattLeer = $true
        for ($j = $i; $j -le $ende; $j++) { if (-not $leer[$j]) { $blattLeer = $false } }
        if ($blattLeer) {
            if ($aktuell.Count -gt 0) { [void]$gruppen.Add($aktuell); $aktuell = New-Object System.Collections.Generic.List[string] }
            continue
        }
        for ($j = $i; $j -le $ende; $j++) { if (-not $leer[$j]) { [void]$aktuell.Add($dateien[$j]) } }
    }
    if ($aktuell.Count -gt 0) { [void]$gruppen.Add($aktuell) }
    if ($gruppen.Count -eq 0) {
        Schreibe-Log "Stapel trennen: alle Seiten wirken leer - es wird zur Sicherheit EIN Dokument mit allen Seiten abgelegt."
        $alle = New-Object System.Collections.Generic.List[string]
        foreach ($f in $dateien) { [void]$alle.Add($f) }
        [void]$gruppen.Add($alle)
    }
    Schreibe-Log ("Stapel trennen: {0} Seite(n) -> {1} Dokument(e) ({2})" -f $dateien.Count, $gruppen.Count, (($gruppen | ForEach-Object { "$($_.Count) S." }) -join ", "))
    return ,$gruppen
}

# Erzeugt aus den Seitenbildern EINE PDF und legt sie im Ablage-Ordner ab,
# wo der Watcher sie wie einen normalen Ausdruck erkennt. Die PDF wird erst
# unter einem anderen Namen fertig geschrieben und dann umbenannt, damit der
# Watcher nie eine halbfertige Datei sieht.
function Erzeuge-ScanPdf($seitenDateien, $dpiX, $dpiY, $schwarzweiss) {
    $jpegs  = New-Object System.Collections.Generic.List[byte[]]
    $sw     = New-Object System.Collections.Generic.List[bool]
    $breite = New-Object System.Collections.Generic.List[int]
    $hoehe  = New-Object System.Collections.Generic.List[int]
    $dx     = New-Object System.Collections.Generic.List[double]
    $dy     = New-Object System.Collections.Generic.List[double]
    $texte  = New-Object System.Collections.Generic.List[string]
    $gesamtText = New-Object System.Text.StringBuilder
    $mitOcr = Initialisiere-Ocr
    $seitenNr = 0

    foreach ($f in $seitenDateien) {
        $seitenNr++
        # Bei "Schwarzweiss" echte 1-Bit-Seiten erzeugen - auch wenn der Scanner
        # (z.B. eSCL-Treiber) in Graustufen geliefert hat. Klappt das nicht,
        # wird die Seite wie bisher als JPEG uebernommen.
        $seite = $null
        if ($schwarzweiss) {
            try { $seite = [PpeBild]::LadeAlsSchwarzweiss($f, [int]$script:SchwarzweissSchwelle) }
            catch { Schreibe-Log "HINWEIS: Schwarzweiss-Umwandlung fehlgeschlagen ($($_.Exception.Message)) - Seite wird als JPEG gespeichert." }
        }
        if ($null -eq $seite) { $seite = [PpeBild]::LadeAlsJpeg($f, [long]$PdfBildQualitaet) }
        # Aufloesung: bevorzugt die beim Scanner eingestellte, sonst die aus
        # dem Bild selbst. Fehlt sie bzw. steht dort nur der Windows-Standard
        # 96 dpi, wird die Seite auf A4-Breite (8.27 Zoll) umgerechnet.
        $x = [double]$dpiX; $y = [double]$dpiY
        if ($x -lt 50) { $x = [double]$seite.DpiX; $y = [double]$seite.DpiY }
        if ($x -lt 50 -or $x -gt 2400 -or [Math]::Abs($x - 96) -lt 0.5) {
            $x = $seite.Breite / $script:A4_BREITE_ZOLL
            $y = $x
        }
        if ($y -lt 50 -or $y -gt 2400) { $y = $x }
        [void]$jpegs.Add($seite.Jpeg)
        [void]$sw.Add([bool]$seite.Schwarzweiss)
        [void]$breite.Add($seite.Breite)
        [void]$hoehe.Add($seite.Hoehe)
        [void]$dx.Add($x)
        [void]$dy.Add($y)

        # Texterkennung: unsichtbarer Text ueber dem Scan (durchsuchbare PDF)
        $ebene = $null
        if ($mitOcr) {
            $erkannt = Erkenne-Text $f
            if ($erkannt -and $erkannt.Woerter.Count -gt 0) {
                try {
                    $ebene = [PpePdf]::TextEbene([string[]]$erkannt.Woerter, [double[]]$erkannt.X, [double[]]$erkannt.Y, [double[]]$erkannt.W, [double[]]$erkannt.H, $x, $y, [int]$seite.Hoehe)
                } catch { Schreibe-Log "HINWEIS: Textebene Seite $seitenNr nicht erzeugt: $($_.Exception.Message)" }
                [void]$gesamtText.AppendLine($erkannt.Text)
            }
        }
        [void]$texte.Add($ebene)
    }

    $basis = "Scan_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    if ([int]$script:ScanTeilNr -gt 0) { $basis += "_Teil$($script:ScanTeilNr)" }
    $tempPdf = Join-Path $ScanTempOrdner "$basis.pdf.tmp"
    [PpePdf]::Schreibe($tempPdf, $jpegs.ToArray(), $breite.ToArray(), $hoehe.ToArray(), $dx.ToArray(), $dy.ToArray(), $sw.ToArray(), $texte.ToArray())
    $zielPdf = Get-EindeutigerZielpfad $WatchFolder $basis "pdf"
    # Erkannten Text VOR dem Verschieben ablegen - sobald die PDF im
    # Ablage-Ordner liegt, kann der Watcher sie schon abfragen
    if ($gesamtText.Length -gt 0) {
        try { [System.IO.File]::WriteAllText((Get-OcrTextDatei ([System.IO.Path]::GetFileName($zielPdf))), $gesamtText.ToString()) } catch {}
    }
    Move-Item -Path $tempPdf -Destination $zielPdf -Force
    $groesseKB = [Math]::Round((Get-Item $zielPdf).Length / 1KB)
    $ocrHinweis = if ($gesamtText.Length -gt 0) { ", durchsuchbar" } else { "" }
    Schreibe-Log "PDF erzeugt: $zielPdf ($($jpegs.Count) Seite(n), $groesseKB KB$ocrHinweis)"
    return $zielPdf
}

# Legt die gescannten Seiten im Ablage-Ordner ab: direkt als PDF (Standard)
# oder - wenn so eingestellt bzw. als Ausweich bei einem Fehler - ueber einen
# Drucker aus $ScanDruckerListe. Bricht man die Druckerauswahl ab, gehen die
# Seiten nicht verloren, sondern landen als Bilder im Ausweich-Ordner.
function Lege-ScanAb($seitenDateien, $dpiX, $dpiY, $bezeichnung) {
    if ($ScanDirektAlsPdf) {
        try {
            [void](Erzeuge-ScanPdf $seitenDateien $dpiX $dpiY ($script:LetzteScanFarbe -eq "Schwarzweiss"))
            return
        } catch {
            Schreibe-Log "FEHLER beim direkten Erzeugen der PDF ($bezeichnung): $_ - weiche auf Drucker aus."
        }
    }

    $drucker = Waehle-ScanDrucker
    if ($null -eq $drucker) {
        foreach ($f in $seitenDateien) { Move-Item -Path $f -Destination $AusweichOrdner -Force -ErrorAction SilentlyContinue }
        Schreibe-Log "Scan ($bezeichnung) nicht abgelegt (kein Drucker gewaehlt) - Seitenbilder liegen in '$AusweichOrdner'."
        [System.Windows.Forms.MessageBox]::Show("Der Scan wurde nicht abgelegt. Die gescannten Seiten liegen als Bilder in:`n$AusweichOrdner", "Scan nicht abgelegt") | Out-Null
        return
    }
    Schreibe-Log "Scan ($bezeichnung, $($seitenDateien.Count) Seite(n)) - sende an Drucker '$drucker'..."
    Drucke-BilderStumm $seitenDateien $drucker
    Start-Sleep -Seconds 2
    Schreibe-Log "Scan ($bezeichnung, $($seitenDateien.Count) Seite(n)) an '$drucker' gesendet."
}

# Loest einen Scan ueber einen angeschlossenen Scanner aus. Zeigt vorher das
# Fenster "Scan-Optionen". Beim Einzug werden alle eingelegten Seiten in
# einem Rutsch eingelesen und als EINE zusammenhaengende Datei abgelegt - so
# landen z.B. mehrseitige Vertraege (5, 6, 7 Seiten) als eine Datei im
# Ablage-Ordner.
function Starte-Scan {
    $seitenDateien = New-Object System.Collections.Generic.List[string]
    try {
        if (-not (Test-Path $ScanTempOrdner)) { New-Item -ItemType Directory -Path $ScanTempOrdner -Force | Out-Null }

        $scannerAuswahl = Ermittle-ScannerAuswahl
        if ($scannerAuswahl.Count -eq 0) {
            throw "Kein Scanner gefunden. Bitte pruefen, ob ein Scanner angeschlossen und in Windows als Scanner eingerichtet ist (Herstellertreiber mit Scanfunktion). Geraete, die nur einen TWAIN-Treiber haben, lassen sich ueber 'Mehrseiten-Scan ueber PDF24' nutzen."
        }

        $optionen = Zeige-ScanOptionenDialog $scannerAuswahl (Lese-LetztenScanner)
        if ($null -eq $optionen) {
            Schreibe-Log "Scan abgebrochen (Scan-Optionen abgebrochen)."
            return
        }
        Speichere-LetztenScanner $optionen.Scanner.Anzeige
        Speichere-ScannerEinstellungen $optionen.Scanner.Anzeige $optionen
        Schreibe-Log "Gewaehlter Scanner: '$($optionen.Scanner.Anzeige)' -> Geraet '$($optionen.Scanner.GeraeteName)'"

        $scanner = Verbinde-Scanner $optionen.Scanner.DeviceID
        $script:ScannerFaehigkeiten[$optionen.Scanner.DeviceID] = $scanner.Faehigkeiten
        if ($optionen.Quelle -eq "Einzug" -and -not $scanner.HatEinzug) {
            Schreibe-Log "Scanner '$($optionen.Scanner.Anzeige)' hat keinen automatischen Einzug - es wird vom Flachbett gescannt."
            $optionen.Quelle = "Flachbett"
            $optionen.Duplex = $false
        }
        if ($optionen.Duplex -and -not $scanner.HatDuplex) {
            Schreibe-Log "Scanner '$($optionen.Scanner.Anzeige)' kann nicht beidseitig scannen - es wird einseitig gescannt."
            $optionen.Duplex = $false
        }

        $script:LetzteScanDpiX = 0
        $script:LetzteScanDpiY = 0
        Wende-ScanOptionenAn $scanner.Device $scanner.Item $optionen

        if ($optionen.Quelle -eq "Einzug") {
            $maxSeiten = [int]$MaxSeitenProScan
            if ($optionen.Duplex) { $maxSeiten = $maxSeiten * 2 }
            $seitenDateien = Scanne-MitEinzug $scanner.Device $scanner.Item $maxSeiten
        } else {
            $seitenDateien = Scanne-VonFlachbett $scanner.Item
        }

        if ($seitenDateien.Count -eq 0) {
            Schreibe-Log "Scan abgebrochen (keine Seiten erfasst)."
            return
        }

        Schreibe-Log "Scan abgeschlossen ($($seitenDateien.Count) Seite(n), Quelle: $($optionen.Quelle), Duplex: $($optionen.Duplex), $($optionen.Dpi) dpi, $($optionen.Farbe), Stapel trennen: $([bool]$optionen.Trennen))."
        if ($optionen.Trennen -and $seitenDateien.Count -gt 1) {
            # Leere Blaetter sind hier Trennblaetter - sie fallen beim Teilen weg
            $gruppen = Teile-Stapel $seitenDateien $optionen.Duplex
        } else {
            if ($optionen.LeereSeiten -and $seitenDateien.Count -gt 1) {
                $seitenDateien = Entferne-LeereSeiten $seitenDateien
            }
            $gruppen = New-Object System.Collections.Generic.List[object]
            [void]$gruppen.Add($seitenDateien)
        }

        $script:LetzteScanFarbe = $optionen.Farbe
        try {
            $teil = 0
            foreach ($gruppe in $gruppen) {
                $teil++
                $script:ScanTeilNr = if ($gruppen.Count -gt 1) { $teil } else { 0 }
                Lege-ScanAb $gruppe $script:LetzteScanDpiX $script:LetzteScanDpiY "Jetzt scannen"
            }
        } finally {
            $script:LetzteScanFarbe = ""
            $script:ScanTeilNr = 0
        }
    } catch {
        Schreibe-Log "FEHLER beim Scannen: $_"
        [System.Windows.Forms.MessageBox]::Show("Scannen fehlgeschlagen: $_`n`nPruefen, ob ein Scanner angeschlossen und in Windows eingerichtet ist.", "Fehler beim Scannen") | Out-Null
    } finally {
        foreach ($f in $seitenDateien) { Remove-Item -Path $f -Force -ErrorAction SilentlyContinue }
    }
}

# Alternative zu Starte-Scan: OEFFNET DAS EIGENE SCAN-FENSTER DES SCANNER-
# TREIBERS (bei Netzwerk-Multifunktionsgeraeten wie dem Samsung M2070FW das
# gleiche Fenster wie die Original-Hersteller-Software) statt den Scanner
# selbst ueber einzelne WIA-Befehle zu steuern. Dieses Fenster nutzt die vom
# Hersteller eingebaute, optimierte Scan-Technik und ist bei manchen
# Geraeten DEUTLICH schneller als unsere eigene Automatisierung (siehe
# Scanne-MitEinzug) - dafuer waehlt man Quelle/Qualitaet selbst im Fenster,
# so wie man es aus der Original-Software gewohnt ist. Bei mehreren Scannern
# fragt Windows selbst, welcher benutzt werden soll. Nach dem Scannen
# uebernimmt unser Skript das Ergebnis genauso wie bisher (PDF im Ablage-
# Ordner -> Mitarbeiter/Shop/Kasse-Zuordnung wie gewohnt).
function Starte-ScanUeberScannerFenster {
    $seitenDateien = New-Object System.Collections.Generic.List[string]
    $tempDatei = $null
    try {
        if (-not (Test-Path $ScanTempOrdner)) { New-Item -ItemType Directory -Path $ScanTempOrdner -Force | Out-Null }

        # Erste Seite ueber das schnelle Herstellerfenster (ShowAcquireImage) -
        # deutlich schneller als unsere eigene Automatisierung, liefert aber
        # technisch bedingt IMMER nur eine Seite pro Aufruf zurueck.
        $dialog = New-Object -ComObject WIA.CommonDialog
        $bild = $null
        try {
            $bild = $dialog.ShowAcquireImage()
        } catch {
            Schreibe-Log "Scan (Scanner-Fenster) abgebrochen oder fehlgeschlagen: $($_.Exception.Message)"
            return
        }
        if ($null -eq $bild) {
            Schreibe-Log "Scan (Scanner-Fenster) abgebrochen (kein Bild erhalten)."
            return
        }

        $tempDatei = Join-Path $ScanTempOrdner "scan_$(Get-Date -Format 'yyyyMMdd_HHmmss')_fenster.tmp"
        $bild.SaveFile($tempDatei)

        $erfasstesBild = [System.Drawing.Image]::FromFile($tempDatei)
        try {
            $frameAnzahl = 1
            try { $frameAnzahl = $erfasstesBild.GetFrameCount([System.Drawing.Imaging.FrameDimension]::Page) } catch {}
            for ($i = 0; $i -lt $frameAnzahl; $i++) {
                if ($frameAnzahl -gt 1) {
                    [void]$erfasstesBild.SelectActiveFrame([System.Drawing.Imaging.FrameDimension]::Page, $i)
                }
                $einzelBild = Join-Path $ScanTempOrdner "scan_$(Get-Date -Format 'yyyyMMdd_HHmmss')_seite$($seitenDateien.Count + 1).bmp"
                $erfasstesBild.Save($einzelBild, [System.Drawing.Imaging.ImageFormat]::Bmp)
                [void]$seitenDateien.Add($einzelBild)
            }
        } finally {
            $erfasstesBild.Dispose()
        }
        Remove-Item -Path $tempDatei -Force -ErrorAction SilentlyContinue
        $tempDatei = $null

        # WICHTIG: Es wurde mehrfach versucht, nach der ersten Seite automatisch
        # eine zweite WIA-Verbindung aufzubauen, um weitere Seiten aus dem
        # Einzug zu holen (Status-Abfrage, dann Verbinde-Scanner+Scanne-
        # MitEinzug). Das hat sich bei diesem Netzwerk-Scanner (Samsung
        # M2070FW) als RISKANT erwiesen: der zusaetzliche Verbindungsversuch
        # kurz nach ShowAcquireImage() hat den Scanner in einen Zustand
        # versetzt, in dem er danach ("Unbekannter WIA-Geraetefehler") auch
        # nach einem Neustart des Watchers gar keine Verbindung mehr zuliess -
        # nur ein Aus-/Einschalten des Scanners hat das wieder behoben.
        # Deshalb bewusst zurueckgebaut: Dieses Fenster liefert IMMER GENAU
        # EINE Seite. Fuer mehrseitige Scans bitte "Jetzt scannen (klassisch)"
        # verwenden - das ist der Weg, der den Einzug zuverlaessig und ohne
        # Risiko fuer die Scanner-Verbindung bis zum Ende ausliest.

        if ($seitenDateien.Count -eq 0) {
            Schreibe-Log "Scan (Scanner-Fenster) abgebrochen (keine Seiten erfasst)."
            return
        }

        Schreibe-Log "Scan (Scanner-Fenster) abgeschlossen ($($seitenDateien.Count) Seite(n))."
        # Aufloesung 0 = aus dem Bild selbst uebernehmen
        Lege-ScanAb $seitenDateien 0 0 "Scanner-Fenster"
    } catch {
        Schreibe-Log "FEHLER beim Scannen (Scanner-Fenster): $_"
        [System.Windows.Forms.MessageBox]::Show("Scannen fehlgeschlagen: $_`n`nPruefen, ob ein Scanner angeschlossen und in Windows eingerichtet ist.", "Fehler beim Scannen") | Out-Null
    } finally {
        foreach ($f in $seitenDateien) { Remove-Item -Path $f -Force -ErrorAction SilentlyContinue }
        if ($tempDatei) { Remove-Item -Path $tempDatei -Force -ErrorAction SilentlyContinue }
    }
}

# Weitere Alternative fuer SCHNELLES UND mehrseitiges Scannen: startet PDF24
# Creators eigenes Scan-Werkzeug (pdf24-DocTool.exe) als GANZ EIGENEN,
# unabhaengigen Prozess. Unser eigenes Skript baut dabei UEBERHAUPT KEINE
# eigene Verbindung zum Scanner auf - kein Risiko fuer eine haengende WIA-
# Verbindung wie bei den bisherigen Versuchen mit dem Scanner-Fenster.
# PDF24 nutzt fuer den Scan die TWAIN-Schnittstelle des Treibers, die bei
# Einzugsscannern oft alle Seiten in einer durchgehenden Sitzung einliest -
# aehnlich der Original-Hersteller-Software, die bei euch bereits schnell
# war. Das Ergebnis soll PDF24 direkt im Ablage-Ordner speichern, wo unser
# Watcher es automatisch erkennt und wie gewohnt nach Mitarbeiter/Shop/Kasse
# fragt.
function Starte-ScanUeberPDF24 {
    $moeglichePfade = @(
        "$env:ProgramFiles\PDF24\pdf24-DocTool.exe",
        "${env:ProgramFiles(x86)}\PDF24\pdf24-DocTool.exe",
        "$env:LocalAppData\PDF24\pdf24-DocTool.exe",
        "$env:LocalAppData\Programs\PDF24\pdf24-DocTool.exe"
    )
    $tool = $moeglichePfade | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $tool) {
        try {
            $gefunden = Get-ChildItem -Path "$env:ProgramFiles","${env:ProgramFiles(x86)}","$env:LocalAppData" -Recurse -Filter "pdf24-DocTool.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($gefunden) { $tool = $gefunden.FullName }
        } catch {}
    }
    if (-not $tool) {
        Schreibe-Log "Scan (PDF24): pdf24-DocTool.exe wurde nicht gefunden."
        [System.Windows.Forms.MessageBox]::Show("PDF24 Creator wurde nicht gefunden. Bitte pruefen, ob PDF24 Creator installiert ist.", "PDF24 nicht gefunden") | Out-Null
        return
    }
    if (-not (Test-Path $WatchFolder)) { New-Item -ItemType Directory -Path $WatchFolder -Force | Out-Null }
    try {
        # Als EIN zusammenhaengender Kommandozeilen-Text uebergeben (nicht als
        # Array), damit "<twain>" garantiert genauso ankommt wie in der
        # PDF24-Dokumentation beschrieben (Array-Argumente wuerden von
        # PowerShell zusaetzlich/anders in Anfuehrungszeichen setzen).
        $argZeile = '"<twain>" -outputDir "' + $WatchFolder + '"'
        Schreibe-Log "Scan (PDF24): starte '$tool' $argZeile"
        Start-Process -FilePath $tool -ArgumentList $argZeile
        Schreibe-Log "Scan (PDF24) gestartet - Ergebnis wird direkt in '$WatchFolder' erwartet und dort automatisch erkannt."
    } catch {
        Schreibe-Log "FEHLER beim Starten von PDF24: $_"
        [System.Windows.Forms.MessageBox]::Show("PDF24 konnte nicht gestartet werden: $_", "Fehler") | Out-Null
    }
}

# ======================= VERARBEITUNG DER ABLAGE =======================

$bekannteDateien = New-Object System.Collections.Generic.HashSet[string]

# Baut den "Wiedererkennungs-Schluessel" fuer eine Datei: Pfad + Aenderungszeit
# + Groesse, NICHT nur der Pfad allein. Grund: manche Drucker (z.B. der
# "dino1 Drucker") legen JEDEN Ausdruck unter demselben festen Dateinamen im
# Ablage-Ordner ab. Wuerde man sich nur den Pfad merken, wuerde ein einmal
# uebersprungener oder fehlgeschlagener Ausdruck diesen Dateinamen fuer immer
# blockieren - ein neuer, voellig anderer Ausdruck unter demselben Namen
# waere dann nie mehr erkennbar (genau das war der gemeldete Fehler). Mit
# Aenderungszeit+Groesse in der Kennung zaehlt ein neu ueberschriebener
# Ausdruck dagegen wieder als "neue" Datei.
function Ermittle-DateiSchluessel($datei) {
    return "$($datei.FullName)|$($datei.LastWriteTimeUtc.Ticks)|$($datei.Length)"
}

# Schiebt Dateien, die waehrend eines HiDrive-Ausfalls lokal in
# $AusweichOrdner gelandet sind, automatisch an ihr eigentliches Ziel, sobald
# dieses wieder erreichbar ist. Aufbau des Ausweich-Ordners (siehe
# Ermittle-Zielordner):
#   Nicht_uebertragen\Shop\...               -> $ShopOrdner\...
#   Nicht_uebertragen\Kasse\<Monat>\...      -> $KassenOrdner\<Monat>\...
#   Nicht_uebertragen\<Mitarbeiterordner>\... -> $ZielBasis\<Mitarbeiterordner>\...
# Unbekannte Unterordner (z.B. von Hand angelegte) werden nicht angefasst.
$script:NachschiebenZaehler = 0
$script:NachschiebenAlleTicks = 100   # bei 3 s Pruefintervall: ca. alle 5 Minuten

function Schiebe-NichtUebertrageneNach {
    if (-not (Test-Path $AusweichOrdner)) { return }
    $mitarbeiterNamen = @($MitarbeiterOrdner.Values | ForEach-Object { [string]$_ })
    foreach ($unter in @(Get-ChildItem -Path $AusweichOrdner -Directory -ErrorAction SilentlyContinue)) {
        $zielBasisOrdner = $null
        if ($unter.Name -eq "Shop") { $zielBasisOrdner = $ShopOrdner }
        elseif ($unter.Name -eq "Kasse") { $zielBasisOrdner = $KassenOrdner }
        elseif ($mitarbeiterNamen -contains $unter.Name) { $zielBasisOrdner = Join-Path $ZielBasis $unter.Name }
        if (-not $zielBasisOrdner) { continue }
        if (-not (Test-Path $zielBasisOrdner -ErrorAction SilentlyContinue)) { continue }   # Ziel noch nicht erreichbar

        $dateien = @(Get-ChildItem -Path $unter.FullName -File -Recurse -ErrorAction SilentlyContinue)
        foreach ($f in $dateien) {
            try {
                $relativ = $f.DirectoryName.Substring($unter.FullName.Length).TrimStart('\')
                $zielOrdner = if ($relativ) { Join-Path $zielBasisOrdner $relativ } else { $zielBasisOrdner }
                if (-not (Test-Path $zielOrdner)) { New-Item -ItemType Directory -Path $zielOrdner -Force | Out-Null }
                $zielPfad = Get-EindeutigerZielpfad $zielOrdner ([System.IO.Path]::GetFileNameWithoutExtension($f.Name)) ($f.Extension.TrimStart('.'))
                Move-Item -Path $f.FullName -Destination $zielPfad -ErrorAction Stop
                Schreibe-Log "Nachtraeglich uebertragen: $($f.FullName) -> $zielPfad"
            } catch {
                Schreibe-Log "HINWEIS: Nachtraegliches Uebertragen von '$($f.FullName)' fehlgeschlagen: $($_.Exception.Message)"
            }
        }
        # Leere Unterordner aufraeumen (tiefste zuerst), den Ausweich-Ordner selbst behalten
        $ordner = @(Get-ChildItem -Path $unter.FullName -Directory -Recurse -ErrorAction SilentlyContinue | Sort-Object { $_.FullName.Length } -Descending) + @($unter)
        foreach ($o in $ordner) {
            if (-not (Get-ChildItem -Path $o.FullName -Force -ErrorAction SilentlyContinue)) {
                Remove-Item -Path $o.FullName -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

function Verarbeite-Ablage {
    $timer.Stop()
    try {
        # Gelegentlich (nicht bei jedem Tick - Netzlaufwerke koennen beim
        # Pruefen kurz haengen) liegengebliebene Dateien nachschieben.
        if (($script:NachschiebenZaehler % $script:NachschiebenAlleTicks) -eq 0) {
            try { Schiebe-NichtUebertrageneNach } catch { Schreibe-Log "FEHLER beim Nachschieben: $($_.Exception.Message)" }
        }
        $script:NachschiebenZaehler++

        # "Dino1 Drucker" schreibt immer in DIESELBE Datei. Deshalb wird sie
        # sofort nach dem Druck umbenannt - so kann ein weiterer Druck die
        # noch nicht erfasste Datei nicht mehr ueberschreiben.
        $dino1Datei = Join-Path $WatchFolder $script:Dino1Dateiname
        if ((Test-Path $dino1Datei) -and (Datei-IstFreigegeben $dino1Datei)) {
            $neuerPfad = Get-EindeutigerZielpfad $WatchFolder ("Druck_" + (Get-Date -Format 'yyyyMMdd_HHmmss')) "pdf"
            try {
                Move-Item -Path $dino1Datei -Destination $neuerPfad -ErrorAction Stop
                Schreibe-Log "Dino1-Druck umbenannt: $neuerPfad"
            } catch {
                Schreibe-Log "HINWEIS: Dino1-Druck konnte (noch) nicht umbenannt werden: $($_.Exception.Message)"
            }
        }

        $pdfs = Get-ChildItem -Path $WatchFolder -Filter "*.pdf" -File -ErrorAction SilentlyContinue

        foreach ($datei in $pdfs) {
            $dateiSchluessel = Ermittle-DateiSchluessel $datei
            if ($bekannteDateien.Contains($dateiSchluessel)) { continue }

            $versuche = 0
            while (-not (Datei-IstFreigegeben $datei.FullName) -and $versuche -lt 10) {
                Start-Sleep -Milliseconds 500
                $versuche++
            }

            $vorschau = $null
            try { $vorschau = Erzeuge-Vorschau $datei.FullName } catch { Schreibe-Log "HINWEIS: Vorschau fehlgeschlagen: $($_.Exception.Message)" }
            try {
                $eingabe = Zeige-Erfassungsdialog $datei.Name $datei.FullName $vorschau
            } finally {
                if ($vorschau -and $vorschau.Bild) { try { $vorschau.Bild.Dispose() } catch {} }
            }

            if ($null -eq $eingabe) {
                # Zurueckstellen statt liegenlassen: in den Uebersprungen-
                # Ordner verschieben (Tray-Menue "Uebersprungene Dokumente
                # erfassen" holt sie spaeter zurueck).
                try {
                    $ueberZiel = Get-EindeutigerZielpfad $UebersprungenOrdner ([System.IO.Path]::GetFileNameWithoutExtension($datei.Name)) "pdf"
                    Move-Item -Path $datei.FullName -Destination $ueberZiel -ErrorAction Stop
                    Schreibe-Log "Uebersprungen, zurueckgestellt nach: $ueberZiel"
                } catch {
                    Schreibe-Log "Uebersprungen: $($datei.Name) (konnte nicht verschoben werden: $($_.Exception.Message))"
                    [void]$bekannteDateien.Add($dateiSchluessel)
                }
                continue
            }

            Merke-Bezeichnung $eingabe.Kunde

            $kundeSauber = Sanitize-Dateiname $eingabe.Kunde
            $basisname   = "$($eingabe.Datum)_$($kundeSauber)"

            # Hinweis: "continue" wirkt innerhalb von switch NICHT wie in einer
            # Schleife (PowerShell-Eigenheit) - deshalb hier ueber $zielOrdner
            # ($null = Fehler/Abbruch) steuern statt "continue" im switch zu nutzen.
            $zielOrdner = $null
            switch ($eingabe.Ziel) {
                "Mitarbeiter" {
                    $mitarbeiterOrdnerName = $MitarbeiterOrdner[$eingabe.Mitarbeiter]
                    if ([string]::IsNullOrWhiteSpace($mitarbeiterOrdnerName)) {
                        Schreibe-Log "FEHLER: Fuer Mitarbeiter '$($eingabe.Mitarbeiter)' ist in `$MitarbeiterOrdner kein Ordnername hinterlegt. Datei bleibt liegen: $($datei.FullName)"
                        [System.Windows.Forms.MessageBox]::Show("Fuer diesen Mitarbeiter ist noch kein HiDrive-Ordner in der Konfiguration hinterlegt. Bitte IT informieren. Die Datei bleibt vorerst im Ablage-Ordner liegen.", "Konfiguration fehlt") | Out-Null
                    } else {
                        $zielOrdner = Ermittle-Zielordner (Join-Path $ZielBasis $mitarbeiterOrdnerName) $mitarbeiterOrdnerName
                    }
                }
                "Shop" {
                    $zielOrdner = Ermittle-Zielordner $ShopOrdner "Shop"
                }
                "Lokal" {
                    # Bewusst KEIN Ausweich-Ordner: liegt ohnehin auf diesem PC
                    $zielOrdner = $LokalerOrdner
                }
                "Kasse" {
                    # Kassenbelege automatisch in einen Monatsordner einsortieren
                    # (Monat richtet sich nach dem im Erfassungsfenster gewaehlten
                    # Datum, nicht nach dem heutigen Tag - so landen nachtraeglich
                    # erfasste Belege trotzdem im richtigen Monat).
                    $kassenBasis = Ermittle-Zielordner $KassenOrdner "Kasse"
                    $kassenDatum = [DateTime]::ParseExact($eingabe.Datum, "yyyy-MM-dd", $null)
                    $monatsordner = $kassenDatum.ToString("MMMM", [System.Globalization.CultureInfo]::GetCultureInfo("de-DE"))
                    $zielOrdner = Join-Path $kassenBasis $monatsordner
                }
            }

            if ($null -eq $zielOrdner) {
                # Fehler wurde oben bereits geloggt/gemeldet - Datei bleibt liegen,
                # aber schon gesehene Datei nicht erneut abfragen in dieser Sitzung.
                [void]$bekannteDateien.Add($dateiSchluessel)
                continue
            }

            if (-not (Test-Path $zielOrdner)) {
                New-Item -ItemType Directory -Path $zielOrdner -Force | Out-Null
                Schreibe-Log "HINWEIS: Ordner '$zielOrdner' existierte noch nicht und wurde neu angelegt - bitte pruefen."
            }

            $zielpfad = Get-EindeutigerZielpfad $zielOrdner $basisname "pdf"

            try {
                Move-Item -Path $datei.FullName -Destination $zielpfad -Force
                Schreibe-Log "Abgelegt ($($eingabe.Ziel)): $zielpfad"
                Remove-Item -Path (Get-OcrTextDatei $datei.Name) -Force -ErrorAction SilentlyContinue
                # Hinweis: Seit Einfuehrung von Ermittle-DateiSchluessel (Pfad +
                # Aenderungszeit + Groesse statt nur Pfad) ist es unproblematisch,
                # auch hier zu vermerken - ein neuer Druckauftrag unter demselben
                # Dateinamen erzeugt automatisch einen neuen, noch unbekannten
                # Schluessel. Datei ist ohnehin schon verschoben/weg, daher rein
                # informativ.
                [void]$bekannteDateien.Add($dateiSchluessel)
            } catch {
                Schreibe-Log "FEHLER beim Verschieben von $($datei.Name): $_"
                # Hier bewusst schon merken, damit bei einem dauerhaft blockierten
                # Ziel nicht alle 3 Sekunden erneut derselbe Dialog aufploppt.
                [void]$bekannteDateien.Add($dateiSchluessel)
            }
        }
    } catch {
        Schreibe-Log "FEHLER in der Ablage-Verarbeitung: $_ | Zeile: $($_.InvocationInfo.PositionMessage -replace '[\r\n]+', ' ')"
    } finally {
        $timer.Start()
    }
}

# Erzeugt ein kleines, selbst gezeichnetes Scanner-Symbol fuer den
# Infobereich (Systray) - unabhaengig von externen Icon-Dateien, damit
# nichts zusaetzlich mitgeliefert/verlinkt werden muss.
function Erstelle-ScannerIcon {
    $groesse = 32
    $bmp = New-Object System.Drawing.Bitmap $groesse, $groesse
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    # Scanner-Gehaeuse (dunkelgrau, leichte Trapezform)
    $gehaeuseFarbe = [System.Drawing.Color]::FromArgb(255, 70, 70, 75)
    $gehaeusePunkte = @(
        (New-Object System.Drawing.Point 2, 20),
        (New-Object System.Drawing.Point 30, 20),
        (New-Object System.Drawing.Point 27, 29),
        (New-Object System.Drawing.Point 5, 29)
    )
    $g.FillPolygon((New-Object System.Drawing.SolidBrush $gehaeuseFarbe), $gehaeusePunkte)

    # Scan-Glasflaeche (helles Blau)
    $glasFarbe = [System.Drawing.Color]::FromArgb(255, 130, 190, 230)
    $g.FillRectangle((New-Object System.Drawing.SolidBrush $glasFarbe), 4, 21, 24, 5)

    # Dokument, das eingezogen wird
    $g.FillRectangle([System.Drawing.Brushes]::White, 6, 2, 20, 16)
    $g.DrawRectangle((New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 150, 150, 150)), 1), 6, 2, 20, 16)

    # Angedeutete Textzeilen auf dem Dokument
    $liniePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 180, 180, 180)), 1
    $g.DrawLine($liniePen, 9, 6, 23, 6)
    $g.DrawLine($liniePen, 9, 9, 23, 9)
    $g.DrawLine($liniePen, 9, 12, 18, 12)

    # Rote Scan-Linie
    $scanPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 220, 50, 50)), 2
    $g.DrawLine($scanPen, 7, 15, 22, 15)

    $g.Dispose()

    $hIcon = $bmp.GetHicon()
    return [System.Drawing.Icon]::FromHandle($hIcon)
}

# ======================= ORDNER NACHTRAEGLICH ANPASSEN =======================
# Tray -> "Ordner anpassen...": HiDrive-Ordner, Mitarbeiter-Tabelle, lokalen
# Ordner und Standortnamen DIESES PCs aendern - ohne Setup, ohne Admin. Die
# Werte werden im Abschnitt KONFIGURATION der eigenen Watcher.ps1 gespeichert
# (bleiben also auch bei automatischen Updates und beim naechsten Setup
# erhalten), danach startet der Watcher neu.

# Liest einen Textwert  $Name = "..."  aus dem Konfigurationstext
function Lese-KonfigWert($konfig, $name) {
    $m = [regex]::Match($konfig, '(?m)^\$' + $name + '\s*=\s*"([^"]*)"')
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}

# Fuer einen Wert in "..." - Anfuehrungszeichen entfernen, $ und ` entschaerfen
function Schuetze-KonfigText($text) {
    return ("$text".Trim().Replace('"', '').Replace('`', '``').Replace('$', '`$'))
}

# Ersetzt  $Name = "..."  im Konfigurationstext (Rest der Zeile bleibt)
function Setze-KonfigWert($konfig, $name, $wert) {
    $m = [regex]::Match($konfig, '(?m)^\$' + $name + '\s*=\s*"[^"]*"')
    $neu = '$' + $name + ' = "' + (Schuetze-KonfigText $wert) + '"'
    if ($m.Success) { return $konfig.Substring(0, $m.Index) + $neu + $konfig.Substring($m.Index + $m.Length) }
    # Fehlt die Zeile (aeltere Installation): vor dem Ende-Marker einfuegen
    $ende = $konfig.LastIndexOf("`n# ")
    if ($ende -lt 0) { return $konfig }
    return $konfig.Substring(0, $ende) + "`r`n" + $neu + "`r`n" + $konfig.Substring($ende)
}

function Setze-KonfigMitarbeiter($konfig, $paare) {
    $m = [regex]::Match($konfig, '(?s)\$MitarbeiterOrdner\s*=\s*\[ordered\]@\{.*?\n\}')
    if (-not $m.Success) { throw "Mitarbeiter-Tabelle im Abschnitt KONFIGURATION nicht gefunden" }
    $zeilen = New-Object System.Collections.Generic.List[string]
    [void]$zeilen.Add('$MitarbeiterOrdner = [ordered]@{')
    foreach ($p in $paare) { [void]$zeilen.Add('    "' + (Schuetze-KonfigText $p.Name) + '" = "' + (Schuetze-KonfigText $p.Ordner) + '"') }
    [void]$zeilen.Add('}')
    return $konfig.Substring(0, $m.Index) + ($zeilen -join "`r`n") + $konfig.Substring($m.Index + $m.Length)
}

function Zeige-OrdnerEinstellungen {
    try {
        $text = Lese-Text $script:EigenerPfad
        $teile = Teile-WatcherText $text
        if (-not $teile) { throw "Abschnitt KONFIGURATION nicht gefunden - bitte Setup.cmd ausfuehren." }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Einstellungen konnten nicht gelesen werden: $($_.Exception.Message)", "Ordner anpassen") | Out-Null
        return
    }
    $konfig = $teile.Konfig

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Ordner anpassen - DiNo1 Druck & Scan"
    $form.ClientSize = New-Object System.Drawing.Size(640, 560)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.Topmost = $true

    $y = 15
    $felder = @{}
    $neuesFeld = {
        param($beschriftung, $name, $mitDurchsuchen)
        $l = New-Object System.Windows.Forms.Label
        $l.Text = $beschriftung
        $l.Location = New-Object System.Drawing.Point(15, ($script:OrdnerY + 3))
        $l.AutoSize = $true
        $form.Controls.Add($l)
        $tb = New-Object System.Windows.Forms.TextBox
        $tb.Location = New-Object System.Drawing.Point(190, $script:OrdnerY)
        $tb.Width = $(if ($mitDurchsuchen) { 340 } else { 435 })
        $wert = Lese-KonfigWert $konfig $name
        $tb.Text = $(if ($null -ne $wert) { $wert } else { "" })
        $form.Controls.Add($tb)
        if ($mitDurchsuchen) {
            $b = New-Object System.Windows.Forms.Button
            $b.Text = "Waehlen..."
            $b.Location = New-Object System.Drawing.Point(540, ($script:OrdnerY - 1))
            $b.Size = New-Object System.Drawing.Size(85, 24)
            $b.Tag = $tb
            $b.Add_Click({
                $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
                $feld = $this.Tag
                if ($feld.Text -and (Test-Path $feld.Text -ErrorAction SilentlyContinue)) { $dlg.SelectedPath = $feld.Text }
                if ($dlg.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) { $feld.Text = $dlg.SelectedPath }
            })
            $form.Controls.Add($b)
        }
        $script:OrdnerY += 32
        return $tb
    }
    $script:OrdnerY = $y
    $txtStandort = & $neuesFeld "Standortname:" "StandortName" $false
    $txtBasis    = & $neuesFeld "HiDrive Mitarbeiter-Ordner:" "ZielBasis" $true
    $txtShop     = & $neuesFeld "HiDrive Shop-Ordner:" "ShopOrdner" $true
    $txtKasse    = & $neuesFeld "HiDrive Kassen-Ordner:" "KassenOrdner" $true
    $txtLokal    = & $neuesFeld "Lokaler Ordner (leer = Dokumente\Scans):" "LokalerOrdner" $true
    $y = $script:OrdnerY + 5

    $lblMA = New-Object System.Windows.Forms.Label
    $lblMA.Text = "Mitarbeiter: Name im Auswahlfeld -> Ordnername im Mitarbeiter-Ordner (genau so wie auf HiDrive).`nNeue Zeile unten eintragen; Zeile markieren + Entf = loeschen; Doppelklick auf Ordner = auf HiDrive auswaehlen."
    $lblMA.Location = New-Object System.Drawing.Point(15, $y)
    $lblMA.Size = New-Object System.Drawing.Size(610, 32)
    $form.Controls.Add($lblMA)
    $y += 36

    $grid = New-Object System.Windows.Forms.DataGridView
    $grid.Location = New-Object System.Drawing.Point(15, $y)
    $grid.Size = New-Object System.Drawing.Size(610, 260)
    $grid.AllowUserToAddRows = $true
    $grid.AllowUserToDeleteRows = $true
    $grid.RowHeadersWidth = 30
    $grid.AutoSizeColumnsMode = "Fill"
    [void]$grid.Columns.Add("Name", "Mitarbeiter (Anzeige)")
    [void]$grid.Columns.Add("Ordner", "Ordner auf HiDrive")
    $mm = [regex]::Match($konfig, '(?s)\$MitarbeiterOrdner\s*=\s*\[ordered\]@\{(.*?)\n\}')
    if ($mm.Success) {
        foreach ($p in [regex]::Matches($mm.Groups[1].Value, '"([^"]*)"\s*=\s*"([^"]*)"')) {
            [void]$grid.Rows.Add($p.Groups[1].Value, $p.Groups[2].Value)
        }
    }
    $grid.Add_CellDoubleClick({
        param($s, $e)
        if ($e.RowIndex -lt 0 -or $e.ColumnIndex -ne 1) { return }
        $basis = $txtBasis.Text.Trim()
        if (-not ($basis -and (Test-Path $basis -ErrorAction SilentlyContinue))) {
            [System.Windows.Forms.MessageBox]::Show($form, "Der Mitarbeiter-Ordner '$basis' ist gerade nicht erreichbar - Ordnername bitte von Hand eintragen.", "Ordner anpassen") | Out-Null
            return
        }
        $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
        $dlg.Description = "Ordner des Mitarbeiters in $basis waehlen:"
        $dlg.SelectedPath = $basis
        if ($dlg.ShowDialog($form) -ne [System.Windows.Forms.DialogResult]::OK) { return }
        $gewaehlt = $dlg.SelectedPath.TrimEnd('\')
        if ((Split-Path $gewaehlt -Parent).TrimEnd('\') -ine $basis.TrimEnd('\')) {
            [System.Windows.Forms.MessageBox]::Show($form, "Bitte einen Ordner direkt in '$basis' waehlen.", "Ordner anpassen") | Out-Null
            return
        }
        if ($e.RowIndex -ge $grid.Rows.Count - 1 -and $grid.AllowUserToAddRows) { [void]$grid.Rows.Add("", "") }
        $grid.Rows[$e.RowIndex].Cells[1].Value = (Split-Path $gewaehlt -Leaf)
        if (-not $grid.Rows[$e.RowIndex].Cells[0].Value) { $grid.Rows[$e.RowIndex].Cells[0].Value = (Split-Path $gewaehlt -Leaf) }
    })
    $form.Controls.Add($grid)
    $y += 268

    # Prueft, ob es die eingetragenen Mitarbeiter-Ordner auf HiDrive gibt
    $pruefeOrdner = {
        $basis = $txtBasis.Text.Trim()
        if (-not ($basis -and (Test-Path $basis -ErrorAction SilentlyContinue))) { return $null }
        $fehlend = New-Object System.Collections.Generic.List[string]
        foreach ($r in $grid.Rows) {
            if ($r.IsNewRow) { continue }
            $o = "$($r.Cells[1].Value)".Trim()
            if (-not $o) { continue }
            if (Test-Path (Join-Path $basis $o) -ErrorAction SilentlyContinue) {
                $r.Cells[1].Style.BackColor = [System.Drawing.Color]::Empty
            } else {
                $r.Cells[1].Style.BackColor = [System.Drawing.Color]::MistyRose
                [void]$fehlend.Add($o)
            }
        }
        return ,$fehlend
    }

    $btnPruefen = New-Object System.Windows.Forms.Button
    $btnPruefen.Text = "Ordner pruefen"
    $btnPruefen.Location = New-Object System.Drawing.Point(15, $y)
    $btnPruefen.Size = New-Object System.Drawing.Size(120, 30)
    $btnPruefen.Add_Click({
        $f = & $pruefeOrdner
        if ($null -eq $f) { [System.Windows.Forms.MessageBox]::Show($form, "Der Mitarbeiter-Ordner ist gerade nicht erreichbar.", "Ordner pruefen") | Out-Null }
        elseif ($f.Count -eq 0) { [System.Windows.Forms.MessageBox]::Show($form, "Alle Mitarbeiter-Ordner sind vorhanden.", "Ordner pruefen") | Out-Null }
        else { [System.Windows.Forms.MessageBox]::Show($form, "Diese Ordner gibt es im Mitarbeiter-Ordner nicht (rot markiert):`n`n$($f -join "`n")", "Ordner pruefen") | Out-Null }
    })
    $form.Controls.Add($btnPruefen)

    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Text = "Speichern"
    $btnOK.Location = New-Object System.Drawing.Point(395, $y)
    $btnOK.Size = New-Object System.Drawing.Size(110, 30)
    $btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($btnOK)

    $btnAbbrechen = New-Object System.Windows.Forms.Button
    $btnAbbrechen.Text = "Abbrechen"
    $btnAbbrechen.Location = New-Object System.Drawing.Point(515, $y)
    $btnAbbrechen.Size = New-Object System.Drawing.Size(110, 30)
    $btnAbbrechen.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($btnAbbrechen)
    $form.CancelButton = $btnAbbrechen

    $script:OrdnerPaare = $null
    $btnOK.Add_Click({
        $grid.EndEdit() | Out-Null
        $paare = New-Object System.Collections.Generic.List[object]
        $namen = @{}
        foreach ($r in $grid.Rows) {
            if ($r.IsNewRow) { continue }
            $n = "$($r.Cells[0].Value)".Trim(); $o = "$($r.Cells[1].Value)".Trim()
            if (-not $n -and -not $o) { continue }
            if (-not $n -or -not $o) {
                [System.Windows.Forms.MessageBox]::Show($form, "Bei jedem Mitarbeiter muessen Name UND Ordner eingetragen sein.", "Fehlende Angabe") | Out-Null
                $form.DialogResult = [System.Windows.Forms.DialogResult]::None; return
            }
            if ($namen.ContainsKey($n.ToLowerInvariant())) {
                [System.Windows.Forms.MessageBox]::Show($form, "Der Name '$n' steht doppelt in der Liste.", "Doppelter Eintrag") | Out-Null
                $form.DialogResult = [System.Windows.Forms.DialogResult]::None; return
            }
            $namen[$n.ToLowerInvariant()] = $true
            [void]$paare.Add([PSCustomObject]@{ Name = $n; Ordner = $o })
        }
        if ($paare.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show($form, "Bitte mindestens einen Mitarbeiter eintragen.", "Fehlende Angabe") | Out-Null
            $form.DialogResult = [System.Windows.Forms.DialogResult]::None; return
        }
        foreach ($p in @(@($txtStandort, "Standortname"), @($txtBasis, "HiDrive Mitarbeiter-Ordner"), @($txtShop, "HiDrive Shop-Ordner"), @($txtKasse, "HiDrive Kassen-Ordner"))) {
            if ([string]::IsNullOrWhiteSpace($p[0].Text)) {
                [System.Windows.Forms.MessageBox]::Show($form, "Bitte '$($p[1])' ausfuellen.", "Fehlende Angabe") | Out-Null
                $form.DialogResult = [System.Windows.Forms.DialogResult]::None; return
            }
        }
        $fehlend = & $pruefeOrdner
        if ($fehlend -and $fehlend.Count -gt 0) {
            $a = [System.Windows.Forms.MessageBox]::Show($form, "Diese Mitarbeiter-Ordner gibt es auf HiDrive nicht (rot markiert):`n`n$($fehlend -join "`n")`n`nTrotzdem speichern? (Der Ordner wird dann bei der ersten Ablage neu angelegt.)", "Ordner fehlen", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
            if ($a -ne [System.Windows.Forms.DialogResult]::Yes) { $form.DialogResult = [System.Windows.Forms.DialogResult]::None; return }
        }
        $script:OrdnerPaare = $paare
    })

    if ($form.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK -or $null -eq $script:OrdnerPaare) { return }

    try {
        $neu = $konfig
        $neu = Setze-KonfigWert $neu "StandortName" $txtStandort.Text
        $neu = Setze-KonfigWert $neu "ZielBasis" $txtBasis.Text
        $neu = Setze-KonfigWert $neu "ShopOrdner" $txtShop.Text
        $neu = Setze-KonfigWert $neu "KassenOrdner" $txtKasse.Text
        $neu = Setze-KonfigWert $neu "LokalerOrdner" $txtLokal.Text
        $neu = Setze-KonfigMitarbeiter $neu $script:OrdnerPaare
        if ($neu -eq $konfig) { return }
        $inhalt = $teile.Kopf + $neu + $teile.Code
        $fehler = $null
        [void][System.Management.Automation.Language.Parser]::ParseInput($inhalt, [ref]$null, [ref]$fehler)
        if ($fehler -and $fehler.Count -gt 0) { throw "Ergebnis waere fehlerhaft (Zeile $($fehler[0].Extent.StartLineNumber): $($fehler[0].Message))" }
        Copy-Item -Path $script:EigenerPfad -Destination (Join-Path (Split-Path $script:EigenerPfad) "Watcher_vor_Ordneraenderung.ps1") -Force
        Set-Content -Path $script:EigenerPfad -Value $inhalt -Encoding UTF8 -Force
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Speichern fehlgeschlagen: $($_.Exception.Message)`n`nEs wurde nichts geaendert.", "Ordner anpassen") | Out-Null
        return
    }
    Schreibe-Log "Ordner angepasst (Standort '$($txtStandort.Text)', $($script:OrdnerPaare.Count) Mitarbeiter). Watcher startet neu."
    [System.Windows.Forms.MessageBox]::Show("Gespeichert. Der Watcher startet jetzt neu und verwendet die neuen Ordner.", "Ordner anpassen") | Out-Null
    Starte-WatcherNeu
}

# ======================= DOPPELT LAUFENDE WATCHER =======================
# Findet alle PowerShell-Prozesse, die eine Watcher.ps1 ausfuehren - auch
# "Geist"-Prozesse ohne Tray-Symbol und Watcher anderer angemeldeter
# Benutzer (deren Befehlszeile sieht man ohne Admin-Rechte evtl. nicht).
function Ermittle-WatcherProzesse {
    $liste = New-Object System.Collections.Generic.List[object]
    try {
        $prozesse = @(Get-CimInstance -ClassName Win32_Process -Filter "Name='powershell.exe' OR Name='pwsh.exe'" -ErrorAction Stop)
    } catch {
        $prozesse = @(Get-WmiObject -Class Win32_Process -Filter "Name='powershell.exe' OR Name='pwsh.exe'" -ErrorAction SilentlyContinue)
    }
    foreach ($p in $prozesse) {
        $befehl = "$($p.CommandLine)"
        if ($p.ProcessId -ne $PID -and $befehl -notmatch 'Watcher[^\\/]*\.ps1') { continue }
        $benutzer = "?"
        try {
            $o = Invoke-CimMethod -InputObject $p -MethodName GetOwner -ErrorAction Stop
            if ($o.User) { $benutzer = $(if ($o.Domain) { "$($o.Domain)\$($o.User)" } else { $o.User }) }
        } catch {}
        $start = $null
        try { $start = (Get-Process -Id $p.ProcessId -ErrorAction Stop).StartTime } catch {}
        $datei = "?"
        if ($befehl -match '([^"\s\\/]*Watcher[^"\\/]*\.ps1)') { $datei = $matches[1] }
        [void]$liste.Add([PSCustomObject]@{
            Pid      = [int]$p.ProcessId
            Benutzer = $benutzer
            Start    = $start
            Datei    = $datei
            Eigener  = ([int]$p.ProcessId -eq $PID)
            EigenerBenutzer = ($benutzer -like "*\$($env:USERNAME)" -or $benutzer -eq $env:USERNAME)
        })
    }
    return ,$liste
}

function Zeige-WatcherProzesse {
    $liste = Ermittle-WatcherProzesse
    $zeilen = foreach ($w in ($liste | Sort-Object Start)) {
        $s = if ($w.Start) { $w.Start.ToString("dd.MM. HH:mm:ss") } else { "?" }
        "PID $($w.Pid)   gestartet $s   Benutzer $($w.Benutzer)   $($w.Datei)$(if ($w.Eigener) { '   <- dieser (mit Tray-Symbol)' })"
    }
    $andere = @($liste | Where-Object { -not $_.Eigener })
    $eigeneAndere = @($andere | Where-Object { $_.EigenerBenutzer })
    $text = "Laufende Watcher auf diesem PC: $($liste.Count)`n`n$($zeilen -join "`n")"
    Schreibe-Log "Laufende Watcher geprueft: $($liste.Count) ($((($liste | ForEach-Object { "PID $($_.Pid) $($_.Benutzer)" }) -join ', ')))"
    if ($andere.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("$text`n`nAlles in Ordnung - der Watcher laeuft nur einmal.", "Laufende Watcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return
    }
    if ($eigeneAndere.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("$text`n`nDie anderen Watcher gehoeren anderen angemeldeten Benutzern (das ist normal, z.B. bei schnellem Benutzerwechsel).", "Laufende Watcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return
    }
    $antwort = [System.Windows.Forms.MessageBox]::Show("$text`n`nDer Watcher laeuft fuer diesen Benutzer DOPPELT ($($eigeneAndere.Count) weitere(r)). Die weiteren jetzt beenden? Dieser hier (mit Tray-Symbol) laeuft weiter.", "Watcher laeuft doppelt", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
    if ($antwort -ne [System.Windows.Forms.DialogResult]::Yes) { return }
    $fehler = New-Object System.Collections.Generic.List[string]
    foreach ($w in $eigeneAndere) {
        try { Stop-Process -Id $w.Pid -Force -ErrorAction Stop; Schreibe-Log "Doppelten Watcher beendet: PID $($w.Pid)" }
        catch { [void]$fehler.Add("PID $($w.Pid): $($_.Exception.Message)") }
    }
    if ($fehler.Count -gt 0) {
        [System.Windows.Forms.MessageBox]::Show("Nicht alle konnten beendet werden:`n$($fehler -join "`n")", "Laufende Watcher") | Out-Null
    } else {
        [System.Windows.Forms.MessageBox]::Show("Erledigt - jetzt laeuft nur noch dieser Watcher.", "Laufende Watcher") | Out-Null
    }
}

# ======================= TRAY-SYMBOL =======================

$trayIcon = New-Object System.Windows.Forms.NotifyIcon
$trayIcon.Icon = Erstelle-ScannerIcon
$trayIcon.Text = "DiNo1 Druck & Scan ($StandortName)"
$trayIcon.Visible = $true

$menu = New-Object System.Windows.Forms.ContextMenuStrip
$menuScan = $menu.Items.Add("Jetzt scannen")
$menuScan.Add_Click({
    $timer.Stop()
    try { Starte-Scan } finally { $timer.Start() }
})
$menuScanFenster = $menu.Items.Add("Jetzt scannen (Scanner-Fenster, schnell, nur 1 Seite)")
$menuScanFenster.Add_Click({
    $timer.Stop()
    try { Starte-ScanUeberScannerFenster } finally { $timer.Start() }
})
$menuScanPdf24 = $menu.Items.Add("Mehrseiten-Scan ueber PDF24 (schnell, experimentell)")
$menuScanPdf24.Add_Click({ Starte-ScanUeberPDF24 })
[void]$menu.Items.Add("-")
$menuUebersprungen = $menu.Items.Add("Uebersprungene Dokumente erfassen")
$menuUebersprungen.Add_Click({
    # Zurueck in den Ablage-Ordner - der Watcher fragt sie dann der Reihe
    # nach wieder ab
    $anzahl = 0
    foreach ($f in @(Get-ChildItem -Path $UebersprungenOrdner -Filter "*.pdf" -File -ErrorAction SilentlyContinue)) {
        try {
            $ziel = Get-EindeutigerZielpfad $WatchFolder ([System.IO.Path]::GetFileNameWithoutExtension($f.Name)) "pdf"
            Move-Item -Path $f.FullName -Destination $ziel -ErrorAction Stop
            $anzahl++
        } catch {
            Schreibe-Log "FEHLER beim Zurueckholen von $($f.Name): $($_.Exception.Message)"
        }
    }
    Schreibe-Log "$anzahl uebersprungene(s) Dokument(e) zur erneuten Erfassung zurueckgeholt."
})
$menuOrdner = $menu.Items.Add("Ordner anpassen...")
$menuOrdner.Add_Click({
    $timer.Stop()
    try { Zeige-OrdnerEinstellungen } finally { if (-not $script:WirdBeendet) { try { $timer.Start() } catch {} } }
})
$menuAblageOeffnen = $menu.Items.Add("Ablage-Ordner oeffnen")
$menuAblageOeffnen.Add_Click({ Start-Process -FilePath "explorer.exe" -ArgumentList "`"$WatchFolder`"" })
$menu.Add_Opening({
    $n = @(Get-ChildItem -Path $UebersprungenOrdner -Filter "*.pdf" -File -ErrorAction SilentlyContinue).Count
    $menuUebersprungen.Text = "Uebersprungene Dokumente erfassen ($n)"
    $menuUebersprungen.Enabled = ($n -gt 0)
    $vorherPfad = Join-Path (Split-Path $script:EigenerPfad) "Watcher_vorher.ps1"
    if (Test-Path $vorherPfad) {
        $vt = "?"
        try { $vt = Ermittle-VersionText (Lese-Text $vorherPfad) } catch {}
        $menuZurueck.Text = "Vorherige Version wiederherstellen ($vt)"
        $menuZurueck.Enabled = $true
    } else {
        $menuZurueck.Text = "Vorherige Version wiederherstellen (keine vorhanden)"
        $menuZurueck.Enabled = $false
    }
})
[void]$menu.Items.Add("-")
$menuDoppelt = $menu.Items.Add("Laufende Watcher pruefen")
$menuDoppelt.Add_Click({
    $timer.Stop()
    try { Zeige-WatcherProzesse } finally { try { $timer.Start() } catch {} }
})
$menuInfo = $menu.Items.Add("Status: Log-Datei oeffnen")
$menuInfo.Add_Click({ Start-Process -FilePath "notepad.exe" -ArgumentList "`"$LogDatei`"" })
$menuUpdate = $menu.Items.Add("Nach Updates suchen")
$menuUpdate.Add_Click({
    $timer.Stop()
    try { Pruefe-AufUpdate $true } finally { if (-not $script:WirdBeendet) { try { $timer.Start() } catch {} } }
})
$menuZurueck = $menu.Items.Add("Vorherige Version wiederherstellen")
$menuZurueck.Add_Click({
    $timer.Stop()
    try { Stelle-VorherigeVersionHer } finally { if (-not $script:WirdBeendet) { try { $timer.Start() } catch {} } }
})
[void]$menu.Items.Add("-")
$menuUeber = $menu.Items.Add("Ueber DiNo1 Druck && Scan")
$menuUeber.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "DiNo1 Druck & Scan - Standort: $StandortName`n$($script:EigeneVersionText) (Programmstand $($script:EigeneCodeKennung))`nUpdate-Quelle: $(if ($UpdateQuelle) { $UpdateQuelle } else { '(keiner)' })`n`nInstallation von Dino1 GmbH und Andre Meschke",
        "Ueber DiNo1 Druck & Scan") | Out-Null
})
[void]$menu.Items.Add("-")
$menuBeenden = $menu.Items.Add("Watcher beenden")
$menuBeenden.Add_Click({
    # Sauberes Beenden DIESES Prozesses. Wichtig: Falls der Watcher stattdessen
    # z.B. per "Stop-ScheduledTask" von aussen beendet wird, kann es je nach
    # Windows-Version vorkommen, dass nur der Huelle-Prozess (conhost.exe)
    # beendet wird, das eigentliche Skript aber als "Geist"-Prozess mit
    # eigenem Tray-Symbol weiterlaeuft. Ueber dieses Menu beendet sich der
    # Prozess IMMER vollstaendig selbst.
    $trayIcon.Visible = $false
    [System.Windows.Forms.Application]::Exit()
})
$trayIcon.ContextMenuStrip = $menu
$trayIcon.Add_BalloonTipClicked({
    if ($script:WarnungOrdner -and (Test-Path $script:WarnungOrdner)) { Start-Process -FilePath "explorer.exe" -ArgumentList "`"$($script:WarnungOrdner)`"" }
})

$trayIcon.Add_DoubleClick({
    $timer.Stop()
    try { Starte-Scan } finally { $timer.Start() }
})

# ======================= AUTOMATISCHE UPDATES =======================
# Prueft beim Start und danach etwa alle 10 Minuten, ob unter $UpdateQuelle
# (Internet-Adresse oder Ordner) eine Watcher.ps1 mit ANDEREM Programmcode
# liegt. Verglichen wird nur der
# Programmcode, nicht der Abschnitt KONFIGURATION - die dort mitgelieferten
# Beispielwerte spielen also keine Rolle. Ablauf bei einem Update:
#   1. neuen Programmcode + EIGENE Konfiguration dieses PCs zusammensetzen
#   2. Ergebnis auf Syntaxfehler pruefen (fehlerhafte Datei wird abgelehnt)
#   3. bisherige Version als Watcher_vorher.ps1 sichern, neue speichern
#   4. Watcher neu starten
$script:EigenerPfad = $PSCommandPath
$script:UpdateZaehler = 0
$script:UpdateAlleTicks = 200          # bei 3 s Pruefintervall: ca. alle 10 Minuten
$script:AbgelehnteUpdateKennung = ""
# Nach "Vorherige Version wiederherstellen" steht hier der Programmstand, der
# NICHT automatisch wieder installiert werden soll (bis "Nach Updates suchen"
# von Hand gewaehlt wird oder eine andere neue Version erscheint)
$script:UpdateSperrDatei = Join-Path (Split-Path $script:EigenerPfad) "UpdateGesperrt.txt"
# Marken zusammengesetzt, damit sie nicht woertlich in diesem Code stehen
# (sonst wuerde die Suche hier statt am echten Abschnitt fuendig)
$script:KonfigStartMarke = '# ======================= ' + 'KONFIGURATION =======================' 
$script:KonfigEndeMarke  = '# ======================= ENDE ' + 'KONFIGURATION ======================='

# Zerlegt eine Watcher.ps1 in Kopf, KONFIGURATION und Programmcode
function Teile-WatcherText($text) {
    $start = $text.IndexOf($script:KonfigStartMarke)
    $ende = $text.IndexOf($script:KonfigEndeMarke)
    if ($start -lt 0 -or $ende -lt $start) { return $null }
    $ende += $script:KonfigEndeMarke.Length
    return [PSCustomObject]@{
        Kopf   = $text.Substring(0, $start)
        Konfig = $text.Substring($start, $ende - $start)
        Code   = $text.Substring($ende)
    }
}

# Kurze Kennung des Programmcodes (ohne KONFIGURATION, Zeilenenden egal)
function Ermittle-CodeKennung($teile) {
    $norm = ($teile.Kopf + $teile.Code).Replace("`r`n", "`n").Trim()
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($norm))
    } finally { $sha.Dispose() }
    return (($hash | ForEach-Object { $_.ToString("x2") }) -join "").Substring(0, 12)
}

function Lese-Text($pfad) {
    return [System.IO.File]::ReadAllText($pfad)
}

$script:EigeneCodeKennung = "?"

# Liest Versionsnummer und -datum aus dem Text einer Watcher.ps1
function Ermittle-VersionText($text) {
    $nr = "?"; $datum = "?"
    if ($text -match '\$script:WatcherVersion\s*=\s*"([^"]*)"') { $nr = $matches[1] }
    if ($text -match '\$script:WatcherVersionDatum\s*=\s*"([^"]*)"') { $datum = $matches[1] }
    if ($nr -eq "?") { return "(ohne Versionsnummer)" }
    return "Version $nr vom $datum"
}
$script:EigeneVersionText = "Version $($script:WatcherVersion) vom $($script:WatcherVersionDatum)"
try {
    $eigeneTeile = Teile-WatcherText (Lese-Text $script:EigenerPfad)
    if ($eigeneTeile) { $script:EigeneCodeKennung = Ermittle-CodeKennung $eigeneTeile }
} catch {}

function Pruefe-AufUpdate([bool]$manuell) {
    $melde = {
        param($text, $icon)
        Schreibe-Log "Update: $text"
        if ($manuell) { [System.Windows.Forms.MessageBox]::Show($text, "DiNo1 Druck & Scan Update", [System.Windows.Forms.MessageBoxButtons]::OK, $icon) | Out-Null }
    }
    if ([string]::IsNullOrWhiteSpace($UpdateQuelle)) {
        if ($manuell) { & $melde "Fuer diesen PC ist keine Update-Quelle eingetragen (Setup -> 'Update-Quelle')." ([System.Windows.Forms.MessageBoxIcon]::Information) }
        return
    }
    $quelleText = $UpdateQuelle.Trim()
    $neuText = $null
    if ($quelleText -match '^[a-zA-Z][a-zA-Z0-9+.-]*://') {
        # Internet: nur verschluesselt (https), damit niemand unterwegs
        # fremden Code einschleusen kann
        if ($quelleText -notmatch '^https://') {
            & $melde "Update-Quelle muss mit https:// beginnen - unverschluesselte Adressen werden aus Sicherheitsgruenden nicht verwendet:`n$quelleText" ([System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        try {
            # Windows PowerShell 5.1 nutzt sonst evtl. noch altes TLS, das z.B.
            # GitHub ablehnt
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            $wc = New-Object System.Net.WebClient
            $wc.Encoding = [System.Text.Encoding]::UTF8
            $wc.Headers.Add("Cache-Control", "no-cache")
            # GitHub haelt Dateien bis zu 5 Minuten im Zwischenspeicher - ein
            # wechselnder Zusatz an der Adresse holt immer den neuesten Stand
            $trenner = if ($quelleText.Contains("?")) { "&" } else { "?" }
            $neuText = $wc.DownloadString($quelleText + $trenner + "t=" + [DateTime]::UtcNow.Ticks)
        } catch {
            if ($manuell) { & $melde "Update konnte nicht heruntergeladen werden (Internet/Adresse pruefen):`n$quelleText`n`n$($_.Exception.Message)" ([System.Windows.Forms.MessageBoxIcon]::Warning) }
            else { Schreibe-Log "Update: Download nicht moeglich ($($_.Exception.Message))" }
            return
        } finally {
            if ($wc) { $wc.Dispose() }
        }
        if ($neuText.Length -gt 0 -and [int]$neuText[0] -eq 0xFEFF) { $neuText = $neuText.Substring(1) }
    } else {
        $quelle = Join-Path $quelleText "Watcher.ps1"
        if (-not (Test-Path $quelle -ErrorAction SilentlyContinue)) {
            if ($manuell) { & $melde "Im Update-Ordner wurde keine Watcher.ps1 gefunden (oder der Ordner ist gerade nicht erreichbar):`n$quelle" ([System.Windows.Forms.MessageBoxIcon]::Warning) }
            return
        }
        try { $neuText = Lese-Text $quelle } catch {
            & $melde "Update-Datei konnte nicht gelesen werden: $($_.Exception.Message)" ([System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
    }

    try {
        $neuTeile = Teile-WatcherText $neuText
        $eigenTeile = Teile-WatcherText (Lese-Text $script:EigenerPfad)
    } catch {
        & $melde "Dateien konnten nicht gelesen werden: $($_.Exception.Message)" ([System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    if (-not $eigenTeile) {
        & $melde "Abschnitt KONFIGURATION in der eigenen Watcher.ps1 nicht gefunden - kein automatisches Update moeglich, bitte Setup.cmd ausfuehren." ([System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    if (-not $neuTeile) {
        if ($script:AbgelehnteUpdateKennung -ne "ohne-konfig" -or $manuell) {
            & $melde "Die Watcher.ps1 der Update-Quelle hat keinen Abschnitt KONFIGURATION - Update abgelehnt." ([System.Windows.Forms.MessageBoxIcon]::Warning)
        }
        $script:AbgelehnteUpdateKennung = "ohne-konfig"
        return
    }

    $neuKennung = Ermittle-CodeKennung $neuTeile
    $neuVersion = Ermittle-VersionText $neuText
    if ($neuKennung -eq $script:EigeneCodeKennung) {
        if ($manuell) { & $melde "Dieser PC ist auf dem aktuellen Stand:`n`n$($script:EigeneVersionText)`n(Programmstand $neuKennung)" ([System.Windows.Forms.MessageBoxIcon]::Information) }
        return
    }
    if ($neuKennung -eq $script:AbgelehnteUpdateKennung -and -not $manuell) { return }
    if (-not $manuell -and (Test-Path $script:UpdateSperrDatei)) {
        $gesperrt = ""
        try { $gesperrt = (Lese-Text $script:UpdateSperrDatei).Trim() } catch {}
        if ($gesperrt -eq $neuKennung) { return }   # bewusst zurueckgestellt
    }

    # Neuer Programmcode + Konfiguration DIESES PCs
    $neuerInhalt = $neuTeile.Kopf + $eigenTeile.Konfig + $neuTeile.Code

    $fehler = $null
    [void][System.Management.Automation.Language.Parser]::ParseInput($neuerInhalt, [ref]$null, [ref]$fehler)
    if ($fehler -and $fehler.Count -gt 0) {
        $script:AbgelehnteUpdateKennung = $neuKennung
        $erster = $fehler[0]
        & $melde "Update auf $neuVersion ($neuKennung) ABGELEHNT - die neue Watcher.ps1 enthaelt Syntaxfehler (Zeile $($erster.Extent.StartLineNumber): $($erster.Message)). Dieser PC arbeitet unveraendert weiter." ([System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    try {
        $sicherung = Join-Path (Split-Path $script:EigenerPfad) "Watcher_vorher.ps1"
        Copy-Item -Path $script:EigenerPfad -Destination $sicherung -Force
        Set-Content -Path $script:EigenerPfad -Value $neuerInhalt -Encoding UTF8 -Force
        Remove-Item -Path $script:UpdateSperrDatei -Force -ErrorAction SilentlyContinue
    } catch {
        $script:AbgelehnteUpdateKennung = $neuKennung
        & $melde "Update auf $neuVersion ($neuKennung) konnte nicht gespeichert werden: $($_.Exception.Message)" ([System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    Schreibe-Log "Update: $($script:EigeneVersionText) ($($script:EigeneCodeKennung)) -> $neuVersion ($neuKennung) uebernommen (Sicherung: $sicherung). Watcher startet neu."
    if ($manuell) { [System.Windows.Forms.MessageBox]::Show("Update auf $neuVersion wurde installiert.`n`nDer Watcher startet jetzt neu.", "DiNo1 Druck & Scan Update", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null }
    Starte-WatcherNeu
}

# Macht das letzte Update rueckgaengig: Programmcode aus Watcher_vorher.ps1
# mit der Konfiguration DIESES PCs. Die bisherige Version wird zur neuen
# "vorherigen" (so kann man auch wieder vor), und sie wird nicht sofort
# automatisch wieder installiert.
function Stelle-VorherigeVersionHer {
    $vorherPfad = Join-Path (Split-Path $script:EigenerPfad) "Watcher_vorher.ps1"
    if (-not (Test-Path $vorherPfad)) {
        [System.Windows.Forms.MessageBox]::Show("Es ist keine vorherige Version vorhanden (sie entsteht erst bei einem Update).", "Vorherige Version") | Out-Null
        return
    }
    try {
        $vorherText = Lese-Text $vorherPfad
        $aktuellText = Lese-Text $script:EigenerPfad
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Dateien konnten nicht gelesen werden: $($_.Exception.Message)", "Vorherige Version") | Out-Null
        return
    }
    $vorherTeile = Teile-WatcherText $vorherText
    $aktuellTeile = Teile-WatcherText $aktuellText
    if (-not $vorherTeile -or -not $aktuellTeile) {
        [System.Windows.Forms.MessageBox]::Show("Abschnitt KONFIGURATION nicht gefunden - Wiederherstellen nicht moeglich.", "Vorherige Version") | Out-Null
        return
    }
    $vorherVersion = Ermittle-VersionText $vorherText
    $konfig = $aktuellTeile.Konfig
    # Aeltere Versionen (vor 14) kennen die Update-Sperre noch nicht und
    # wuerden sofort wieder aktualisieren - dort automatische Updates aus.
    $kenntSperre = $vorherTeile.Code.Contains("UpdateGesperrt.txt")
    if ($kenntSperre) {
        $hinweis = "Die aktuelle Version wird danach nicht wieder automatisch installiert (erst wenn eine neuere erscheint oder Sie 'Nach Updates suchen' waehlen)."
    } else {
        $hinweis = "Diese aeltere Version kennt die Update-Sperre noch nicht - automatische Updates werden deshalb AUSGESCHALTET. Zum Wiedereinschalten Setup.cmd erneut ausfuehren."
        $zeilen = $konfig -split "`r?`n"
        for ($i = 0; $i -lt $zeilen.Count; $i++) {
            if ($zeilen[$i] -match '^\$UpdateQuelle\s*=') {
                $zeilen[$i] = '$UpdateQuelle = ""   # ausgeschaltet durch "Vorherige Version wiederherstellen" - vorher: ' + ($zeilen[$i] -replace '^\$UpdateQuelle\s*=\s*', '')
            }
        }
        $konfig = $zeilen -join "`r`n"
    }
    $frage = "Zurueck auf ${vorherVersion}?`n`nAktuell: $($script:EigeneVersionText)`n`nDie Einstellungen dieses PCs bleiben erhalten. $hinweis`n`nDer Watcher startet danach neu."
    $antwort = [System.Windows.Forms.MessageBox]::Show($frage, "Vorherige Version wiederherstellen", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($antwort -ne [System.Windows.Forms.DialogResult]::Yes) { return }

    $neuerInhalt = $vorherTeile.Kopf + $konfig + $vorherTeile.Code
    $fehler = $null
    [void][System.Management.Automation.Language.Parser]::ParseInput($neuerInhalt, [ref]$null, [ref]$fehler)
    if ($fehler -and $fehler.Count -gt 0) {
        [System.Windows.Forms.MessageBox]::Show("Die vorherige Version enthaelt Syntaxfehler - Wiederherstellen abgebrochen.", "Vorherige Version") | Out-Null
        return
    }
    try {
        Set-Content -Path $script:EigenerPfad -Value $neuerInhalt -Encoding UTF8 -Force
        Set-Content -Path $vorherPfad -Value $aktuellText -Encoding UTF8 -Force
        Set-Content -Path $script:UpdateSperrDatei -Value $script:EigeneCodeKennung -Encoding ASCII -Force
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Wiederherstellen fehlgeschlagen: $($_.Exception.Message)", "Vorherige Version") | Out-Null
        return
    }
    Schreibe-Log "Vorherige Version wiederhergestellt: $($script:EigeneVersionText) ($($script:EigeneCodeKennung)) -> $vorherVersion. Automatisches Update auf $($script:EigeneCodeKennung) gesperrt. Watcher startet neu."
    Starte-WatcherNeu
}

# Startet den Watcher neu (z.B. nach einem Update): Sperre freigeben, neuen
# Prozess genauso unsichtbar starten wie die geplante Aufgabe, diesen beenden.
$script:WirdBeendet = $false
function Starte-WatcherNeu {
    $script:WirdBeendet = $true
    try { $timer.Stop() } catch {}
    try { $trayIcon.Visible = $false } catch {}
    try { $script:EinzelStartMutex.ReleaseMutex() } catch {}
    try { $script:EinzelStartMutex.Dispose() } catch {}
    try {
        Start-Process -FilePath "conhost.exe" -ArgumentList "--headless powershell.exe -ExecutionPolicy Bypass -File `"$($script:EigenerPfad)`""
    } catch {
        Schreibe-Log "FEHLER: Neustart nach Update fehlgeschlagen: $($_.Exception.Message) - der Watcher startet bei der naechsten Anmeldung wieder."
    }
    [System.Windows.Forms.Application]::Exit()
}

# ======================= STATUS UND WARNHINWEISE =======================
# Alle paar Minuten: Zustand pruefen, bei Problemen einen Hinweis am
# Tray-Symbol zeigen (jede Meldung hoechstens einmal pro Stunde) und eine
# kleine Statusdatei in $StatusOrdner schreiben (fuer Uebersicht.cmd).
$script:ZustandZaehler = 80         # erste Pruefung ca. 1 Minute nach dem Start (HiDrive braucht nach der Anmeldung etwas)
$script:ZustandAlleTicks = 100        # bei 3 s Pruefintervall: ca. alle 5 Minuten
$script:LetzteWarnung = @{}
$script:WarnungOrdner = $null

function Warne-Einmal($schluessel, $titel, $text, $ordner) {
    $jetzt = Get-Date
    if ($script:LetzteWarnung.ContainsKey($schluessel) -and ($jetzt - $script:LetzteWarnung[$schluessel]).TotalMinutes -lt 60) { return }
    $script:LetzteWarnung[$schluessel] = $jetzt
    Schreibe-Log "WARNUNG: $titel - $text"
    $script:WarnungOrdner = $ordner
    try { $trayIcon.ShowBalloonTip(20000, $titel, $text, [System.Windows.Forms.ToolTipIcon]::Warning) } catch {}
}

function Ermittle-Zustand {
    $hidriveOk = [bool](Test-Path $ZielBasis -ErrorAction SilentlyContinue)
    $nicht = @(Get-ChildItem -Path $AusweichOrdner -File -Recurse -ErrorAction SilentlyContinue)
    $nichtAlt = @($nicht | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes(-30) })
    return [PSCustomObject]@{
        HiDriveErreichbar = $hidriveOk
        NichtUebertragen  = $nicht.Count
        NichtUebertragenAlt = $nichtAlt.Count
        Uebersprungen     = @(Get-ChildItem -Path $UebersprungenOrdner -Filter "*.pdf" -File -ErrorAction SilentlyContinue).Count
        WartendInAblage   = @(Get-ChildItem -Path $WatchFolder -Filter "*.pdf" -File -ErrorAction SilentlyContinue).Count
    }
}

function Pruefe-Zustand {
    $z = Ermittle-Zustand
    $script:AnzahlWatcher = 0
    try {
        $wl = Ermittle-WatcherProzesse
        $doppelt = @($wl | Where-Object { -not $_.Eigener -and $_.EigenerBenutzer })
        $script:AnzahlWatcher = 1 + $doppelt.Count   # nur die dieses Benutzers
        if ($doppelt.Count -gt 0) {
            Warne-Einmal "doppelt" "Watcher laeuft doppelt" "Der Watcher laeuft fuer diesen Benutzer $($doppelt.Count + 1)-mal (PID $((($doppelt | ForEach-Object { $_.Pid }) -join ', '))). Rechtsklick aufs Symbol -> 'Laufende Watcher pruefen' zum Beenden." $null
        }
    } catch {}
    if (-not $z.HiDriveErreichbar) {
        Warne-Einmal "hidrive" "HiDrive nicht erreichbar" "'$ZielBasis' ist gerade nicht erreichbar. Dokumente werden vorerst auf diesem PC gesammelt und spaeter automatisch uebertragen." $null
    } elseif ($z.NichtUebertragenAlt -gt 0) {
        Warne-Einmal "nicht_uebertragen" "Dokumente nicht uebertragen" "$($z.NichtUebertragen) Dokument(e) liegen noch in '$AusweichOrdner' und konnten nicht automatisch nach HiDrive uebertragen werden. Klicken zum Oeffnen." $AusweichOrdner
    }
    Schreibe-Status $z
}

function Schreibe-Status($zustand) {
    if ([string]::IsNullOrWhiteSpace($StatusOrdner) -or $StatusOrdner.Trim() -eq "-") { return }
    try {
        if (-not (Test-Path $StatusOrdner -ErrorAction SilentlyContinue)) {
            $eltern = Split-Path $StatusOrdner -Parent
            if (-not $eltern -or -not (Test-Path $eltern -ErrorAction SilentlyContinue)) { return }   # HiDrive gerade nicht da
            New-Item -ItemType Directory -Path $StatusOrdner -Force -ErrorAction Stop | Out-Null
        }
        $status = [ordered]@{
            Rechner           = $env:COMPUTERNAME
            Benutzer          = $env:USERNAME
            Standort          = $StandortName
            Version           = $script:WatcherVersion
            VersionDatum      = $script:WatcherVersionDatum
            Programmstand     = $script:EigeneCodeKennung
            Zeit              = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            HiDriveErreichbar = $zustand.HiDriveErreichbar
            NichtUebertragen  = $zustand.NichtUebertragen
            Uebersprungen     = $zustand.Uebersprungen
            WartendInAblage   = $zustand.WartendInAblage
            LetzteAblage      = "$($script:LetzteAblage)"
            LetzterFehler     = "$($script:LetzterFehler)"
            Texterkennung     = $(if (-not $OcrAktiv) { "aus" } elseif (-not $script:OcrGeprueft) { "noch nicht benutzt" } elseif ($script:OcrEngine) { "bereit" } else { "nicht verfuegbar" })
            UpdateQuelle      = $UpdateQuelle
            UpdatesGesperrt   = [bool](Test-Path $script:UpdateSperrDatei)
            LaufendeWatcher   = [int]$script:AnzahlWatcher
        }
        $name = (Sanitize-Dateiname "$($env:COMPUTERNAME)_$($env:USERNAME)") + ".json"
        $datei = Join-Path $StatusOrdner $name
        # Erst lokal schreiben und dann kopieren - genau wie die Dokumente.
        # Direktes Schreiben auf das HiDrive-Laufwerk wird von manchen
        # HiDrive-Verbindungen abgelehnt ("kann auf die Datei nicht zugreifen").
        $lokal = Join-Path $ScanTempOrdner ("Status_" + $name)
        [System.IO.File]::WriteAllText($lokal, ($status | ConvertTo-Json -Depth 3), (New-Object System.Text.UTF8Encoding($false)))
        try {
            Copy-Item -Path $lokal -Destination $datei -Force -ErrorAction Stop
        } catch {
            # Vorhandene Datei laesst sich evtl. nicht ueberschreiben: loeschen und neu ablegen
            Remove-Item -Path $datei -Force -ErrorAction SilentlyContinue
            Copy-Item -Path $lokal -Destination $datei -Force -ErrorAction Stop
        }
        Remove-Item -Path $lokal -Force -ErrorAction SilentlyContinue
        if ($script:StatusFehler) { Schreibe-Log "Statusdatei wird wieder geschrieben: $datei" }
        $script:StatusFehler = ""
    } catch {
        # Nur bei neuem Fehlertext ins Log (sonst alle 5 Minuten dieselbe Zeile)
        $meldung = ($_.Exception.Message -replace '\s+', ' ').Trim()
        if ($meldung -ne $script:StatusFehler) {
            Schreibe-Log "HINWEIS: Statusdatei in '$StatusOrdner' konnte nicht geschrieben werden: $meldung"
        }
        $script:StatusFehler = $meldung
    }
}

# ======================= HAUPTSCHLEIFE (Timer statt Dauerschleife) =======================
# Ein WinForms-Timer wird benoetigt, damit gleichzeitig das Tray-Symbol auf
# Klicks reagieren kann UND der Ablage-Ordner regelmaessig geprueft wird.

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $PruefIntervall * 1000
$timer.Add_Tick({
    if (($script:UpdateZaehler % $script:UpdateAlleTicks) -eq 0) {
        try { Pruefe-AufUpdate $false } catch { Schreibe-Log "FEHLER bei der Update-Pruefung: $($_.Exception.Message)" }
    }
    $script:UpdateZaehler++
    if ($script:WirdBeendet) { return }   # Neustart nach Update laeuft
    if (($script:ZustandZaehler % $script:ZustandAlleTicks) -eq 0) {
        try { Pruefe-Zustand } catch { Schreibe-Log "FEHLER bei der Zustandspruefung: $($_.Exception.Message)" }
    }
    $script:ZustandZaehler++
    Verarbeite-Ablage
})
$timer.Start()

Schreibe-Log "=== Watcher gestartet fuer Standort '$StandortName' ($($script:EigeneVersionText), Programmstand $($script:EigeneCodeKennung)) ==="

[System.Windows.Forms.Application]::Run()
