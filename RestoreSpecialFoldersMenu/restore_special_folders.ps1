Write-Host "`n[*] Restoring default special folders..." -ForegroundColor Green

$folderPaths = @{
    "{374DE290-123F-4565-9164-39C4925E467B}" = "$env:USERPROFILE\Downloads"
    "Desktop"    = "$env:USERPROFILE\Desktop"
    "Personal"   = "$env:USERPROFILE\Documents"
    "My Pictures"= "$env:USERPROFILE\Pictures"
    "My Music"   = "$env:USERPROFILE\Music"
    "My Video"   = "$env:USERPROFILE\Videos"
}

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

foreach ($key in $folderPaths.Keys) {
    try {
        Set-ItemProperty -Path $regPath -Name $key -Value $folderPaths[$key] -ErrorAction Stop
        Write-Host "  ↳ Restored '$key' to '$($folderPaths[$key])'" -ForegroundColor Cyan
    }
    catch {
        Write-Warning "  ✗ Failed to restore $key: $_"
    }
}
