@echo off
setlocal

REM Step 1: Move updated directives file into the repo as a new file
move /Y "%USERPROFILE%\Downloads\AI_Directives_UPDATED.txt" "%USERPROFILE%\OneDrive\Code\Utilsrepo\AI_Directives_UPDATED.txt"

REM Step 2: Change to repo directory
cd /d "%USERPROFILE%\OneDrive\Code\Utilsrepo"

REM Step 3: Ensure this is a Git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] This is not a Git repository.
    exit /b 1
)

REM Step 4: Stage the new updated file
git add AI_Directives_UPDATED.txt

REM Step 5: Commit with message
git commit -m "Add AI_Directives_UPDATED.txt with Directive 8 (syntax validation) and Directive 9 (corrected output enforcement)"

REM Step 6: Push to GitHub
git push origin main

echo.
echo [✔] AI_Directives_UPDATED.txt added and pushed to GitHub without overwriting original.
endlocal
pause
