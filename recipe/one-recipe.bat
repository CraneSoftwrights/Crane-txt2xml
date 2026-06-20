@echo off
setlocal

rem ---------------------------------------------------------------------------
rem one-recipe.bat
rem
rem A Windows batch script converting the supplied recipe text file into
rem recipe XML
rem
rem Usage:
rem   one-recipe.bat
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

set "DP0=%~dp0"

echo Converting "%~1" to "%~2"...

call "%DP0%..\windows\Crane-txt2xml.bat" "%DP0%recipe.ixml" "%DP0%..\xsl\Crane-ixml2xml.xsl" "%~1" "%~2"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
