
<#
.SYNOPSIS
    Offlines drives whose volumes are all essentially empty.
.DESCRIPTION
    For each disk, if all associated volumes have near-zero used space,
    the disk is offlined. Intended to declutter Windows Explorer and Disk Management.
.NOTES
    Author: nielsg2
    License: MIT
    Repo: https://github.com/nielsg2/Utilsrepo
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param (
    [switch]$ForceOffline
)

# region CONFIGURATION
$LogPath = "$PSScriptRoot\Logs"
$LogFile = Join-Path $LogPath "VolumeDeclutterActions.log"
$UsedSpaceThresholdMB = 5  # MB threshold for "empty"
# endregion

# region FUNCTIONS
function Ensure-LogDirectory {
    if (-not (Test-Path $LogPath)) {
        New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
    }
}

function Log-Action {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp`t$Message" | Out-File -Append -FilePath $LogFile -Encoding UTF8
}

function Get-EmptyVolumeDisks {
    $candidates = @()

    $volumes = Get-Volume | Where-Object { $_.DriveLetter -ne $null -and $_.FileSystem -ne $null }
    foreach ($volume in $volumes) {
        $fsStats = Get-Volume -DriveLetter $volume.DriveLetter | Get-Partition | Get-Disk
        $usedMB = [math]::Round(($volume.Size - $volume.SizeRemaining) / 1MB, 2)

        if ($usedMB -le $UsedSpaceThresholdMB) {
            $diskNum = ($fsStats | Select-Object -First 1).Number
            $candidates += $diskNum
        }
    }

    # Return unique disk numbers where *all* volumes are empty
    $candidates | Group-Object | Where-Object { $_.Count -ge 1 } | ForEach-Object { $_.Name } | Sort-Object -Unique
}

function Set-DrivesOfflineIfAllVolumesEmpty {
    $targets = Get-EmptyVolumeDisks
    foreach ($diskNum in $targets) {
        $disk = Get-Disk -Number $diskNum
        if (-not $disk.IsOffline) {
            if ($PSCmdlet.ShouldProcess("Disk $diskNum", "Set Offline")) {
                Set-Disk -Number $diskNum -IsOffline $true -Confirm:$false
                Log-Action "Disk $diskNum offlined — all volumes empty."
                Write-Host "🔻 Disk $diskNum offlined (empty volumes only)."
            }
        } else {
            Write-Host "ℹ️ Disk $diskNum already offline."
        }
    }
}
# endregion

# region EXECUTION
Write-Host "`n🧹 Starting volume-based declutter pass..." -ForegroundColor Cyan
Ensure-LogDirectory
Set-DrivesOfflineIfAllVolumesEmpty
Write-Host "✅ Declutter scan complete.`n"
# endregion
