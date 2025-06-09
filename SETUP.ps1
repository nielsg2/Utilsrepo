
<#
.SYNOPSIS
    Initializes the PowerShell AI-Enhanced Dev Environment.
.DESCRIPTION
    Validates environment, ensures folder structure, loads profile if available,
    and logs session initialization for ChatGPT-driven collaboration.
.NOTES
    Author: nielsg2
    License: MIT
    Repo: https://github.com/nielsg2/Utilsrepo
    Status: MVP – Expand iteratively
#>

# region CONFIGURATION
$ExpectedCodePath = "C:\Users\nsgadm1\OneDrive\Code\Utilsrepo"
$LinkedPath = "C:\OnedriveCode"
$RepoName = "Utilsrepo"
$SessionLog = "$ExpectedCodePath\Session_Startup.log"
$ProfileScript = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
# endregion

# region ENVIRONMENT VALIDATION
function Test-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning "❌ Script not running as Administrator. Some operations may fail."
    } else {
        Write-Host "✅ Running as Administrator"
    }
}

function Validate-DirectoryStructure {
    if (-not (Test-Path $ExpectedCodePath)) {
        Write-Host "❌ Missing Code Directory: $ExpectedCodePath" -ForegroundColor Red
        return $false
    }
    if (-not (Test-Path $LinkedPath)) {
        try {
            New-Item -Path $LinkedPath -ItemType SymbolicLink -Value $ExpectedCodePath -Force
            Write-Host "🔗 Created symbolic link: $LinkedPath → $ExpectedCodePath"
        } catch {
            Write-Warning "⚠️ Could not create symbolic link: $_"
        }
    } else {
        Write-Host "✅ Symbolic link or directory exists: $LinkedPath"
    }
    return $true
}
# endregion

# region PROFILE LOADER
function Load-PowerShellProfile {
    if (Test-Path $ProfileScript) {
        . $ProfileScript
        Write-Host "✅ PowerShell profile loaded."
    } else {
        Write-Host "⚠️ PowerShell profile not found. Skipped loading." -ForegroundColor Yellow
    }
}
# endregion

# region LOGGING STUB
function Initialize-SessionLog {
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "Session initialized at $now by SETUP.ps1" | Out-File -FilePath $SessionLog -Append -Encoding UTF8
    Write-Host "📝 Session startup logged to $SessionLog"
}
# endregion

# region MAIN EXECUTION
Write-Host "`n🚀 Starting Utilsrepo SETUP.ps1 (MVP)" -ForegroundColor Cyan
Test-Admin
if (Validate-DirectoryStructure) {
    Load-PowerShellProfile
    Initialize-SessionLog
}

# region OPTIONAL: Run Refactor Queue
$RefactorQueueScript = Join-Path -Path $PSScriptRoot -ChildPath "Refactor_Queue.ps1"
if (Test-Path $RefactorQueueScript) {
    Write-Host "`n📌 Running Refactor Queue Overview..." -ForegroundColor Green
    . $RefactorQueueScript
} else {
    Write-Host "ℹ️ Refactor_Queue.ps1 not found in script directory."
}
# endregion

Write-Host "✅ SETUP complete.`n"
# endregion
