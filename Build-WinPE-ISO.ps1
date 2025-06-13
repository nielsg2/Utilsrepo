$oscdimg = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
$bootloader = "C:\WinPE_amd64\fwfiles\etfsboot.com"
$sourceDir = "C:\WinPE_amd64\media"
$outputIso = "C:\WinPE_amd64\WinPE.iso"

if (!(Test-Path $oscdimg)) {
    Write-Host "[ERROR] oscdimg.exe not found. Please ensure Deployment Tools are installed." -ForegroundColor Red
    exit 1
}

if (!(Test-Path $bootloader)) {
    Write-Host "[ERROR] Boot loader etfsboot.com not found. Missing or incorrect fwfiles location." -ForegroundColor Red
    exit 1
}

& $oscdimg -n -b"$bootloader" "$sourceDir" "$outputIso"

if (Test-Path $outputIso) {
    Write-Host "[✔] ISO successfully created at $outputIso"
} else {
    Write-Host "[ERROR] Failed to create WinPE ISO." -ForegroundColor Red
}
