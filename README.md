# DiNo1 Druck & Scan

Ablage-Watcher für Scans und Ausdrucke (PDF24 / „Dino1 Drucker“ / WIA-Scanner) mit Zuordnung zu HiDrive-Ordnern (Mitarbeiter, Shop, Kasse) oder lokal.

## Installation

Auf jedem PC: Dateien herunterladen und **komplett entpacken**. Danach `Setup.cmd` starten (siehe `ANLEITUNG.txt`).

## Automatische Updates

Das Setup trägt unter **„Update-Quelle“** automatisch diese Adresse ein (kann dort geändert oder geleert werden):

```
https://raw.githubusercontent.com/trendtino/dino1-druck-scan/main/Watcher.ps1
```

Jeder PC prüft beim Start und etwa alle 10 Minuten, ob sich der Programmcode der `Watcher.ps1` in diesem Projekt geändert hat. Ist das der Fall, übernimmt er ihn automatisch und behält dabei seine eigenen Einstellungen. Eine Datei mit Syntaxfehlern wird abgelehnt.

**Hinweise:**

- Der Abschnitt `KONFIGURATION` in der `Watcher.ps1` hier enthält nur Beispielwerte. Die PCs ignorieren ihn, deshalb hier **keine echten Namen oder Pfade** eintragen. Das Projekt ist öffentlich.
- Wer in dieses Projekt schreiben darf, kann Code auf allen PCs ausführen. Schreibrechte bekommt deshalb nur die IT.
- Neue Einstellungen brauchen einen Standardwert im Block `STANDARDWERTE FUER NEUERE EINSTELLUNGEN`, sonst fehlen sie auf automatisch aktualisierten PCs.

## Funktionen ab Version 14

- **Texterkennung (OCR)** mit der in Windows eingebauten Erkennung: gescannte PDFs sind durchsuchbar, bekannte Kundennamen werden im Erfassungsfenster vorgeschlagen.
- **Vorschau** der ersten Seite im Erfassungsfenster.
- **Stapel trennen** an leeren Blättern (Scan-Optionen, nur Einzug).
- **Statusdatei je PC** im Status-Ordner auf HiDrive, Anzeige mit `Uebersicht.cmd`.
- **Warnhinweis** am Tray-Symbol, wenn HiDrive nicht erreichbar ist oder Dokumente nicht übertragen wurden.
- **Vorherige Version wiederherstellen** im Tray-Menü.

## Neu in Version 15

- **Ordner anpassen…** im Tray-Menü: Ordner und Mitarbeiter eines PCs nachträglich ändern, ohne Setup und ohne Admin.

## Neu in Version 16 bis 27

### Programmfenster (ab Version 24)

- **Programmfenster** mit großen Knöpfen: Jetzt scannen, Dokumente suchen, Übersprungene erfassen, Ablage-Ordner öffnen, Ordner anpassen, Nach Updates suchen. Oben steht, ob HiDrive erreichbar ist und was zuletzt abgelegt wurde.
- **Öffnen**: Doppelklick auf das Tray-Symbol (ab Version 26), über das Tray-Menü „Programmfenster öffnen“ oder über die Verknüpfung **„DiNo1 Druck und Scan“**. Die Verknüpfung wird einmalig auf dem Desktop und im Startmenü angelegt und kann an die Taskleiste angeheftet werden.
- **Ordner öffnen** (ab Version 27): Knöpfe für Mitarbeiter-Ordner (Auswahl je Mitarbeiter oder alle), Shop-Ordner, Kassen-Ordner und den lokalen Ordner des PCs. Ein fehlender lokaler Ordner wird angelegt.
- **Tray-Symbol immer sichtbar** (ab Version 24/25): Unter Windows 11 wird das Symbol automatisch neben der Uhr angeheftet statt im ^-Überlauf. Kennt Windows das Symbol noch unter dem alten Namen „PaperPort …“, wird auch dieser Eintrag erkannt. Klappt es nicht, steht ein HINWEIS im Log.

### Dokumente suchen (ab Version 23)

- Tray-Menü oder Programmfenster → **„Dokumente suchen…“**, ähnlich wie bei PaperPort.
- Gesucht wird in Bezeichnung, Mitarbeiter, Dateiname und erkanntem Text (bei Scans alle Seiten, bei Ausdrucken die erste Seite).
- Die Suche umfasst die Ablagen **aller PCs des Shops**: Jeder PC legt sein Suchverzeichnis im Shop-Ordner unter `DiNo1-Druck-Scan-Status\Suchindex` ab.
- Optional werden auch Dateinamen direkt in den HiDrive-Ordnern durchsucht. Gefundene Dokumente lassen sich direkt öffnen, oder ihr Ordner wird geöffnet.

