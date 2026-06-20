# Scenario: LLM egress of structured content as compressed text

This directory is a post-mortem of a completed experiment. It tells the
story of a user who needs a high volume of structured results from an
LLM, and who is concerned about the token cost of getting that
structure out as XML. The scenario shows how the Crane-txt2xml
environment lets that user ask the LLM for a *compressed* text
notation instead — at a fraction of the token cost of XML — and then
expand that notation back into schema-valid XML locally, using
open-source tools, at no LLM cost at all.

For the recipe vocabulary itself (the document model, the four XSD
authoring styles, the iXML grammar, and the short-label and
long-label text conventions), see the parent directory's
[`../README.md`](../README.md). This file does not repeat that
description; it only narrates what was *done* with that vocabulary as
a scenario.

## The story, in order

1. **An LLM (Claude) synthesized twelve toy recipes, each as a
   schema-valid XML instance**, against the document model in
   `../recipe-garden-of-eden.xsd` — not as ad hoc structure invented on
   the spot, but as XML conforming to a schema the LLM had been given
   to read. Nine were ordinary recipes; three deliberately exercised
   edge cases in escaping and character content (an embedded quotation
   mark, a literal backslash, and multi-codepoint emoji).

2. **Each XML instance was validated against the schema before
   anything else happened to it.** This is the point in the story
   where structure and content are pulled apart: once an instance
   validates, any error remaining in the result can only be a content
   error — a wrong amount, a mis-stated unit, an implausible step —
   never a structural one (a missing element, a misplaced attribute,
   an unclosed tag). Validation was run not only against the Garden of
   Eden schema but against all four XSD authoring-style variants
   supplied in the parent directory, confirming they are equivalent
   expressions of one model and that the synthesized instances satisfy
   all four.

3. **The only files the user supplied were the schemas and the
   stylesheets** — `recipe-garden-of-eden.xsd` (and its three sibling
   style variants) and `Crane-recipe2short.xsl` together with its
   imports `Crane-xml2txt.xsl` and `Crane-recipe-common.xsl`. No
   utility-directory files, no XSLT processor, no Java runtime, no
   schema validator, and no driver script were uploaded. Every piece
   of software needed to run the schemas and stylesheets — the Java
   runtime, the XSLT 3.0 processor, the schema-validation library —
   was located, retrieved, and installed by the LLM itself, inside its
   own execution environment, in response to the task. The user's
   contribution to this half of the story was the *specification*
   (schema and stylesheet); the *means of executing* that specification
   was the LLM's to find.

4. **The XML was compressed to text by running the user's own
   `Crane-recipe2short.xsl` stylesheet, unmodified, under a real Saxon
   XSLT processor** — not by asking the LLM to imitate, summarize, or
   freehand what that stylesheet would probably output. The
   distinction matters to the story: the compaction step is
   mechanical and deterministic, and its correctness rests on the
   stylesheet's own logic, not on the LLM's recollection or guess of
   what that logic does. The short-label, no-indent, no-label-gap
   default parameters were used throughout, producing text like:

   ```
   R:T:Pancakes I:N:Flour A:@u:cups 2 I:N:Milk A:@u:cups 1.5 I:N:Egg A:@u:whole 2 S:Whisk the dry ingredients together S:Add milk and eggs and mix until smooth S:Cook on a greased griddle until golden S:Serve warm with syrup
   ```

5. **The only files returned to the user were the twelve compressed
   text renditions.** The twelve XML instances synthesized in step 1
   and validated in step 2 were the LLM's own intermediate working
   artifact — necessary internally so that schema validation and the
   stylesheet-driven compaction (step 4) had something to operate on,
   but never sent back. Nothing else crossed back to the user: no
   intermediate XML, no copies of the stylesheets the user already
   had, no installed software. The user received exactly the one
   artifact the scenario is about — the compressed notation — and
   nothing more.

