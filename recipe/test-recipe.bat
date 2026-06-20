@echo off
setlocal

rem ---------------------------------------------------------------------------
rem test-recipe.bat
rem
rem A Windows batch script converting the example recipe text files into
rem recipe XML
rem
rem Usage:
rem   test-recipe.bat
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

set "DP0=%~dp0"

call "%DP0%..\windows\Crane-txt2xml.bat" "%DP0%recipe.ixml" "%DP0%..\xsl\Crane-ixml2xml.xsl" "%DP0%recipeTokens1.txt" "%DP0%recipeTokens1.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

call "%DP0%..\windows\Crane-txt2xml.bat" "%DP0%recipe.ixml" "%DP0%..\xsl\Crane-ixml2xml.xsl" "%DP0%recipe1.txt"       "%DP0%recipe1.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

call "%DP0%..\windows\Crane-txt2xml.bat" "%DP0%recipe.ixml" "%DP0%..\xsl\Crane-ixml2xml.xsl" "%DP0%recipe2.txt"       "%DP0%recipe2.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%

call "%DP0%..\windows\Crane-txt2xml.bat" "%DP0%recipe.ixml" "%DP0%..\xsl\Crane-ixml2xml.xsl" "%DP0%recipe3error.txt"  "%DP0%recipe3error.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
