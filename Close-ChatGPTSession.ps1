
<#
.SYNOPSIS
    Finalizes AI-driven development session by logging end time and preparing handoff.
.DESCRIPTION
    Logs the closure of a ChatGPT-guided session, optionally packaging files for archival,
    and prints resume instructions for Future ME.
.NOTES
    Author: nielsg2
    License: MIT
    Repo: https://github.com/nielsg2/Utilsrepo
    Status: MVP – Expand iteratively
#>

# region CONFIGURATION
$RepoRoot = "C:\Users\nsgadm1\OneDrive\Code\Utilsrepo"
$LogFile = "$RepoRoot\Session_Startup.log"
$ClosureNote = "$RepoRoot\Session_Closed_At.txt"
# endregion

# region CLOSE SESSION LOG
function Finalize-SessionLog {
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "Session closed at $now by Close-ChatGPTSession.ps1"
    Set-Content -Path $ClosureNote -Value "Session closed at $now`r`nEnsure all files are committed to GitHub before exit."
    Write-Host "🛑 Session closed and logged: $now"
}
# endregion

# region SUMMARY
function Print-NextSteps {
    Write-Host "`n📘 NEXT STEPS:" -ForegroundColor Cyan
    Write-Host "1. Review modified files and commit to GitHub if ready."
    Write-Host "2. Upload session summaries and roadmap updates if prompted."
    Write-Host "3. Run SETUP.ps1 next session to restore continuity."
}
# endregion

# region EXECUTION
Write-Host "`n📦 Executing Close-ChatGPTSession.ps1 (MVP)" -ForegroundColor Magenta
Finalize-SessionLog
Print-NextSteps
Write-Host "`n✅ Close process complete.`n"
# endregion
