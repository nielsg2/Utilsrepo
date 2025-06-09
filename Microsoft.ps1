# Microsoft.PowerShell_profile.ps1
# Author: nielsg2
# Purpose: Optimized PowerShell startup for automation, logging, and Git management
# Version: 2.3

# --- Ensure Logging Path Exists ---
$LogDirectory = "$env:USERPROFILE\Documents\PowerShell"
$LogFile = "$LogDirectory\ProfileLog.txt"

if (-not (Test-Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory -Force
}

# Corrected logging statement ensuring valid pipeline syntax
$LogEntry = "[$(Get-Date)] PowerShell profile loading..."
$LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile

# --- Set Default Working Directory ---
$DefaultPath = "C:\OneDriveCode"
if (Test-Path $DefaultPath) {
    Set-Location -Path $DefaultPath
    $LogEntry = "[$(Get-Date)] Default location set to $DefaultPath"
    $LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile
} else {
    $LogEntry = "[$(Get-Date)] Warning: Default path missing - profile did not set working directory."
    $LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile
}

# --- Alias Definitions ---
Set-Alias gs Get-Service
Set-Alias lsl "Get-ChildItem -Force -Attributes Directory"

# --- Module Imports ---
$Modules = @("Microsoft.WinGet.CommandNotFound", "PowerShellGet", "Microsoft.PowerShell.Utility")
foreach ($Module in $Modules) {
    if (-not (Get-Module -ListAvailable | Where-Object { $_.Name -eq $Module })) {
        $LogEntry = "[$(Get-Date)] Module $Module is missing!"
    } else {
        Import-Module -Name $Module
        $LogEntry = "[$(Get-Date)] Imported module: $Module"
    }
    $LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile
}

# --- Git & Automation Enhancements ---
$GitRepoPath = "C:\Users\nsgadm1\OneDrive\Code"
$UtilsRepo = "https://github.com/nielsg2/Utilsrepo.git"

function Git-QuickCommit {
    param ($Message = "Automated Commit")
    $LogEntry = "[$(Get-Date)] Executing Git commit..."
    $LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile

    Set-Location $GitRepoPath
    git add .
    git commit -m $Message
    git push origin main

    $LogEntry = "[$(Get-Date)] Git commit completed: $Message"
    $LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile
}

# --- Error Handling & Debugging Tools ---
function Handle-Error {
    param ($ErrorMessage)
    $LogEntry = "[$(Get-Date)] ERROR: $ErrorMessage"
    $LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile
    Write-Host "ERROR: $ErrorMessage" -ForegroundColor Red
}

$Global:ErrorActionPreference = "Stop"

# --- Profile Load Completion ---
$LogEntry = "[$(Get-Date)] PowerShell profile loaded successfully."
$LogEntry | Out-File -Append -Encoding utf8 -FilePath $LogFile
Write-Host "PowerShell profile loaded!" -ForegroundColor Green