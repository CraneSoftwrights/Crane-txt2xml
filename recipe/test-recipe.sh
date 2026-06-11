set -e

# ---------------------------------------------------------------------------
# Crane-txt2xml.sh
#
# A shell script for invoking the Crane-txt2xml workflow on the inputs
#
# Usage:
#   Crane-txt2xml.sh  model-base-name  test-base-name
#
# Assumptions:
#
#   model-base-name.ixml - iXML grammar
#   model-base-name.xsl  - iXML output massage stylesheet
#
#   test-base-name.txt                        - text input for XML output
#   test-base-name/test-base-name.ixmlout.xml - iXML output XML
#   test-base-name/test-base-name.ixmlout.txt - iXML XML as text
#   test-base-name/test-base-name.xml         - XML output for text input
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

DP0=$( cd "$(dirname "$0")" ; pwd -P )

sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipetokens1.txt" "$DP0/recipetokens1.xml" 
sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipe1.txt"       "$DP0/recipe1.xml"
sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipe2.txt"       "$DP0/recipe2.xml"
sh "$DP0/../shell/Crane-txt2xml.sh" "$DP0/recipe.ixml" "$DP0/../xsl/Crane-ixml2xml.xsl" "$DP0/recipe3error.txt"  "$DP0/recipe3error.xml"
