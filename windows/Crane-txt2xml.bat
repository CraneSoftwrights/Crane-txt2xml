@echo off

rem ---------------------------------------------------------------------------
rem Crane-txt2xml.bat
rem
rem A Windows batch script for invoking the Crane-txt2xml workflow on the
rem inputs
rem
rem Usage:
rem   Crane-txt2xml.bat  model.ixml  model.xsl  input.txt  output.xml
rem
rem Assumptions:
rem
rem   model.ixml - iXML grammar
rem   model.xsl  - iXML output massage stylesheet
rem
rem   input.txt                - text input for XML output
rem   input/output.ixmlout.xml - iXML output XML
rem   input/output.ixmlout.txt - iXML XML as text
rem   input/output.xml         - XML output for text input
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
set "outputdir=%~dp4"
set "outputbase=%~nx4"

rem echo Processing: "%~3" into "%~4" ...

if not exist "%~3" echo Input text "%~3" not found && exit /b 1
if not exist "%modeliXML%" echo Grammar file "%modeliXML%" not found && exit /b 1
if not exist "%modelXSLT%" echo Massage file "%modelXSLT%" not found && exit /b 1

rem Remove any old intermediate files
if exist "%outputdir%%outputbase%.ixmlout.xml" del "%outputdir%%outputbase%.ixmlout.xml"
if exist "%outputdir%%outputbase%.ixmlout.txt" del "%outputdir%%outputbase%.ixmlout.txt"

rem Parse the input text into intermediate XML
java -Xss64m -jar "%REPO%\utilities\coffeepot\coffeepot.jar" -i "%~3" -g "%modeliXML%" -o "%outputdir%%outputbase%.ixmlout.xml" --input-newline --parse-count:2
set ret=%errorlevel%
rem if not "%ret%"=="0" exit /b %ret%

rem Convert the intermediate XML into final XML
java -Xss64m -Xms200m -Xmx1000m -cp "%REPO%\utilities\saxonhe\saxonhe.jar" net.sf.saxon.Transform -s:"%outputdir%%outputbase%.ixmlout.xml" -xsl:"%modelXSLT%" -o:"%~4"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

rem Convert intermediate XML into raw text for reporting
call "%REPO%\windows\Crane-xml2txt.bat" "%outputdir%%outputbase%.ixmlout.xml" "%outputdir%%outputbase%.ixmlout.txt"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

rem Indent the iXML output for legibility
call "%REPO%\windows\indentXML.bat" "%outputdir%%outputbase%.ixmlout.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

rem end
