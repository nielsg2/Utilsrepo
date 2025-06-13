
<#
.SYNOPSIS
    Collects disk performance telemetry (IOPS, latency, throughput).
.DESCRIPTION
    Queries disk performance counters and logs results in readable format.
    Future versions may integrate SQLite logging for long-term tracking.
.NOTES
    Author: nielsg2
    License: MIT
    Repo: https://github.com/nielsg2/Utilsrepo
#>

[CmdletBinding()]
param (
    [string]$OutFile = "$PSScriptRoot\Logs\DiskPerfMetrics.csv",
    [switch]$VerboseOutput
)

# region CONFIGURATION
$LogPath = Split-Path -Path $OutFile
$PerfCounters = @(
    "\PhysicalDisk(*)\Disk Reads/sec",
    "\PhysicalDisk(*)\Disk Writes/sec",
    "\PhysicalDisk(*)\Avg. Disk sec/Read",
    "\PhysicalDisk(*)\Avg. Disk sec/Write",
    "\PhysicalDisk(*)\Disk Bytes/sec"
)
# endregion

# region FUNCTIONS
function Ensure-LogDirectory {
    if (-not (Test-Path $LogPath)) {
        New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
    }
}

function Collect-Telemetry {
    try {
        Get-Counter -Counter $PerfCounters -ErrorAction Stop
    } catch {
        Write-Warning "⚠️ Failed to retrieve performance counters: $_"
        return $null
    }
}

function Format-CounterResults {
    param ([object]$CounterData)

    return $CounterData.CounterSamples | ForEach-Object {
        [PSCustomObject]@{
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Path      = $_.Path
            Value     = [math]::Round($_.CookedValue, 2)
        }
    }
}

function Export-Telemetry {
    param ([object]$FormattedData)
    $FormattedData | Export-Csv -Path $OutFile -Append -NoTypeInformation -Encoding UTF8
}
# endregion

# region EXECUTION
Write-Host "`n📊 Starting Disk Performance Telemetry..." -ForegroundColor Cyan
Ensure-LogDirectory
$rawData = Collect-Telemetry

if ($rawData) {
    $formatted = Format-CounterResults -CounterData $rawData
    if ($VerboseOutput) {
        $formatted | Format-Table -AutoSize
    }
    Export-Telemetry -FormattedData $formatted
    Write-Host "✅ Telemetry written to $OutFile"
} else {
    Write-Host "❌ Telemetry collection failed. No data written."
}
# endregion
