@echo off
setlocal

set SRC="%USERPROFILE%\Downloads\AI_Directives_UPDATED.txt"
set DEST="%USERPROFILE%\OneDrive\Code\Utilsrepo\AI_Directives.txt"
set REPO="%USERPROFILE%\OneDrive\Code\Utilsrepo"
set README="%REPO%\README.md"

echo [*] Validating updated directives file...
if not exist %SRC% (
    echo [ERROR] AI_Directives_UPDATED.txt not found in Downloads.
    pause
    exit /b 1
)

echo [*] Overwriting original AI_Directives.txt in Utilsrepo...
copy /Y %SRC% %DEST%

cd /d %REPO%

echo [*] Updating README.md with directive change note...

REM Append a change log entry to README
echo.>> %README%
echo ## [Directives Updated - %DATE% %TIME%] >> %README%
echo - Added Directive 8: All scripts must be syntax-tested and validated before delivery. >> %README%
echo - Added Directive 9: AI must always output corrected files. >> %README%
echo - Added Directive 10: Always update README.md and tracking files when modifying repository files. >> %README%

echo [*] Staging changes...
git add AI_Directives.txt README.md

echo [*] Committing changes...
git commit -m "Update AI_Directives.txt with Directives 8–10 and README.md changelog"

echo [*] Pushing to GitHub...
git push origin main

echo [✔] Directives and README.md successfully updated and pushed.
endlocal
pause
