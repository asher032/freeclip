@echo off
title FreeClip - AI Clip Generator
echo ============================================
echo   FreeClip - AI Clip Generator
echo   Built to clip what people actually watch
echo ============================================
echo.

:: Kill any existing processes on our ports
echo [1/4] Cleaning up old processes...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8000" ^| findstr "LISTENING"') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5175" ^| findstr "LISTENING"') do taskkill /F /PID %%a >nul 2>&1
timeout /t 2 /nobreak >nul

:: Set PATH for Python and FFmpeg
echo [2/4] Setting up environment...
set "PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python311;%USERPROFILE%\AppData\Local\Programs\Python\Python311\Scripts;%PATH%"

:: Auto-discover FFmpeg (works regardless of version)
for /d %%d in ("%USERPROFILE%\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_*\ffmpeg-*\bin") do set "PATH=%%d;%PATH%"

:: Start the backend
echo [3/4] Starting backend on http://localhost:8000 ...
cd /d "%~dp0"
start "FreeClip Backend" cmd /k "cd /d "%~dp0" && set "PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python311;%PATH%" && for /d %%d in ("%USERPROFILE%\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_*\ffmpeg-*\bin") do set "PATH=%%d;%PATH%" && .venv\Scripts\python -u app.py"

:: Wait for backend to be ready
echo [4/4] Waiting for backend...
:waitloop
timeout /t 2 /nobreak >nul
curl -s http://localhost:8000/health >nul 2>&1
if errorlevel 1 goto waitloop
echo.
echo ============================================
echo   ALL READY!
echo.
echo   App:        http://localhost:5175
echo   Backend:    http://localhost:8000
echo ============================================
echo.
echo Starting frontend...
cd /d "%~dp0dashboard"
npx vite --port 5175
pause
