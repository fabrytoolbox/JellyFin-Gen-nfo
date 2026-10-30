<#
.SYNOPSIS
    JellyFin-Gen-nfo - Creatore e modificatore di metadati NFO per Jellyfin.
.DESCRIPTION
    Script con interfaccia grafica (GUI Matrix) per generare o aggiornare file .nfo 
    compatibili con Jellyfin, Kodi ed Emby. Supporta la gestione degli attori e la 
    sanificazione dei caratteri XML.
.NOTES
    Prerequisiti: PowerShell 7 o superiore.
    Autore: Fabrizio (FabryToolbox)
    Anno: 2024
#>

#Requires -Version 7.0
Add-Type -AssemblyName System.Windows.Forms
# ...
#Requires -Version 7.0
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Inizializzazione Liste ---
$Global:ActorsList = New-Object System.Collections.Generic.List[PSObject]
$Global:Target = $null

# Palette Colori Matrix
$BgColor = [System.Drawing.Color]::Black
$FgColor = [System.Drawing.Color]::Lime
$InputBgColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$BtnColor = [System.Drawing.Color]::FromArgb(0, 50, 0)

# --- Finestra Principale ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "JellyFin-Gen-nfo FabryToolbox (Matrix Edition)"
$Form.Size = "900, 800" # Più larga e alta
$Form.StartPosition = "CenterScreen"
$Form.Font = "Consolas, 10"
$Form.BackColor = $BgColor
$Form.ForeColor = $FgColor

# --- 1. SELEZIONE FILE ---
$BtnBrowse = New-Object System.Windows.Forms.Button
$BtnBrowse.Text = "SELEZIONA VIDEO"; $BtnBrowse.Location = "20, 20"; $BtnBrowse.Size = "180, 40"
$BtnBrowse.BackColor = $BtnColor; $BtnBrowse.ForeColor = $FgColor; $BtnBrowse.FlatStyle = "Flat"
$Form.Controls.Add($BtnBrowse)

$LblFile = New-Object System.Windows.Forms.Label
$LblFile.Text = "> In attesa di un video..."; $LblFile.Location = "220, 30"; $LblFile.Width = 650; 
$LblFile.ForeColor = $FgColor; $LblFile.Font = "Consolas, 10"
$Form.Controls.Add($LblFile)

# --- Funzione per caricare NFO esistente ---
function Load-ExistingNfo($nfoPath) {
    if (Test-Path $nfoPath) {
        try {
            [xml]$existingXml = Get-Content $nfoPath -Raw
            
            $TxtTitle.Text = $existingXml.movie.title
            $TxtYear.Text = $existingXml.movie.year
            $TxtPlot.Text = $existingXml.movie.plot
            if ($existingXml.movie.genre) { $ComboGenre.SelectedItem = $existingXml.movie.genre }

            $Global:ActorsList.Clear()
            $ListActorsDisp.Items.Clear()
            foreach ($actor in $existingXml.movie.actor) {
                if ($actor.name) {
                    $Global:ActorsList.Add([PSCustomObject]@{Name=$actor.name})
                    $ListActorsDisp.Items.Add($actor.name)
                }
            }
            Update-Preview
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Errore nel caricamento dati.", "Errore", "OK", "Error")
        }
    }
}

# --- 2. INTERFACCIA (Titoli, Plot, Generi) ---
$CreateLabel = { param($t, $x, $y) $L=New-Object System.Windows.Forms.Label; $L.Text=$t; $L.Location="$x, $y"; $L.AutoSize=$true; $L.ForeColor=$FgColor; $Form.Controls.Add($L) }

# Riga Titolo
$CreateLabel.Invoke("Titolo Film:", 20, 80)
$TxtTitle = New-Object System.Windows.Forms.TextBox; $TxtTitle.Location = "20, 105"; $TxtTitle.Width = 520
$TxtTitle.BackColor = $InputBgColor; $TxtTitle.ForeColor = $FgColor; $TxtTitle.BorderStyle = "FixedSingle"; $Form.Controls.Add($TxtTitle)

