@echo off
REM ===================================================================
REM Publish Lofcz.Forks.Umbraco NuGet Packages to NuGet.org
REM ===================================================================
REM 
REM Get your API key from: https://www.nuget.org/account/apikeys
REM ===================================================================

echo.
echo ===================================================================
echo Publishing Lofcz.Forks.Umbraco Packages to NuGet.org
echo ===================================================================
echo.
echo Get your API key from: https://www.nuget.org/account/apikeys
echo.

set /p NUGET_API_KEY="Enter your NuGet API Key: "

if "%NUGET_API_KEY%"=="" (
    echo.
    echo ERROR: No API key provided!
    pause
    exit /b 1
)

echo.
echo API key received. Starting publish...
echo.

cd build.out

REM Find the package files
for %%f in (Lofcz.Forks.Umbraco.Core.*.nupkg) do set CORE_PKG=%%f
for %%f in (Lofcz.Forks.Umbraco.Web.*.nupkg) do set WEB_PKG=%%f
for %%f in (Lofcz.Forks.Umbraco.*.nupkg) do (
    echo %%f | findstr /V "Core Web" >nul
    if not errorlevel 1 set MAIN_PKG=%%f
)

if not defined CORE_PKG (
    echo ERROR: Could not find Lofcz.Forks.Umbraco.Core package in build.out
    cd ..
    pause
    exit /b 1
)
if not defined WEB_PKG (
    echo ERROR: Could not find Lofcz.Forks.Umbraco.Web package in build.out
    cd ..
    pause
    exit /b 1
)
if not defined MAIN_PKG (
    echo ERROR: Could not find Lofcz.Forks.Umbraco package in build.out
    cd ..
    pause
    exit /b 1
)

echo Found packages:
echo   - %CORE_PKG%
echo   - %WEB_PKG%
echo   - %MAIN_PKG%
echo.

echo.
echo [1/3] Publishing %CORE_PKG%...
echo ===================================================================
nuget push %CORE_PKG% -Source https://api.nuget.org/v3/index.json -ApiKey %NUGET_API_KEY%
if errorlevel 1 (
    echo ERROR: Failed to publish %CORE_PKG%
    cd ..
    pause
    exit /b 1
)
echo SUCCESS: %CORE_PKG% published!
echo.

echo [2/3] Publishing %WEB_PKG%...
echo ===================================================================
nuget push %WEB_PKG% -Source https://api.nuget.org/v3/index.json -ApiKey %NUGET_API_KEY%
if errorlevel 1 (
    echo ERROR: Failed to publish %WEB_PKG%
    cd ..
    pause
    exit /b 1
)
echo SUCCESS: %WEB_PKG% published!
echo.

echo [3/3] Publishing %MAIN_PKG%...
echo ===================================================================
nuget push %MAIN_PKG% -Source https://api.nuget.org/v3/index.json -ApiKey %NUGET_API_KEY%
if errorlevel 1 (
    echo ERROR: Failed to publish %MAIN_PKG%
    cd ..
    pause
    exit /b 1
)
echo SUCCESS: %MAIN_PKG% published!
echo.

cd ..

echo.
echo ===================================================================
echo SUCCESS: All packages published to NuGet.org!
echo ===================================================================
echo.
echo Your packages are now available at:
echo - https://www.nuget.org/packages/Lofcz.Forks.Umbraco.Core/
echo - https://www.nuget.org/packages/Lofcz.Forks.Umbraco.Web/
echo - https://www.nuget.org/packages/Lofcz.Forks.Umbraco/
echo.
echo Note: It may take a few minutes for packages to appear in search results.
echo.
pause

