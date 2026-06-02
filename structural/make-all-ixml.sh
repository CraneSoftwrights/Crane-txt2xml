set -e

xslt2 ../pubmed/xsd/PubMedIn.xsd PubNote-pubmedin-xml2ixml.xsl ../demo/PubMedIn.ixml
xslt2 ../pubmed/xsd/PubMedIn.xsd PubNote-pubmedin-en2ixml.xsl  ../demo/PubMedIn-en.ixml
xslt2 ../pubmed/xsd/PubMedIn.xsd PubNote-pubmedin-de2ixml.xsl  ../demo/PubMedIn-de.ixml
xslt2 ../pubmed/xsd/PubMedIn.xsd PubNote-pubmedin-fr2ixml.xsl  ../demo/PubMedIn-fr.ixml

xslt2 ../recipe/recipe-garden-of-eden.xsd ../xsl/Crane-recipe2ixml.xsl ../demo/recipe.ixml

xslt2 structural.xsd ../xsl/Crane-xsd2ixml.xsl ../demo/structural.ixml

xslt2 ../ubl/UBL-AllDocuments-2.5.xsd Crane-ubl2ixml.xsl ../demo/ubl.ixml

