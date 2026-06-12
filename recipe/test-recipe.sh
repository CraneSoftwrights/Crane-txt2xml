#!/bin/bash

set -e

# ---------------------------------------------------------------------------
# test-recipe.sh
#
# A shell script converting the example recipe text files into recipe XML
#
# Usage:
#   test-recipe.sh
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

DP0=$( cd "$(dirname "$0")" ; pwd -P )

sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipeTokens1.txt" "$DP0/recipeTokens1.xml"

sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipe1.txt"       "$DP0/recipe1.xml"

sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipe2.txt"       "$DP0/recipe2.xml"

sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipe3error.txt"  "$DP0/recipe3error.xml"
