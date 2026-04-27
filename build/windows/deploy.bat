@echo off
setlocal enabledelayedexpansion

rem =============================================================
rem libugm Windows deploy script
rem Copies libugm{32,32d,64,64d}.lib to ..\raygen-renderer\lib\windows
rem =============================================================

set "SRC=%~dp0cpp-graphics-math"
set "DST=%~dp0..\..\..\raygen-renderer\lib\windows"

if not exist "%DST%" (
    echo [ERROR] Destination not found: %DST%
    exit /b 1
)

set "FAILED="

call :copy "%SRC%\Debug\libugm32d.lib"        "%DST%\libugm32d.lib"        || set "FAILED=!FAILED! libugm32d"
call :copy "%SRC%\Release\libugm32.lib"       "%DST%\libugm32.lib"         || set "FAILED=!FAILED! libugm32"
call :copy "%SRC%\x64\Debug\libugm64d.lib"    "%DST%\libugm64d.lib"        || set "FAILED=!FAILED! libugm64d"
call :copy "%SRC%\x64\Release\libugm64.lib"   "%DST%\libugm64.lib"         || set "FAILED=!FAILED! libugm64"

echo.
if defined FAILED (
    echo [FAILED]!FAILED!
    exit /b 1
) else (
    echo [SUCCESS] deployed to %DST%
    exit /b 0
)

:copy
if not exist %1 (
    echo [SKIP] missing: %~1
    exit /b 1
)
echo [copy] %~nx1 -^> %~2
copy /y %1 %2 >nul
exit /b %errorlevel%
