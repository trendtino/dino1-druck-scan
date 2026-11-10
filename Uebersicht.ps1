<#
DiNo1 Druck & Scan - Uebersicht aller PCs

Liest die Statusdateien, die jeder PC alle paar Minuten in den Status-Ordner
auf HiDrive schreibt (Einstellung $StatusOrdner, Standard
DiNo1-Druck-Scan-Status im Shop-Ordner), und zeigt sie als Tabelle:
Version, letzte Meldung, HiDrive erreichbar, nicht uebertragene Dokumente,
letzte Ablage, letzter Fehler.

Start: Uebersicht.cmd doppelklicken (kein Admin noetig).
Optional: Uebersicht.cmd "Y:\anderer\Status-Ordner"
#>
param([string]$Ordner = "")

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Statusdateien liegen pro Shop in "<Shop-Ordner>\DiNo1-Druck-Scan-Status".
# Gesucht wird ab dem Ordner, der alle Shops enthaelt (z.B. "Y:\o2 shops"):
# dort und bis zu zwei Ebenen darunter.
$script:StatusName = "DiNo1-Druck-Scan-Status"

function Finde-StatusOrdner($wurzel) {
    $treffer = New-Object System.Collections.Generic.List[string]
    if (-not $wurzel -or -not (Test-Path -LiteralPath $wurzel)) { return ,$treffer }
    if ((Split-Path $wurzel -Leaf) -eq $script:StatusName) { [void]$treffer.Add($wurzel); return ,$treffer }
    $ebene = @(Get-Item -LiteralPath $wurzel)
    for ($i = 0; $i -le 2; $i++) {
        $naechste = New-Object System.Collections.Generic.List[object]
        foreach ($o in $ebene) {
            foreach ($u in @(Get-ChildItem -LiteralPath $o.FullName -Directory -ErrorAction SilentlyContinue)) {
                if ($u.Name -eq $script:StatusName) { [void]$treffer.Add($u.FullName) } else { [void]$naechste.Add($u) }
            }
        }
        $ebene = $naechste
    }
    return ,$treffer
}

# Startordner: Parameter -> aus der Installation auf diesem PC (Ordner ueber
# dem Shop-Ordner) -> nachfragen
function Ermittle-Wurzel {
    if ($Ordner) { return $Ordner }
    $watcher = "C:\PaperPortErsatz\Watcher.ps1"
    if (Test-Path $watcher) {
        try {
            $text = [System.IO.File]::ReadAllText($watcher)
            if ($text -match '(?m)^\$StatusOrdner\s*=\s*"([^"]+)"' -and $matches[1] -ne "-") { return (Split-Path (Split-Path $matches[1] -Parent) -Parent) }
            if ($text -match '(?m)^\$ShopOrdner\s*=\s*"([^"]+)"') { return (Split-Path $matches[1] -Parent) }
        } catch {}
    }
    return ""
}

