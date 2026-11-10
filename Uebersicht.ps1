<#
DiNo1 Druck & Scan - Uebersicht aller PCs

Liest die Statusdateien, die jeder PC alle paar Minuten in den Status-Ordner
auf HiDrive schreibt (Einstellung $StatusOrdner, Standard
X:\DiNo1-Druck-Scan-Status), und zeigt sie als Tabelle:
Version, letzte Meldung, HiDrive erreichbar, nicht uebertragene Dokumente,
letzte Ablage, letzter Fehler.

Start: Uebersicht.cmd doppelklicken (kein Admin noetig).
Optional: Uebersicht.cmd "Y:\anderer\Status-Ordner"
#>
param([string]$Ordner = "")

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Status-Ordner ermitteln: Parameter -> Einstellung der Installation auf
# diesem PC -> X:\DiNo1-Druck-Scan-Status -> nachfragen
function Ermittle-StatusOrdner {
    if ($Ordner) { return $Ordner }
    $watcher = "C:\PaperPortErsatz\Watcher.ps1"
    if (Test-Path $watcher) {
        try {
            $text = [System.IO.File]::ReadAllText($watcher)
            $status = ""; $zielBasis = ""
            if ($text -match '(?m)^\$StatusOrdner\s*=\s*"([^"]*)"') { $status = $matches[1] }
            if ($text -match '(?m)^\$ZielBasis\s*=\s*"([^"]*)"') { $zielBasis = $matches[1] }
            if ($status -and $status -ne "-") { return $status }
            if ($zielBasis) { return (Join-Path (Split-Path $zielBasis -Parent) "DiNo1-Druck-Scan-Status") }
        } catch {}
    }
    return "X:\DiNo1-Druck-Scan-Status"
}

$script:StatusOrdner = Ermittle-StatusOrdner
if (-not (Test-Path $script:StatusOrdner)) {
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Status-Ordner '$($script:StatusOrdner)' nicht gefunden. Bitte den Ordner mit den Statusdateien waehlen (z.B. auf HiDrive):"
    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { exit }
    $script:StatusOrdner = $dlg.SelectedPath
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
$btnOrdner.Text = "Status-Ordner oeffnen"
$btnOrdner.Size = New-Object System.Drawing.Size(160, 28)
$btnOrdner.Add_Click({ Start-Process -FilePath "explorer.exe" -ArgumentList "`"$($script:StatusOrdner)`"" })
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
    $dateien = @(Get-ChildItem -Path $script:StatusOrdner -Filter "*.json" -File -ErrorAction SilentlyContinue)
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
    $lbl.Text = "Status-Ordner: $($script:StatusOrdner)    PCs: $(@($eintraege).Count)    Versionen im Einsatz: $((@($versionen.Keys) | Sort-Object) -join ', ')    (Stand $(Get-Date -Format 'HH:mm:ss'))"
}

$btnNeu.Add_Click({ Lade-Status })
$form.Add_Shown({ Lade-Status })
[void]$form.ShowDialog()
