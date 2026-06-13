#!/bin/bash

set +x

# ---------------------------------------------------------------------------
# Crane-txt2xml.sh
#
# A shell script for invoking the Crane-txt2xml workflow on the inputs
#
# Usage:
#   Crane-txt2xml.sh  modeliXML  modelXSLT  inputText  outputXML
#
# Assumptions:
#
#   modeliXML  - iXML grammar
#   modelXSLT  - iXML output massage stylesheet
#
#   inputText                - text input for XML output
#   outputXML.ixmlout.xml    - intermediate iXML output XML (deleted)
#   outputXML.err.txt        - if error: text file of guidance
#   outputXML                - if no error: XML output for text input
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
if ! REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"; then
  echo "Cannot determine REPO path" >&2
  exit 1
fi

# Invocation and command line
if [ "" == "$4" ]; then
  echo Usage: "$0" model.ixml model.xsl input.txt output.xml >&2
  echo See script header for full details >&2
  exit 1
fi

#if [ -z "$TIMED" ]; then
#  date
#  TIMED=1 time bash "$0" "$@"
#  exit
#fi

modeliXML="$1"
modelXSLT="$2"
inputFile="$3"
outputFile="$4"
intermediate="$3.ixmlout.xml"
errorFile="$4.err.txt"

# echo Processing: "$3" into "$4" ...

if [ ! -f "$3" ];   then echo Input text "$3" not found ; exit 1 ; fi
if [ ! -f "$modeliXML" ]; then echo Grammar file "$modeliXML" not found ; exit 1 ; fi
if [ ! -f "$modelXSLT" ];  then echo Massage file "$modelXSLT" not found ; exit 1 ; fi

# Remove any old intermediate and final files
if [ -f "$intermediate" ]; then rm "$intermediate" ; fi
if [ -f "$errorFile" ];     then rm "$errorFile" ; fi
if [ -f "$4" ]; then rm "$4" ; fi

# echo Parse the input text into intermediate XML or error text
java -Xss16m -jar "$REPO/utilities/coffeepot/coffeepot.jar" -i "$3" -g "$modeliXML" -o "$intermediate" --mark-ambiguities --input-newline 2>&1
ret=$? 
if [ "$ret" -ne "0" ]; then
  mv "$intermediate" "$errorFile"
  exit $ret
fi

# echo Convert the intermediate XML into final XML or error text
java -cp "$REPO/utilities/saxonhe/saxonhe.jar" net.sf.saxon.Transform -s:"$intermediate" -xsl:"$modelXSLT" -o:"$4" 2>"$errorFile"
ret=$?

# echo The intermediate file no longer is needed
if [ -f "$intermediate" ]; then rm "$intermediate" ; fi

# if there was an error then any output is bogus and the error file should have details
if [ "$ret" -ne "0" ]; then 
  echo Error reported for: "$3"
  if [ -f "$4" ]; then rm "$4" ; fi
  exit $ret
fi

# if there was no error then any error file should be bogus
if [ -f "$errorFile" ]; then rm "$errorFile" ; fi

# end