# Riga Anno
$CreateLabel.Invoke("Anno:", 560, 80)
$TxtYear = New-Object System.Windows.Forms.TextBox; $TxtYear.Location = "560, 105"; $TxtYear.Width = 80
$TxtYear.BackColor = $InputBgColor; $TxtYear.ForeColor = $FgColor; $TxtYear.BorderStyle = "FixedSingle"; $Form.Controls.Add($TxtYear)

# Riga Genere
$CreateLabel.Invoke("Genere:", 660, 80)
$ComboGenre = New-Object System.Windows.Forms.ComboBox; $ComboGenre.Location = "660, 105"; $ComboGenre.Width = 200
$ComboGenre.BackColor = $InputBgColor; $ComboGenre.ForeColor = $FgColor; $ComboGenre.FlatStyle = "Flat"
$ComboGenre.Items.AddRange(@("Sperimentale", "AI Faceswap", "Famiglia", "Documentario", "Azione"))
$ComboGenre.SelectedIndex = 0; $Form.Controls.Add($ComboGenre)

# Riga Plot (Larghezza intera)
$CreateLabel.Invoke("Trama (Plot):", 20, 145)
$TxtPlot = New-Object System.Windows.Forms.TextBox; $TxtPlot.Location = "20, 170"; $TxtPlot.Width = 840; $TxtPlot.Height = 80; $TxtPlot.Multiline = $true
$TxtPlot.BackColor = $InputBgColor; $TxtPlot.ForeColor = $FgColor; $TxtPlot.BorderStyle = "FixedSingle"; $Form.Controls.Add($TxtPlot)

# --- 3. GESTIONE ATTORI (Colonna Sinistra) ---
$GroupActors = New-Object System.Windows.Forms.GroupBox; $GroupActors.Text = " Gestione Attori "; $GroupActors.Location = "20, 270"; $GroupActors.Size = "400, 220"
$GroupActors.ForeColor = $FgColor; $Form.Controls.Add($GroupActors)

$TxtActorName = New-Object System.Windows.Forms.TextBox; $TxtActorName.Location = "15, 30"; $TxtActorName.Width = 200
$TxtActorName.BackColor = $InputBgColor; $TxtActorName.ForeColor = $FgColor; $TxtActorName.BorderStyle = "FixedSingle"; $GroupActors.Controls.Add($TxtActorName)

$BtnAddActor = New-Object System.Windows.Forms.Button; $BtnAddActor.Text = "Aggiungi"; $BtnAddActor.Location = "225, 28"; $BtnAddActor.Size = "150, 26"
$BtnAddActor.BackColor = $BtnColor; $BtnAddActor.ForeColor = $FgColor; $BtnAddActor.FlatStyle = "Flat"; $GroupActors.Controls.Add($BtnAddActor)

$ListActorsDisp = New-Object System.Windows.Forms.ListBox; $ListActorsDisp.Location = "15, 70"; $ListActorsDisp.Size = "360, 90"
$ListActorsDisp.BackColor = $InputBgColor; $ListActorsDisp.ForeColor = $FgColor; $ListActorsDisp.BorderStyle = "FixedSingle"; $GroupActors.Controls.Add($ListActorsDisp)

$BtnRemoveActor = New-Object System.Windows.Forms.Button; $BtnRemoveActor.Text = "Rimuovi Selezionato"; $BtnRemoveActor.Location = "15, 170"; $BtnRemoveActor.Size = "360, 30"
$BtnRemoveActor.BackColor = $BtnColor; $BtnRemoveActor.ForeColor = $FgColor; $BtnRemoveActor.FlatStyle = "Flat"; $GroupActors.Controls.Add($BtnRemoveActor)

# --- 4. PREVIEW (Colonna Destra, grande e leggibile) ---
$LblPreview = New-Object System.Windows.Forms.Label; $LblPreview.Text = "Preview XML:"; $LblPreview.Location = "440, 275"; $LblPreview.AutoSize=$true; $Form.Controls.Add($LblPreview)
$TxtPreview = New-Object System.Windows.Forms.TextBox; $TxtPreview.Location = "440, 300"; $TxtPreview.Width = 420; $TxtPreview.Height = 340; $TxtPreview.Multiline = $true; $TxtPreview.ReadOnly = $true; 
$TxtPreview.Font = "Consolas, 9"; $TxtPreview.BackColor = [System.Drawing.Color]::Black; $TxtPreview.ForeColor = $FgColor; $TxtPreview.BorderStyle = "FixedSingle"; $Form.Controls.Add($TxtPreview)

