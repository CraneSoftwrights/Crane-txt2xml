@echo off
setlocal

rem ---------------------------------------------------------------------------
rem indentXML.bat
rem
rem A Windows batch script for indenting the argument file using an
rem intermediate result
rem
rem Usage:
rem   indentXML.bat file.xml
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's parent's directory (inside the repo)
for %%I in ("%~dp0..") do set "REPO=%%~fI"

rem Require input file
if "%~1"=="" (
  echo Usage: %~nx0 file.xml
  exit /b 1
)
if not exist "%~1" (
  echo File "%~1" not found.
  echo.
  echo Usage: %~nx0 file.xml
  exit /b 1
)

rem Indent the given XML input file at argument

java -Xms200m -Xmx1000m -cp "%REPO%\utilities\saxonhe\saxonhe.jar" net.sf.saxon.Transform -s:"%~1" -xsl:"%REPO%\xsl\indentXML.xsl" -o:"%~1.indented.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

move /y "%~1.indented.xml" "%~1" >nul
