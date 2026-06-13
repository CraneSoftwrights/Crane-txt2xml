# Crane-txt2xml

A configurable environment for creating XML documents from simple labelled text without angle brackets.

## Two Problems To Consider

(1) Many people are tasked with creating XML documents manually, such as ad-hoc invoices, articles, and metadata records. but find XML syntax cumbersome or intimidating. Angle brackets, closing tags, namespace declarations, and strict formatting rules create barriers for authors whose expertise is in the content, not the markup.

(2) When working with AI Large Language Models (LLMs) the egress and ingress of structured information in XML syntax can tend to be more costly in tokens than simple text because of the fully-spelled out element and attribute names, and element end tags. Being able simply to export or even fully round-trip an XML document through simple text with cryptic but unambiguous single-letter labels and no end indicators provides a mechanism for reducing costs.

## The Solution

Crane-txt2xml is used in environments equipping authors to create valid XML by typing simple structured text in the context of the schema that governs the conversion.

The structural rules of the XML vocabulary, as expressed in its governing schema, determine how elements nest. The author simply labels content; the environment handles the XML syntax. Elements are identified by labels ending with a colon. Attributes are prefixed with `@`. Values are either unquoted words or quoted strings. Decoration white-space is the author's choice for readability, as it has no effect on the result.

When an author writes the simple text:

```
a: b: @x: xyz c: hello d:
```

and the schema for the environment dictates that the element "c" is a child of element "b":

```
A ::= B, D.
B ::= C.
```

then the environment produces the XML syntax:

```xml
<a><b x="xyz"><c>hello</c></b><d/></a>
```

And for the same simple text, should the schema dictate that the element "c" is a sibling of element "b":

```
A ::= B, C, D.
```

then the environment produces the differently nested result of XML syntax:

```xml
<a><b x="xyz"/><c>hello</c><d/></a>
```


## How It Works

Crane-txt2xml is a configurable framework. An implementer adapts the base environment for a specific XML vocabulary (such as UBL invoices or PubMed articles), producing a turnkey implementation that authors or LLM users use directly. Included is both the conversion of authored or exported simple text files to XML documents, and the conversion of XML documents to simple text files for round-tripping through a Large Language Model or a non-XML user's fingers.

```
LLM or non-XML user   ──►  Simple text  ──►  Crane-txt2xml  ──►  ( XML document or Error text )
```

```
XML document  ──►  Crane-xml2txt  ──►  Simple text  ──►  LLM or non-XML user
```

The user unpacks a self-contained distribution of a configured environment. Either an author creates a file or the LLM is instructed for egress to generate a file with simple text labels that preface structured information. The text syntax labeling is easy to learn and easy to instruct an LLM to perform reliably and cheaply.

The resulting simple and compact labeled text follows the vocabulary's structural rules using the one common Crane-txt2xml syntax, and gets as output either valid XML or plain-language error messages. No software installation is required beyond unzipping the distribution.

Under the hood, Crane-txt2xml uses [Invisible XML (iXML)](https://invisiblexml.org/) to parse the authored text into XML, followed by an XSLT transformation to produce the final output. Authors do not need to know this.

An important caveat regarding using this strategy for LLM ingress is that while existing LLM tools are robust with built-in XML syntax processing, they would have to be taught the compressed simple syntax with every stateless interaction. This is costly in itself, but it would pay dividends if the LLM is able to deal with a very large dataset compressed using the abbreviated labels.

## Who This Is For

**Authors** create XML by typing text or by exporting text from an LLM. They need to know the text syntax (universal across all environments) and the structural rules of their specific vocabulary (provided by the implementer).
- **[Author's guide](AUTHORING.md)** — The text syntax: how to write element labels, attribute labels, and values. Applicable to all vocabulary environments.

**Implementers** create vocabulary environments. They adapt Crane-txt2xml for a specific XML vocabulary by providing schema information, label mappings, and a serialization stylesheet. They package the result for their authors and document the vocabulary's elements and attributes.
- **[Implementer's guide](IMPLEMENTING.md)** — How to create a vocabulary environment: the required inputs, the generation pipeline, error handling, packaging, and documentation responsibilities.

**Executives and evaluators** need to understand what Crane-txt2xml does and whether it fits their organization's needs, and whether or not there exists a configured environment that already can suit their requirements.
- **[Known environments](ENVIRONMENTS.md)** — Each vocabulary environment provides its own documentation covering the specific elements, attributes, and structures available to authors. These serve both as usable environments and as examples for implementers creating their own.

## A conference paper and presentation video

See the [XML Prague Conference 2026 landing page](https://www.xmlprague.cz/) for links to the PDF proceedings of the conference and watch [G. Ken Holman's 30-minute video recording (starting 59 minutes in)](https://www.youtube.com/watch?v=vqL7uzEkYIk&t=59m00s) titled "Crane-txt2xml - an attempt to socialize XML for non-XML'ers". 

## Final important note

This environment is not suited for every possible XML vocabulary. Please see the Implementer's guide below for the specific constraints. In general, regularly-structured schemas following the Garden of Eden or the Venetian Blind practice of global declarations, with little or no mixed content, should be able to be adapted. 

---

## Maintenance, feedback, and the future

For questions, suggestions, comments, and contributions we invite you to create issues and pull requests, both of which are accessible in tabs in the GitHub web page header. Eager qualified contributors are invited to introduce themselves for consideration in joining the team.

The numeric versioning of this project Latest release: [![Latest release](https://img.shields.io/github/v/release/CraneSoftwrights/Crane-txt2xml)](https://github.com/CraneSoftwrights/Crane-txt2xml/releases) follows the `<major/>`.`<minor/>`.`<patch/>` pattern defined by [Semantic Versioning](https://semver.org/). While generally aligned with SemVer principles, major version changes may also signal significant expansions in the project's scope.

- `<major/>` — increased when existing usage may break due to changes, or when substantial new functionality is introduced that significantly broadens the project’s scope (i.e. new project phases).
- `<minor/>` — increased when new features are added that extend functionality without disrupting existing use (i.e. backward-compatible additions).
- `<patch/>` — increased when errors are corrected or documentation is improved, without changes to features or behaviour (i.e. bug fixes and cosmetic adjustments).

This approach helps indicate whether an update is likely to affect existing workflows or simply enhance the project.

Please review the following documents to understand repository governance, expectations, and support channels:

- [ROADMAP.md](ROADMAP.md) – looking ahead  
- [CHANGELOG.md](CHANGELOG.md) – looking back  
- [CONTRIBUTING.md](CONTRIBUTING.md) – how to propose changes or fixes  
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) – expectations for respectful collaboration  
- [SECURITY.md](SECURITY.md) – how to report vulnerabilities responsibly  
- [SUPPORT.md](SUPPORT.md) – where and how to request help or ask questions

Further resources are available via the tabs above:

- See the [Wiki](https://github.com/CraneSoftwrights/Crane-txt2xml/wiki) for installation instructions, additional details, and frequently asked questions.  
- See the [Discussions](https://github.com/CraneSoftwrights/Crane-txt2xml/discussions) for ongoing conversations and infrequently asked questions.

At this time the project manager is [G. Ken Holman](mailto:gkholman@CraneSoftwrights.com), a [long-time XML community contributor](https://linkedin.com/in/gkholman) and the Principal Softwright at [Crane Softwrights Ltd.](https://CraneSoftwrights.com).