#!/bin/bash

# ---------------------------------------------------------------------------
# indentXML.sh
#
# A shell script for indenting the argument file using an intermediate result
#
# Usage:
#   indentXML.sh file.xml
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"
DP0=$( cd "$(dirname "$0")" ; pwd -P )

# Require input file
if [[ -z "$1" || ! -f "$1" ]]; then
  if [[ ! -f "$1" ]]; then
    echo File "$1" not found.
    echo
  fi
  echo "Usage: $0 file.xml"
  exit 1
fi

# Indent the given XML input file at argument

java -Xms200m -Xmx1000m -cp "$DP0/../utilities/saxonhe/saxonhe.jar" net.sf.saxon.Transform -s:"$1" -xsl:"$REPO/xsl/indentXML.xsl" -o:"$1.indented.xml"
ret=$?
if [ "$ret" -ne "0" ]; then exit $ret ; fi

mv "$1.indented.xml" "$1"
