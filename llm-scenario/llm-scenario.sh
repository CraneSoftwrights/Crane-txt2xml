#!/bin/bash

set -e

# ---------------------------------------------------------------------------
# llm-scenario.sh
#
# A shell script converting the example recipe text files into recipe XML
#
# Usage:
#   llm-scenario.sh
#
# Project: https://GitHub.com/CraneSoftwrights/Crane-txt2xml
#
# ---------------------------------------------------------------------------

DP0=$( cd "$(dirname "$0")" ; pwd -P )

sh "$DP0/../recipe/one-recipe.sh" "r01-pancakes.short.txt" "r01-pancakes.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r02-scrambled-eggs.short.txt" "r02-scrambled-eggs.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r03-grilled-cheese.short.txt" "r03-grilled-cheese.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r04-tomato-soup.short.txt" "r04-tomato-soup.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r05-caesar-salad.short.txt" "r05-caesar-salad.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r06-aglio-e-olio.short.txt" "r06-aglio-e-olio.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r07-hard-boiled-egg.short.txt" "r07-hard-boiled-egg.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r08-banana-smoothie.short.txt" "r08-banana-smoothie.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r09-toast-with-butter.short.txt" "r09-toast-with-butter.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r10-chicken-stir-fry.short.txt" "r10-chicken-stir-fry.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r11-lemonade.short.txt" "r11-lemonade.short.txt.xml"
sh "$DP0/../recipe/one-recipe.sh" "r12-rice-pilaf.short.txt" "r12-rice-pilaf.short.txt.xml"

