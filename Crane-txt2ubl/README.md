# Crane-txt2ubl - conversion of simple text to a UBL document

This is an environment for creating OASIS Universal Business Language (UBL) ISO/IEC 19845 XML documents from simple text inputs using the [Crane-txt2xml](https://GitHub.com/CraneSoftwrights/Crane-txt2xml?tab=readme-ov-file#readme) environment.

This configuration uses [version 2.5 of the UBL vocabulary](https://docs.oasis-open.org/ubl/UBL-2.5.html). This vocabulary is very large with over 5000 elements defined in many more contexts.

The `Crane-ubl2txt.xsl` stylesheet converts a UBL instance into a text document suitable for using the `Crane-txt2ubl` environment for conversion back to XML.

At this time only the complete schemas are supported and not the endorsed schema subset.

The Cleanup XSLT stylesheet is `Crane-ixml2ubl.xsl` for inferring the output namespaces from the input parsed output of the synthesized iXML grammar.

## An important note regarding performance

At this time the magnitude of the generated iXML schema is such that it provides only an exercise of capacities of iXML processors. The conversion of sample XML documents to text is very quick, but the conversion of text to XML documents is very slow. Slow enough to be unusable.

# Manifest

[`Crane-ixml2ubl.xsl`](Crane-ixml2ubl.xsl)
 - conversion of iXML output into UBL

[`Crane-ixml2ubl.xsl.html`](Crane-ixml2ubl.xsl.html)
 - documentation for `Crane-ixml2ubl.xsl`

[`Crane-ubl2ixml.xsl`](Crane-ubl2ixml.xsl)
 - conversion of UBL XSD into iXML grammar

[`Crane-ubl2ixml.xsl.html`](Crane-ubl2ixml.xsl.html)
 - documentation for `Crane-ubl2ixml.xsl`

[`Crane-ubl2txt.xsl`](Crane-ubl2txt.xsl)
 - conversion of UBL XML into Crane-txt2xml text stream with expanded labels

[`Crane-ubl2txt.xsl.html`](Crane-ubl2txt.xsl.html)
 - documentation for `Crane-ubl2txt.xsl`

[`make-ubl-ixml.sh`](make-ubl-ixml.sh)
 - invoke the creation of UBL XSD into the iXML grammar

[`README.md`](README.md)
 - this file

[`shell`](shell)
 - the directory of shell invocations

[`test-ubl.sh`](test-ubl.sh)
 - invoke the UBL test

[`UBL-AllDocuments-2.5.xsd`](UBL-AllDocuments-2.5.xsd)
 - a wrapper XSD document model incorporating all 101 UBL document models

[`UBL-invoice-2.1-Example-text`](UBL-invoice-2.1-Example-text)
 - the results of converting the example text stream into UBL XML

[`UBL-invoice-2.1-Example-text.txt`](UBL-invoice-2.1-Example-text.txt)
 - a demonstration UBL XML document from the UBL distribution

[`ubl.ixml`](ubl.ixml)
 - the synthesized iXML grammar for UBL

[`xsd`](xsd)
 - the XSD directory of document models from the UBL distribution
