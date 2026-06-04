### Crane-txt2ubl

An environment for creating OASIS Universal Business Language (UBL) ISO/IEC 19845 XML documents from simple text inputs using the [Crane-txt2xml](https://GitHub.com/CraneSoftwrights/Crane-txt2xml?tab=readme-ov-file#readme) environment.

This configuration uses [version 2.5 of the UBL vocabulary](https://docs.oasis-open.org/ubl/UBL-2.5.html). This vocabulary is very large with over 5000 elements defined in many more contexts.

The `Crane-ubl2txt.xsl` stylesheet converts a UBL instance into a text document suitable for using the `Crne-txt2ubl` environment for conversion back to XML.

At this time only the complete schemas are supported and not the endorsed schema subset.

The Cleanup XSLT stylesheet is `Crane-ixml2ubl.xsl` for inferring the output namespaces from the input parsed output of the synthesized iXML grammar.

## An important note regarding performance

At this time the magnitude of the generated iXML schema is such that it provides only an exercise of capacities of iXML processors. The conversion of sample XML documents to text is very quick, but the conversion of text to XML documents is very slow. Slow enough to be unusable.


