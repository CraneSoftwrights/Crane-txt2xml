# Crane-txt2ubl - conversion of simple text to a UBL document

This is an environment for creating OASIS Universal Business Language (UBL) ISO/IEC 19845 XML documents from simple text inputs using the [Crane-txt2xml](https://GitHub.com/CraneSoftwrights/Crane-txt2xml?tab=readme-ov-file#readme) environment.

This configuration uses [version 2.5 of the UBL vocabulary](https://docs.oasis-open.org/ubl/UBL-2.5.html). This vocabulary is very large with over 5000 elements defined in many more contexts.

The `Crane-ubl2txt.xsl` stylesheet converts a UBL instance into a text document suitable for using the `Crane-txt2ubl` environment for conversion back to XML.

At this time only the complete schemas are supported and not the endorsed schema subset.

The Cleanup XSLT stylesheet is `Crane-ixml2ubl.xsl` for inferring the output namespaces from the input parsed output of the synthesized iXML grammar.

The `Crane-txt2ubl.*` script converts a text input (the first argument) into either its successful XML result (the second argument) or a text error report explaining its unsuccessful result (the standard error port).

> [!IMPORTANT]
> At this time the magnitude of the generated iXML schema for UBL is such that it provides only an exercise of capacities of iXML processors. The conversion of sample XML documents to text is very quick, but the conversion of text to XML documents is very slow and consumes a big stack and a very large Java heap. Slow enough to be unusable and big enough not to run on many machines.

# Invocations

Converting UBL XML input to text output:
- Windows: `Crane-ubl2txt.bat  inputXML  outputTEXT`
- Shell: `Crane-ubl2txt.sh  inputXML  outputTEXT`

Converting text input to UBL XML output:
- Windows: `Crane-txt2ubl.bat  inputTEXT  outputXML 2>errorTEXT`
- Shell: `Crane-txt2ubl.sh  inputTEXT  outputXML 2>errorTEXT`

# Vocabulary notes

## Labels

The element and attribute labels can be entered in two different ways:

- the actual spelling of the element name: e.g. `DocumentCurrencyCode`
- splitting the camelCase letters with a space: e.g. `Document Currency Code`

## Mandatory end indicators

At this time only a single structural ambiguity has been detected that requires a mandatory end indicator:

- `AllowanceCharge:` due to the optional child `TaxTotal` and following sibling `TaxTotal`

## Example input snippet

From [UBL-invoice-2.1-Example-text.txt](UBL-invoice-2.1-Example-text.txt) is the following partial snippet:

```
  Invoice Line:
    ID: 1 
    Note: Scratch on box 
    Invoiced Quantity: @unit Code: C62  1 
    Line Extension Amount: @currency ID: EUR  1273 
    Accounting Cost: BookingCode001 
    Order Line Reference:
      Line ID: 1 
    Allowance Charge:
      Charge Indicator: false 
      Allowance Charge Reason: Damage 
      Amount: @currency ID: EUR  12 
    /Allowance Charge 
    Allowance Charge:
      Charge Indicator: true 
      Allowance Charge Reason: Testing 
      Amount: @currency ID: EUR  10 
    /Allowance Charge 
    Tax Total:
      Tax Amount: @currency ID: EUR  254.6 
```

## Example result transformation

See [UBL-invoice-2.1-Example-text.xml](UBL-invoice-2.1-Example-text.xml) for the transformation results.

# Manifest

[`README.md`](README.md)
- this file

[`shell/`](shell)
- the directory of shell invocation scripts

[`ubl-2.5.ixml`](ubl-2.5.ixml)
- the synthesized iXML grammar for UBL 2.5

[`UBL-AllDocuments-2.5.xsd`](UBL-AllDocuments-2.5.xsd)
- a wrapper XSD document model incorporating all 101 UBL document models

[`UBL-Invoice-2.1-Example.xml`](UBL-invoice-2.1-Example.xml)
- an example XML invoice from the UBL 2.1 distribution

[`UBL-Invoice-2.1-Example-text.txt`](UBL-invoice-2.1-Example-text.txt)
- a text stream rendering of the example invoice from the UBL 2.1 distribution

[`UBL-Invoice-2.1-Example-text.xml`](UBL-invoice-2.1-Example-text.xml)
- the UBL XML result of converting the example text stream

[`windows/`](windows)
- the directory of Windows batch invocation scripts

[`xsd/`](xsd)
- the XSD directory of document models from the UBL distribution

[`xsl/`](xsl)
- the directory of UBL-specific XSLT stylesheets
