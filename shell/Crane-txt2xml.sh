#!/bin/bash

set +x

# ---------------------------------------------------------------------------
# Crane-txt2xml.sh
#
# A shell script for invoking the Crane-txt2xml workflow on the inputs
#
# Usage:
#   Crane-txt2xml.sh  model.ixml  model.xsl  input.txt  output.xml
#
# Assumptions:
#
#   model.ixml - iXML grammar
#   model.xsl  - iXML output massage stylesheet
#
#   input.txt                - text input for XML output
#   input/output.ixmlout.xml - iXML output XML
#   input/output.ixmlout.txt - iXML XML as text
#   input/output.xml         - if error: text file of messages
#                            - if no error: XML output for text input
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
inputdir=$(dirname "$3")
inputbase=$(basename "$3")
outputdir=$(dirname "$4")
outputbase=$(basename "$4")

# echo Processing: "$3" into "$4" ...

if [ ! -f "$3" ];   then echo Input text "$3" not found ; exit 1 ; fi
if [ ! -f "$modeliXML" ]; then echo Grammar file "$modeliXML" not found ; exit 1 ; fi
if [ ! -f "$modelXSLT" ];  then echo Massage file "$modelXSLT" not found ; exit 1 ; fi

# Remove any old intermediate and final files
if [ -f "$outputdir/$outputbase.ixmlout.xml" ]; then rm "$outputdir/$outputbase.ixmlout.xml" ; fi
if [ -f "$outputdir/$outputbase.ixmlout.txt" ]; then rm "$outputdir/$outputbase.ixmlout.txt" ; fi
if [ -f "$outputdir/$outputbase.err.txt" ];     then rm "$outputdir/$outputbase.err.txt" ; fi
if [ -f "$4" ]; then rm "$4" ; fi

# echo Parse the input text into intermediate XML or error text
java -Xss64m -jar "$REPO/utilities/coffeepot/coffeepot.jar" -i "$3" -g "$modeliXML" -o "$outputdir/$outputbase.ixmlout.xml" --mark-ambiguities --input-newline 2>&1
ret=$? 
if [ "$ret" -ne "0" ]; then
  mv "$outputdir/$outputbase.ixmlout.xml" "$outputdir/$outputbase.err.txt"
  exit $ret
fi

# echo Convert the intermediate XML into final XML or error text
java -Xss64m -Xms200m -Xmx1000m -cp "$REPO/utilities/saxonhe/saxonhe.jar" net.sf.saxon.Transform -s:"$outputdir/$outputbase.ixmlout.xml" -xsl:"$modelXSLT" -o:"$4" 2>"$outputdir/$outputbase.err.txt"
ret=$?

# echo The intermediate file no longer is needed
if [ -f "$outputdir/$outputbase.ixmlout.xml" ]; then rm "$outputdir/$outputbase.ixmlout.xml" ; fi

# if there was an error then any output is bogus and the error file should have details
if [ "$ret" -ne "0" ]; then 
  echo Error reported for: "$3"
  if [ -f "$4" ]; then rm "$4" ; fi
  exit $ret
fi

# if there was no error then any error file should be bogus
if [ -f "$outputdir/$outputbase.err.txt" ]; then rm "$outputdir/$outputbase.err.txt" ; fi

# end