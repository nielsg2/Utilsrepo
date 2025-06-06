# PowerShell Script: Restore System PATH Variable
# Author: Nothing
# Repository: Utilsrepo
# Description: Restores the system PATH from a backup, supports both text and JSON formats, and logs all actions.
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
$logFile = "$backupFolder\RestorePathLog.txt"
$latestBackupTxt = Get-ChildItem -Path $backupFolder -Filter "PATH_Backup_*.txt" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$latestBackupJson = Get-ChildItem -Path $backupFolder -Filter "PATH_Backup_*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Start logging
Write-Host "Logging output to $logFile" -ForegroundColor Cyan
"PowerShell PATH Restore Log - $(Get-Date)" | Out-File -FilePath $logFile -Append
"-------------------------------------------" | Out-File -FilePath $logFile -Append

# Restore from latest JSON backup if available
if ($latestBackupJson) {
    Write-Host "Restoring PATH from JSON: $($latestBackupJson.FullName)" -ForegroundColor Cyan
    "Restoring PATH from JSON: $($latestBackupJson.FullName)" | Out-File -FilePath $logFile -Append
    $pathArray = Get-Content $latestBackupJson.FullName | ConvertFrom-Json
    $restoredPath = $pathArray -join ";"
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -Value $restoredPath
    Write-Host "System PATH restored successfully!" -ForegroundColor Green
    "System PATH restored successfully from JSON!" | Out-File -FilePath $logFile -Append
} elseif ($latestBackupTxt) {
    # Restore from latest text backup if JSON is unavailable
    Write-Host "Restoring PATH from text backup: $($latestBackupTxt.FullName)" -ForegroundColor Cyan
    "Restoring PATH from text backup: $($latestBackupTxt.FullName)" | Out-File -FilePath $logFile -Append
    $restoredPath = Get-Content $latestBackupTxt.FullName
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -Value $restoredPath
    Write-Host "System PATH restored successfully!" -ForegroundColor Green
    "System PATH restored successfully from text backup!" | Out-File -FilePath $logFile -Append
} else {
    # No backup found
    Write-Host "No valid PATH backup found! Please ensure backups exist in $backupFolder." -ForegroundColor Red
    "No valid PATH backup found!" | Out-File -FilePath $logFile -Append
}

Write-Host "Restore process completed. Please restart your system for changes to take effect." -ForegroundColor Yellow
"Restore completed at $(Get-Date)" | Out-File -FilePath $logFile -Append