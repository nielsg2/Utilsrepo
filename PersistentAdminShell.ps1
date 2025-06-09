# PowerShell Script: Persistent Admin Shell
# Author: nielsg2
# Repository: Utilsrepo
# Description: Ensures a persistent elevated PowerShell session for executing multiple scripts.
# Version: 1.4

# Check if running as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Starting persistent Administrator PowerShell session..." -ForegroundColor Yellow
    
    # Start an Admin PowerShell session in a new window that remains open
    Start-Process PowerShell -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command `"Start-Process PowerShell -ArgumentList '-NoExit -NoProfile -ExecutionPolicy Bypass' -Verb RunAs`"" -Verb RunAs
    
    Exit
}

# Ensure scripts run in this same persistent session
Write-Host "Running inside an elevated PowerShell session. All subsequent scripts will execute here." -ForegroundColor Green

# Example: Load additional scripts
$scriptFiles = @(
    "$env:USERPROFILE\Documents\Scripts\DiskTelemetry.ps1",
    "$env:USERPROFILE\Documents\Scripts\Setup.ps1"
)

foreach ($script in $scriptFiles) {
    if (Test-Path $script) {
        Write-Host "Executing script: $script" -ForegroundColor Cyan
        & $script
    } else {
        Write-Warning "Script not found: $script"
    }
}

Write-Host "All scripts executed in this persistent Admin session. Keep this window open for further execution." -ForegroundColor Green

# Keeps the session open
cmd /k