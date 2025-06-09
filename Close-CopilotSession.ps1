# Close-CopilotSession.ps1
# Author: nielsg2
# Purpose: Finalizes current AI session, ensuring history is archived before closing.
# License: MIT License
# Copyright (C) 2025 nielsg2

# --- Define Paths ---
$RepoPath = "C:\OnedriveCode\Utilsrepo"
$CopilotDir = "$RepoPath\Copilot_History"

Write-Host "`n=============================" -ForegroundColor Yellow
Write-Host "Closing Current Copilot Session..." -ForegroundColor Cyan
Write-Host "=============================`n" -ForegroundColor Yellow

# Ensure all history files are structured & saved
Write-Host "Finalizing AI interaction history..." -ForegroundColor Green

# Validate latest session file exists
$LatestSessionFile = "$CopilotDir\Session_Summary_$(Get-Date -Format 'yyyy-MM-dd').txt"

if (-not (Test-Path $LatestSessionFile)) {
    Write-Host "WARNING: Latest session summary does not exist. Request the latest summary from AI before continuing!" -ForegroundColor Red
    Pause
}

# Prompt user to retrieve final AI session summary
Write-Host "`nSTOP: Request latest AI session history from Copilot before proceeding." -ForegroundColor Yellow
Write-Host "Once retrieved, press any key to continue and push updates to GitHub..." -ForegroundColor Green
Pause

# Commit files to GitHub
Write-Host "`nArchiving session history and pushing to GitHub..." -ForegroundColor Cyan
Set-Location $RepoPath
git add Copilot_History
git commit -m "Finalized and archived AI session history for structured tracking"
git push origin main

Write-Host "`nSession history successfully archived!" -ForegroundColor Green
Write-Host "Copilot session closed. Ready for next engagement." -ForegroundColor Cyan