# PowerShell Script: List Volumes and Set Disks Offline If All Volumes Are Empty
# Author: Nothing
# Repository: Utilsrepo
# Description: Lists all volumes with their used space, then sets disks offline if all volumes are below threshold.
# Version: 1.1

# Ensure script runs as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting with Administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Define threshold (Modify as needed)
$threshold = 100MB  # Set to desired value

# List all volumes before filtering
Write-Host "Listing all volumes and their used space..." -ForegroundColor Cyan
$volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.FileSystem }
foreach ($volume in $volumes) {
    $usedSpace = $volume.Size - $volume.SizeRemaining
    Write-Host "Volume $($volume.DriveLetter): Used Space = $([math]::Round($usedSpace / 1MB, 2)) MB" -ForegroundColor White
}

# Get all disks
$disks = Get-Disk | Where-Object { $_.OperationalStatus -eq "Online" }

foreach ($disk in $disks) {
    $diskVolumes = Get-Volume | Where-Object { $_.UniqueId -match $disk.UniqueId }

    # Ensure all volumes on disk are below the threshold
    if ($diskVolumes.Count -gt 0 -and ($diskVolumes | Where-Object { ($_.Size - $_.SizeRemaining) -gt $threshold }).Count -eq 0) {
        try {
            Set-Disk -Number $disk.Number -IsOffline $true
            Write-Host "Disk $($disk.Number) is now OFFLINE (all volumes were below $threshold)." -ForegroundColor Red
        } catch {
            Write-Host "Failed to update Disk $($disk.Number). Error: $_" -ForegroundColor Yellow
        }
    }
}

Write-Host "Finished processing disks where all volumes are below threshold." -ForegroundColor Green
