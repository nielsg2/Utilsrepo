powershell
# Define paths
$peRoot = "C:\WinPE_amd64"
$mediaDir = Join-Path $peRoot "media"
$fwFiles = Join-Path $peRoot "fwfiles"
$etfsboot = Join-Path $fwFiles "etfsboot.com"
$isoOut = Join-Path $peRoot "WinPE.iso"
$copypeCmd = '"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\copype.cmd"'
$oscdimg = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"

# Ensure PE structure and bootloader exist
if (!(Test-Path $etfsboot)) {
    Write-Host "[INFO] etfsboot.com not found. Attempting to regenerate PE base via copype.cmd..." -ForegroundColor Yellow
    if (!(Test-Path $copypeCmd)) {
        Write-Host "[ERROR] copype.cmd not found. Please ensure the Windows PE add-on is properly installed." -ForegroundColor Red
        exit 1
    }
    cmd.exe /c "$copypeCmd amd64 $peRoot"
}

# Re-check after attempted regeneration
if (!(Test-Path $etfsboot)) {
    Write-Host "[ERROR] Bootloader etfsboot.com still missing after copype attempt." -ForegroundColor Red
    exit 1
}

# Confirm oscdimg exists
if (!(Test-Path $oscdimg)) {
    Write-Host "[ERROR] oscdimg.exe not found. Please install the ADK Deployment Tools." -ForegroundColor Red
    exit 1
}

# Create ISO
Write-Host "[INFO] All prerequisites met. Generating WinPE ISO..." -ForegroundColor Cyan
& "$oscdimg" -n -b"$etfsboot" "$mediaDir" "$isoOut"

# Report outcome
if (Test-Path $isoOut) {
    $sizeMB = [math]::Round((Get-Item $isoOut).Length / 1MB, 1)
    Write-Host "[✔] ISO successfully created at $isoOut ($sizeMB MB)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to generate ISO." -ForegroundColor Red
}
