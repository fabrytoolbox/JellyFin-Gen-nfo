# 📺 JellyFin-Gen-nfo

![PowerShell](https://img.shields.io/badge/PowerShell-7.0%2B-blue?logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey?logo=windows)

**JellyFin-Gen-nfo** è un tool con interfaccia grafica (GUI Matrix) per la creazione e modifica di file `.nfo` (metadati) per i tuoi video. 
È progettato per essere perfettamente compatibile con **Jellyfin**, **Kodi** ed **Emby**.

## ✨ Caratteristiche
- **GUI Matrix:** Interfaccia scura con colori ad alto contrasto, per non affaticare gli occhi.
- **Caricamento Intelligente:** Se esiste già un file `.nfo` accanto al video, lo script lo carica automaticamente in modalità modifica.
- **Sanificazione XML:** I campi inseriti (Titolo, Trama, ecc.) vengono "puliti" da caratteri illegali che potrebbero corrompere il file XML.
- **Salvataggio Pulito:** Genera file UTF-8 senza BOM, garantendo la massima compatibilità con i media server.
- **Gestione Attori:** Aggiungi e rimuovi attori dalla lista con un click.

## ⚠️ Prerequisiti
Questo script richiede **PowerShell 7** o superiore. 
Puoi scaricarlo gratuitamente dal [repository ufficiale di Microsoft](https://github.com/PowerShell/PowerShell).

## 🚀 Come si usa
1. Scarica il file `JellyFin-Gen-nfo.ps1`.
2. Apri PowerShell 7 e posizionati nella cartella dello script.
3. Esegui il comando:
   ```powershell
   .\JellyFin-Gen-nfo.ps1
4.Clicca su SELEZIONA VIDEO e scegli il tuo file (es. Film.mp4).
5.Compila i campi (Titolo, Anno, Genere, Trama, Attori).
6.Clicca su AGGIORNA / SALVA NFO. Verrà creato un file Film.nfo nella stessa cartella.

🖼️ Anteprima
<img width="1097" height="988" alt="image" src="https://github.com/user-attachments/assets/08fb34e9-7da1-4c01-ba22-430af16e1018" />

Creato da Fabrizio per il progetto Fabry Toolbox.


   
