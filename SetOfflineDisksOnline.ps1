# PowerShell Script: Set Offline Disks to Online
# Author: Nothing
# Repository: Utilsrepo
# Description: Identifies offline disks and sets them to online, ensuring admin privileges.
# Version: 1.0

$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting with Administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$offlineDisks = Get-Disk | Where-Object { $_.OperationalStatus -eq "Offline" }
foreach ($disk in $offlineDisks) {
    try {
        Set-Disk -Number $disk.Number -IsOffline $false
        Write-Host "Disk $($disk.Number) is now ONLINE." -ForegroundColor Green
    } catch {
        Write-Host "Failed to update Disk $($disk.Number). Error: $_" -ForegroundColor Red
    }
}

Write-Host "Finished updating disk statuses." -ForegroundColor Cyan
