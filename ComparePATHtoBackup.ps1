# PowerShell Script: Compare PATH Backup vs. Current PATH
# Author: Nothing
# Repository: Utilsrepo
# Description: Compares the backed-up PATH variable against the current system PATH.
# Version: 1.0

# Define backup folder and latest backup file locations
$backupFolder = "$env:USERPROFILE\Documents\PathBackups"
$latestBackupTxt = Get-ChildItem -Path $backupFolder -Filter "PATH_Backup_*.txt" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$logFile = "$backupFolder\PathComparisonLog.txt"

# Validate that a backup exists
if (-not $latestBackupTxt) {
    Write-Host "No PATH backup found! Ensure backups exist in $backupFolder." -ForegroundColor Red
    Exit
}

# Read backup and current PATH
$backupPath = Get-Content $latestBackupTxt.FullName -Raw -ErrorAction Stop
$currentPath = $env:Path

# Convert PATH variables to arrays for comparison
$backupArray = $backupPath -split ";"
$currentArray = $currentPath -split ";"

# Find differences
$missingEntries = $backupArray | Where-Object { $_ -notin $currentArray }
$newEntries = $currentArray | Where-Object { $_ -notin $backupArray }

# Log results
"PATH Comparison Report - $(Get-Date)" | Out-File -FilePath $logFile -Append
"-------------------------------------------" | Out-File -FilePath $logFile -Append
"Missing Entries (Present in Backup, Missing Now):" | Out-File -FilePath $logFile -Append
$missingEntries | Out-File -FilePath $logFile -Append
"New Entries (Present Now, Missing in Backup):" | Out-File -FilePath $logFile -Append
$newEntries | Out-File -FilePath $logFile -Append

# Display results
Write-Host "`nComparison Complete! Results saved in $logFile" -ForegroundColor Green
Write-Host "`nMissing Entries:`n" -ForegroundColor Yellow
$missingEntries
Write-Host "`nNew Entries:`n" -ForegroundColor Cyan
$newEntries