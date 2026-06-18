@echo off

rem ---------------------------------------------------------------------------
rem Crane-txt2xml.bat
rem
rem A Windows batch script for invoking the Crane-txt2xml workflow on the
rem inputs
rem
rem Usage:
rem   Crane-txt2xml.bat  modeliXML  modelXSLT  inputText  outputXML
rem
rem Assumptions:
rem
rem   modeliXML  - iXML grammar
rem   modelXSLT  - iXML output massage stylesheet
rem
rem   inputText             - text input for XML output
rem   outputXML.ixmlout.xml - iXML output XML (deleted)
rem   outputXML.err.txt     - if error: text file of messages
rem   outputXML             - if no error: XML output for text input
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's parent's directory (inside the repo)
for %%I in ("%~dp0..") do set "REPO=%%~fI"

rem Invocation and command line
if "%~4"=="" (
  >&2 echo Usage: %~nx0 model.ixml model.xsl input.txt output.xml
  >&2 echo See script header for full details
  exit /b 1
)

set "modeliXML=%~1"
set "modelXSLT=%~2"
set "inputFile=%~3"
set "outputFile=%~4"
set "intermediate=%~3.ixmlout.xml"
set "errorFile=%~4.err.txt"

rem echo Processing: "%~3" into "%~4" ...

if not exist "%~3" echo Input text "%~3" not found && exit /b 1
if not exist "%modeliXML%" echo Grammar file "%modeliXML%" not found && exit /b 1
if not exist "%modelXSLT%" echo Massage file "%modelXSLT%" not found && exit /b 1

rem Remove any old intermediate and final files
if exist "%intermediate%" del "%intermediate%"
if exist "%errorFile%"    del "%errorFile%"
if exist "%~4"            del "%~4"

rem Parse the input text into intermediate XML or error text
java -Xss16m -jar "%REPO%\utilities\coffeepot\coffeepot.jar" -i "%~3" -g "%modeliXML%" -o "%intermediate%" --mark-ambiguities --input-newline 2>&1
set ret=%errorlevel%
if not "%ret%"=="0" (
  ren "%intermediate%" "%outputbase%.err.txt"
  exit /b %ret%
)

rem Convert the intermediate XML into final XML or error text
java -Xss16m -cp "%REPO%\utilities\saxonhe\saxonhe.jar" net.sf.saxon.Transform -s:"%intermediate%" -xsl:"%modelXSLT%" -o:"%~4" 2>"%errorFile%"
set ret=%errorlevel%

rem The intermediate file no longer is needed
if exist "%intermediate%" del "%intermediate%"

rem If there was an error then any output is bogus and the error file should have details
if not "%ret%"=="0" (
  echo Error reported for: "%~3"
  if exist "%~4" del "%~4"
  exit /b %ret%
)

rem If there was no error then any error file should be bogus
if exist "%errorFile%" del "%errorFile%"

rem end