# PowerShell Script: Backup System PATH Variable
# Author: Nothing
# Repository: Utilsrepo
# Description: Backs up the current PATH variable, logs all details, and ensures easy recovery if needed.
# Version: 1.1

# Ensure script runs as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting with Administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Define new persistent backup folder
$backupFolder = "$env:USERPROFILE\Documents\PathBackups"
$backupFile = "$backupFolder\PATH_Backup_$(Get-Date -Format yyyyMMdd_HHmmss).txt"
$backupJson = "$backupFolder\PATH_Backup_$(Get-Date -Format yyyyMMdd_HHmmss).json"

# Create backup folder if it doesn’t exist
if (-not (Test-Path $backupFolder)) {
    New-Item -Path $backupFolder -ItemType Directory
    Write-Host "Created backup folder: $backupFolder" -ForegroundColor Green
}

# Backup current PATH in text format
$env:Path | Out-File -FilePath $backupFile
Write-Host "System PATH backed up to: $backupFile" -ForegroundColor Cyan

# Backup current PATH in JSON format for easy restore
$pathArray = $env:Path -split ";"
$pathJson = $pathArray | ConvertTo-Json -Depth 1
$pathJson | Out-File -FilePath $backupJson
Write-Host "System PATH saved in JSON format: $backupJson" -ForegroundColor Cyan

# Log completion details
Write-Host "Backup completed successfully at $(Get-Date)" -ForegroundColor Green