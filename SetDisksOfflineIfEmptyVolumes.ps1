# PowerShell Script: Set Disks Offline If All Volumes Are Empty
# Author: Nothing
# Repository: Utilsrepo
# Description: Identifies disks where all volumes have under 1MB of used space and sets the disk offline, ensuring admin privileges.
# Version: 1.0

# Ensure script runs as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting with Administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Get all disks
$disks = Get-Disk | Where-Object { $_.OperationalStatus -eq "Online" }

foreach ($disk in $disks) {
    $volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.FileSystem -and $_.UniqueId -match $disk.UniqueId }
    
    if ($volumes.Count -gt 0 -and ($volumes | Where-Object { ($_.Size - $_.SizeRemaining) -gt 1MB }).Count -eq 0) {
        try {
            Set-Disk -Number $disk.Number -IsOffline $true
            Write-Host "Disk $($disk.Number) is now OFFLINE (all volumes were empty)." -ForegroundColor Red
        } catch {
            Write-Host "Failed to update Disk $($disk.Number). Error: $_" -ForegroundColor Yellow
        }
    }
}

Write-Host "Finished processing disks where all volumes are empty." -ForegroundColor Cyan
