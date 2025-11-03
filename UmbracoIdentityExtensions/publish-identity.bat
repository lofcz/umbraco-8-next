@echo off
REM ===================================================================
REM Publish Lofcz.Forks.Umbraco.IdentityExtensions to NuGet.org
REM ===================================================================

echo.
echo ===================================================================
echo Publishing Lofcz.Forks.Umbraco.IdentityExtensions to NuGet.org
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

cd build\Release

REM Find the package files
for %%f in (Lofcz.Forks.Umbraco.IdentityExtensions.*.nupkg) do (
    echo %%f | findstr /V "Google Facebook AzureActiveDirectory" >nul
    if not errorlevel 1 set MAIN_PKG=%%f
)
for %%f in (Lofcz.Forks.Umbraco.IdentityExtensions.Google.*.nupkg) do set GOOGLE_PKG=%%f
for %%f in (Lofcz.Forks.Umbraco.IdentityExtensions.Facebook.*.nupkg) do set FACEBOOK_PKG=%%f
for %%f in (Lofcz.Forks.Umbraco.IdentityExtensions.AzureActiveDirectory.*.nupkg) do set AZURE_PKG=%%f

if not defined MAIN_PKG (
    echo ERROR: Could not find main IdentityExtensions package in build\Release
    cd ..\..
    pause
    exit /b 1
)

echo Found packages:
echo   - %MAIN_PKG%
if defined GOOGLE_PKG echo   - %GOOGLE_PKG%
if defined FACEBOOK_PKG echo   - %FACEBOOK_PKG%
if defined AZURE_PKG echo   - %AZURE_PKG%
echo.

echo.
echo [1/4] Publishing %MAIN_PKG%...
echo ===================================================================
nuget push %MAIN_PKG% -Source https://api.nuget.org/v3/index.json -ApiKey %NUGET_API_KEY%
if errorlevel 1 (
    echo ERROR: Failed to publish %MAIN_PKG%
    cd ..\..
    pause
    exit /b 1
)
echo SUCCESS: %MAIN_PKG% published!
echo.

if defined GOOGLE_PKG (
    echo [2/4] Publishing %GOOGLE_PKG%...
    echo ===================================================================
    nuget push %GOOGLE_PKG% -Source https://api.nuget.org/v3/index.json -ApiKey %NUGET_API_KEY%
    if errorlevel 1 (
        echo ERROR: Failed to publish %GOOGLE_PKG%
        cd ..\..
        pause
        exit /b 1
    )
    echo SUCCESS: %GOOGLE_PKG% published!
    echo.
)

if defined FACEBOOK_PKG (
    echo [3/4] Publishing %FACEBOOK_PKG%...
    echo ===================================================================
    nuget push %FACEBOOK_PKG% -Source https://api.nuget.org/v3/index.json -ApiKey %NUGET_API_KEY%
    if errorlevel 1 (
        echo ERROR: Failed to publish %FACEBOOK_PKG%
        cd ..\..
        pause
        exit /b 1
    )
    echo SUCCESS: %FACEBOOK_PKG% published!
    echo.
)

if defined AZURE_PKG (
    echo [4/4] Publishing %AZURE_PKG%...
    echo ===================================================================
    nuget push %AZURE_PKG% -Source https://api.nuget.org/v3/index.json -ApiKey %NUGET_API_KEY%
    if errorlevel 1 (
        echo ERROR: Failed to publish %AZURE_PKG%
        cd ..\..
        pause
        exit /b 1
    )
    echo SUCCESS: %AZURE_PKG% published!
    echo.
)

cd ..\..

echo.
echo ===================================================================
echo SUCCESS: All packages published to NuGet.org!
echo ===================================================================
echo.
echo Your packages are now available at:
echo - https://www.nuget.org/packages/Lofcz.Forks.Umbraco.IdentityExtensions/
echo - https://www.nuget.org/packages/Lofcz.Forks.Umbraco.IdentityExtensions.Google/
echo - https://www.nuget.org/packages/Lofcz.Forks.Umbraco.IdentityExtensions.Facebook/
echo - https://www.nuget.org/packages/Lofcz.Forks.Umbraco.IdentityExtensions.AzureActiveDirectory/
echo.
echo Note: It may take a few minutes for packages to appear in search results.
echo.
pause

