@echo off
setlocal

REM Step 1: Move updated directives file
move /Y "%USERPROFILE%\Downloads\AI_Directives_UPDATED.txt" "%USERPROFILE%\OneDrive\Code\Utilsrepo\AI_Directives.txt"

REM Step 2: Change to repo directory
cd /d "%USERPROFILE%\OneDrive\Code\Utilsrepo"

REM Step 3: Ensure this is a Git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] This is not a Git repository.
    exit /b 1
)

REM Step 4: Stage the updated file
git add AI_Directives.txt

REM Step 5: Commit the change with message
git commit -m "Add Directive 8 (syntax validation) and Directive 9 (corrected output enforcement)"

REM Step 6: Push to GitHub main branch
git push origin main

echo.
echo [✔] Directives updated and pushed to GitHub.
endlocal
pause
