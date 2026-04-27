@echo off
setlocal enabledelayedexpansion

rem =============================================================
rem libugm Windows build script
rem Builds Win32/x64 x Debug/Release -> libugm{32,32d,64,64d}.lib
rem =============================================================

set "MSBUILD=C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe"
set "PROJ=%~dp0cpp-graphics-math\cpp-graphics-math.vcxproj"

if not exist "%MSBUILD%" (
    echo [ERROR] MSBuild.exe not found: %MSBUILD%
    exit /b 1
)
if not exist "%PROJ%" (
    echo [ERROR] Project not found: %PROJ%
    exit /b 1
)

set "TARGET=%~1"
if /i "%TARGET%"=="" set "TARGET=all"

set "FAILED="

if /i "%TARGET%"=="all" (
    call :build Debug   Win32 || set "FAILED=!FAILED! Debug^|Win32"
    call :build Release Win32 || set "FAILED=!FAILED! Release^|Win32"
    call :build Debug   x64   || set "FAILED=!FAILED! Debug^|x64"
    call :build Release x64   || set "FAILED=!FAILED! Release^|x64"
) else if /i "%TARGET%"=="win32" (
    call :build Debug   Win32 || set "FAILED=!FAILED! Debug^|Win32"
    call :build Release Win32 || set "FAILED=!FAILED! Release^|Win32"
) else if /i "%TARGET%"=="x64" (
    call :build Debug   x64 || set "FAILED=!FAILED! Debug^|x64"
    call :build Release x64 || set "FAILED=!FAILED! Release^|x64"
) else if /i "%TARGET%"=="debug" (
    call :build Debug Win32 || set "FAILED=!FAILED! Debug^|Win32"
    call :build Debug x64   || set "FAILED=!FAILED! Debug^|x64"
) else if /i "%TARGET%"=="release" (
    call :build Release Win32 || set "FAILED=!FAILED! Release^|Win32"
    call :build Release x64   || set "FAILED=!FAILED! Release^|x64"
) else if /i "%TARGET%"=="clean" (
    call :clean Debug   Win32
    call :clean Release Win32
    call :clean Debug   x64
    call :clean Release x64
    echo.
    echo [clean] done.
    exit /b 0
) else (
    echo Usage: build.bat [all^|win32^|x64^|debug^|release^|clean]
    exit /b 1
)

echo.
if defined FAILED (
    echo [FAILED]!FAILED!
    exit /b 1
) else (
    echo [SUCCESS] all configurations built.
    echo Output: %~dp0cpp-graphics-math\{Debug^|Release}\ ^(Win32^) and \x64\{Debug^|Release}\ ^(x64^)
    exit /b 0
)

:build
echo.
echo ================================================
echo Building %1 ^| %2
echo ================================================
"%MSBUILD%" "%PROJ%" /t:Build /p:Configuration=%1 /p:Platform=%2 /m /nologo /v:minimal
exit /b %errorlevel%

:clean
echo.
echo ================================================
echo Cleaning %1 ^| %2
echo ================================================
"%MSBUILD%" "%PROJ%" /t:Clean /p:Configuration=%1 /p:Platform=%2 /nologo /v:minimal
exit /b %errorlevel%
