#!/bin/bash

# ---------------------------------------------------------------------------
# documentAll.sh
#
# A shell script without arguments to revise the HTML documentation of the
# stylesheets.
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

# Get the absolute path to the script's parent's directory (inside the repo)
if ! REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"; then
  echo "Cannot determine REPO path" >&2
  exit 1
fi

echo REPO=$REPO
ls -la $REPO/utilities/saxonhe/saxonhe.jar
echo \(note that SXWN9040 is innocuous and inevitable with recent design decisions by Saxonica\)
find "$REPO" \
  -name xslstyle -prune \
  -o \( -name '*.xsl' ! -name 'Crane-recipe2ixml.xsl' ! -name 'Crane-reportCoffeepotErrors.xsl' \
    -exec sh -c '
      file=$1
      repo=$2
      echo "Generating HTML for $file..."
      java -jar "$repo/utilities/saxonhe/saxonhe.jar" -a -warnings:silent -s:"$file" > "$file.html"
    ' sh {} "$REPO" \; \)
echo
echo These files have inconsistencies that need to be addressed:
find "$REPO" \
  -name xslstyle -prune \
  -o \( -name '*.xsl' \
    -exec grep -l Inconsistencies {} \; \)
echo End of list of files with inconsistencies
echo Remember that the SXWN9040 errors are innocuous ... would love to avoid them but I haven\'t the time to update the 22-year-old files
