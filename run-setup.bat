@echo off
echo Starting CareerNest Database Setup...
echo.

cd /d "%~dp0"
npm run setup

echo.
echo Setup completed! Press any key to exit...
pause >nul
