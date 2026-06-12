#!/bin/bash

# ---------------------------------------------------------------------------
# Crane-ubl2txt.sh
#
# A shell script for invoking the Crane-ubl2txt stylesheet on a UBL XML
# document to create a simple text file suitable for editing.
#
# Usage:
#   Crane-ubl2txt.sh  input-XML  output-text
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
if ! REPO="$(cd "$(dirname "$0")" && cd ../.. && pwd)"; then
  echo "Cannot determine REPO path" >&2
  exit 1
fi

# Invocation and command line
if [ "" == "$2" ]; then
  echo Usage: "$0" input-XML output-text >&2
  echo See script header for full details >&2
  exit 1
fi

if [ ! -f "$1" ]; then echo Input XML "$1" not found ; exit 1 ; fi

# Remove any old result file
if [ -f "$2" ]; then rm "$2" ; fi

java -Xss64m -Xms200m -Xmx1000m -cp "$REPO/utilities/saxonhe/saxonhe.jar" net.sf.saxon.Transform -s:"$1" -xsl:"$REPO/Crane-txt2ubl/xsl/Crane-ubl2txt.xsl" -o:"$2"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

# end
