# Move updated AI Directives file into the repo
move /Y "%USERPROFILE%\Downloads\AI_Directives_UPDATED.txt" "%USERPROFILE%\OneDrive\Code\Utilsrepo\AI_Directives.txt"

# Change directory to the repo
cd /d "%USERPROFILE%\OneDrive\Code\Utilsrepo"

# Stage and commit the file
git add AI_Directives.txt
git commit -m "Add Directive 8 (syntax validation) and Directive 9 (corrected output enforcement)"
git push origin main
