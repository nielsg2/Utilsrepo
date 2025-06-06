# PowerShell Script: Ensure All Disks Are Online & Read-Write (Verbose Support)
# Author: Nothing
# Repository: Utilsrepo
# Description: Brings offline disks online, ensures they are NOT read-only, and provides verbose logging.

[CmdletBinding()]
param ()

# Ensure script runs as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Verbose "Restarting with Administrator privileges..."
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Write-Verbose "Checking for offline disks..."
$offlineDisks = Get-Disk | Where-Object { $_.OperationalStatus -eq "Offline" }

if ($offlineDisks.Count -gt 0) {
    Write-Host "Bringing Offline Disks Online..." -ForegroundColor Cyan
    foreach ($disk in $offlineDisks) {
        Write-Host "Bringing Disk $($disk.Number) online..." -ForegroundColor Cyan
        Write-Verbose "Running: Set-Disk -Number $($disk.Number) -IsOffline $false"
        Set-Disk -Number $disk.Number -IsOffline $false
    }
} else {
    Write-Host "No offline disks found. Skipping online checks..." -ForegroundColor Green
}

# Checking for read-only disks (even if all disks are online)
Write-Verbose "Checking for read-only disks..."
$readOnlyDisks = Get-Disk | Where-Object { $_.IsReadOnly -eq $true }

if ($readOnlyDisks.Count -gt 0) {
    Write-Host "Fixing Read-Only Disks..." -ForegroundColor Yellow
    foreach ($disk in $readOnlyDisks) {
        Write-Host "Removing Read-Only Attribute for Disk $($disk.Number)..." -ForegroundColor Red
        Write-Verbose "Running: Set-Disk -Number $($disk.Number) -IsReadOnly $false"
        Set-Disk -Number $disk.Number -IsReadOnly $false
    }
} else {
    Write-Host "No read-only disks found. Skipping fixes..." -ForegroundColor Green
}

# Final disk status check
Write-Host "`nFinal Disk Status:" -ForegroundColor Green
Write-Verbose "Running: Get-Disk | Select-Object Number, OperationalStatus, IsReadOnly"
Get-Disk | Select-Object Number, OperationalStatus, IsReadOnly | Format-Table -AutoSize

Write-Host "`nAll disks should now be online and writable!" -ForegroundColor Green