6. **The user expanded the compressed text back into XML on their own
   side**, using their own open-source toolchain — Coffeepot as the
   iXML processor, the `recipe.ixml` grammar (itself generated from
   the schema by `Crane-recipe2ixml.xsl`), and `Crane-ixml2xml.xsl` to
   complete the conversion — orchestrated by
   [`llm-scenario.sh`](llm-scenario.sh) (or its Windows equivalent,
   [`llm-scenario.bat`](llm-scenario.bat), composed alongside this
   README), which calls [`../one-recipe.sh`](../one-recipe.sh) once
   per compressed file. This half of the story involves no LLM at all:
   it is the user's own software, on the user's own machine, doing the
   expansion.

## Where the cost lies, and where it doesn't

This is the crux the scenario is meant to illustrate for a user
weighing whether high-volume structured output from an LLM is
affordable:

- **There is no LLM-side execution cost to the user.** Locating,
  installing, and running the Java runtime, the Saxon XSLT processor,
  and the schema validator all happened inside the LLM's own
  environment, as part of the conversation. None of that consumes the
  user's tokens; tokens are consumed only by the conversation itself.

- **The user's token cost is specifically the upload of the
  stylesheets and schemas, and the download of the compressed text
  results** — not the XML. The stylesheets and schemas were read once,
  at the start of the conversation, as input tokens. The compressed
  text returned at roughly 43% of the corresponding XML's byte size
  in this sample (see the table below), and at a proportionally
  larger savings in LLM *tokens*, since XML's punctuation-heavy
  angle-bracket syntax tends to fragment into more tokens per byte
  than plain compressed text does. No XML needed to be generated as
  output tokens at any point to get a structurally correct,
  schema-conformant result, and none was.

- **There is no LLM-side cost, and no token cost at all, for the
  user's own expansion of the compressed text back into XML.** That
  step runs entirely on the user's machine, using open-source software
  the user already controls (Coffeepot, Saxon, the shell or batch
  scripts), against a grammar (`recipe.ixml`) generated once from the
  schema. Running it twelve times, or twelve thousand times, costs the
  same: nothing, beyond ordinary local compute.

## A caution belonging to this story

The reliability shown here — schema-valid XML synthesized correctly,
compressed correctly via the user's own stylesheet, and (on the user's
side) expanded back without loss — rests on the LLM actually being
able to retrieve and run a real XSLT processor and a real schema
validator against the user's own code, rather than asking the LLM to
narrate or approximate what that code does. Not every LLM, and not
every environment an LLM runs in, has that retrieval-and-execution
capability available, or applies it as a matter of course rather than
answering directly from training. A user relying on this approach
should confirm that whatever LLM and environment they are using
actually executed the supplied schema and stylesheet — and didn't
simply produce text that resembles what it might output.

## Compression observed (XML bytes vs. short-text bytes)

The "XML bytes" column below reflects the internal working artifact,
never returned to the user. It is shown only to quantify the
compression the user received by getting back compressed text
instead.

| file | XML bytes | short-text bytes | ratio |
|---|---|---|---|
| r01-pancakes | 546 | 222 | 40.7% |
| r02-scrambled-eggs | 253 | 102 | 40.3% |
| r03-grilled-cheese | 549 | 238 | 43.4% |
| r04-tomato-soup | 664 | 275 | 41.4% |
| r05-caesar-salad | 579 | 261 | 45.1% |
| r06-aglio-e-olio | 725 | 325 | 44.8% |
| r07-hard-boiled-egg | 407 | 217 | 53.3% |
| r08-banana-smoothie | 517 | 208 | 40.2% |
| r09-toast-with-butter | 350 | 121 | 34.6% |
| r10-chicken-stir-fry | 992 | 432 | 43.5% |
| r11-lemonade | 623 | 298 | 47.8% |
| r12-rice-pilaf | 694 | 303 | 43.7% |
| **TOTAL** | **6899** | **3002** | **43.5%** |

This is byte compression, measured directly from the files in this
directory. It understates the token savings that motivate the
scenario, since XML's angle brackets and closing tags tend to
tokenize less efficiently than the compressed notation's plain
delimiters — a separate, larger effect this table doesn't measure.

## The prompt that produced the twelve recipes

The synthesis step (point 1 above) was requested of the LLM, in the
conversation that produced this scenario, as follows:

