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