### Scannen

- **Fortschrittsfenster** (ab Version 21) unten rechts: aktuelle Seite, Anzahl erfasster Seiten, PDF-Erstellung und Texterkennung. Mit **„Stoppen“** endet der Einzug nach der aktuellen Seite.
- **Samsung- und andere Einzugsscanner** (ab Version 16): Meldet der Scanner nach der letzten Seite „WIA-Gerät ausgelastet“, gilt der Stapel als fertig. Der Scan bleibt nicht mehr hängen.

### Status, Log und Diagnose im Shop-Ordner

- **Statusdatei je PC** liegt ab Version 20 im Shop-Ordner, z. B. `<Shop-Ordner>\DiNo1-Druck-Scan-Status`. Sie wird erst lokal geschrieben und dann kopiert, weil HiDrive direktes Schreiben teilweise ablehnt.
- **`Uebersicht.cmd`** sammelt die Statusdateien aus **allen Shops** und zeigt alle PCs in einer Liste. Rot heißt Problem, grau heißt, dass sich der PC seit über 30 Minuten nicht gemeldet hat.
- **Log im Shop-Ordner** (ab Version 21): Die letzten 3000 Log-Zeilen werden etwa alle 5 Minuten nach `DiNo1-Druck-Scan-Status\Logs\<PC>_<Benutzer>_Log.txt` kopiert.
- **Diagnose in den Shop-Ordner legen**: im Tray-Menü. `Diagnose.cmd` legt ihren Bericht ebenfalls dort ab.
- **Laufende Watcher prüfen** (ab Version 17): im Tray-Menü. Zeigt, ob der Watcher auf dem PC doppelt läuft. In der Übersicht wird das rot markiert.

### Einstellungen

- **Ordner anpassen…** (ab Version 15, überarbeitet in Version 22): Shop-, Kassen-, Mitarbeiter- und lokalen Ordner („Lokaler Ordner (PC)“) nachträglich ändern.
- **Kassenbelege nach Jahr und Monat** (ab Version 29): Ablage unter `<Kassen-Ordner>\<Jahr>\<MM Monat>`, z. B. `Kasse\2026\11 November`. Vorhandene Jahres- und Monatsordner werden wiederverwendet, fehlende angelegt. Maßgeblich ist das Datum im Erfassungsfenster.
- **„Über DiNo1 Druck & Scan“** im Tray-Menü zeigt Version und Datum.

## Versionsübersicht

| Version | Neu |
|---|---|
| 31 | Suche nur in Shop- und Mitarbeiter-Ordnern, läuft im Hintergrund (kein Einfrieren); Desktop-Verknüpfung „DiNo1 neu starten“ |
| 30 | Kassen-Ordner darf auch der Jahresordner sein (`Kasse\2026`) |
| 29 | Kassenbelege nach Jahr und Monat: `Kasse\2026\11 November` |
| 28 | Zeitmessung je Scan im Log (Zeile „ZEITEN“) |
| 27 | Ordner-Knöpfe (Mitarbeiter, Shop, Kasse, Lokal) im Programmfenster |
| 26 | Doppelklick aufs Tray-Symbol öffnet das Programmfenster |
| 25 | Anheften des Tray-Symbols erkennt alte Namen, Hinweis im Log |
| 24 | Programmfenster, Verknüpfung auf Desktop/Startmenü, Tray-Symbol anheften |
| 23 | Dokumente suchen (Volltext, alle PCs des Shops) |
| 22 | „Ordner anpassen“: Beschriftungen überdecken die Felder nicht mehr |
| 21 | Fortschrittsfenster mit „Stoppen“, Log und Diagnose im Shop-Ordner |
| 20 | Statusdateien im Shop-Ordner, Übersicht über alle Shops |
| 18–19 | Statusdatei erst lokal schreiben, Fehler nur einmal im Log |
| 17 | Laufende Watcher prüfen (doppelter Start sichtbar) |
| 16 | Scan hängt nicht mehr bei „WIA-Gerät ausgelastet“ |
| 15 | Ordner anpassen |
| 14 | Texterkennung, Vorschau, Stapel trennen, Statusdatei, Warnhinweise, Version wiederherstellen |
