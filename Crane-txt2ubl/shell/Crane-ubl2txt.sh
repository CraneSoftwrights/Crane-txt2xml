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
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml/Crane-txt2ubl
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
if ! REPO="$(cd "$(dirname "$0")" && cd ../.. && pwd)"; then
  echo "Cannot determine REPO path" >&2
  exit 1
fi

# Invocation and command line
if [ "" == "$1" ]; then
  echo Usage: "$0" test-base-name >&2
  echo See script header for full details >&2
  exit 1
fi

#if [ -z "$TIMED" ]; then
#  date
#  TIMED=1 time bash "$0" "$@"
#  exit
#fi

$REPO/shell/Crane-txt2xml.sh $REPO/Crane-txt2ubl/ubl-2.5.ixml $REPO/Crane-txt2ubl/Crane-ixml2ubl.xsl $1


# end