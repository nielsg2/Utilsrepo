@echo off
wpeinit

:: Set working path for tools
set TOOLPATH=%SystemDrive%\Program Files\GeoMFA-Tools

:: Launch Explorer++ (portable)
start "" "%TOOLPATH%\Explorer++.exe"

:: Launch Notepad++
start "" "%TOOLPATH%\notepad++.exe"

:: Optional: Launch RAIDXpert2 GUI if available
if exist "%TOOLPATH%\RAIDXpert2.exe" (
    start "" "%TOOLPATH%\RAIDXpert2.exe"
)

:: Open CMD prompt last
cmd