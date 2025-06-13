powershell
# --- Configurable section ---
$rufusPath = "rufus.exe"  # Must be on PATH or full path

Write-Host "[INIT] Launching Rufus in GUI mode only..." -ForegroundColor Cyan

# --- Check Rufus availability ---
try {
    $rufusFullPath = Get-Command $rufusPath -ErrorAction Stop | Select-Object -ExpandProperty Source
    Write-Host "[CHECK] Rufus located: $rufusFullPath" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Rufus not found. Check installation or PATH." -ForegroundColor Red
    exit 1
}

# --- Launch Rufus GUI without arguments ---
Start-Process -FilePath $rufusFullPath -NoNewWindow
Write-Host "[SUCCESS] Rufus GUI launched. Please configure flashing manually." -ForegroundColor Yellow
