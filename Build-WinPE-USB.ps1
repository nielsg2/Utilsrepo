# Set up variables
$repoRoot = "C:\Users\nsgadm1\OneDrive\Code\Utilsrepo"
$winPEBase = "$repoRoot\WinPE_amd64"
$mountDir = "$winPEBase\mount"
$isoDir = "$winPEBase\media"
$toolsDir = "$repoRoot\Tools"
$usbDrive = "F:"

# Validate paths
function Validate-Path($path, $desc) {
    if (!(Test-Path $path)) {
        Write-Error "$desc not found at: $path"
        exit 1
    }
}

Write-Host "`n[+] Starting WinPE Build Automation..." -ForegroundColor Cyan

# Step 1: Generate WinPE base folders
if (!(Test-Path $winPEBase)) {
    Write-Host "[*] Creating WinPE working directory..."
    copype.cmd amd64 $winPEBase
} else {
    Write-Host "[=] WinPE working directory already exists."
}

# Step 2: Mount boot.wim
$bootWIM = "$isoDir\sources\boot.wim"
Validate-Path $bootWIM "boot.wim"

if (!(Test-Path $mountDir)) {
    New-Item -ItemType Directory -Path $mountDir -Force | Out-Null
}

Write-Host "[*] Mounting boot.wim..."
Dism /Mount-Image /ImageFile:$bootWIM /index:1 /MountDir:$mountDir | Out-Null

# Step 3: Inject tools
$targetTools = "$mountDir\Tools"
New-Item -ItemType Directory -Path $targetTools -Force | Out-Null

if (Test-Path "$toolsDir\Explorer++\Explorer++.exe") {
    Copy-Item "$toolsDir\Explorer++\*" "$targetTools\Explorer++" -Recurse -Force
    Write-Host "[+] Copied Explorer++"
} else {
    Write-Warning "Missing Explorer++ binary"
}

if (Test-Path "$toolsDir\Notepad++\notepad++.exe") {
    Copy-Item "$toolsDir\Notepad++\*" "$targetTools\Notepad++" -Recurse -Force
    Write-Host "[+] Copied Notepad++"
} else {
    Write-Warning "Missing Notepad++ binary"
}

# Step 4: Add custom StartNet.cmd to auto-launch Explorer++
$startnetPath = "$mountDir\Windows\System32\StartNet.cmd"
$startnetContent = @"
wpeinit
X:\Tools\Explorer++\Explorer++.exe
"@
Set-Content -Path $startnetPath -Value $startnetContent -Encoding ASCII
Write-Host "[*] Replaced StartNet.cmd with Explorer++ autolaunch"

# Step 5: Unmount and commit changes
Write-Host "[*] Committing changes and unmounting..."
Dism /Unmount-Image /MountDir:$mountDir /Commit | Out-Null

# Step 6: Deploy to USB (F:)
Write-Host "[*] Creating bootable USB at $usbDrive..."
MakeWinPEMedia /UFD $winPEBase $usbDrive

# Final status output with correct syntax
Write-Host "`n[✔] WinPE USB created successfully on $usbDrive`n" -ForegroundColor Green
