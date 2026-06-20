#!/bin/bash

set -e

# ---------------------------------------------------------------------------
# test-ubl.sh
#
# A shell script converting an example UBL invoice text file into UBL XML
#
# Usage:
#   test-ubl.sh
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
if ! REPO="$(cd "$(dirname "$0")" && cd ../.. && pwd)"; then
  echo "Cannot determine REPO path" >&2
  exit 1
fi

echo Converting sample UBL document to text...
$REPO/Crane-txt2ubl/shell/Crane-ubl2txt.sh $REPO/Crane-txt2ubl/UBL-Invoice-2.1-Example.xml $REPO/Crane-txt2ubl/UBL-Invoice-2.1-Example-text.txt

echo Converting generated text to UBL document...
$REPO/Crane-txt2ubl/shell/Crane-txt2ubl.sh $REPO/Crane-txt2ubl/UBL-Invoice-2.1-Example-text.txt $REPO/Crane-txt2ubl/UBL-Invoice-2.1-Example-text.xml
