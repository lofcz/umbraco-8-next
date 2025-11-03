@echo off
setlocal enabledelayedexpansion
REM ===================================================================
REM Build Lofcz.Forks.Umbraco.IdentityExtensions
REM ===================================================================

echo.
echo ===================================================================
echo Lofcz.Forks.Umbraco.IdentityExtensions - Build
echo ===================================================================
echo.

REM Get the latest IdentityExtensions package version from Release folder if it exists
set CURRENT_VERSION=2.0.0
if exist "build\Release\Lofcz.Forks.Umbraco.IdentityExtensions.*.nupkg" (
    for /f "tokens=5 delims=." %%a in ('dir /b build\Release\Lofcz.Forks.Umbraco.IdentityExtensions.*.nupkg 2^>nul') do (
        set CURRENT_VERSION=%%a
    )
)

echo Current version: %CURRENT_VERSION%
echo.
echo What would you like to increment?
echo   [1] Patch   (e.g., 2.0.0 -^> 2.0.1)
echo   [2] Minor   (e.g., 2.0.0 -^> 2.1.0)
echo   [3] Major   (e.g., 2.0.0 -^> 3.0.0)
echo   [4] Custom version
echo.

set /p CHOICE="Enter choice (1-4): "

REM Parse current version
for /f "tokens=1-3 delims=." %%a in ("%CURRENT_VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
    set PATCH=%%c
)

if "%CHOICE%"=="1" (
    set /a NEW_PATCH=!PATCH!+1
    set VERSION=!MAJOR!.!MINOR!.!NEW_PATCH!
) else if "%CHOICE%"=="2" (
    set /a NEW_MINOR=!MINOR!+1
    set VERSION=!MAJOR!.!NEW_MINOR!.0
) else if "%CHOICE%"=="3" (
    set /a NEW_MAJOR=!MAJOR!+1
    set VERSION=!NEW_MAJOR!.0.0
) else if "%CHOICE%"=="4" (
    set /p VERSION="Enter version (e.g., 2.1.0): "
    if "!VERSION!"=="" (
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
echo Building version %VERSION%...
echo.

REM Call the PowerShell build script
cd build
powershell -NoProfile -ExecutionPolicy Bypass -File Build-Release.ps1 -ReleaseVersionNumber "%VERSION%" -PreReleaseName ""

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    cd ..
    pause
    exit /b 1
)

cd ..

echo.
echo ===================================================================
echo SUCCESS: Build completed!
echo ===================================================================
echo.
echo Version: %VERSION%
echo.
echo Packages created in build\Release:
dir /b build\Release\Lofcz.Forks.Umbraco.IdentityExtensions*.%VERSION%.nupkg 2>nul
echo.
echo Next steps:
echo   1. Run publish-identity.bat to publish to NuGet.org
echo   2. Or manually test the packages
echo.
pause

