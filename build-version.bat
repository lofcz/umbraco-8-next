@echo off
setlocal enabledelayedexpansion
REM ===================================================================
REM Set Version and Build Lofcz.Forks.Umbraco
REM ===================================================================

echo.
echo ===================================================================
echo Lofcz.Forks.Umbraco - Version and Build
echo ===================================================================
echo.

REM Get current version from existing package
set CURRENT_VERSION=
for /f "tokens=2 delims=." %%a in ('dir /b build.out\Lofcz.Forks.Umbraco.Core.*.nupkg 2^>nul') do (
    for /f "tokens=1-3 delims=.-" %%b in ("%%a") do (
        set CURRENT_MAJOR=%%b
        set CURRENT_MINOR=%%c
        set CURRENT_PATCH=%%d
        set CURRENT_VERSION=%%b.%%c.%%d
    )
)

if not defined CURRENT_VERSION (
    echo No previous build found. Starting with version 8.19.0
    set CURRENT_MAJOR=8
    set CURRENT_MINOR=19
    set CURRENT_PATCH=0
    set CURRENT_VERSION=8.19.0
)

REM Calculate preview versions
set /a PREVIEW_PATCH=%CURRENT_PATCH%+1
set /a PREVIEW_MINOR=%CURRENT_MINOR%+1
set /a PREVIEW_MAJOR=%CURRENT_MAJOR%+1

echo Current version: %CURRENT_VERSION%-lofcz
echo.
echo What would you like to increment?
echo   [1] Patch   (%CURRENT_MAJOR%.%CURRENT_MINOR%.%CURRENT_PATCH% -^> %CURRENT_MAJOR%.%CURRENT_MINOR%.%PREVIEW_PATCH%)
echo   [2] Minor   (%CURRENT_MAJOR%.%CURRENT_MINOR%.%CURRENT_PATCH% -^> %CURRENT_MAJOR%.%PREVIEW_MINOR%.0)
echo   [3] Major   (%CURRENT_MAJOR%.%CURRENT_MINOR%.%CURRENT_PATCH% -^> %PREVIEW_MAJOR%.0.0)
echo   [4] Custom version
echo.

set /p CHOICE="Enter choice (1-4): "

if "%CHOICE%"=="1" (
    set /a NEW_PATCH=%CURRENT_PATCH%+1
    set VERSION=%CURRENT_MAJOR%.%CURRENT_MINOR%.!NEW_PATCH!-lofcz
) else if "%CHOICE%"=="2" (
    set /a NEW_MINOR=%CURRENT_MINOR%+1
    set VERSION=%CURRENT_MAJOR%.!NEW_MINOR!.0-lofcz
) else if "%CHOICE%"=="3" (
    set /a NEW_MAJOR=%CURRENT_MAJOR%+1
    set VERSION=!NEW_MAJOR!.0.0-lofcz
) else if "%CHOICE%"=="4" (
    set /p VERSION="Enter custom version (e.g., 8.20.0-lofcz): "
    if "%VERSION%"=="" (
        echo ERROR: No version provided!
        pause
        exit /b 1
    )
) else (
    echo ERROR: Invalid choice!
    pause
    exit /b 1
)

echo.
echo Setting version to %VERSION%...
echo.

REM Set the version using PowerShell build infrastructure
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ubuild = .\build\build.ps1 -get; $ubuild.SetUmbracoVersion('%VERSION%')"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to set version!
    pause
    exit /b 1
)

echo.
echo Version set successfully!
echo.
echo Starting build...
echo ===================================================================
echo.

REM Run the build
powershell -NoProfile -ExecutionPolicy Bypass -File .\build\build.ps1

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ===================================================================
echo SUCCESS: Build completed!
echo ===================================================================
echo.
echo Version: %VERSION%
echo.
echo Packages created in build.out:
dir /b build.out\Lofcz.Forks.Umbraco.*.nupkg
echo.
echo Next steps:
echo   1. Run publish.bat to publish to NuGet.org
echo   2. Or manually test the packages
echo.
pause

