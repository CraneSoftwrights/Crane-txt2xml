#!/bin/bash

# ---------------------------------------------------------------------------
# Crane-xml2txt.sh
#
# A shell script converting XML into a text form suitable for Crane-txt2xml
#
# Usage:
#   Crane-xml2txt.sh  inputXMLname  outputTXTname
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
if ! REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"; then
  echo "Cannot determine REPO path" >&2
  exit 1
fi

if [ "" == "$2" ]; then
  echo Usage: "$0" inputXMLname outputTXTname >&2
  echo See script header for full details >&2
  exit 1
fi

echo Processing: "$1" into "$2" ...

if [ ! -f "$1" ]; then echo Input XML "$1" not found ; exit 1 ; fi

# Remove any old result file
if [ -f "$2" ]; then rm "$2" ; fi

java -Xss64m -Xms200m -Xmx1000m -cp "$REPO/utilities/saxonhe/saxonhe.jar" net.sf.saxon.Transform -s:"$1" -xsl:"$REPO/xsl/Crane-xml2txt.xsl" -o:"$2" labels=no escape=no
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# end