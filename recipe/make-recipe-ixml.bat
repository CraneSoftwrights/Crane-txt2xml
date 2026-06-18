@echo off

rem ---------------------------------------------------------------------------
rem make-recipe-ixml.bat
rem
rem A Windows batch script converting the recipe XSD into iXML
rem
rem Usage:
rem   make-recipe-ixml.bat
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's parent's directory (inside the repo)
for %%I in ("%~dp0..") do set "REPO=%%~fI"

java -jar "%REPO%\utilities\saxonhe\saxonhe.jar" -s:"%REPO%\recipe\recipe-garden-of-eden.xsd" -xsl:"%REPO%\recipe\Crane-recipe2ixml.xsl" -o:"%REPO%\recipe\recipe.ixml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
