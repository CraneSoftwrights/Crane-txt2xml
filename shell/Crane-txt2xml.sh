#!/bin/bash

# ---------------------------------------------------------------------------
# Crane-txt2xml.sh
#
# A shell script for invoking the Crane-txt2xml workflow on the inputs
#
# Usage:
#   Crane-txt2xml.sh  model-base-name  test-base-name
#
# Assumptions:
#
#   model-base-name.ixml - iXML grammar
#   model-base-name.xsl  - iXML output massage stylesheet
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
if [ "" == "$2" ]; then
  echo Usage: "$0" model-base-name test-base-name >&2
  echo See script header for full details >&2
  exit 1
fi

if [ -z "$TIMED" ]; then
  date
  TIMED=1 time bash "$0" "$@"
  exit
fi

modelbase="$1"
testbase="$2"
shift
shift

echo Processing: "$testbase.txt" into "$testbase/$testbase.xml" ...

if [ ! -f "$testbase.txt" ];   then echo Input text "$testbase.txt" not found ; exit 1 ; fi
if [ ! -f "$modelbase.ixml" ]; then echo Grammar file "$modelbase.ixml" not found ; exit 1 ; fi
if [ ! -f "$modelbase.xsl" ];  then echo Massage file "$modelbase.xsl" not found ; exit 1 ; fi

# Remove any old intermediate files
if [ -f "$testbase/$testbase.ixmlout.xml" ]; then rm "$testbase/$testbase.ixmlout.xml" ; fi
if [ -f "$testbase/$testbase.ixmlout.txt" ]; then rm "$testbase/$testbase.ixmlout.txt" ; fi

# Parse the input text into intermediate XML
java -Xss64m -jar "$REPO/utilities/coffeepot/coffeepot.jar" -i "$testbase.txt" -g "$modelbase.ixml" -o "$testbase/$testbase.ixmlout.xml" --input-newline --parse-count:2 "$@"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# Convert the intermediate XML into final XML
java -Xss64m -Xms200m -Xmx1000m -cp "$REPO/utilities/saxonhe/saxonhe.jar" net.sf.saxon.Transform -s:"$testbase/$testbase.ixmlout.xml" -xsl:"$modelbase.xsl" -o:"$testbase/$testbase.xml"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# Convert intermedate XML into raw text for reporting
"$REPO/shell/Crane-xml2txt.sh" "$testbase/$testbase.ixmlout.xml" "$testbase/$testbase.ixmlout.txt"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# Convert output XML into text for review
"$REPO/shell/Crane-xml2txt.sh" "$testbase/$testbase.xml" "$testbase/$testbase.xml.txt"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# Indent the iXML output for legibility
"$REPO/shell/indentXML.sh" "$testbase/$testbase.ixmlout.xml"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# end