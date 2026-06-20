# Crane-txt2xml Implementer's Guide

This guide is for XML practitioners creating a vocabulary environment, adapting Crane-txt2xml for a specific XML vocabulary so that authors or users of LLMs can create structured documents in that vocabulary by typing simplified text.

It assumes familiarity with XML, XSD, XSLT, and the basics of Invisible XML (iXML). If you are an author looking to write text or a user looking to instruct an LLM to emit text for an existing Crane-txt2xml environment, see the [Author's Guide](AUTHORING.md).

For illustrative and documentation purposes, the [`recipe`](recipe/) directory has resources cited below that can be followed for guidance on integration and configuration. 

## Architecture Overview

A Crane-txt2xml vocabulary environment is produced in two phases: a configuration phase (your work as implementer) and a runtime phase (the author's or LLM user's experience).


### Configuration Phase

You provide three inputs to the Crane-txt2xml generation pipeline:

1. **A "Venetian Blind" or "Garden of Eden" XSD schema** for the target XML vocabulary. If your vocabulary is defined in RELAX NG or DTD form, use [Trang](https://relaxng.org/jclark/trang.html) to produce a compatible XSD — provided the schema is expressible in XSD. Note that the repository includes a utility XSLT stylesheet `Crane-salami2eden.xsl` that may help in converting a "Salami Slice" XSD schema into a "Garden of Eden" XSD schema.

    See the [`recipe/`](recipe/) directory for four versions of the XSD for the simple recipe examples.

2. **An Alias XML document or algorithm** of your own with an iXML declaration of the output document element and, optionally, a mapping natural-language element and attribute labels to their XML names. Each XML element name may have multiple labels (aliases). Every environment implicitly supports the raw XML element names as labels; the aliases you define are additive. Whether this is a separate file or built-in to your code is not relevant. Conceptually, this is just the list of allowed aliases if you choose to allow such. Perhaps natural-language names for humans and short names for LLMs.

    See [`recipe/Crane-recipe2ixml.xsl`](recipe/Crane-recipe2ixml.xsl) for how the recipe example defines both element names (for humans) and single-letter names (for LLMs) as aliases for labeling. 
    See [`Crane-txt2ubl/xsl/Crane-ubl2ixml.xsl`](Crane-txt2ubl/xsl/Crane-ubl2ixml.xsl) for how the UBL example accommodates namespaces and camel-case labels.
    

3. **A Cleanup XSLT stylesheet** that transforms the intermediate XML produced by the iXML processor into the final output. This stylesheet handles error reporting and namespace assignment or any other serialization requirements of the target vocabulary.

    See [`xsl/Crane-ixml2xml.xsl`](xsl/Crane-ixml2xml.xsl) for the recipe example and any vocabulary that does not need special handling of the XML serialization. See [`Crane-txt2ubl/xsl/Crane-ixml2ubl.xsl`](Crane-txt2ubl/xsl/Crane-ixml2ubl.xsl) for the UBL example that does need such special handling. See [`xsl/Crane-reportCoffeepotErrors.xsl`](xsl/Crane-reportCoffeepotErrors.xsl) used by both for the interpretation of iXML error reports.

The first two inputs are used to synthesize an **iXML grammar** tailored to the vocabulary, encoding the content models from the XSD and the label alternatives from the Alias XML.
The **Cleanup XSLT stylesheet** that you provide is bundled with the generated grammar for use at runtime for error interpretation and result serialization.

![Crane-txt2xml data flow](images/data-flow.png)


### Runtime Phase

The conversion experience is a simple pipeline:

![Crane-txt2xml authoring data flow](images/authoring.png)

1. The **iXML processor** parses the flat labelled text against the generated iXML grammar, producing intermediate XML. If the text contains element structure or naming errors, the processor produces error output instead.

2. The **Cleanup XSLT** transforms the intermediate XML into the final output, resolving attribute aliases, assigning namespaces, and performing any vocabulary-specific serialization.

3. Optionally, the output XML is **validated** against the vocabulary's schema (XSD, DTD, or RELAX NG) to catch attribute usage errors and any structural issues not fully constrained by the iXML grammar.

The user interacts with this pipeline through a turnkey mechanism (command-line invocation, drag-and-drop, or whatever delivery method you choose). They see either the final XML output or plain-language error messages.

## Technologies and Software

Included in this distribution are the following open-source software components:

### Coffeepot

For the interpretation of iXML syntax and conversion of simple text into XML syntax:

[https://codeberg.org/NineML/nineml/releases](https://codeberg.org/NineML/nineml/releases)

### Saxon

For the execution of XSLT in the generation of iXML syntax and in the massage of XML syntax:

[https://www.saxonica.com/html/download/download_page.html](https://www.saxonica.com/html/download/download_page.html)

### xslstyle

For the generation of documentation of the XSLT stylesheets:

[https://github.com/CraneSoftwrights/xslstyle/](https://github.com/CraneSoftwrights/xslstyle/)

## Error Handling

Errors are detected at three stages, each catching different classes of problems:

### Stage 1: iXML Parsing

The iXML grammar encodes the vocabulary's element content models. When the labelled text violates element structure — misspelled element labels, wrong element order, missing required elements, elements in impermissible locations — the iXML processor reports errors. Successful output includes specifically-named patterns useful for subsequent massage into the final result. 

The Coffeepot iXML processor returns both successful and unsuccessful results in a single XML result using the standard error output port for subsequent interpretation to discern the actual result status.

### Stage 2: Cleanup XSLT

The raw Cleanup XSLT [`xsl/Crane-ixml2xml.xsl`](xsl/Crane-ixml2xml.xsl) fragment accommodates both the successful and unsuccessful output from parsing the iXML grammar. It is used standalone for creating the recipe XML output as that output has no requirements for namespaces or special handling.

The included [`xsl/Crane-reportCoffeepotErrors.xsl`](xsl/Crane-reportCoffeepotErrors.xsl) fragment accommodates the error reporting to the standard error port using Saxon's implementation of `<xsl:message>`. Feedback is welcome regarding unaddressed guidance reporting that can be improved upon. As more patterns of unexpected content are recognized, this fragment will be updated with more guidance for users. Please [file an issue](https://GitHub.com/CraneSoftwrights/Crane-txt2xml/issues) with any suggestions for new guidance, complete with test files illustrating the unguided failure. 

When the Saxon XSLT processor returns a non-zero failure execution error code, the text content of the standard error port is the significant output. When Saxon returns a zero successful execution error code, the XML content of the standard output port is the significant output.

The Cleanup XSLT example [`Crane-txt2ubl/xsl/Crane-ixml2ubl.xsl`](Crane-txt2ubl/xsl/Crane-ixml2ubl.xsl) illustrates how the iXML output can be accommodated for XML vocabularies with namespaces or special needs.

### Stage 3: Schema Validation

Post-generation schema validation catches element and attribute value usage errors based on the schema's type constraints. It also serves as a safety net for any element-level structural issues that the iXML grammar might not fully constrain.

## The XSD Schema

The [`xsl/Crane-xsd2ixml.xsl`](xsl/Crane-xsd2ixml.xsl) generation stylesheet requires a Garden of Eden or a Venetian Blind XSD. In these conventions, all the type definitions are global (named) types, and the element declarations reference these types are global (Garden of Eden) or local (Venetian Blind). This allows the stylesheet to traverse the content models systematically and generate iXML rules for each element.

If your vocabulary's authoritative schema is in RELAX NG or DTD form, the basic conversion to XSD can use Trang as a first step:

```
trang -I rnc -O xsd schema.rnc schema.xsd
trang -I dtd -O xsd  schema.dtd schema.xsd
```

Not all schema languages convert cleanly to the structure needed for conversion to iXML; manual adjustment may be necessary.

Note that the repository includes a utility XSLT stylesheet `Crane-salami2eden.xsl` that may help in converting a Salami Slice XSD schema into a Garden of Eden XSD schema.

## The Alias XML

The Alias XML document (or transformation) defines alternative labels for element and attribute names. Each alias maps one or more natural-language label forms to a single XML name.

Design considerations for aliases:

- **Raw XML names always are supported.** A label always can be the actual XML element name (e.g., `AccountingSupplierParty:`) regardless of what aliases exist. Aliases are additive.
- **Multi-word labels.** Aliases may contain whitespace. For example, the UBL implementation breaks camelCase element names into separate words: `Invoice Line:` as an alias for `InvoiceLine`. The iXML grammar accommodates optional whitespace within multi-word labels.
- **Multiple languages.** Different environments can define aliases in different natural languages for the same vocabulary. For example, the \<PubNote> project offers language-specific invocations (PubNoteInText2XML-de, PubNoteInText2XML-fr, PubNoteInText2XML-en) where element labels are available in German, French, and so on, alongside the English XML names.
- **Multiple aliases per name.** A single XML element name may have several aliases — abbreviations, full names, translations — all mapping to the same output element.

In the distribution is a demonstration implementation of both long and very short labels for the recipe example. Long for the non-XML user:


```
Recipe:Title:Pancakes Ingredient:Name:Flour Amount: @unit:cups 2 Ingredient:Name:"Maple Syrup"Amount:@unit:tablespoon @approximate:yes "3"Step:"Mix ingredients together"Step:"Cook on a greased griddle \1FAE7\"Step:Serve
```

And very short to mitigate the costly LLM egress (or even ingress):

```
R:T:Pancakes I:N:Flour A:@u:cups 2 I:N:Maple Syrup A:@u:tablespoon @a:yes 3 S:Mix ingredients together S:Cook on a greased griddle \1FAE7\ S:Serve 
```
## The Cleanup XSLT

The Cleanup XSLT stylesheet transforms the intermediate XML produced by the iXML processor into the final vocabulary-conformant XML output. Its responsibilities include:

- **Namespace assignment.** The intermediate XML is in no namespace and so any required resulting namespaces need to be inferred from context.
- **Error message transformation.** When the iXML processor output is in the iXML namespace (indicating parse errors), the Cleanup XSLT uses `<xsl:message>` to report the iXML errors to the error port and terminates the process

## The Generation Pipeline

The [`xsl/Crane-xsd2ixml.xsl`](xsl/Crane-xsd2ixml.xsl) XSLT stylesheet, provided in the base Crane-txt2xml distribution, reads the appropriately-configured XSD and the alias information to produce the iXML grammar. The generated grammar encodes:

- An iXML rule for each element in the vocabulary, with the element's content model expressed as the rule's definition.
- All label alternatives (the raw XML name plus any aliases) as alternatives in each rule's label matching.
- The boilerplate productions for attribute handling, value parsing (unquoted and quoted), white-space, and XML name characters.

See [`recipe/Crane-recipe2ixml.xsl`](recipe/Crane-recipe2ixml.xsl) for an illustration and documentation for the importation of the [`xsl/Crane-xsd2ixml.xsl`](xsl/Crane-xsd2ixml.xsl) stylesheet.

## Packaging a Distribution

The user's experience should be turnkey. Package your vocabulary environment as a ZIP file containing:

- The generated iXML grammar
- The Cleanup XSLT stylesheet
- The iXML processor and XSLT processor (or scripts that invoke them)
- A drag-and-drop mechanism or command-line entry point
- Sample text input files with their expected XML outputs
- Your vocabulary documentation (element/attribute reference, structural guidance)
- A link or reference to the [Author's Guide](AUTHORING.md) for the universal text syntax rules

## Documenting Your Vocabulary

You are responsible for documenting the vocabulary-specific information that the [Author's Guide](AUTHORING.md) deliberately omits:

- Which elements exist and what they mean
- How elements nest (parent-child relationships)
- Element order within each parent
- Which elements are required, optional, or repeatable
- Which elements accept attributes, and which attributes are available
- Any aliases you have defined for element and attribute labels

The universal text syntax rules — how labels, attributes, values, quoting, escaping, and whitespace work — are covered in the guide. Point your users there rather than duplicating that content in your vocabulary documentation.

If your users are creating prompts for instructing LLMs on the emission of XML in Crane-txt2xml syntax, you should review the ["Sample Prompt" section of the Authoring Guide](AUTHORING.md) for a guideline regarding the detailed prompt to compose.

# Future work

See [the roadmap](ROADMAP.md) for details.