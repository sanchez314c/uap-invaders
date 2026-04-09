@echo off
setlocal enabledelayedexpansion

REM ════════════════════════════════════════════════════════════════════
REM UAP Invaders - Windows Source Launcher
REM ════════════════════════════════════════════════════════════════════

REM ── Port Configuration ──
set DEV_SERVER_PORT=55377
set ELECTRON_DEBUG_PORT=60205
set ELECTRON_INSPECT_PORT=63365

REM ── Color Codes ──
set RED=[91m
set GREEN=[92m
set BLUE=[94m
set YELLOW=[93m
set NC=[0m

echo %BLUE%[%TIME%]%NC% Starting UAP Invaders from source (Windows)...

REM ── Zombie Process Cleanup ──
echo %BLUE%[%TIME%]%NC% Checking for zombie processes...
taskkill /F /IM electron.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
timeout /t 1 /nobreak >nul

REM ── Port Cleanup ──
echo %BLUE%[%TIME%]%NC% Checking ports: %DEV_SERVER_PORT%, %ELECTRON_DEBUG_PORT%, %ELECTRON_INSPECT_PORT%...
for %%P in (%DEV_SERVER_PORT% %ELECTRON_DEBUG_PORT% %ELECTRON_INSPECT_PORT%) do (
    for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":%%P"') do (
        echo %YELLOW%[%TIME%] WARNING%NC% Port %%P in use, killing PID %%a...
        taskkill /F /PID %%a >nul 2>&1
    )
)

REM ── Dependency Check ──
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %RED%[%TIME%] X%NC% Node.js not installed
    pause
    exit /b 1
)

where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %RED%[%TIME%] X%NC% npm not installed
    pause
    exit /b 1
)

REM ── Install Dependencies ──
if not exist "node_modules" (
    echo %BLUE%[%TIME%]%NC% Installing dependencies...
    call npm install
)

REM ── Environment Setup ──
set NODE_ENV=development

REM ── Launch Application ──
echo %GREEN%[%TIME%] OK%NC% Launching UAP Invaders...
call npm run dev || call npm start

echo.
echo %GREEN%[%TIME%] OK%NC% Application session ended
pause
