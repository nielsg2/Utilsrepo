@echo off
setlocal

set REPO="%USERPROFILE%\OneDrive\Code\Utilsrepo"

cd /d %REPO%

echo [*] Staging updated files...
git add AI_Directives.txt README.md CHANGELOG.md Directives_History.md

echo [*] Committing changes for version v1.3.0...
git commit -m "v1.3.0: Add Directives 8–10, CHANGELOG, Directives_History, and README.md updates"

echo [*] Pushing commit to main...
git push origin main

echo [*] Tagging commit as v1.3.0...
git tag -a v1.3.0 -m "Version 1.3.0: Directives 8–10, metadata updates"
git push origin v1.3.0

echo [✔] Repository updated and tagged as v1.3.0 successfully.
endlocal
pause
