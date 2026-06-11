#!/bin/bash

set +x

# ---------------------------------------------------------------------------
# Crane-txt2ubl.sh
#
# A shell script for invoking the Crane-txt2ubl workflow on the text input to
# create a UBL instance
#
# Usage:
#   Crane-txt2ubl.sh  test-base-name
#
# Assumptions:
#
#   test-base-name.txt                        - text input for XML output
#   test-base-name/test-base-name.ixmlout.xml - iXML output XML
#   test-base-name/test-base-name.ixmlout.txt - iXML XML as text
#   test-base-name/test-base-name.xml         - XML output for text input
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

$REPO/shell/Crane-txt2xml.sh $REPO/Crane-txt2ubl/ubl-2.5.ixml $REPO/Crane-txt2ubl/xsl/Crane-ixml2ubl.xsl "$1" "$1.xml"

# end