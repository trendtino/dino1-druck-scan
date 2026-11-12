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
$script:WatcherVersion      = "32"
$script:WatcherVersionDatum = "12.11.2026"

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
# Kassenbelege: <Kassen-Ordner>\<Jahr>\<MM Monat>, z.B. Kasse\2026\11 November.
# Vorhandene Ordner werden wiederverwendet, auch wenn sie etwas anders
# heissen (z.B. "2026 Kasse", "11_November", "November", "11"). Fehlt der
# Jahres- oder Monatsordner, wird er als "2026" bzw. "11 November" angelegt.
function Ermittle-KassenMonatsordner($kassenBasis, [DateTime]$datum) {
    $kultur = [System.Globalization.CultureInfo]::GetCultureInfo("de-DE")
    $jahr = $datum.ToString("yyyy")
    $monatName = $datum.ToString("MMMM", $kultur)
    $monatNr = $datum.ToString("MM")

    # Ist als Kassen-Ordner schon ein Jahresordner eingetragen (z.B.
    # "...\Kasse\2026"), gilt dessen uebergeordneter Ordner als Kassen-Ordner -
    # sonst entstuende "2026\2026\..." bzw. im neuen Jahr "2026\2027\...".
    $blatt = Split-Path -Path $kassenBasis -Leaf
    $eltern = Split-Path -Path $kassenBasis -Parent
    if ($blatt -match '^(19|20)\d\d(\D|$)' -and $eltern) { $kassenBasis = $eltern }

    $jahrOrdner = $null
    $kandidaten = @(Get-ChildItem -Path $kassenBasis -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^$jahr(\D|$)" })
    if ($kandidaten.Count -gt 0) {
        $genau = @($kandidaten | Where-Object { $_.Name -eq $jahr })
        $jahrOrdner = if ($genau.Count -gt 0) { $genau[0].FullName } else { $kandidaten[0].FullName }
    } else {
        $jahrOrdner = Join-Path $kassenBasis $jahr
    }

    $monatOrdner = $null
    if (Test-Path $jahrOrdner -ErrorAction SilentlyContinue) {
        $nr = [int]$datum.Month
        $muster = "^0?$nr(\D|$)"
        foreach ($d in @(Get-ChildItem -Path $jahrOrdner -Directory -ErrorAction SilentlyContinue)) {
            if ($d.Name -match $muster -or $d.Name -match "(^|\W)$([regex]::Escape($monatName))(\W|$)") { $monatOrdner = $d.FullName; break }
        }
    }
    if (-not $monatOrdner) { $monatOrdner = Join-Path $jahrOrdner "$monatNr $monatName" }
    return $monatOrdner
}

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
    $form.Add_Load({ Setze-Design $this })
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
    $form.Add_Load({ Setze-Design $this })
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
    $form.Add_Load({ Setze-Design $this })
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

# ======================= FORTSCHRITTSFENSTER BEIM SCANNEN =======================
# Kleines Fenster unten rechts: welche Seite gerade gescannt wird, wie viele
# schon erfasst sind, PDF/Texterkennung. "Stoppen" beendet den Einzug nach
# der aktuellen Seite (bisher gescannte Seiten bleiben erhalten).
# Hinweis: Waehrend der Scanner eine Seite einzieht, ist das Fenster kurz
# "eingefroren" - es wird zwischen den Seiten aktualisiert.
$script:Fortschritt = $null
$script:ScanStoppen = $false
$script:ZeitOcr = 0.0
$script:ZeitEinzugEnde = 0
$script:ZeitSeiten = New-Object System.Collections.Generic.List[string]

function Zeige-Fortschritt($titel, $text) {
    try {
        if ($null -eq $script:Fortschritt -or $script:Fortschritt.IsDisposed) {
            $f = New-Object System.Windows.Forms.Form
            $f.Add_Load({ Setze-Design $this })
            $f.Text = "DiNo1 Druck & Scan"
            $f.FormBorderStyle = "FixedToolWindow"
            $f.ClientSize = New-Object System.Drawing.Size(360, 120)
            $f.StartPosition = "Manual"
            $bereich = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
            $f.Location = New-Object System.Drawing.Point(($bereich.Right - 380), ($bereich.Bottom - 160))
            $f.ShowInTaskbar = $true
            $f.ControlBox = $false

            $l1 = New-Object System.Windows.Forms.Label
            $l1.Location = New-Object System.Drawing.Point(12, 10)
            $l1.Size = New-Object System.Drawing.Size(336, 20)
            $l1.Font = New-Object System.Drawing.Font($l1.Font.FontFamily, 10, [System.Drawing.FontStyle]::Bold)
            $f.Controls.Add($l1)

            $l2 = New-Object System.Windows.Forms.Label
            $l2.Location = New-Object System.Drawing.Point(12, 34)
            $l2.Size = New-Object System.Drawing.Size(336, 36)
            $f.Controls.Add($l2)

            $balken = New-Object System.Windows.Forms.ProgressBar
            $balken.Location = New-Object System.Drawing.Point(12, 76)
            $balken.Size = New-Object System.Drawing.Size(230, 18)
            $balken.Style = "Marquee"
            $balken.MarqueeAnimationSpeed = 30
            $f.Controls.Add($balken)

            $b = New-Object System.Windows.Forms.Button
            $b.Text = "Stoppen"
            $b.Location = New-Object System.Drawing.Point(255, 72)
            $b.Size = New-Object System.Drawing.Size(93, 26)
            $b.Add_Click({
                $script:ScanStoppen = $true
                $this.Enabled = $false
                $this.Text = "Wird gestoppt..."
                Schreibe-Log "Scan: 'Stoppen' gedrueckt - Einzug endet nach der aktuellen Seite."
            })
            $f.Controls.Add($b)
            $f.Tag = @{ Titel = $l1; Text = $l2; Balken = $balken; Stopp = $b }
            $script:Fortschritt = $f
            $f.Show()
        }
        $teile = $script:Fortschritt.Tag
        $teile.Titel.Text = $titel
        $teile.Text.Text = $text
        $script:Fortschritt.Refresh()
        [System.Windows.Forms.Application]::DoEvents()
    } catch {}
}

# "Stoppen"-Knopf nur waehrend des Einzugs anbieten
function Setze-FortschrittStopp([bool]$sichtbar) {
    try { if ($script:Fortschritt -and -not $script:Fortschritt.IsDisposed) { $script:Fortschritt.Tag.Stopp.Visible = $sichtbar } } catch {}
}

function Schliesse-Fortschritt {
    try { if ($script:Fortschritt -and -not $script:Fortschritt.IsDisposed) { $script:Fortschritt.Close(); $script:Fortschritt.Dispose() } } catch {}
    $script:Fortschritt = $null
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

    $script:ScanStoppen = $false
    $script:ZeitEinzugEnde = 0
    $script:ZeitSeiten = New-Object System.Collections.Generic.List[string]
    $scanStart = Get-Date
    Setze-FortschrittStopp $true
    while ($weiter) {
        if ($script:ScanStoppen) {
            Schreibe-Log "Scan nach $seitenNr Seite(n) gestoppt (Knopf 'Stoppen')."
            break
        }
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
        $dauer = [Math]::Round(((Get-Date) - $scanStart).TotalSeconds)
        Zeige-Fortschritt "Scanne Seite $($seitenNr + 1) ..." "Bisher erfasst: $seitenNr Seite(n)  -  $dauer s`nEinzug laeuft. 'Stoppen' beendet nach der aktuellen Seite."
        $zeitmesser = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            $bild = Hole-WiaBild $item ($seitenNr -gt 0)
        } catch {
            $hResult = $_.Exception.HResult
            if (-not $hResult -and $_.Exception.InnerException) { $hResult = $_.Exception.InnerException.HResult }
            $script:ZeitEinzugEnde = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1)
            if ($seitenNr -gt 0 -and ($hResult -eq $script:WIA_ERROR_PAPER_EMPTY -or $_.Exception.Message -match "0x80210003")) {
                Schreibe-Log "Einzug leer gemeldet nach $($script:ZeitEinzugEnde)s."
                break   # Einzug ist leer - alle Seiten wurden erfasst
            }
            if ($seitenNr -eq 0) { throw }
            Schreibe-Log "Einzug: nach $seitenNr Seite(n) keine weitere Seite ($($_.Exception.Message)) - Scan beendet."
            break
        }
        if ($null -eq $bild) {
            if ($seitenNr -gt 0) { $script:ZeitEinzugEnde = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1); break }   # kein weiteres Bild -> Einzug vermutlich leer
            throw "Der Scanner hat kein Bild geliefert. Bitte als Farbe 'Graustufen' oder 'Farbe' statt 'Schwarzweiss' waehlen oder einen anderen Eintrag fuer diesen Scanner nehmen (z.B. '... LAN' statt '... series' - das ist der Herstellertreiber). Details im Log."
        }
        $transferSekunden = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1)

        $zeitmesser.Restart()
        $seitenNr++
        $tempBild = Join-Path $ScanTempOrdner "scan_$(Get-Date -Format 'yyyyMMdd_HHmmss')_seite$seitenNr.bmp"
        $bild.SaveFile($tempBild)
        [void]$ergebnisDateien.Add($tempBild)
        $speichernSekunden = [Math]::Round($zeitmesser.Elapsed.TotalSeconds, 1)
        $groesseMB = 0
        try { $groesseMB = [Math]::Round((Get-Item $tempBild).Length / 1MB, 1) } catch {}
        [void]$script:ZeitSeiten.Add("${transferSekunden}s")
        Schreibe-Log "Seite $seitenNr erfasst: $tempBild (Scan/Transfer: ${transferSekunden}s, Speichern: ${speichernSekunden}s, ${groesseMB} MB, $($bild.Width)x$($bild.Height) Pixel)"
        Zeige-Fortschritt "Seite $seitenNr erfasst" "Bisher erfasst: $seitenNr Seite(n)  -  $([Math]::Round(((Get-Date) - $scanStart).TotalSeconds)) s`nPruefe, ob noch Papier im Einzug liegt ..."
    }
    Setze-FortschrittStopp $false

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
        Zeige-Fortschritt "Scanne Seite $($seitenNr + 1) (Flachbett) ..." "Bisher erfasst: $seitenNr Seite(n)"
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
        Zeige-Fortschritt "Seite $seitenNr erfasst" "Bisher erfasst: $seitenNr Seite(n) - naechste Seite auflegen?"

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

    $seitenGesamt = @($seitenDateien).Count
    foreach ($f in $seitenDateien) {
        $seitenNr++
        Zeige-Fortschritt "PDF wird erstellt ..." "Seite $seitenNr von $seitenGesamt$(if ($mitOcr) { ' (mit Texterkennung)' })$(if ([int]$script:ScanTeilNr -gt 0) { " - Dokument $($script:ScanTeilNr)" })"
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
            $ocrUhr = [System.Diagnostics.Stopwatch]::StartNew()
            $erkannt = Erkenne-Text $f
            $script:ZeitOcr += $ocrUhr.Elapsed.TotalSeconds
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

        Zeige-Fortschritt "Verbinde mit Scanner ..." "$($optionen.Scanner.Anzeige)"
        $phasenUhr = [System.Diagnostics.Stopwatch]::StartNew()
        $gesamtUhr = [System.Diagnostics.Stopwatch]::StartNew()
        $script:ZeitEinzugEnde = 0
        $script:ZeitSeiten = New-Object System.Collections.Generic.List[string]
        $script:ZeitOcr = 0.0
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
        $zeitVerbinden = [Math]::Round($phasenUhr.Elapsed.TotalSeconds, 1)
        $phasenUhr.Restart()

        if ($optionen.Quelle -eq "Einzug") {
            $maxSeiten = [int]$MaxSeitenProScan
            if ($optionen.Duplex) { $maxSeiten = $maxSeiten * 2 }
            $seitenDateien = Scanne-MitEinzug $scanner.Device $scanner.Item $maxSeiten
        } else {
            $seitenDateien = Scanne-VonFlachbett $scanner.Item
        }
        $zeitScanner = [Math]::Round($phasenUhr.Elapsed.TotalSeconds, 1)
        $phasenUhr.Restart()

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

        $zeitLeer = [Math]::Round($phasenUhr.Elapsed.TotalSeconds, 1)
        $phasenUhr.Restart()
        $script:LetzteScanFarbe = $optionen.Farbe
        try {
            $teil = 0
            foreach ($gruppe in $gruppen) {
                $teil++
                $script:ScanTeilNr = if ($gruppen.Count -gt 1) { $teil } else { 0 }
                Lege-ScanAb $gruppe $script:LetzteScanDpiX $script:LetzteScanDpiY "Jetzt scannen"
            }
            $zeitPdf = [Math]::Round($phasenUhr.Elapsed.TotalSeconds, 1)
            $zeitOcr = [Math]::Round($script:ZeitOcr, 1)
            Schreibe-Log ("ZEITEN ($($optionen.Farbe), $($optionen.Dpi) dpi angefordert, $($script:LetzteScanDpiX) dpi erhalten, $($seitenDateien.Count) Seite(n)): " +
                "Verbinden+Einstellen ${zeitVerbinden}s | Scanner ${zeitScanner}s (je Seite: $($script:ZeitSeiten -join ', '); Warten auf Einzug-Ende $($script:ZeitEinzugEnde)s) | " +
                "Leere Seiten pruefen ${zeitLeer}s | PDF ${zeitPdf}s (davon Texterkennung ${zeitOcr}s) | gesamt $([Math]::Round($gesamtUhr.Elapsed.TotalSeconds, 1))s")
        } finally {
            $script:LetzteScanFarbe = ""
            $script:ScanTeilNr = 0
        }
    } catch {
        Schreibe-Log "FEHLER beim Scannen: $_"
        Schliesse-Fortschritt
        [System.Windows.Forms.MessageBox]::Show("Scannen fehlgeschlagen: $_`n`nPruefen, ob ein Scanner angeschlossen und in Windows eingerichtet ist.", "Fehler beim Scannen") | Out-Null
    } finally {
        Schliesse-Fortschritt
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
        Schliesse-Fortschritt
        [System.Windows.Forms.MessageBox]::Show("Scannen fehlgeschlagen: $_`n`nPruefen, ob ein Scanner angeschlossen und in Windows eingerichtet ist.", "Fehler beim Scannen") | Out-Null
    } finally {
        Schliesse-Fortschritt
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
#   Nicht_uebertragen\Kasse\<Jahr>\<MM Monat>\... -> $KassenOrdner\<Jahr>\<MM Monat>\...
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
                    $zielOrdner = Ermittle-KassenMonatsordner $kassenBasis $kassenDatum
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
                Merke-FuerSuche $eingabe $zielpfad $(if ($vorschau) { $vorschau.Text } else { "" })
                Kopiere-SuchindexInShop
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

# ======================= DESIGN (Farben, Logo, Symbole) =======================
# Einheitliches, modernes Aussehen aller Fenster: helle Flaeche, flache Knoepfe,
# DiNo1-Orange als Akzentfarbe. Logo und Programmsymbol sind hier eingebettet,
# damit die Watcher.ps1 weiterhin eine einzelne Datei bleibt (Auto-Update).
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

# Symbol-Schrift von Windows 10/11 (fuer die Bildchen auf den Kacheln)
$script:SymbolSchrift = $null
try {
    $namen = @((New-Object System.Drawing.Text.InstalledFontCollection).Families | ForEach-Object { $_.Name })
    foreach ($n in @("Segoe Fluent Icons", "Segoe MDL2 Assets")) { if ($namen -contains $n) { $script:SymbolSchrift = $n; break } }
} catch {}

function Neuer-RundPfad([float]$x, [float]$y, [float]$b, [float]$h, [float]$r) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $p.AddArc($x, $y, $d, $d, 180, 90)
    $p.AddArc(($x + $b - $d), $y, $d, $d, 270, 90)
    $p.AddArc(($x + $b - $d), ($y + $h - $d), $d, $d, 0, 90)
    $p.AddArc($x, ($y + $h - $d), $d, $d, 90, 90)
    $p.CloseFigure()
    return $p
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

# ---- Kacheln fuer das Programmfenster (abgerundet, mit Symbol) ----
$script:KachelZeichnen = {
    param($s, $e)
    try {
        $t = $s.Tag
        $g = $e.Graphics
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $pfad = Neuer-RundPfad 0.5 0.5 ($s.Width - 1.5) ($s.Height - 1.5) 8
        $fuellung = if (-not $s.Enabled) { [System.Drawing.Color]::FromArgb(238, 238, 240) } elseif ($t.Hover) { $t.FuellungHover } else { $t.Fuellung }
        $pinsel = New-Object System.Drawing.SolidBrush($fuellung)
        $stift = New-Object System.Drawing.Pen($(if ($t.Hover -and $s.Enabled) { $t.RahmenHover } else { $t.Rahmen }))
        $g.FillPath($pinsel, $pfad)
        $g.DrawPath($stift, $pfad)
        $pinsel.Dispose(); $stift.Dispose(); $pfad.Dispose()
    } catch {}
}
$script:KachelHinein = {
    $p = if ($this -is [System.Windows.Forms.Label]) { $this.Parent } else { $this }
    if ($p.Tag -and $p.Tag.Klickbar -and -not $p.Tag.Hover) { $p.Tag.Hover = $true; $p.Invalidate($true) }
}
$script:KachelHinaus = {
    $p = if ($this -is [System.Windows.Forms.Label]) { $this.Parent } else { $this }
    if (-not $p.Tag) { return }
    if ($p.ClientRectangle.Contains($p.PointToClient([System.Windows.Forms.Cursor]::Position))) { return }
    if ($p.Tag.Hover) { $p.Tag.Hover = $false; $p.Invalidate($true) }
}
$script:KachelKlick = {
    $p = if ($this -is [System.Windows.Forms.Label]) { $this.Parent } else { $this }
    if ($p.Enabled -and $p.Tag -and $p.Tag.Aktion) { & $p.Tag.Aktion $p }
}

# Erzeugt eine Kachel. $art: "gross" (Symbol links, Text rechts), "klein" (Symbol oben, Text unten), "karte" (nur Flaeche)
function Neue-Kachel($eltern, $x, $y, $b, $h, $text, $glyph, $aktion, $art = "gross", [bool]$hervorgehoben = $false) {
    $p = New-Object System.Windows.Forms.Panel
    $p.Location = New-Object System.Drawing.Point($x, $y)
    $p.Size = New-Object System.Drawing.Size($b, $h)
    $p.BackColor = $eltern.BackColor
    $tag = @{
        Aktion = $aktion; Klickbar = ($null -ne $aktion); Hover = $false
        Fuellung = [System.Drawing.Color]::White; FuellungHover = $script:FarbeAkzentHell
        Rahmen = $script:FarbeRahmen; RahmenHover = $script:FarbeAkzent
        TextLabel = $null; GlyphLabel = $null
    }
    $vorder = $script:FarbeText; $glyphFarbe = $script:FarbeAkzent
    if ($hervorgehoben) {
        $tag.Fuellung = $script:FarbeAkzent; $tag.FuellungHover = $script:FarbeAkzentDunkel
        $tag.Rahmen = $script:FarbeAkzent; $tag.RahmenHover = $script:FarbeAkzentDunkel
        $vorder = [System.Drawing.Color]::White; $glyphFarbe = [System.Drawing.Color]::White
    }
    $p.Tag = $tag
    $p.Add_Paint($script:KachelZeichnen)
    if ($art -ne "karte") {
        $hatGlyph = ($script:SymbolSchrift -and $glyph)
        if ($hatGlyph) {
            $gl = New-Object System.Windows.Forms.Label
            $gl.Text = [string][char]$glyph
            $gl.UseMnemonic = $false
            $gl.BackColor = [System.Drawing.Color]::Transparent
            $gl.ForeColor = $glyphFarbe
            $gl.TextAlign = "MiddleCenter"
            if ($art -eq "klein") {
                $gl.Font = New-Object System.Drawing.Font($script:SymbolSchrift, 15)
                $gl.Location = New-Object System.Drawing.Point(0, 6); $gl.Size = New-Object System.Drawing.Size($b, 30)
            } else {
                $gl.Font = New-Object System.Drawing.Font($script:SymbolSchrift, 20)
                $gl.Location = New-Object System.Drawing.Point(10, 0); $gl.Size = New-Object System.Drawing.Size(44, $h)
            }
            $p.Controls.Add($gl); $tag.GlyphLabel = $gl
        }
        $tl = New-Object System.Windows.Forms.Label
        $tl.Text = $text
        $tl.UseMnemonic = $false
        $tl.BackColor = [System.Drawing.Color]::Transparent
        $tl.ForeColor = $vorder
        if ($art -eq "klein") {
            $tl.Font = New-Object System.Drawing.Font("Segoe UI", 9)
            $tl.TextAlign = "MiddleCenter"
            if ($hatGlyph) { $tl.Location = New-Object System.Drawing.Point(0, 36); $tl.Size = New-Object System.Drawing.Size($b, ($h - 40)) }
            else { $tl.Location = New-Object System.Drawing.Point(0, 0); $tl.Size = New-Object System.Drawing.Size($b, $h) }
        } else {
            $tl.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10.5)
            $tl.TextAlign = "MiddleLeft"
            $links = if ($hatGlyph) { 58 } else { 16 }
            $tl.Location = New-Object System.Drawing.Point($links, 0); $tl.Size = New-Object System.Drawing.Size(($b - $links - 8), $h)
        }
        $p.Controls.Add($tl); $tag.TextLabel = $tl
    }
    if ($tag.Klickbar) {
        $p.Cursor = [System.Windows.Forms.Cursors]::Hand
        foreach ($c in @($p) + @($p.Controls)) {
            $c.Add_Click($script:KachelKlick)
            $c.Add_MouseEnter($script:KachelHinein)
            $c.Add_MouseLeave($script:KachelHinaus)
        }
    }
    $p.Add_EnabledChanged({ $this.Invalidate($true) })
    $eltern.Controls.Add($p)
    return $p
}

