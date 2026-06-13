# Crane-txt2ubl - conversion of simple text to a UBL document

This is an environment for creating OASIS Universal Business Language (UBL) ISO/IEC 19845 XML documents from simple text inputs using the [Crane-txt2xml](https://GitHub.com/CraneSoftwrights/Crane-txt2xml?tab=readme-ov-file#readme) environment.

This configuration uses [version 2.5 of the UBL vocabulary](https://docs.oasis-open.org/ubl/UBL-2.5.html). This vocabulary is very large with over 5000 elements defined in many more contexts.

The `Crane-ubl2txt.xsl` stylesheet converts a UBL instance into a text document suitable for using the `Crane-txt2ubl` environment for conversion back to XML.

At this time only the complete schemas are supported and not the endorsed schema subset.

The Cleanup XSLT stylesheet is `Crane-ixml2ubl.xsl` for inferring the output namespaces from the input parsed output of the synthesized iXML grammar.

Converting a text input `name.txt` into its result `name.txt.xml` leaves behind the temporary files `name.txt.xml.ixmlout.xml` (the iXML parser output) and `name.txt.xml.ixmlout.txt` (its text rendering).

> [!IMPORTANT]
> At this time the magnitude of the generated iXML schema for UBL is such that it provides only an exercise of capacities of iXML processors. The conversion of sample XML documents to text is very quick, but the conversion of text to XML documents is very slow and consumes a big stack and a very large Java heap. Slow enough to be unusable and big enough not to run on many machines.

# Manifest

[`README.md`](README.md)
- this file

[`shell/`](shell)
- the directory of shell invocation scripts

[`ubl-2.5.ixml`](ubl-2.5.ixml)
- the synthesized iXML grammar for UBL 2.5

[`UBL-AllDocuments-2.5.xsd`](UBL-AllDocuments-2.5.xsd)
- a wrapper XSD document model incorporating all 101 UBL document models

[`UBL-invoice-2.1-Example.xml`](UBL-invoice-2.1-Example.xml)
- an example XML invoice from the UBL 2.1 distribution

[`UBL-invoice-2.1-Example-text.txt`](UBL-invoice-2.1-Example-text.txt)
- a text stream rendering of the example invoice from the UBL 2.1 distribution

[`UBL-invoice-2.1-Example-text.txt.xml`](UBL-invoice-2.1-Example-text.txt.xml)
- the UBL XML result of converting the example text stream

[`windows/`](windows)
- the directory of Windows batch invocation scripts

[`xsd/`](xsd)
- the XSD directory of document models from the UBL distribution

[`xsl/`](xsl)
- the directory of UBL-specific XSLT stylesheets
