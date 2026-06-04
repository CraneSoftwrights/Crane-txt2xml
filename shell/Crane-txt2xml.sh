#!/bin/bash

# ---------------------------------------------------------------------------
# Crane-txt2xml.sh
#
# A shell script for invoking the Crane-txt2xml workflow on the inputs
#
# Usage:
#   Crane-txt2xml.sh  model.ixml  model.xsl  test-base-name
#
# Assumptions:
#
#   model.ixml - iXML grammar
#   model.xsl  - iXML output massage stylesheet
#
#   test-base-name.txt                        - text input for XML output
#   test-base-name/test-base-name.ixmlout.xml - iXML output XML
#   test-base-name/test-base-name.ixmlout.txt - iXML XML as text
#   test-base-name/test-base-name.xml         - XML output for text input
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
if [ "" == "$3" ]; then
  echo Usage: "$0" model.ixml model.xsl test-base-name >&2
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
testdir=$(dirname "$3")
testbase=$(basename "$3")

echo Processing: "$testdir/$testbase.txt" into "$testdir/$testbase/$testbase.xml" ...

if [ ! -f "$testdir/$testbase.txt" ];   then echo Input text "$testdir/$testbase.txt" not found ; exit 1 ; fi
if [ ! -f "$modeliXML" ]; then echo Grammar file "$modeliXML" not found ; exit 1 ; fi
if [ ! -f "$modelXSLT" ];  then echo Massage file "$modelXSLT" not found ; exit 1 ; fi

# Remove any old intermediate files
if [ -f "$testdir/$testbase/$testbase.ixmlout.xml" ]; then rm "$testdir/$testbase/$testbase.ixmlout.xml" ; fi
if [ -f "$testdir/$testbase/$testbase.ixmlout.txt" ]; then rm "$testdir/$testbase/$testbase.ixmlout.txt" ; fi
# Prepare for intermediate files
if [ ! -d "$testdir/$testbase" ]; then mkdir "$testdir/$testbase" ; fi

echo Parse the input text into intermediate XML
java -Xss64m -jar "$REPO/utilities/coffeepot/coffeepot.jar" -i "$testdir/$testbase.txt" -g "$modeliXML" -o "$testdir/$testbase/$testbase.ixmlout.xml" --input-newline --parse-count:2
ret=$?
#if [ "$ret" -ne "0" ]; then exit $ret ; fi

echo Convert the intermediate XML into final XML
java -Xss64m -Xms200m -Xmx1000m -cp "$REPO/utilities/saxonhe/saxonhe.jar" net.sf.saxon.Transform -s:"$testdir/$testbase/$testbase.ixmlout.xml" -xsl:"$modelXSLT" -o:"$testdir/$testbase/$testbase.xml"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

echo Convert intermedate XML into raw text for reporting
"$REPO/shell/Crane-xml2txt.sh" "$testdir/$testbase/$testbase.ixmlout.xml" "$testdir/$testbase/$testbase.ixmlout.txt"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

echo Convert output XML into text for review
"$REPO/shell/Crane-xml2txt.sh" "$testdir/$testbase/$testbase.xml" "$testdir/$testbase/$testbase.xml.txt"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

echo Indent the iXML output for legibility
"$REPO/shell/indentXML.sh" "$testdir/$testbase/$testbase.ixmlout.xml"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# end