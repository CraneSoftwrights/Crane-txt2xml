@echo off
setlocal

rem ---------------------------------------------------------------------------
rem llm-scenario.bat
rem
rem A Windows batch script script converting the example recipe text files
rem into recipe XML
rem
rem Usage:
rem   llm-scenario.bat
rem
rem Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
rem
rem ---------------------------------------------------------------------------

set "DP0=%~dp0"

call "%DP0%..\recipe\one-recipe.bat" "%DP0%r01-pancakes.short.txt" "%DP0%r01-pancakes.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r02-scrambled-eggs.short.txt" "%DP0%r02-scrambled-eggs.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r03-grilled-cheese.short.txt" "%DP0%r03-grilled-cheese.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r04-tomato-soup.short.txt" "%DP0%r04-tomato-soup.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r05-caesar-salad.short.txt" "%DP0%r05-caesar-salad.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r06-aglio-e-olio.short.txt" "%DP0%r06-aglio-e-olio.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r07-hard-boiled-egg.short.txt" "%DP0%r07-hard-boiled-egg.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r08-banana-smoothie.short.txt" "%DP0%r08-banana-smoothie.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r09-toast-with-butter.short.txt" "%DP0%r09-toast-with-butter.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r10-chicken-stir-fry.short.txt" "%DP0%r10-chicken-stir-fry.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r11-lemonade.short.txt" "%DP0%r11-lemonade.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
call "%DP0%..\recipe\one-recipe.bat" "%DP0%r12-rice-pilaf.short.txt" "%DP0%r12-rice-pilaf.short.txt.xml"
set ret=%errorlevel%
if not "%ret%"=="0" exit /b %ret%
