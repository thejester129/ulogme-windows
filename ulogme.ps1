
Write-Output "ulogme starting..."
Start-Job -ScriptBlock { 
    .\keyfreq.ps1 
}
Start-Job -ScriptBlock {
    .\logactivewin.ps1 
}