> Attached is a ZIP of two directories, one describing properties of
> an XML vocabulary for recipes. The other is a support stylesheet
> directory.
>
> Please conceive of a dozen simple toy recipes as XML structures
> conforming to the XSD, create valid XML for them, and then serialize
> from them the simple text renditions using the
> Crane-recipe2short.xsl stylesheet.
>
> This is to test the premise that I can export from an LLM a
> compressed version of a corpus of XML that I then can realize back
> as angle brackets using my new environment.

A follow-up exchange narrowed two open choices before synthesis began:
a mix of mostly straightforward recipes with two or three deliberate
edge cases (rather than either uniformly simple or uniformly
adversarial), and the short-label compressed form only (rather than
showing both long-label and short-label renditions side by side).

## The script that expanded the results back to XML

[`llm-scenario.sh`](llm-scenario.sh) is the script that ran the
expansion, once per compressed file, on the user's side:

```sh
#!/bin/bash

set -e

DP0=$( cd "$(dirname "$0")" ; pwd -P )

sh "$DP0/../one-recipe.sh" "r01-pancakes.short.txt" "r01-pancakes.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r02-scrambled-eggs.short.txt" "r02-scrambled-eggs.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r03-grilled-cheese.short.txt" "r03-grilled-cheese.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r04-tomato-soup.short.txt" "r04-tomato-soup.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r05-caesar-salad.short.txt" "r05-caesar-salad.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r06-aglio-e-olio.short.txt" "r06-aglio-e-olio.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r07-hard-boiled-egg.short.txt" "r07-hard-boiled-egg.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r08-banana-smoothie.short.txt" "r08-banana-smoothie.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r09-toast-with-butter.short.txt" "r09-toast-with-butter.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r10-chicken-stir-fry.short.txt" "r10-chicken-stir-fry.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r11-lemonade.short.txt" "r11-lemonade.short.txt.xml"
sh "$DP0/../one-recipe.sh" "r12-rice-pilaf.short.txt" "r12-rice-pilaf.short.txt.xml"
```

It in turn calls [`../one-recipe.sh`](../one-recipe.sh), which invokes
`../shell/Crane-txt2xml.sh` with `recipe.ixml` and
`../xsl/Crane-ixml2xml.xsl` against each compressed input file.

A Windows batch equivalent, [`llm-scenario.bat`](llm-scenario.bat),
calls [`../one-recipe.bat`](../one-recipe.bat) once per compressed
file, mirroring `llm-scenario.sh`'s call to `../one-recipe.sh`, with
explicit `errorlevel` checking after each call.

## Manifest

[`README.md`](README.md)
- this file

[`llm-scenario.sh`](llm-scenario.sh)
- shell script expanding all twelve compressed text files into XML

[`llm-scenario.bat`](llm-scenario.bat)
- Windows batch equivalent of `llm-scenario.sh`, calling
  `../one-recipe.bat` once per file; correct operation depends on
  `setlocal` being present in `one-recipe.bat` and `Crane-txt2xml.bat`
  (see the note above)

[`r01-pancakes.xml`](r01-pancakes.xml) … [`r12-rice-pilaf.xml`](r12-rice-pilaf.xml)
- the twelve LLM-synthesized recipe instances, each schema-valid
  against all four XSD authoring styles in the parent directory.
  These were the LLM's own working artifacts, used internally for
  validation and compaction; they were not returned to the user as 
  part of the experiment, only after the fact for the purpose of comparison testing.
  They are included here only so a reader can verify the round trip by
  comparing against the `.short.txt.xml` files below

[`r01-pancakes.short.txt`](r01-pancakes.short.txt) … [`r12-rice-pilaf.short.txt`](r12-rice-pilaf.short.txt)
- the corresponding compressed text, produced by running the user's
  own `Crane-recipe2short.xsl` against each `.xml` file

[`r01-pancakes.short.txt.xml`](r01-pancakes.short.txt.xml) … [`r12-rice-pilaf.short.txt.xml`](r12-rice-pilaf.short.txt.xml)
- the XML recovered by expanding each `.short.txt` file through
  `llm-scenario.sh`, closing the round trip
