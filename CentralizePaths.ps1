# PowerShell Script: Centralized PATH Optimization
# Author: Nothing
# Repository: Utilsrepo
# Description: Creates a PATH folder, scans all existing PATH directories for executables, creates symbolic links, logs actions, and modifies PATH to use only the new folder.
# Version: 1.0

# Ensure script runs as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting with Administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Define new PATH folder
$pathLinksDir = "C:\PathLinks"
$logFile = "$env:TEMP\PathLinksSetupLog.txt"

# Log start
Write-Host "Logging output to $logFile" -ForegroundColor Cyan
"PowerShell PATH Optimization Log - $(Get-Date)" | Out-File -FilePath $logFile -Append
"-------------------------------------------" | Out-File -FilePath $logFile -Append

# Create the folder if it doesn’t exist
if (-not (Test-Path $pathLinksDir)) {
    New-Item -Path $pathLinksDir -ItemType Directory
    Write-Host "Created PATH links folder: $pathLinksDir" -ForegroundColor Green
    "Created PATH links folder: $pathLinksDir" | Out-File -FilePath $logFile -Append
} else {
    Write-Host "PATH links folder already exists: $pathLinksDir" -ForegroundColor Yellow
    "PATH links folder already exists: $pathLinksDir" | Out-File -FilePath $logFile -Append
}

# Extract all directories from current PATH
$pathDirs = $env:Path -split ";"
$exeTypes = @("*.exe", "*.bat", "*.cmd")

# Loop through each directory in PATH and find executables
foreach ($dir in $pathDirs) {
    if (Test-Path $dir) {
        foreach ($exeType in $exeTypes) {
            $executables = Get-ChildItem -Path $dir -Filter $exeType -File -ErrorAction SilentlyContinue
            foreach ($exe in $executables) {
                $linkPath = "$pathLinksDir\$($exe.Name)"
                if (-not (Test-Path $linkPath)) {
                    New-Item -Path $linkPath -ItemType SymbolicLink -Value $exe.FullName
                    Write-Host "Created link for: $($exe.Name)" -ForegroundColor Cyan
                    "Linked: $($exe.FullName) -> $linkPath" | Out-File -FilePath $logFile -Append
                } else {
                    Write-Host "Skipped existing link for: $($exe.Name)" -ForegroundColor Yellow
                    "Skipped existing link for: $($exe.Name)" | Out-File -FilePath $logFile -Append
                }
            }
        }
    }
}

# Update PATH to only use the new folder
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -Value $pathLinksDir
Write-Host "System PATH updated to use only $pathLinksDir" -ForegroundColor Green
"System PATH updated to use only: $pathLinksDir" | Out-File -FilePath $logFile -Append

Write-Host "Setup complete. Restart your terminal or system for changes to take effect." -ForegroundColor Yellow
"Setup complete at $(Get-Date)" | Out-File -FilePath $logFile -Append