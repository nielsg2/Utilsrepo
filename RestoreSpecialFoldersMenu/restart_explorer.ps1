Write-Host "`n[*] Restarting Windows Explorer..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force
Start-Process explorer
Write-Host "[✔] Explorer restarted." -ForegroundColor Green
