$adkWinPEPath = "C:\WinPE_amd64"
$isoOutput = "$adkWinPEPath\WinPE.iso"
$targetDrive = "F:"
$makeWinPEPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\MakeWinPEMedia.cmd"

# Correct quoting for execution via cmd.exe
cmd.exe /c ('"' + $makeWinPEPath + '" /ISO "' + $adkWinPEPath + '" "' + $isoOutput + '"')

# Try launching Rufus from common paths
$rufusCandidates = @(
    "$env:ProgramFiles\Rufus\rufus.exe",
    "$env:ProgramFiles(x86)\Rufus\rufus.exe",
    "$env:LOCALAPPDATA\rufus\rufus.exe",
    "rufus.exe"
)

foreach ($candidate in $rufusCandidates) {
    if (Test-Path $candidate) {
        Start-Process $candidate -ArgumentList "--quiet", "--device=$targetDrive", "--iso=$isoOutput"
        break
    }
}
