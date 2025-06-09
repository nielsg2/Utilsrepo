# PowerShell Script: Disk Performance Telemetry
# Author: nielsg2
# Repository: Utilsrepo
# Description: Gathers IOPS, latency, and throughput for each physical disk, logs results for historical tracking.
# Version: 1.5

# Ensure script runs as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Starting persistent Administrator PowerShell session..." -ForegroundColor Yellow
    
    Start-Process PowerShell -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    
    Exit
}

# Define persistent logging folder
$logFolder = "$env:USERPROFILE\Documents\DiskTelemetryLogs"
$logFile = "$logFolder\Disk_Performance_$(Get-Date -Format yyyyMMdd_HHmmss).csv"

# Create log folder if it doesn’t exist
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory
    Write-Host "Created log folder: $logFolder" -ForegroundColor Green
}

# Retrieve valid disk performance instances from WMI
$disks = Get-PhysicalDisk | Select-Object DeviceID, MediaType, FriendlyName
$diskInstances = Get-WmiObject -Query "SELECT Name FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk" | Select-Object Name

$performanceData = foreach ($disk in $disks) {
    $diskInstance = $diskInstances | Where-Object { $_.Name -match "^\d+" } | Where-Object { $_.Name -eq "$($disk.DeviceID)" }

    if ($diskInstance -and $diskInstance.Name) {
        try {
            $perfData = Get-WmiObject -Query "SELECT DiskTransfersPerSec, AvgDiskSecPerTransfer, DiskBytesPerSec FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name='$($diskInstance.Name)'"

            [PSCustomObject]@{
                "Timestamp" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                "Disk ID" = $disk.DeviceID
                "Media Type" = $disk.MediaType
                "Disk Name" = $disk.FriendlyName
                "IOPS" = "{0:N2}" -f $perfData.DiskTransfersPerSec
                "Latency (ms)" = "{0:N2}" -f ($perfData.AvgDiskSecPerTransfer * 1000)
                "Throughput (MB/s)" = "{0:N2}" -f ($perfData.DiskBytesPerSec / 1MB)
            }
        } catch {
            Write-Warning "Failed to retrieve performance data for Disk ID $($disk.DeviceID)"
        }
    } else {
        Write-Warning "No valid performance counters found for Disk ID $($disk.DeviceID)"
    }
}

# Save data to CSV for historical tracking
$performanceData | Export-Csv -Path $logFile -NoTypeInformation
Write-Host "Performance data saved to: $logFile" -ForegroundColor Cyan

# Display formatted table output
$performanceData | Format-Table -AutoSize