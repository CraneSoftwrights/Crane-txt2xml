@echo off

rem ---------------------------------------------------------------------------
rem test-ubl.bat
rem
rem A Windows batch script converting an example UBL invoice text file into
rem UBL XML
rem
rem Usage:
rem   test-ubl.bat
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

rem Get the absolute path to the script's grandparent's directory (the repo)
for %%I in ("%~dp0..\..") do set "REPO=%%~fI"

echo Converting sample UBL document to text...
call "%REPO%\Crane-txt2ubl\windows\Crane-ubl2txt.bat" "%REPO%\Crane-txt2ubl\UBL-invoice-2.1-Example.xml" "%REPO%\Crane-txt2ubl\UBL-invoice-2.1-Example-text.txt"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

echo Converting generated text to UBL document...
call "%REPO%\Crane-txt2ubl\windows\Crane-txt2ubl.bat" "%REPO%\Crane-txt2ubl\UBL-invoice-2.1-Example-text.txt" "%REPO%\Crane-txt2ubl\UBL-invoice-2.1-Example-text.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