# --- LOGICA AGGIORNAMENTO ---
function Update-Preview {
    $cleanTitle = [System.Security.SecurityElement]::Escape(($TxtTitle.Text -replace '[\\\/\:\*\?\"\<\>\|]', ''))
    $cleanPlot = [System.Security.SecurityElement]::Escape($TxtPlot.Text)
    $cleanYear = [System.Security.SecurityElement]::Escape($TxtYear.Text)
    $cleanGenre = [System.Security.SecurityElement]::Escape($ComboGenre.SelectedItem)

    $xml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<movie>
  <title>$cleanTitle</title>
  <year>$cleanYear</year>
  <genre>$cleanGenre</genre>
  <plot>$cleanPlot</plot>
"@
    foreach($a in $Global:ActorsList) { 
        $cleanActor = [System.Security.SecurityElement]::Escape($a.Name)
        $xml += "`n  <actor>`n    <name>$cleanActor</name>`n    <role>Attore</role>`n  </actor>" 
    }
    $xml += "`n  <studio>FabryToolbox</studio>`n</movie>"
    $TxtPreview.Text = $xml
}

# Eventi
$BtnAddActor.Add_Click({ 
    if($TxtActorName.Text -ne "") { 
        $Global:ActorsList.Add([PSCustomObject]@{Name=$TxtActorName.Text}); 
        $ListActorsDisp.Items.Add($TxtActorName.Text); 
        $TxtActorName.Clear(); 
        Update-Preview 
    } 
})

$BtnRemoveActor.Add_Click({
    if ($ListActorsDisp.SelectedIndex -ge 0) {
        $Global:ActorsList.RemoveAt($ListActorsDisp.SelectedIndex)
        $ListActorsDisp.Items.RemoveAt($ListActorsDisp.SelectedIndex)
        Update-Preview
    }
})

$TxtTitle.Add_TextChanged({Update-Preview}); $TxtYear.Add_TextChanged({Update-Preview}); $TxtPlot.Add_TextChanged({Update-Preview}); $ComboGenre.Add_SelectedIndexChanged({Update-Preview})

# --- SALVATAGGIO ---
$BtnSave = New-Object System.Windows.Forms.Button
$BtnSave.Text = "AGGIORNA / SALVA NFO"; $BtnSave.Location = "20, 680"; $BtnSave.Size = "840, 50"
$BtnSave.BackColor = [System.Drawing.Color]::Lime; $BtnSave.ForeColor = [System.Drawing.Color]::Black; $BtnSave.Font = "Consolas, 12, style=Bold"
$BtnSave.FlatStyle = "Flat"; $Form.Controls.Add($BtnSave)

$BtnBrowse.Add_Click({
    $FB = New-Object System.Windows.Forms.OpenFileDialog
    $FB.Filter = "Video Files|*.mp4;*.mkv;*.avi;*.mov;*.wmv|All Files|*.*"
    
    if($FB.ShowDialog() -eq "OK") {
        $Global:Target = [System.IO.Path]::ChangeExtension($FB.FileName, ".nfo")
        $LblFile.Text = "> File: " + $FB.SafeFileName
        Load-ExistingNfo($Global:Target) 
        Update-Preview
    }
})

$BtnSave.Add_Click({
    if($Global:Target) {
        try {
            [System.IO.File]::WriteAllText($Global:Target, $TxtPreview.Text, [System.Text.UTF8Encoding]::new($false))
            [System.Windows.Forms.MessageBox]::Show("Metadati aggiornati con successo!", "Successo", "OK", "Information")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Errore durante il salvataggio: $_", "Errore", "OK", "Error")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Per favore, seleziona prima un video!", "Attenzione", "OK", "Warning")
    }
})

$Form.ShowDialog()