$script:Wurzel = Ermittle-Wurzel
$script:StatusOrdnerListe = Finde-StatusOrdner $script:Wurzel
if ($script:StatusOrdnerListe.Count -eq 0) {
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Keine Statusdateien gefunden$(if ($script:Wurzel) { " unter '$($script:Wurzel)'" }). Bitte den Ordner waehlen, der alle Shops enthaelt (z.B. Y:\o2 shops):"
    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { exit }
    $script:Wurzel = $dlg.SelectedPath
    $script:StatusOrdnerListe = Finde-StatusOrdner $script:Wurzel
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "DiNo1 Druck & Scan - Uebersicht aller PCs"
$form.Size = New-Object System.Drawing.Size(1250, 520)
$form.StartPosition = "CenterScreen"

$lbl = New-Object System.Windows.Forms.Label
$lbl.Dock = "Top"
$lbl.Height = 26
$lbl.Padding = New-Object System.Windows.Forms.Padding(8, 6, 0, 0)
$form.Controls.Add($lbl)

$grid = New-Object System.Windows.Forms.DataGridView
$grid.Dock = "Fill"
$grid.ReadOnly = $true
$grid.AllowUserToAddRows = $false
$grid.AllowUserToDeleteRows = $false
$grid.RowHeadersVisible = $false
$grid.SelectionMode = "FullRowSelect"
$grid.AutoSizeColumnsMode = "AllCells"
$form.Controls.Add($grid)
$grid.BringToFront()

$leiste = New-Object System.Windows.Forms.FlowLayoutPanel
$leiste.Dock = "Bottom"
$leiste.Height = 42
$leiste.Padding = New-Object System.Windows.Forms.Padding(6)
$form.Controls.Add($leiste)

$btnNeu = New-Object System.Windows.Forms.Button
$btnNeu.Text = "Aktualisieren"
$btnNeu.Size = New-Object System.Drawing.Size(120, 28)
$leiste.Controls.Add($btnNeu)

$btnOrdner = New-Object System.Windows.Forms.Button
$btnOrdner.Text = "Ordner oeffnen"
$btnOrdner.Size = New-Object System.Drawing.Size(160, 28)
$btnOrdner.Add_Click({ Start-Process -FilePath "explorer.exe" -ArgumentList "`"$($script:Wurzel)`"" })
$leiste.Controls.Add($btnOrdner)

$lblLegende = New-Object System.Windows.Forms.Label
$lblLegende.AutoSize = $true
$lblLegende.Padding = New-Object System.Windows.Forms.Padding(10, 7, 0, 0)
$lblLegende.Text = "Rot = Problem (HiDrive nicht erreichbar / Dokumente nicht uebertragen)   Grau = PC meldet sich seit ueber 30 Minuten nicht (aus oder Watcher laeuft nicht)"
$leiste.Controls.Add($lblLegende)

$spalten = @(
    @("Hinweis", "Hinweis"), @("PC", "Rechner"), @("Benutzer", "Benutzer"), @("Standort", "Standort"),
    @("Version", "VersionText"), @("Zuletzt gemeldet", "Zeit"), @("HiDrive", "HiDriveText"),
    @("Nicht uebertragen", "NichtUebertragen"), @("Uebersprungen", "Uebersprungen"), @("Wartend", "WartendInAblage"),
    @("Texterkennung", "Texterkennung"), @("Letzte Ablage", "LetzteAblage"), @("Letzter Fehler", "LetzterFehler")
)
foreach ($s in $spalten) { [void]$grid.Columns.Add($s[1], $s[0]) }

function Lade-Status {
    $grid.Rows.Clear()
    $script:StatusOrdnerListe = Finde-StatusOrdner $script:Wurzel
    $dateien = @(foreach ($o in $script:StatusOrdnerListe) { Get-ChildItem -LiteralPath $o -Filter "*.json" -File -ErrorAction SilentlyContinue })
    $jetzt = Get-Date
    $versionen = @{}
    $eintraege = foreach ($d in $dateien) {
        try {
            $j = [System.IO.File]::ReadAllText($d.FullName) | ConvertFrom-Json
        } catch { continue }
        $zeit = $null
        try { $zeit = [DateTime]::ParseExact([string]$j.Zeit, "yyyy-MM-dd HH:mm:ss", $null) } catch {}
        $hinweise = New-Object System.Collections.Generic.List[string]
        $alt = ($null -eq $zeit -or ($jetzt - $zeit).TotalMinutes -gt 30)
        if ($alt) { [void]$hinweise.Add("meldet sich nicht") }
        $problem = $false
        if (-not $alt) {
            if (-not $j.HiDriveErreichbar) { [void]$hinweise.Add("HiDrive nicht erreichbar"); $problem = $true }
            if ([int]$j.NichtUebertragen -gt 0) { [void]$hinweise.Add("$($j.NichtUebertragen) nicht uebertragen"); $problem = $true }
            if ($j.UpdatesGesperrt) { [void]$hinweise.Add("Update zurueckgestellt") }
            if ([int]$j.LaufendeWatcher -gt 1) { [void]$hinweise.Add("Watcher $($j.LaufendeWatcher)x gestartet"); $problem = $true }
        }
        if ($j.Version) { $versionen["$($j.Version)"] = $true }
        [PSCustomObject]@{
            Daten = $j; Zeit = $zeit; Alt = $alt; Problem = $problem
            Hinweis = $(if ($hinweise.Count) { $hinweise -join ", " } else { "OK" })
        }
    }
    foreach ($e in @($eintraege | Sort-Object { $_.Daten.Standort }, { $_.Daten.Rechner })) {
        $j = $e.Daten
        $werte = @(
            $e.Hinweis, $j.Rechner, $j.Benutzer, $j.Standort,
            "$($j.Version) vom $($j.VersionDatum)", $(if ($e.Zeit) { $e.Zeit.ToString("dd.MM.yyyy HH:mm") } else { "?" }),
            $(if ($j.HiDriveErreichbar) { "ja" } else { "NEIN" }),
            $j.NichtUebertragen, $j.Uebersprungen, $j.WartendInAblage,
            $j.Texterkennung, $j.LetzteAblage, $j.LetzterFehler
        )
        $i = $grid.Rows.Add([object[]]$werte)
        $zeile = $grid.Rows[$i]
        if ($e.Alt) { $zeile.DefaultCellStyle.ForeColor = [System.Drawing.Color]::Gray }
        elseif ($e.Problem) { $zeile.DefaultCellStyle.BackColor = [System.Drawing.Color]::MistyRose }
    }
    $lbl.Text = "Gesucht in: $($script:Wurzel) ($($script:StatusOrdnerListe.Count) Shop(s))    PCs: $(@($eintraege).Count)    Versionen im Einsatz: $((@($versionen.Keys) | Sort-Object) -join ', ')    (Stand $(Get-Date -Format 'HH:mm:ss'))"
}

$btnNeu.Add_Click({ Lade-Status })
$form.Add_Shown({ Lade-Status })
[void]$form.ShowDialog()
