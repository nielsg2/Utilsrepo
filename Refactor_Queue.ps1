
<#
.SYNOPSIS
    Tracks modernization progress of all Utilsrepo scripts.
.DESCRIPTION
    Use this queue to manage and prioritize script updates for compliance with AI directives.
    This includes logging, modularity, CLI params, standard headers, and naming conventions.
.NOTES
    Author: nielsg2
    License: MIT
    Repo: https://github.com/nielsg2/Utilsrepo
#>

# region REFACTOR QUEUE
$RefactorQueue = @(
    @{ Script = "BackupPath.ps1";                     Status = "Minor updates needed: add CLI and log stub" },
    @{ Script = "CentralizePaths.ps1";                Status = "Minor updates needed: doc headers, dry-run flag" },
    @{ Script = "ComparePATHtoBackup.ps1";            Status = "Add output formatting + basic log entry" },
    @{ Script = "RestorePath.ps1";                    Status = "Needs file existence check and region markers" },
    @{ Script = "SetDisksOfflineIfEmptyVolumes.ps1";  Status = "Refactor needed: structure, logging, safe mode" },
    @{ Script = "SetEmptyDrivesOffline.ps1";          Status = "Same as above" },
    @{ Script = "SetOfflineDisksOnline.ps1";          Status = "Wrap logic in function, add params" },
    @{ Script = "SimulateOutput.ps1";                 Status = "Add summary message and optional JSON log" },
    @{ Script = "ListVolumesAndSetDisksOffline.ps1";  Status = "✅ COMPLETE: Modular, logged, WhatIf-ready declutter tool" },
    @{ Script = "PersistentAdminShell.ps1";           Status = "Add headers, admin checks, CLI flow" },
    @{ Script = "Microsoft.ps1";                      Status = "Undocumented — clarify intent or remove" },
    @{ Script = "Microsoft.PowerShell_profile.ps1";   Status = "Optional cleanup, not part of repo release" },
    @{ Script = "Regenerate-CopilotHistory.ps1";      Status = "Rename + reformat to ChatGPT standard" },
    @{ Script = "Initialize-CopilotHistory.ps1";      Status = "Same as above" },
    @{ Script = "DiskPerfTelemetry.ps1";              Status = "High ROI: telemetry structure + logging (SQLite later)" }
)

# Display queue
$RefactorQueue | Format-Table Script, Status -AutoSize
# endregion
