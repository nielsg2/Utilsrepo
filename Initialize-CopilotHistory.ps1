# Initialize-CopilotHistory.ps1
# Author: nielsg2
# Purpose: Automates creation of Copilot_History directory for structured AI interaction tracking.
# License: MIT License
# Copyright (C) 2025 nielsg2

# --- Define Directory Paths ---
$RepoPath = "C:\OnedriveCode\Utilsrepo"
$CopilotDir = "$RepoPath\Copilot_History"

# Ensure Copilot_History exists
if (-not (Test-Path $CopilotDir)) {
    New-Item -Path $CopilotDir -ItemType Directory -Force
}

# --- Create Placeholder Files with Initial Content ---

# Directives.txt (Copy existing directives file)
Copy-Item "$RepoPath\AI_Directives.txt" "$CopilotDir\Directives.txt" -Force

# Roadmap.md (Copy existing roadmap file)
Copy-Item "$RepoPath\Development Roadmap and History.txt" "$CopilotDir\Roadmap.md" -Force

# Session Summary
$SessionFile = "$CopilotDir\Session_Summary_$(Get-Date -Format 'yyyy-MM-dd').txt"
$SessionContent = @"
# AI Interaction Summary - $(Get-Date -Format 'yyyy-MM-dd')
## Context:
- Initialized structured AI history archive.
- Defined repeatable automation for knowledge transfer.

## Key Changes:
- Established Copilot_History repository tracking system.
- Ensured full documentation for all past AI interactions.

## Next Steps:
- Refine SETUP.ps1 to support environment initialization.
- Expand SQLite-based logging across core scripts.
"@
$SessionContent | Out-File -FilePath $SessionFile -Encoding utf8

# Tasks_Completed.md
$TasksCompletedFile = "$CopilotDir\Tasks_Completed.md"
$TasksCompletedContent = @"
# Completed Technical Tasks
✅ Initialized Copilot_History for structured AI handoff.
✅ Ensured full-script output compliance in Directives.txt.
✅ Committed roadmap tracking improvements.
✅ Verified structured Git workflow for AI documentation.
"@
$TasksCompletedContent | Out-File -FilePath $TasksCompletedFile -Encoding utf8

# Future_Features.md
$FutureFeaturesFile = "$CopilotDir\Future_Features.md"
$FutureFeaturesContent = @"
# Planned Enhancements
🚀 Finalize SETUP.ps1 for streamlined environment setup.
🚀 Expand SQLite logging for improved telemetry analysis.
🚀 Enhance disk management automation for tiered storage.
🚀 Strengthen AI documentation integration for seamless handoff.
"@
$FutureFeaturesContent | Out-File -FilePath $FutureFeaturesFile -Encoding utf8

Write-Host "Copilot_History initialized successfully!" -ForegroundColor Green