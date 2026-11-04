<#
    PaperPort-Ersatz: Ablage-Watcher (Produktivversion)
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
$UpdateQuelle = "https://raw.githubusercontent.com/trendtino/paperport-ersatz/main/Watcher.ps1"

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
}

# ======================= VERSION =======================
# Bei JEDER Aenderung am Programm hochzaehlen und das Datum anpassen - wird im
# Tray-Menue "Ueber", bei "Nach Updates suchen" und im Log angezeigt.
# (Ein Update wird auch ohne Hochzaehlen erkannt; die Nummer dient nur der
# Uebersicht, welcher PC welchen Stand hat.)
$script:WatcherVersion      = "12"
$script:WatcherVersionDatum = "04.11.2026"

# ======================= STANDARDWERTE FUER NEUERE EINSTELLUNGEN =======================
# Bei einem automatischen Update bleibt der Abschnitt KONFIGURATION dieses
# PCs unveraendert - Einstellungen, die erst in einer neueren Version
# hinzugekommen sind, fehlen dort also. Sie bekommen hier einen Standardwert.
# WICHTIG fuer kuenftige Aenderungen: Jede NEUE Einstellung hier ebenfalls
# mit Standardwert eintragen, sonst fehlt sie auf automatisch aktualisierten
# PCs (bis dort Setup.cmd erneut ausgefuehrt wird).
if ($null -eq $LokalerOrdner) { $LokalerOrdner = "" }
if ($null -eq $UpdateQuelle)  { $UpdateQuelle = "" }

if ([string]::IsNullOrWhiteSpace($LokalerOrdner)) {
    $LokalerOrdner = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Scans"
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
#   PpePdf.Schreibe          - PDF aus JPEG-Seiten erzeugen
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
        int n = jpegs.Length;
        long[] pos = new long[3 + 3 * n];
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
                T(s, seiteNr + " 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 " + Z(wPt) + " " + Z(hPt) + "] /Resources << /XObject << /Im0 " + bildNr + " 0 R >> >> /Contents " + inhaltNr + " 0 R >>\nendobj\n");

                string inhalt = "q " + Z(wPt) + " 0 0 " + Z(hPt) + " 0 0 cm /Im0 Do Q";
                pos[inhaltNr] = s.Position;
                T(s, inhaltNr + " 0 obj\n<< /Length " + inhalt.Length + " >>\nstream\n" + inhalt + "\nendstream\nendobj\n");

                pos[bildNr] = s.Position;
                string bildArt = schwarzweiss[i]
                    ? " /ColorSpace /DeviceGray /BitsPerComponent 1 /Filter /FlateDecode"
                    : " /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode";
                T(s, bildNr + " 0 obj\n<< /Type /XObject /Subtype /Image /Width " + breite[i] + " /Height " + hoehe[i] + bildArt + " /Length " + jpegs[i].Length + " >>\nstream\n");
                s.Write(jpegs[i], 0, jpegs[i].Length);
                T(s, "\nendstream\nendobj\n");
            }

            long xref = s.Position;
            int anzahl = 3 + 3 * n;
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

