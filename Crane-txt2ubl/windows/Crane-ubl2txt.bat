@echo off

rem ---------------------------------------------------------------------------
rem Crane-ubl2txt.bat
rem
rem A Windows batch script for invoking the Crane-ubl2txt stylesheet on a UBL
rem XML document to create a simple text file suitable for editing.
rem
rem Usage:
rem   Crane-ubl2txt.bat  inputXML  outputTEXT
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's grandparent's directory (the repo)
for %%I in ("%~dp0..\..") do set "REPO=%%~fI"

rem Invocation and command line
if "%~2"=="" (
  >&2 echo Usage: %~nx0 input-XML output-text
  >&2 echo See script header for full details
  exit /b 1
)

if not exist "%~1" echo Input XML "%~1" not found && exit /b 1

rem Remove any old result file
if exist "%~2" del "%~2"

java -cp "%REPO%\utilities\saxonhe\saxonhe.jar" net.sf.saxon.Transform -s:"%~1" -xsl:"%REPO%\Crane-txt2ubl\xsl\Crane-ubl2txt.xsl" -o:"%~2"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

rem end
