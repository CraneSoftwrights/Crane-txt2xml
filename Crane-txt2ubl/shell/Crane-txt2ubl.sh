#!/bin/bash

# ---------------------------------------------------------------------------
# Crane-txt2ubl.sh
#
# A shell script for invoking the Crane-txt2xml workflow on the text input to
# create a UBL instance
#
# Usage:
#   Crane-txt2ubl.sh  inputTEXT  outputXML
#
# Assumptions:
#
#   inputTEXT             - text input for XML output
#   outputXML         - XML output for text input
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
  echo Usage: "$0"  inputTEXT  outputXML >&2
  echo See script header for full details >&2
  exit 1
fi

#if [ -z "$TIMED" ]; then
#  date
#  TIMED=1 time bash "$0" "$@"
#  exit
#fi

$REPO/shell/Crane-txt2xml.sh $REPO/Crane-txt2ubl/ubl-2.5.ixml $REPO/Crane-txt2ubl/xsl/Crane-ixml2ubl.xsl "$1" "$2"

# end