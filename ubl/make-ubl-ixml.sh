#!/bin/bash

set -e

# ---------------------------------------------------------------------------
# make-ubl-ixml.sh
#
# A shell script converting UBL XSD into iXML
#
# Usage:
#   make-ubl-ixml.sh
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
if ! REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"; then
  echo "Cannot determine REPO path" >&2
  exit 1
fi

java -jar "$REPO/utilities/saxonhe/saxonhe.jar" -s:"$REPO/ubl/UBL-AllDocuments-2.5.xsd" -xsl:"$REPO/ubl/Crane-ubl2ixml.xsl" -o:"$REPO/ubl/ubl.ixml"