# Ordner im Explorer oeffnen (lokalen Ordner bei Bedarf anlegen)
function Oeffne-OrdnerPfad([string]$pfad) {
    if (-not $pfad) { return }
    if (-not (Test-Path $pfad -ErrorAction SilentlyContinue)) {
        if ($pfad -eq $LokalerOrdner) { try { New-Item -ItemType Directory -Path $pfad -Force | Out-Null } catch {} }
    }
    if (Test-Path $pfad -ErrorAction SilentlyContinue) { Start-Process -FilePath "explorer.exe" -ArgumentList "`"$pfad`"" }
    else { [System.Windows.Forms.MessageBox]::Show("Der Ordner ist gerade nicht erreichbar:`n$pfad", "Ordner oeffnen") | Out-Null }
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
    $form.Add_Load({ Setze-Design $this })
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
        $l.AutoSize = $false
        $l.Size = New-Object System.Drawing.Size(172, 20)
        $l.AutoEllipsis = $true
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
    $txtLokal    = & $neuesFeld "Lokaler Ordner (PC):" "LokalerOrdner" $true
    $tipLokal = New-Object System.Windows.Forms.ToolTip
    $tipLokal.SetToolTip($txtLokal, "Ziel fuer 'Nur lokal (PC)'. Leer lassen = Ordner 'Scans' in den eigenen Dokumenten.")
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

# ======================= LOG UND DIAGNOSE IM SHOP-ORDNER =======================
# Kopie der Log-Datei und (per Tray-Menue) ein Diagnosebericht landen in
# "<Status-Ordner>\Logs" - also im Shop-Ordner auf HiDrive, damit man sie
# ohne Zugriff auf den PC ansehen kann.
$script:LogKopieStand = ""

function Get-ShopLogOrdner {
    if ([string]::IsNullOrWhiteSpace($StatusOrdner) -or $StatusOrdner.Trim() -eq "-") { return $null }
    if (-not (Test-Path $StatusOrdner -ErrorAction SilentlyContinue)) { return $null }
    $o = Join-Path $StatusOrdner "Logs"
    if (-not (Test-Path $o)) { New-Item -ItemType Directory -Path $o -Force -ErrorAction Stop | Out-Null }
    return $o
}

function Get-PcKennung { return (Sanitize-Dateiname "$($env:COMPUTERNAME)_$($env:USERNAME)") }

# Lokal zusammenstellen, dann kopieren (direktes Schreiben lehnt HiDrive ab)
function Kopiere-InShopOrdner($lokal, $zielName) {
    $ordner = Get-ShopLogOrdner
    if (-not $ordner) { throw "Shop-Ordner/Status-Ordner '$StatusOrdner' ist nicht erreichbar" }
    $ziel = Join-Path $ordner $zielName
    try { Copy-Item -Path $lokal -Destination $ziel -Force -ErrorAction Stop }
    catch { Remove-Item -Path $ziel -Force -ErrorAction SilentlyContinue; Copy-Item -Path $lokal -Destination $ziel -Force -ErrorAction Stop }
    return $ziel
}

# Alle paar Minuten: Log-Datei in den Shop-Ordner (nur wenn sie sich geaendert hat)
function Kopiere-LogInShopOrdner {
    try {
        if (-not (Test-Path $LogDatei)) { return }
        $info = Get-Item $LogDatei
        $stand = "$($info.Length)|$($info.LastWriteTimeUtc.Ticks)"
        if ($stand -eq $script:LogKopieStand) { return }
        $lokal = Join-Path $ScanTempOrdner ("LogKopie_" + (Get-PcKennung) + ".txt")
        # nur die letzten 3000 Zeilen - die volle Log-Datei kann bis zu $LogMaxMB MB gross werden
        Get-Content -Path $LogDatei -Tail 3000 -ErrorAction Stop | Set-Content -Path $lokal -Encoding UTF8 -Force
        [void](Kopiere-InShopOrdner $lokal ((Get-PcKennung) + "_Log.txt"))
        Remove-Item -Path $lokal -Force -ErrorAction SilentlyContinue
        $script:LogKopieStand = $stand
    } catch {}
}

function Erstelle-Diagnose {
    $z = New-Object System.Collections.Generic.List[string]
    $abschnitt = { param($t) [void]$z.Add(""); [void]$z.Add("===== $t =====") }
    [void]$z.Add("DiNo1 Druck & Scan - Diagnose vom $(Get-Date -Format 'dd.MM.yyyy HH:mm:ss')")
    & $abschnitt "Programm"
    [void]$z.Add("PC: $env:COMPUTERNAME   Benutzer: $env:USERNAME   Standort: $StandortName")
    [void]$z.Add("$($script:EigeneVersionText) (Programmstand $($script:EigeneCodeKennung))")
    [void]$z.Add("Watcher-Datei: $($script:EigenerPfad)")
    [void]$z.Add("Update-Quelle: $UpdateQuelle   Updates gesperrt: $([bool](Test-Path $script:UpdateSperrDatei))")
    & $abschnitt "System"
    try { $os = Get-CimInstance Win32_OperatingSystem; [void]$z.Add("Windows: $($os.Caption) $($os.Version) ($($os.OSArchitecture)), gestartet $($os.LastBootUpTime)") } catch { [void]$z.Add("Windows: ?") }
    [void]$z.Add("PowerShell: $($PSVersionTable.PSVersion)   Sprache: $((Get-Culture).Name)")
    [void]$z.Add("Texterkennung: $(if (-not $OcrAktiv) { 'aus' } elseif ($script:OcrEngine) { 'bereit' } elseif ($script:OcrGeprueft) { 'nicht verfuegbar' } else { 'noch nicht benutzt' })")
    & $abschnitt "Ordner"
    foreach ($p in @(@("Mitarbeiter", $ZielBasis), @("Shop", $ShopOrdner), @("Kasse", $KassenOrdner), @("Lokal", $LokalerOrdner), @("Status", $StatusOrdner), @("Ablage", $WatchFolder), @("Ausweich", $AusweichOrdner))) {
        [void]$z.Add(("{0,-12} {1}  -> {2}" -f $p[0], $p[1], $(if ($p[1] -and (Test-Path $p[1] -ErrorAction SilentlyContinue)) { "erreichbar" } else { "NICHT erreichbar" })))
    }
    try {
        $zs = Ermittle-Zustand
        [void]$z.Add("Nicht uebertragen: $($zs.NichtUebertragen)   Uebersprungen: $($zs.Uebersprungen)   Wartend in Ablage: $($zs.WartendInAblage)")
    } catch {}
    & $abschnitt "Mitarbeiter"
    foreach ($k in $MitarbeiterOrdner.Keys) {
        $o = Join-Path $ZielBasis $MitarbeiterOrdner[$k]
        [void]$z.Add(("{0} -> {1}  ({2})" -f $k, $MitarbeiterOrdner[$k], $(if (Test-Path $o -ErrorAction SilentlyContinue) { "ok" } else { "FEHLT" })))
    }
    & $abschnitt "Laufende Watcher"
    try { foreach ($w in (Ermittle-WatcherProzesse)) { [void]$z.Add("PID $($w.Pid)  Start $($w.Start)  Benutzer $($w.Benutzer)  $($w.Datei)$(if ($w.Eigener) { '  <- dieser' })") } } catch { [void]$z.Add("?") }
    & $abschnitt "Scanner (WIA)"
    try {
        $dm = New-Object -ComObject WIA.DeviceManager
        foreach ($d in $dm.DeviceInfos) {
            $name = "?"; try { $name = $d.Properties.Item("Name").Value } catch {}
            [void]$z.Add("$($d.DeviceID)  Name='$name'  Typ=$($d.Type)")
        }
    } catch { [void]$z.Add("WIA nicht abfragbar: $($_.Exception.Message)") }
    [void]$z.Add("Zuletzt benutzt: $(try { (Get-Content $script:LetzterScannerDatei -Raw -ErrorAction Stop).Trim() } catch { '-' })")
    & $abschnitt "Drucker"
    try { foreach ($d in @(Get-CimInstance Win32_Printer)) { [void]$z.Add("$($d.Name)  (Anschluss $($d.PortName))") } } catch { [void]$z.Add("?") }
    & $abschnitt "Log (letzte 200 Zeilen)"
    try { foreach ($l in @(Get-Content $LogDatei -Tail 200 -ErrorAction Stop)) { [void]$z.Add($l) } } catch { [void]$z.Add("(keine Log-Datei)") }
    return $z
}

function Sende-DiagnoseAnShop {
    $lokal = Join-Path $ScanTempOrdner ("Diagnose_" + (Get-PcKennung) + ".txt")
    try {
        Erstelle-Diagnose | Set-Content -Path $lokal -Encoding UTF8 -Force
        $ziel = Kopiere-InShopOrdner $lokal ((Get-PcKennung) + "_Diagnose_" + (Get-Date -Format 'yyyy-MM-dd_HHmm') + ".txt")
        Kopiere-LogInShopOrdner
        Schreibe-Log "Diagnose in den Shop-Ordner gelegt: $ziel"
        [System.Windows.Forms.MessageBox]::Show("Diagnose und Log liegen jetzt im Shop-Ordner:`n`n$ziel", "Diagnose", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
    } catch {
        Schreibe-Log "FEHLER: Diagnose konnte nicht in den Shop-Ordner gelegt werden: $($_.Exception.Message)"
        $antwort = [System.Windows.Forms.MessageBox]::Show("Die Diagnose konnte nicht in den Shop-Ordner gelegt werden:`n$($_.Exception.Message)`n`nStattdessen lokal oeffnen?", "Diagnose", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
        if ($antwort -eq [System.Windows.Forms.DialogResult]::Yes -and (Test-Path $lokal)) { Start-Process notepad.exe -ArgumentList "`"$lokal`"" }
        return
    }
    Remove-Item -Path $lokal -Force -ErrorAction SilentlyContinue
}

# ======================= DOKUMENTSUCHE =======================
# Jede Ablage wird in einem Suchverzeichnis vermerkt (Datum, Ziel,
# Mitarbeiter, Bezeichnung, Pfad und - wenn vorhanden - der erkannte Text).
# Lokal: C:\PaperPortErsatz\Suchindex.jsonl, Kopie im Shop-Ordner
# "<Status-Ordner>\Suchindex\<PC>_<Benutzer>.jsonl" - so findet jeder PC
# des Shops auch die Dokumente der anderen PCs.
$script:SuchindexDatei = Join-Path $script:DatenOrdner "Suchindex.jsonl"
$script:SuchindexKopieStand = ""

function Merke-FuerSuche($eingabe, $zielpfad, $text) {
    try {
        $t = "$text"
        if ($t.Length -gt 30000) { $t = $t.Substring(0, 30000) }
        $eintrag = [ordered]@{
            Zeit        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Datum       = $eingabe.Datum
            Ziel        = $eingabe.Ziel
            Mitarbeiter = "$($eingabe.Mitarbeiter)"
            Bezeichnung = $eingabe.Kunde
            Pfad        = $zielpfad
            PC          = $env:COMPUTERNAME
            Text        = $t
        }
        $zeile = ($eintrag | ConvertTo-Json -Compress -Depth 2)
        [System.IO.File]::AppendAllText($script:SuchindexDatei, $zeile + "`r`n", (New-Object System.Text.UTF8Encoding($false)))
    } catch {
        Schreibe-Log "HINWEIS: Suchverzeichnis konnte nicht ergaenzt werden: $($_.Exception.Message)"
    }
}

# Alle paar Minuten bzw. nach einer Ablage: Kopie in den Shop-Ordner
function Kopiere-SuchindexInShop {
    try {
        if (-not (Test-Path $script:SuchindexDatei)) { return }
        $info = Get-Item $script:SuchindexDatei
        $stand = "$($info.Length)|$($info.LastWriteTimeUtc.Ticks)"
        if ($stand -eq $script:SuchindexKopieStand) { return }
        if ([string]::IsNullOrWhiteSpace($StatusOrdner) -or $StatusOrdner.Trim() -eq "-" -or -not (Test-Path $StatusOrdner -ErrorAction SilentlyContinue)) { return }
        $ordner = Join-Path $StatusOrdner "Suchindex"
        if (-not (Test-Path $ordner)) { New-Item -ItemType Directory -Path $ordner -Force -ErrorAction Stop | Out-Null }
        $ziel = Join-Path $ordner ((Get-PcKennung) + ".jsonl")
        try { Copy-Item -Path $script:SuchindexDatei -Destination $ziel -Force -ErrorAction Stop }
        catch { Remove-Item -Path $ziel -Force -ErrorAction SilentlyContinue; Copy-Item -Path $script:SuchindexDatei -Destination $ziel -Force -ErrorAction Stop }
        $script:SuchindexKopieStand = $stand
    } catch {}
}

# Ordner, in denen gesucht wird: NUR der Shop-Ordner und die Ordner der
# hier hinterlegten Mitarbeiter (nicht Kasse, nicht lokal, nicht der ganze
# Mitarbeiter-Basisordner mit den Ordnern anderer Shops).
function Get-SuchOrdner {
    $liste = New-Object System.Collections.Generic.List[string]
    if (-not [string]::IsNullOrWhiteSpace($ShopOrdner)) { [void]$liste.Add($ShopOrdner.Trim().TrimEnd('\')) }
    if ($MitarbeiterOrdner -and -not [string]::IsNullOrWhiteSpace($ZielBasis)) {
        foreach ($k in @($MitarbeiterOrdner.Keys)) {
            $name = "$($MitarbeiterOrdner[$k])".Trim()
            if (-not $name) { continue }   # leerer Ordnername wuerde sonst den ganzen Basisordner durchsuchen
            try { [void]$liste.Add((Join-Path $ZielBasis.Trim() $name).TrimEnd('\')) } catch {}
        }
    }
    return ,@($liste | Select-Object -Unique)
}

# Die eigentliche Suche laeuft in einem eigenen Hintergrund-Thread, damit
# das Fenster (und der Watcher) nicht einfriert, wenn HiDrive langsam ist.
# Ergebnisse landen in $zustand.Treffer und werden per Timer angezeigt.
$script:SuchArbeit = {
    param($zustand, $woerter, $suchOrdner, $eigenerIndex, $indexOrdner, $eigeneKennung, $mitDateien, $statusOrdner)

    $maxTreffer = 1000
    $anzahl = 0
    $gefunden = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)

    function ImErlaubtenOrdner($pfad) {
        foreach ($o in $suchOrdner) {
            if ($pfad.StartsWith($o + '\', [System.StringComparison]::OrdinalIgnoreCase)) { return $true }
        }
        return $false
    }
    function PasstAlles($text) {
        foreach ($w in $woerter) { if ($text.IndexOf($w, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) { return $false } }
        return $true
    }
    function Ausschnitt($text, $wort) {
        if (-not $text -or -not $wort) { return "" }
        $flach = ($text -replace '\s+', ' ')
        $i = $flach.IndexOf($wort, [System.StringComparison]::OrdinalIgnoreCase)
        if ($i -lt 0) { return "" }
        $start = [Math]::Max(0, $i - 40)
        $laenge = [Math]::Min($flach.Length - $start, $wort.Length + 80)
        return ("..." + $flach.Substring($start, $laenge).Trim() + "...")
    }

    try {
        # 1. Suchverzeichnisse (dieser PC + andere PCs des Shops)
        $zustand.Status = "Lese Suchverzeichnis ..."
        $dateien = New-Object System.Collections.Generic.List[string]
        if ([System.IO.File]::Exists($eigenerIndex)) { [void]$dateien.Add($eigenerIndex) }
        if ($indexOrdner) {
            try {
                if ([System.IO.Directory]::Exists($indexOrdner)) {
                    foreach ($f in [System.IO.Directory]::GetFiles($indexOrdner, "*.jsonl")) {
                        if ([System.IO.Path]::GetFileName($f) -ne $eigeneKennung) { [void]$dateien.Add($f) }
                    }
                }
            } catch {}
        }
        foreach ($d in $dateien) {
            if ($zustand.Abbrechen) { break }
            $zeilen = @()
            try { $zeilen = [System.IO.File]::ReadAllLines($d, [System.Text.Encoding]::UTF8) } catch { continue }
            foreach ($z in $zeilen) {
                if ($zustand.Abbrechen -or $anzahl -ge $maxTreffer) { break }
                if (-not $z.Trim()) { continue }
                # schneller Vorfilter ohne JSON-Auswertung
                if (-not (PasstAlles $z)) {
                    # Umlaute stehen im JSON evtl. als Unicode-Escape (Backslash-u) - dann trotzdem auswerten
                    if ($z.IndexOf('\u', [System.StringComparison]::Ordinal) -lt 0) { continue }
                }
                try { $e = $z | ConvertFrom-Json } catch { continue }
                $pfad = [string]$e.Pfad
                if (-not $pfad -or -not (ImErlaubtenOrdner $pfad)) { continue }
                if ($gefunden.Contains($pfad)) { continue }
                $alles = "$($e.Bezeichnung) $($e.Mitarbeiter) $($e.Ziel) $([System.IO.Path]::GetFileName($pfad)) $($e.Text)"
                if (-not (PasstAlles $alles)) { continue }
                [void]$gefunden.Add($pfad)
                $fund = Ausschnitt ([string]$e.Text) $woerter[0]
                if (-not $fund) { $fund = "(in Bezeichnung/Dateiname)" }
                $ablage = if ($e.Ziel -eq "Mitarbeiter") { "Mitarbeiter: $($e.Mitarbeiter)" } else { "$($e.Ziel)" }
                $da = $true
                try { $da = [System.IO.File]::Exists($pfad) } catch {}
                $zustand.Treffer.Enqueue([object[]]@([string]$e.Datum, [string]$e.Bezeichnung, $ablage, $fund, $pfad, $da))
                $anzahl++
            }
        }

        # 2. Optional: Dateinamen direkt in den Ordnern (Shop + eigene Mitarbeiter)
        if ($mitDateien -and -not $zustand.Abbrechen) {
            $statusPfad = if ($statusOrdner -and $statusOrdner -ne "-") { $statusOrdner.TrimEnd('\') } else { "" }
            $ordnerZahl = 0
            foreach ($wurzel in $suchOrdner) {
                if ($zustand.Abbrechen -or $anzahl -ge $maxTreffer) { break }
                $zustand.Status = "Durchsuche $wurzel ..."
                try { if (-not [System.IO.Directory]::Exists($wurzel)) { continue } } catch { continue }
                $stapel = New-Object System.Collections.Generic.Stack[string]
                $stapel.Push($wurzel)
                while ($stapel.Count -gt 0) {
                    if ($zustand.Abbrechen -or $anzahl -ge $maxTreffer) { break }
                    $dir = $stapel.Pop()
                    $ordnerZahl++
                    if ($ordnerZahl % 20 -eq 0) { $zustand.Status = "Durchsuche Dateinamen ($ordnerZahl Ordner) ... $dir" }
                    try {
                        foreach ($u in [System.IO.Directory]::GetDirectories($dir)) {
                            if ($statusPfad -and $u.Equals($statusPfad, [System.StringComparison]::OrdinalIgnoreCase)) { continue }
                            $stapel.Push($u)
                        }
                    } catch {}
                    try {
                        foreach ($f in [System.IO.Directory]::GetFiles($dir, "*.pdf")) {
                            if ($gefunden.Contains($f)) { continue }
                            if (-not (PasstAlles $f)) { continue }
                            [void]$gefunden.Add($f)
                            $datum = ""
                            try { $datum = [System.IO.File]::GetLastWriteTime($f).ToString("yyyy-MM-dd") } catch {}
                            $zustand.Treffer.Enqueue([object[]]@($datum, [System.IO.Path]::GetFileNameWithoutExtension($f), [System.IO.Path]::GetFileName($dir), "(Dateiname)", $f, $true))
                            $anzahl++
                            if ($anzahl -ge $maxTreffer) { break }
                        }
                    } catch {}
                }
            }
        }
        if ($anzahl -ge $maxTreffer) { $zustand.ZuViele = $true }
    } catch {
        $zustand.Fehler = $_.Exception.Message
    } finally {
        $zustand.Fertig = $true
    }
}

function Zeige-Suche {
    $suchOrdner = Get-SuchOrdner

    $form = New-Object System.Windows.Forms.Form
    $form.Add_Load({ Setze-Design $this })
    $form.Text = "Dokumente suchen - DiNo1 Druck & Scan ($StandortName)"
    $form.Size = New-Object System.Drawing.Size(1000, 600)
    $form.StartPosition = "CenterScreen"
    $form.MinimumSize = New-Object System.Drawing.Size(700, 400)

    $oben = New-Object System.Windows.Forms.Panel
    $oben.Dock = "Top"
    $oben.Height = 70
    $form.Controls.Add($oben)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "Suchbegriff(e):"
    $lbl.Location = New-Object System.Drawing.Point(10, 13)
    $lbl.AutoSize = $true
    $oben.Controls.Add($lbl)

    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Location = New-Object System.Drawing.Point(110, 10)
    $txt.Width = 420
    $oben.Controls.Add($txt)

    $btnSuchen = New-Object System.Windows.Forms.Button
    $btnSuchen.Text = "Suchen"
    $btnSuchen.Location = New-Object System.Drawing.Point(540, 8)
    $btnSuchen.Size = New-Object System.Drawing.Size(90, 26)
    $oben.Controls.Add($btnSuchen)
    $form.AcceptButton = $btnSuchen

    $btnStopp = New-Object System.Windows.Forms.Button
    $btnStopp.Text = "Stopp"
    $btnStopp.Location = New-Object System.Drawing.Point(636, 8)
    $btnStopp.Size = New-Object System.Drawing.Size(70, 26)
    $btnStopp.Enabled = $false
    $oben.Controls.Add($btnStopp)

    $chkDateien = New-Object System.Windows.Forms.CheckBox
    $chkDateien.Text = "Auch Dateinamen im Shop-Ordner und in den Mitarbeiter-Ordnern durchsuchen (findet auch aeltere Dokumente, langsamer)"
    $chkDateien.Location = New-Object System.Drawing.Point(110, 40)
    $chkDateien.AutoSize = $true
    $oben.Controls.Add($chkDateien)

    $tip = New-Object System.Windows.Forms.ToolTip
    $tip.SetToolTip($chkDateien, "Durchsucht werden nur:`n" + (($suchOrdner | ForEach-Object { "  $_" }) -join "`n"))

    $grid = New-Object System.Windows.Forms.DataGridView
    $grid.Dock = "Fill"
    $grid.ReadOnly = $true
    $grid.AllowUserToAddRows = $false
    $grid.RowHeadersVisible = $false
    $grid.SelectionMode = "FullRowSelect"
    $grid.MultiSelect = $false
    $grid.AutoSizeColumnsMode = "Fill"
    foreach ($s in @(@("Datum", 80), @("Bezeichnung", 160), @("Ablage", 140), @("Fundstelle", 260), @("Datei", 280))) {
        $i = $grid.Columns.Add($s[0], $s[0]); $grid.Columns[$i].FillWeight = $s[1]
    }
    $form.Controls.Add($grid)
    $grid.BringToFront()

    $unten = New-Object System.Windows.Forms.Panel
    $unten.Dock = "Bottom"
    $unten.Height = 42
    $unten.Padding = New-Object System.Windows.Forms.Padding(6, 7, 6, 7)
    $form.Controls.Add($unten)

    $lblInfo = New-Object System.Windows.Forms.Label
    $lblInfo.Location = New-Object System.Drawing.Point(10, 13)
    $lblInfo.AutoSize = $true
    $lblInfo.UseMnemonic = $false
    $lblInfo.Text = "Sucht nur im Shop-Ordner und in den Ordnern der hinterlegten Mitarbeiter. Mehrere Woerter = alle muessen vorkommen."
    $unten.Controls.Add($lblInfo)

    $btnOrdner = New-Object System.Windows.Forms.Button
    $btnOrdner.Text = "Ordner oeffnen"
    $btnOrdner.Size = New-Object System.Drawing.Size(120, 28)
    $btnOrdner.Dock = "Right"
    $unten.Controls.Add($btnOrdner)

    $btnOeffnen = New-Object System.Windows.Forms.Button
    $btnOeffnen.Text = "Oeffnen"
    $btnOeffnen.Size = New-Object System.Drawing.Size(120, 28)
    $btnOeffnen.Dock = "Right"
    $unten.Controls.Add($btnOeffnen)

    $holePfad = {
        if ($grid.SelectedRows.Count -eq 0) { return $null }
        return [string]$grid.SelectedRows[0].Cells["Datei"].Value
    }
    $oeffne = {
        $p = & $holePfad
        if (-not $p) { return }
        if (-not (Test-Path $p)) { [System.Windows.Forms.MessageBox]::Show($form, "Die Datei ist nicht (mehr) erreichbar:`n$p", "Oeffnen") | Out-Null; return }
        try { Start-Process -FilePath $p } catch { [System.Windows.Forms.MessageBox]::Show($form, "Oeffnen fehlgeschlagen: $($_.Exception.Message)", "Oeffnen") | Out-Null }
    }
    $btnOeffnen.Add_Click($oeffne)
    $grid.Add_CellDoubleClick($oeffne)
    $btnOrdner.Add_Click({
        $p = & $holePfad
        if (-not $p) { return }
        if (Test-Path $p) { Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$p`"" }
        elseif (Test-Path (Split-Path $p -Parent)) { Start-Process -FilePath "explorer.exe" -ArgumentList "`"$(Split-Path $p -Parent)`"" }
    })

    # Zustand der laufenden Suche (Hashtable, damit die Handler ihn aendern koennen)
    $lauf = @{ PS = $null; Handle = $null; Zustand = $null; Anzahl = 0 }

    $beendeLauf = {
        if ($lauf.Zustand) { $lauf.Zustand.Abbrechen = $true }
        if ($lauf.PS) {
            $alt = $lauf.PS
            # nicht blockierend beenden: haengt HiDrive gerade, endet der Hintergrund-Thread spaeter von selbst
            try { [void]$alt.BeginStop($null, $null) } catch {}
        }
        $lauf.PS = $null; $lauf.Handle = $null
    }

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 250
    $timer.Add_Tick({
        $z = $lauf.Zustand
        if (-not $z) { $timer.Stop(); return }
        $zeile = $null
        $n = 0
        if ($z.Treffer.Count -gt 0) { $grid.SuspendLayout() }
        while ($n -lt 300 -and $z.Treffer.TryDequeue([ref]$zeile)) {
            $i = $grid.Rows.Add([object[]]@($zeile[0], $zeile[1], $zeile[2], $zeile[3], $zeile[4]))
            if (-not $zeile[5]) { $grid.Rows[$i].DefaultCellStyle.ForeColor = [System.Drawing.Color]::Gray }
            $lauf.Anzahl++
            $n++
        }
        if ($n -gt 0) { $grid.ResumeLayout() }
        if ($z.Fertig -and $z.Treffer.Count -eq 0) {
            $timer.Stop()
            try { if ($lauf.PS) { $lauf.PS.Dispose() } } catch {}
            $lauf.PS = $null
            $btnStopp.Enabled = $false
            $form.Cursor = [System.Windows.Forms.Cursors]::Default
            try { $grid.Sort($grid.Columns["Datum"], [System.ComponentModel.ListSortDirection]::Descending) } catch {}
            if ($z.Fehler) {
                $lblInfo.Text = "Fehler bei der Suche: $($z.Fehler)"
            } else {
                $zusatz = ""
                if ($z.Abbrechen) { $zusatz = " (gestoppt)" }
                elseif ($z.ZuViele) { $zusatz = " (es gibt mehr - bitte Suchbegriff genauer fassen)" }
                $lblInfo.Text = "$($lauf.Anzahl) Treffer$zusatz. Doppelklick = oeffnen. Grau = Datei nicht erreichbar."
            }
        } else {
            $lblInfo.Text = "$($lauf.Anzahl) Treffer bisher - $($z.Status)"
        }
    })

    $btnSuchen.Add_Click({
        $woerter = @(($txt.Text -split '\s+') | Where-Object { $_ })
        if ($woerter.Count -eq 0) { return }
        & $beendeLauf
        $grid.Rows.Clear()
        $lauf.Anzahl = 0

        $zustand = [hashtable]::Synchronized(@{
            Abbrechen = $false; Fertig = $false; Fehler = ""; ZuViele = $false
            Status = "Suche laeuft ..."
            Treffer = New-Object 'System.Collections.Concurrent.ConcurrentQueue[object]'
        })
        $lauf.Zustand = $zustand

        $indexOrdner = ""
        if (-not [string]::IsNullOrWhiteSpace($StatusOrdner) -and $StatusOrdner.Trim() -ne "-") {
            try { $indexOrdner = Join-Path $StatusOrdner "Suchindex" } catch {}
        }
        try {
            $ps = [System.Management.Automation.PowerShell]::Create()
            [void]$ps.AddScript($script:SuchArbeit.ToString())
            [void]$ps.AddArgument($zustand)
            [void]$ps.AddArgument([string[]]$woerter)
            [void]$ps.AddArgument([string[]]$suchOrdner)
            [void]$ps.AddArgument([string]$script:SuchindexDatei)
            [void]$ps.AddArgument($indexOrdner)
            [void]$ps.AddArgument((Get-PcKennung) + ".jsonl")
            [void]$ps.AddArgument([bool]$chkDateien.Checked)
            [void]$ps.AddArgument([string]$StatusOrdner)
            $lauf.PS = $ps
            $lauf.Handle = $ps.BeginInvoke()
        } catch {
            $lblInfo.Text = "Suche konnte nicht gestartet werden: $($_.Exception.Message)"
            return
        }
        $form.Cursor = [System.Windows.Forms.Cursors]::AppStarting
        $btnStopp.Enabled = $true
        $lblInfo.Text = "Suche laeuft ..."
        $timer.Start()
    })

    $btnStopp.Add_Click({
        if ($lauf.Zustand) { $lauf.Zustand.Abbrechen = $true }
        $lblInfo.Text = "Wird gestoppt ..."
    })

    $form.Add_FormClosing({
        $timer.Stop()
        & $beendeLauf
    })

    $form.Add_Shown({ $txt.Focus() })
    [void]$form.ShowDialog()
    try { $timer.Dispose() } catch {}
}

# ======================= TRAY-SYMBOL =======================

$trayIcon = New-Object System.Windows.Forms.NotifyIcon
$trayIcon.Icon = $(try { $ti = Hole-DinoIcon ([System.Windows.Forms.SystemInformation]::SmallIconSize.Width); if ($ti) { $ti } else { Erstelle-ScannerIcon } } catch { Erstelle-ScannerIcon })
$trayIcon.Text = "DiNo1 Druck & Scan ($StandortName)"
$trayIcon.Visible = $true

$menu = New-Object System.Windows.Forms.ContextMenuStrip
$menuSuche = $menu.Items.Add("Dokumente suchen...")
$menuSuche.Font = New-Object System.Drawing.Font($menuSuche.Font, [System.Drawing.FontStyle]::Bold)
$menuSuche.Add_Click({ Zeige-Suche })
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
$menuDiagnose = $menu.Items.Add("Diagnose in den Shop-Ordner legen")
$menuDiagnose.Add_Click({
    $timer.Stop()
    try { Sende-DiagnoseAnShop } finally { try { $timer.Start() } catch {} }
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

# Doppelklick aufs Symbol: Programmfenster (Scannen, Dokumente suchen, ...)
$trayIcon.Add_DoubleClick({ Zeige-Hauptfenster })

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
    Kopiere-LogInShopOrdner
    Kopiere-SuchindexInShop
    Hefte-TraySymbolAn
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

# ======================= PROGRAMMFENSTER, VERKNUEPFUNG, SYMBOL ANHEFTEN =======================
# 1. Tray-Symbol immer sichtbar (Windows 11): In "HKCU\Control Panel\
#    NotifyIconSettings" fuer unser Symbol IsPromoted=1 setzen - wie
#    "Einstellungen -> Taskleiste -> Weitere Symbole" von Hand.
# 2. Programmfenster mit grossen Knoepfen (Scannen, Suchen, ...), zu oeffnen
#    ueber die Verknuepfung "DiNo1 Druck & Scan" auf dem Desktop / im
#    Startmenue (laesst sich auch an die Taskleiste anheften) oder ueber
#    das Tray-Menue (oder Doppelklick aufs Symbol).
#    Die Verknuepfung startet Oeffnen.ps1; das signalisiert dem laufenden
#    Watcher ueber ein benanntes Ereignis, das Fenster zu zeigen (laeuft keiner,
#    wird er gestartet).

function Hefte-TraySymbolAn {
    try {
        $basis = "HKCU:\Control Panel\NotifyIconSettings"
        if (-not (Test-Path $basis)) { return }   # Windows 10: dort gibt es das nicht
        $kandidaten = New-Object System.Collections.Generic.List[string]
        $gefunden = $false
        foreach ($k in @(Get-ChildItem -Path $basis -ErrorAction SilentlyContinue)) {
            $w = Get-ItemProperty -Path $k.PSPath -ErrorAction SilentlyContinue
            if ("$($w.ExecutablePath)" -notmatch '(?i)powershell\.exe$') { continue }
            # Windows merkt sich den Text, den das Symbol beim ALLERERSTEN Mal
            # hatte - bei aelteren Installationen also noch "PaperPort Ersatz ..."
            $tip = "$($w.InitialTooltip)"
            [void]$kandidaten.Add("'$tip' (angeheftet: $([int]$w.IsPromoted))")
            if ($tip -match '(?i)DiNo1|PaperPort|Druck.*Scan') {
                $gefunden = $true
                if ([int]$w.IsPromoted -ne 1) {
                    Set-ItemProperty -Path $k.PSPath -Name "IsPromoted" -Value 1 -Type DWord -ErrorAction Stop
                    Schreibe-Log "Tray-Symbol dauerhaft sichtbar gemacht (Eintrag '$tip')."
                }
            }
        }
        if (-not $gefunden -and -not $script:AnheftenGemeldet) {
            $script:AnheftenGemeldet = $true
            Schreibe-Log "HINWEIS: Tray-Symbol zum Anheften nicht gefunden. PowerShell-Eintraege: $(if ($kandidaten.Count) { $kandidaten -join '; ' } else { '(keine)' })"
        }
    } catch {
        if (-not $script:AnheftenGemeldet) { $script:AnheftenGemeldet = $true; Schreibe-Log "HINWEIS: Tray-Symbol anheften fehlgeschlagen: $($_.Exception.Message)" }
    }
}

$script:FensterEreignisName = "Local\DiNo1DruckScanFenster"
$script:FensterEreignis = $null
try { $script:FensterEreignis = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::AutoReset, $script:FensterEreignisName) } catch {}

function Erstelle-Verknuepfungen {
    $ordner = Split-Path $script:EigenerPfad
    $merker = Join-Path $ordner "Verknuepfung_erstellt.txt"
    $oeffnen = Join-Path $ordner "Oeffnen.ps1"
    $icoPfad = Join-Path $ordner "DiNo1.ico"
    try {
        # Hilfsskript fuer die Verknuepfung (wird bei jedem Start aktualisiert)
        $inhalt = @'
# DiNo1 Druck & Scan - Programmfenster oeffnen (wird von der Verknuepfung gestartet)
$name = "Local\DiNo1DruckScanFenster"
$ereignis = $null
try { $ereignis = [System.Threading.EventWaitHandle]::OpenExisting($name) } catch {}
if (-not $ereignis) {
    Start-Process -FilePath "conhost.exe" -ArgumentList ("--headless powershell.exe -ExecutionPolicy Bypass -File `"" + (Join-Path $PSScriptRoot "Watcher.ps1") + "`"")
    for ($i = 0; $i -lt 30 -and -not $ereignis; $i++) {
        Start-Sleep -Milliseconds 500
        try { $ereignis = [System.Threading.EventWaitHandle]::OpenExisting($name) } catch {}
    }
}
if ($ereignis) { [void]$ereignis.Set() }
'@
        $alt = if (Test-Path $oeffnen) { [System.IO.File]::ReadAllText($oeffnen) } else { "" }
        if ($alt -ne $inhalt) { [System.IO.File]::WriteAllText($oeffnen, $inhalt, [System.Text.Encoding]::ASCII) }
        # Programmsymbol (DiNo1-Logo) fuer die Verknuepfungen - bei neuem Symbol ersetzen
        try {
            $icoBytes = [Convert]::FromBase64String($script:IconBase64)
            $altBytes = if (Test-Path $icoPfad) { [System.IO.File]::ReadAllBytes($icoPfad) } else { $null }
            if ($null -eq $altBytes -or [Convert]::ToBase64String($altBytes) -ne $script:IconBase64) { [System.IO.File]::WriteAllBytes($icoPfad, $icoBytes) }
        } catch {
            if (-not (Test-Path $icoPfad)) {
                $fs = [System.IO.File]::Create($icoPfad)
                try { $trayIcon.Icon.Save($fs) } finally { $fs.Close() }
            }
        }
        if (Test-Path $merker) { return }   # nur einmal anlegen - geloeschte Verknuepfungen nicht wieder herstellen
        $shell = New-Object -ComObject WScript.Shell
        $ziele = @(
            (Join-Path ([Environment]::GetFolderPath("Desktop")) "DiNo1 Druck und Scan.lnk"),
            (Join-Path ([Environment]::GetFolderPath("Programs")) "DiNo1 Druck und Scan.lnk")
        )
        foreach ($lnk in $ziele) {
            $v = $shell.CreateShortcut($lnk)
            $v.TargetPath = Join-Path $env:WINDIR "System32\conhost.exe"
            $v.Arguments = "--headless powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$oeffnen`""
            $v.WorkingDirectory = $ordner
            $v.IconLocation = "$icoPfad,0"
            $v.Description = "DiNo1 Druck & Scan - Scannen, Dokumente suchen, Ablage"
            $v.Save()
        }
        Set-Content -Path $merker -Value (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -Encoding ASCII
        Schreibe-Log "Verknuepfungen 'DiNo1 Druck und Scan' auf Desktop und im Startmenue angelegt."
    } catch {
        Schreibe-Log "HINWEIS: Verknuepfungen konnten nicht angelegt werden: $($_.Exception.Message)"
    }
}

# Desktop-Verknuepfung "DiNo1 neu starten": beendet einen haengenden Watcher
# (nur die eigenen Prozesse dieses Benutzers) und startet ihn neu. Wird
# einmal angelegt; das Hilfsskript Neustart.ps1 bei jedem Start aktualisiert.
function Erstelle-NeustartVerknuepfung {
    $ordner = Split-Path $script:EigenerPfad
    $merker = Join-Path $ordner "Neustart_Verknuepfung_erstellt.txt"
    $skript = Join-Path $ordner "Neustart.ps1"
    $icoPfad = Join-Path $ordner "DiNo1.ico"
    try {
        $inhalt = @'
# DiNo1 Druck & Scan - Watcher beenden und neu starten (Desktop-Verknuepfung)
Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe' OR Name = 'conhost.exe'" -ErrorAction SilentlyContinue |
    Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -like '*Watcher.ps1*' } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
Start-Sleep -Seconds 2
Start-Process -FilePath "conhost.exe" -ArgumentList ("--headless powershell.exe -ExecutionPolicy Bypass -File `"" + (Join-Path $PSScriptRoot "Watcher.ps1") + "`"")
'@
        $alt = if (Test-Path $skript) { [System.IO.File]::ReadAllText($skript) } else { "" }
        if ($alt -ne $inhalt) { [System.IO.File]::WriteAllText($skript, $inhalt, [System.Text.Encoding]::ASCII) }
        if (Test-Path $merker) { return }
        $shell = New-Object -ComObject WScript.Shell
        $v = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("Desktop")) "DiNo1 neu starten.lnk"))
        $v.TargetPath = Join-Path $env:WINDIR "System32\WindowsPowerShell\v1.0\powershell.exe"
        $v.Arguments = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$skript`""
        $v.WorkingDirectory = $ordner
        if (Test-Path $icoPfad) { $v.IconLocation = "$icoPfad,0" }
        $v.Description = "DiNo1 Druck & Scan beenden und neu starten (z.B. wenn es haengt)"
        $v.Save()
        Set-Content -Path $merker -Value (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -Encoding ASCII
        Schreibe-Log "Verknuepfung 'DiNo1 neu starten' auf dem Desktop angelegt."
    } catch {
        Schreibe-Log "HINWEIS: Verknuepfung 'DiNo1 neu starten' konnte nicht angelegt werden: $($_.Exception.Message)"
    }
}

$script:Hauptfenster = $null
function Zeige-Hauptfenster {
    if ($script:Hauptfenster -and -not $script:Hauptfenster.IsDisposed) {
        $script:Hauptfenster.WindowState = "Normal"
        $script:Hauptfenster.Activate()
        return
    }
    $oe = [char]0x00F6; $ue = [char]0x00FC
    $f = New-Object System.Windows.Forms.Form
    $f.Add_Load({ Setze-Design $this })
    $f.Text = "DiNo1 Druck & Scan - $StandortName"
    $ic = Hole-DinoIcon
    $f.Icon = $(if ($ic) { $ic } else { $trayIcon.Icon })
    $f.FormBorderStyle = "FixedSingle"
    $f.MaximizeBox = $false
    $f.StartPosition = "CenterScreen"
    $f.BackColor = $script:FarbeFlaeche
    $f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None
    $f.ClientSize = New-Object System.Drawing.Size(460, 616)

    # ---- Kopfbereich: Logo + Titel ----
    $kopfFlaeche = New-Object System.Windows.Forms.Panel
    $kopfFlaeche.Location = New-Object System.Drawing.Point(0, 0)
    $kopfFlaeche.Size = New-Object System.Drawing.Size(460, 118)
    $kopfFlaeche.BackColor = [System.Drawing.Color]::White
    $f.Controls.Add($kopfFlaeche)

    $logo = Hole-Logo
    $textLinks = 20
    if ($logo) {
        $bild = New-Object System.Windows.Forms.PictureBox
        $bild.Image = $logo
        $bild.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $bild.Location = New-Object System.Drawing.Point(14, 9)
        $bild.Size = New-Object System.Drawing.Size(202, 100)
        $kopfFlaeche.Controls.Add($bild)
        $textLinks = 234
    }
    $titel = New-Object System.Windows.Forms.Label
    $titel.Text = "Druck & Scan"
    $titel.UseMnemonic = $false
    $titel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 18)
    $titel.ForeColor = $script:FarbeText
    $titel.Location = New-Object System.Drawing.Point($textLinks, 26)
    $titel.AutoSize = $true
    $kopfFlaeche.Controls.Add($titel)

    $standort = New-Object System.Windows.Forms.Label
    $standort.Text = "Standort: $StandortName"
    $standort.UseMnemonic = $false
    $standort.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $standort.ForeColor = $script:FarbeText
    $standort.Location = New-Object System.Drawing.Point(($textLinks + 2), 66)
    $standort.Size = New-Object System.Drawing.Size((450 - $textLinks), 20)
    $kopfFlaeche.Controls.Add($standort)

    $version = New-Object System.Windows.Forms.Label
    $version.Text = $script:EigeneVersionText
    $version.UseMnemonic = $false
    $version.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
    $version.ForeColor = $script:FarbeGrau
    $version.Location = New-Object System.Drawing.Point(($textLinks + 2), 86)
    $version.Size = New-Object System.Drawing.Size((450 - $textLinks), 18)
    $kopfFlaeche.Controls.Add($version)

    $streifen = New-Object System.Windows.Forms.Panel
    $streifen.Location = New-Object System.Drawing.Point(0, 118)
    $streifen.Size = New-Object System.Drawing.Size(460, 4)
    $streifen.BackColor = $script:FarbeAkzent
    $f.Controls.Add($streifen)

    # ---- Hauptaktionen als Kacheln ----
    $menueAktion = { param($p) $p.Tag.Menue.PerformClick() }
    $kacheln = @(
        @("Jetzt scannen",            0xE8FE, $menuScan,          $true),
        @("Dokumente suchen",         0xE721, $menuSuche,         $false),
        @("$($ue)bersprungene erfassen", 0xE81C, $menuUebersprungen, $false),
        @("Ablage-Ordner $($oe)ffnen", 0xE838, $menuAblageOeffnen, $false),
        @("Ordner anpassen",          0xE713, $menuOrdner,        $false),
        @("Nach Updates suchen",      0xE895, $menuUpdate,        $false)
    )
    for ($i = 0; $i -lt $kacheln.Count; $i++) {
        $k = $kacheln[$i]
        $x = 20 + ($i % 2) * 216
        $y = 140 + [Math]::Floor($i / 2) * 86
        $p = Neue-Kachel $f $x $y 204 74 $k[0] $k[1] $menueAktion "gross" $k[3]
        $p.Tag.Menue = $k[2]
        if ($i -eq 2) { $script:HfUeberKachel = $p }
    }

    # ---- Ordner direkt oeffnen ----
    $ordnerTitel = New-Object System.Windows.Forms.Label
    $ordnerTitel.Text = "ORDNER $($oe.ToString().ToUpper())FFNEN"
    $ordnerTitel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 8.5)
    $ordnerTitel.ForeColor = $script:FarbeGrau
    $ordnerTitel.Location = New-Object System.Drawing.Point(22, 404)
    $ordnerTitel.AutoSize = $true
    $f.Controls.Add($ordnerTitel)

    $ordnerAktion = {
        param($p)
        if ($p.Tag.Auswahl) { $p.Tag.Auswahl.Show($p, 0, $p.Height) } else { Oeffne-OrdnerPfad ([string]$p.Tag.Pfad) }
    }
    $menueOrdnerKlick = { Oeffne-OrdnerPfad ([string]$this.Tag) }
    $ordnerKnoepfe = @(
        @("Mitarbeiter", $ZielBasis,     0xE716),
        @("Shop",        $ShopOrdner,    0xE719),
        @("Kasse",       $KassenOrdner,  0xE8C7),
        @("Lokal (PC)",  $LokalerOrdner, 0xE977)
    )
    for ($i = 0; $i -lt $ordnerKnoepfe.Count; $i++) {
        $p = Neue-Kachel $f (20 + $i * 106) 426 98 66 $ordnerKnoepfe[$i][0] $ordnerKnoepfe[$i][2] $ordnerAktion "klein"
        $p.Tag.Pfad = $ordnerKnoepfe[$i][1]
        $p.Tag.Auswahl = $null
        if ($i -eq 0 -and $MitarbeiterOrdner.Count -gt 0) {
            $auswahl = New-Object System.Windows.Forms.ContextMenuStrip
            $alle = $auswahl.Items.Add("Alle Mitarbeiter-Ordner")
            $alle.Tag = $ZielBasis
            $alle.Add_Click($menueOrdnerKlick)
            [void]$auswahl.Items.Add("-")
            foreach ($k in $MitarbeiterOrdner.Keys) {
                $e = $auswahl.Items.Add($k)
                $e.Tag = Join-Path $ZielBasis $MitarbeiterOrdner[$k]
                $e.Add_Click($menueOrdnerKlick)
            }
            $p.Tag.Auswahl = $auswahl
        }
    }

    # ---- Status-Karte ----
    $karte = Neue-Kachel $f 20 508 420 84 "" $null $null "karte"
    $script:HfPunkte = @()
    $script:HfTexte = @()
    for ($i = 0; $i -lt 3; $i++) {
        $pu = New-Object System.Windows.Forms.Label
        $pu.Text = [string][char]0x25CF
        $pu.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $pu.BackColor = [System.Drawing.Color]::Transparent
        $pu.ForeColor = $script:FarbeGrau
        $pu.Location = New-Object System.Drawing.Point(14, (9 + $i * 23))
        $pu.Size = New-Object System.Drawing.Size(18, 22)
        $karte.Controls.Add($pu)
        $tx = New-Object System.Windows.Forms.Label
        $tx.UseMnemonic = $false
        $tx.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
        $tx.BackColor = [System.Drawing.Color]::Transparent
        $tx.ForeColor = $script:FarbeText
        $tx.Location = New-Object System.Drawing.Point(34, (11 + $i * 23))
        $tx.Size = New-Object System.Drawing.Size(376, 20)
        $karte.Controls.Add($tx)
        $script:HfPunkte += $pu
        $script:HfTexte += $tx
    }

    $fuss = New-Object System.Windows.Forms.Label
    $fuss.Text = "$([char]0x00A9) DiNo1 GmbH"
    $fuss.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $fuss.ForeColor = $script:FarbeGrau
    $fuss.Location = New-Object System.Drawing.Point(22, 597)
    $fuss.AutoSize = $true
    $f.Controls.Add($fuss)

    # Laeuft spaeter (Fenster ist nicht modal) - deshalb nur $script:-Variablen
    $aktualisiere = {
        $n = @(Get-ChildItem -Path $UebersprungenOrdner -Filter "*.pdf" -File -ErrorAction SilentlyContinue).Count
        $script:HfUeberKachel.Tag.TextLabel.Text = "$([char]0x00DC)bersprungene erfassen ($n)"
        $script:HfUeberKachel.Enabled = ($n -gt 0)
        $hdOk = [bool](Test-Path $ZielBasis -ErrorAction SilentlyContinue)
        $nu = @(Get-ChildItem -Path $AusweichOrdner -File -Recurse -ErrorAction SilentlyContinue).Count
        $letzte = if ($script:LetzteAblage) { ($script:LetzteAblage -split '  ', 2)[0] } else { "-" }
        $script:HfTexte[0].Text = "HiDrive: " + $(if ($hdOk) { "erreichbar" } else { "NICHT erreichbar" })
        $script:HfPunkte[0].ForeColor = $(if ($hdOk) { $script:FarbeGruen } else { $script:FarbeRot })
        $script:HfTexte[1].Text = "Noch nicht $([char]0x00FC)bertragen: $nu"
        $script:HfPunkte[1].ForeColor = $(if ($nu -eq 0) { $script:FarbeGruen } else { $script:FarbeRot })
        $script:HfTexte[2].Text = "Letzte Ablage: $letzte"
        $script:HfPunkte[2].ForeColor = $script:FarbeGrau
    }
    $f.Add_Activated($aktualisiere)
    $script:Hauptfenster = $f
    $f.Show()
    $f.Activate()
}

# Schneller Zusatz-Timer: reagiert auf die Verknuepfung (Fenster zeigen)
$script:FensterTimer = New-Object System.Windows.Forms.Timer
$script:FensterTimer.Interval = 400
$script:FensterTimer.Add_Tick({
    try {
        if ($script:FensterEreignis -and $script:FensterEreignis.WaitOne(0)) { Zeige-Hauptfenster }
    } catch {}
})
$script:FensterTimer.Start()

$menuFenster = New-Object System.Windows.Forms.ToolStripMenuItem("Programmfenster oeffnen")
$menuFenster.Add_Click({ Zeige-Hauptfenster })
$menu.Items.Insert(0, $menuFenster)

Erstelle-Verknuepfungen
Erstelle-NeustartVerknuepfung

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
