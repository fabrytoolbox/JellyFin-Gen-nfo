#Requires -Version 7.0
<#
.SYNOPSIS
    Jellyfin-Gen-Nfo - Genera e modifica di metadati NFO per Jellyfin
.DESCRIPTION
    (Inserisci qui una descrizione più dettagliata dello script)
.NOTES
    Prerequisiti: PowerShell 7 o superiore.
    Autore: Fabrizio (FabryToolbox)
    Anno: 2026
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Palette Colori Matrix ---
$BgColor = [System.Drawing.Color]::Black
$FgColor = [System.Drawing.Color]::Lime
$InputBgColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$BtnColor = [System.Drawing.Color]::FromArgb(0, 50, 0)

# --- Finestra Principale ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Jellyfin-Gen-Nfo - FabryToolbox (Matrix Edition)"
$Form.Size = "800, 600"
$Form.StartPosition = "CenterScreen"
$Form.Font = "Consolas, 10"
$Form.BackColor = $BgColor
$Form.ForeColor = $FgColor

# --- Inizia a costruire la tua GUI qui ---
$LblHello = New-Object System.Windows.Forms.Label
$LblHello.Text = "Benvenuto in Jellyfin-Gen-Nfo"
$LblHello.Location = "20, 20"
$LblHello.AutoSize = $true
$Form.Controls.Add($LblHello)

$Form.ShowDialog()