function Zeige-Erfassungsdialog($dateiname, $dateipfad) {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Dokument erfassen - $dateiname ($StandortName)"
    $form.Size = New-Object System.Drawing.Size(480, 340)
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
    $doc.DocumentName = "PaperPort-Ersatz Scan ($($bildPfade.Count) Seite(n))"

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
    $form.ClientSize = New-Object System.Drawing.Size(400, 325)
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
        $dpi = $ScanStandardDpi; $leer = $LeereSeitenEntfernen
        if ($gemerkt.ContainsKey($e.Anzeige)) {
            $g = $gemerkt[$e.Anzeige]
            if ($g.Quelle) { $quelle = $g.Quelle }
            if ($null -ne $g.Duplex) { $duplex = [bool]$g.Duplex }
            if ($g.Farbe) { $farbe = $g.Farbe }
            if ($g.Dpi) { $dpi = [int]$g.Dpi }
            if ($null -ne $g.LeereSeiten) { $leer = [bool]$g.LeereSeiten }
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
        & $aktualisiereDuplex
    }
    $cmbScanner.Add_SelectedIndexChanged($aktualisiere)
    $radEinzug.Add_CheckedChanged($aktualisiereDuplex)
    $cmbScanner.SelectedIndex = $startIndex
    & $aktualisiere

    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Text = "Scannen"
    $btnOK.Size = New-Object System.Drawing.Size(110, 32)
    $btnOK.Location = New-Object System.Drawing.Point(155, 278)
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
    $btnAbbrechen.Location = New-Object System.Drawing.Point(275, 278)
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
function Hole-WiaBild($item) {
    $versuche = @(
        @{ Name = "Transfer BMP";     Format = $script:WIA_FORMAT_BMP;  Dialog = $false },
        @{ Name = "Transfer PNG";     Format = $script:WIA_FORMAT_PNG;  Dialog = $false },
        @{ Name = "Transfer JPEG";    Format = $script:WIA_FORMAT_JPEG; Dialog = $false },
        @{ Name = "CommonDialog BMP"; Format = $script:WIA_FORMAT_BMP;  Dialog = $true  }
    )
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
            $bild = Hole-WiaBild $item
        } catch {
            $hResult = $_.Exception.HResult
            if (-not $hResult -and $_.Exception.InnerException) { $hResult = $_.Exception.InnerException.HResult }
            if ($seitenNr -gt 0 -and ($hResult -eq $script:WIA_ERROR_PAPER_EMPTY -or $_.Exception.Message -match "0x80210003")) {
                break   # Einzug ist leer - alle Seiten wurden erfasst
            }
            if ($seitenNr -eq 0) { throw }
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

    foreach ($f in $seitenDateien) {
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
    }

    $basis = "Scan_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    $tempPdf = Join-Path $ScanTempOrdner "$basis.pdf.tmp"
    [PpePdf]::Schreibe($tempPdf, $jpegs.ToArray(), $breite.ToArray(), $hoehe.ToArray(), $dx.ToArray(), $dy.ToArray(), $sw.ToArray())
    $zielPdf = Get-EindeutigerZielpfad $WatchFolder $basis "pdf"
    Move-Item -Path $tempPdf -Destination $zielPdf -Force
    $groesseKB = [Math]::Round((Get-Item $zielPdf).Length / 1KB)
    Schreibe-Log "PDF erzeugt: $zielPdf ($($jpegs.Count) Seite(n), $groesseKB KB)"
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

        if ($optionen.LeereSeiten -and $seitenDateien.Count -gt 1) {
            $seitenDateien = Entferne-LeereSeiten $seitenDateien
        }

        Schreibe-Log "Scan abgeschlossen ($($seitenDateien.Count) Seite(n), Quelle: $($optionen.Quelle), Duplex: $($optionen.Duplex), $($optionen.Dpi) dpi, $($optionen.Farbe))."
        $script:LetzteScanFarbe = $optionen.Farbe
        try {
            Lege-ScanAb $seitenDateien $script:LetzteScanDpiX $script:LetzteScanDpiY "Jetzt scannen"
        } finally {
            $script:LetzteScanFarbe = ""
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

            $eingabe = Zeige-Erfassungsdialog $datei.Name $datei.FullName

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

# ======================= TRAY-SYMBOL =======================

$trayIcon = New-Object System.Windows.Forms.NotifyIcon
$trayIcon.Icon = Erstelle-ScannerIcon
$trayIcon.Text = "PaperPort-Ersatz ($StandortName)"
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
$menuAblageOeffnen = $menu.Items.Add("Ablage-Ordner oeffnen")
$menuAblageOeffnen.Add_Click({ Start-Process -FilePath "explorer.exe" -ArgumentList "`"$WatchFolder`"" })
$menu.Add_Opening({
    $n = @(Get-ChildItem -Path $UebersprungenOrdner -Filter "*.pdf" -File -ErrorAction SilentlyContinue).Count
    $menuUebersprungen.Text = "Uebersprungene Dokumente erfassen ($n)"
    $menuUebersprungen.Enabled = ($n -gt 0)
})
[void]$menu.Items.Add("-")
$menuInfo = $menu.Items.Add("Status: Log-Datei oeffnen")
$menuInfo.Add_Click({ Start-Process -FilePath "notepad.exe" -ArgumentList "`"$LogDatei`"" })
$menuUpdate = $menu.Items.Add("Nach Updates suchen")
$menuUpdate.Add_Click({
    $timer.Stop()
    try { Pruefe-AufUpdate $true } finally { if (-not $script:WirdBeendet) { try { $timer.Start() } catch {} } }
})
[void]$menu.Items.Add("-")
$menuUeber = $menu.Items.Add("Ueber PaperPort-Ersatz")
$menuUeber.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "PaperPort-Ersatz - Standort: $StandortName`n$($script:EigeneVersionText) (Programmstand $($script:EigeneCodeKennung))`nUpdate-Quelle: $(if ($UpdateQuelle) { $UpdateQuelle } else { '(keiner)' })`n`nInstallation von Dino1 GmbH und Andre Meschke",
        "Ueber PaperPort-Ersatz") | Out-Null
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
        if ($manuell) { [System.Windows.Forms.MessageBox]::Show($text, "PaperPort-Ersatz Update", [System.Windows.Forms.MessageBoxButtons]::OK, $icon) | Out-Null }
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
            $neuText = $wc.DownloadString($quelleText)
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
    } catch {
        $script:AbgelehnteUpdateKennung = $neuKennung
        & $melde "Update auf $neuVersion ($neuKennung) konnte nicht gespeichert werden: $($_.Exception.Message)" ([System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    Schreibe-Log "Update: $($script:EigeneVersionText) ($($script:EigeneCodeKennung)) -> $neuVersion ($neuKennung) uebernommen (Sicherung: $sicherung). Watcher startet neu."
    if ($manuell) { [System.Windows.Forms.MessageBox]::Show("Update auf $neuVersion wurde installiert.`n`nDer Watcher startet jetzt neu.", "PaperPort-Ersatz Update", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null }
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
    Verarbeite-Ablage
})
$timer.Start()

Schreibe-Log "=== Watcher gestartet fuer Standort '$StandortName' ($($script:EigeneVersionText), Programmstand $($script:EigeneCodeKennung)) ==="

[System.Windows.Forms.Application]::Run()
