@echo off

rem ---------------------------------------------------------------------------
rem Crane-txt2ubl.bat
rem
rem A Windows batch script for invoking the Crane-txt2ubl workflow on the text
rem input to create a UBL instance
rem
rem Usage:
rem   Crane-txt2ubl.bat  inputTEXT  outputXML
rem
rem Assumptions:
rem
rem   inputTEXT             - text input for XML output
rem   outputXML         - XML output for text input
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's grandparent's directory (the repo)
for %%I in ("%~dp0..\..") do set "REPO=%%~fI"

rem Invocation and command line
if "%~2"=="" (
  >&2 echo Usage: %~nx0  inputTEXT  outputXML
  >&2 echo See script header for full details
  exit /b 1
)

call "%REPO%\windows\Crane-txt2xml.bat" "%REPO%\Crane-txt2ubl\ubl-2.5.ixml" "%REPO%\Crane-txt2ubl\xsl\Crane-ixml2ubl.xsl" "%~1" "%~2"

rem end
