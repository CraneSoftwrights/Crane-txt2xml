@echo off

rem ---------------------------------------------------------------------------
rem Crane-xml2txt.bat
rem
rem A Windows batch script converting XML into a text form suitable for
rem Crane-txt2xml
rem
rem Usage:
rem   Crane-xml2txt.bat  input.xml  output.txt
rem
rem To use Markdown in mixed content output text, set MARKDOWN=markdown=yes
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's parent's directory (inside the repo)
for %%I in ("%~dp0..") do set "REPO=%%~fI"

if "%~2"=="" (
  >&2 echo Usage: %~nx0 input.xml output.txt
  >&2 echo See script header for full details
  exit /b 1
)

rem echo Processing: "%~1" into "%~2" ...

if not exist "%~1" echo Input XML "%~1" not found && exit /b 1

rem Remove any old result file
if exist "%~2" del "%~2"

java -Xss64m -Xms200m -Xmx1000m -cp "%REPO%\utilities\saxonhe\saxonhe.jar" net.sf.saxon.Transform -s:"%~1" -xsl:"%REPO%\xsl\Crane-xml2txt.xsl" -o:"%~2" use-labels=no escape=no %MARKDOWN%
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

rem end
