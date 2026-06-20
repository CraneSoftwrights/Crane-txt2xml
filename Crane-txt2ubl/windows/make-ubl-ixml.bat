@echo off
setlocal

rem ---------------------------------------------------------------------------
rem make-ubl-ixml.bat
rem
rem A Windows batch script converting UBL XSD into iXML
rem
rem Usage:
rem   make-ubl-ixml.bat
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's grandparent's directory (the repo)
for %%I in ("%~dp0..\..") do set "REPO=%%~fI"

java -jar "%REPO%\utilities\saxonhe\saxonhe.jar" -s:"%REPO%\Crane-txt2ubl\UBL-AllDocuments-2.5.xsd" -xsl:"%REPO%\Crane-txt2ubl\xsl\Crane-ubl2ixml.xsl" -o:"%REPO%\Crane-txt2ubl\ubl-2.5.ixml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
