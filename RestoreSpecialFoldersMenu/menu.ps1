Clear-Host
Write-Host "Restore Special Folders Utility" -ForegroundColor Cyan
Write-Host "================================="

Write-Host "1. Restore Special Folder Paths"
Write-Host "2. Restart Windows Explorer"
Write-Host "3. Exit"

$choice = Read-Host "`nSelect an option (1-3)"

switch ($choice) {
    "1" { . "$PSScriptRoot\restore_special_folders.ps1" }
    "2" { . "$PSScriptRoot\restart_explorer.ps1" }
    "3" { Write-Host "Goodbye!" -ForegroundColor Yellow; exit }
    default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red }
}
