#!/bin/bash

set -e

# ---------------------------------------------------------------------------
# one-recipe.sh
#
# A shell script converting a single recipe text file into XML
#
# Usage:
#   one-recipe.sh  inputTextFile  outputXMLfile
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

DP0=$( cd "$(dirname "$0")" ; pwd -P )

# Invocation and command line
if [ "" == "$2" ]; then
  echo Usage: "$0"  inputTextFile  outputXMLfile
  echo See script header for full details >&2
  exit 1
fi

echo Converting "$1" to "$2"...

sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$1" "$2"
