# PowerShell Script: Set Empty Drives to Offline
# Author: Nothing
# Repository: Utilsrepo
# Description: Identifies drives with under 1MB of used space and sets them to offline, ensuring admin privileges.
# Version: 1.0

# Ensure script runs as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting with Administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Get volumes with under 1MB of used space
$emptyDisks = Get-Volume | Where-Object { ($_.Size - $_.SizeRemaining) -lt 1MB }

# Loop through each empty disk and bring it offline
foreach ($disk in $emptyDisks) {
    try {
        $diskNumber = (Get-Disk -Volume $disk).Number
        Set-Disk -Number $diskNumber -IsOffline $true
        Write-Host "Disk $diskNumber is now OFFLINE." -ForegroundColor Red
    } catch {
        Write-Host "Failed to update Disk $diskNumber. Error: $_" -ForegroundColor Yellow
    }
}

Write-Host "Finished processing empty disks." -ForegroundColor Cyan
