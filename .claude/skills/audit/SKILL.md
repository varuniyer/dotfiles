---
name: audit
description: Fan out subagents to sweep the repository for violations of my code and prose rules, collect them in data/findings.md, and hand back a questionnaire covering the ambiguous cases. Load whenever I ask for a rule-violation audit, a style sweep, or a findings pass over the repo or the paper.
---

# Auditing a repo against the rules

Nothing is handed over to verify. The agents generate the findings themselves, so the controls that matter are the ones keeping them from reporting violations no rule states. Applying the findings is a separate request.

## Load the rules first

Read the full text of the `code` and `prose` skills before writing a single agent prompt. A session hook may deliver them as a truncated preview that ends partway through the first one. Read the persisted file whole, pass its path to every agent, and tell each agent to read it whole too. An agent holding half the rules reports half the violations and invents the rest.

## Partition by surface

One agent per coherent file set. A set is coherent when its agent can read every file in it completely, so size the sets by what fits rather than by subsystem tidiness. Split a file too large to read whole into line ranges at its own section boundaries. Tell each agent which range it owns, and that it may grep the whole file to check whether a name is bound outside that range.

Cover every tracked surface. Application code, schema, build files, manifests, configuration, type stubs, documentation, and the paper all count, since the `code` skill names all of them and the `prose` skill governs every comment inside them.

Add one cross-cutting agent for the naming rule. One thing under two names hides between files, and neither name looks wrong at its own site, so a single-surface agent cannot see it. That agent inventories what each concept is called on every surface and reports the collisions with counts.

Use the `general-purpose` subagent type. State in every prompt that the agent is read-only and edits nothing.

## What each agent prompt carries

- The repo path, the path to the skills text, and an instruction to read `AGENTS.md` next for the project's own additions.
- Which skill governs which part of the surface. Both govern a code file, since docstrings and comments are prose.
- The files held byte-for-byte from an outside source, named and marked exempt. A vendored prompt, a third-party template, and a generated file each carry oddities that belong to the source and stay. Say what the agent may report there instead, which is usually a drift from the original or a mismatch with the code reading it.
- The placeholder convention, where the document has one. A draft plans its length and structure by typesetting filler tables and writing the claims that will read them once the numbers land. A result assertion standing over an unfilled table is deliberate, so tell the agent to check whether the table a claim reads is filled before reporting the claim. What survives the convention is a claim contradicting another passage, since two passages disagreeing is a defect whatever the numbers turn out to be.
- The settled-name record binds. A name `AGENTS.md` records as settled is no finding. A passage contradicting one is.
- The deliberate splits, listed outright. Where the project has ruled that one concept takes a different name in code than in prose, the cross-cutting agent reports every one of them unless told.
- The shape of a finding: a file and line, a verbatim quote, the rule cited by skill and section, the problem in two sentences, and the concrete replacement.
- The ban on style preference. A finding no rule states is noise, and noise is what makes a long report unreadable.
- The counting rule. Count with a script over the raw text rather than a bare regex, which undercounts whatever it was not written for. Before calling anything dead, check every reader directory the layout names, the paper and ad-hoc queries included.
- A QUESTIONS section, for cases where two readings of the rules give materially different fixes, or where the fix collides with a settled name.
- An instruction to name the checks that came back clean. A clean surface is a result, and it is the only thing separating a rule the agent checked from one it forgot.
- The output path, one file per agent in the session scratchpad, and a per-agent finding prefix so a merged finding traces back to its auditor.
- An instruction to reply with a one-paragraph summary alone. The file is the report.

## What each agent hunts

On a code surface: a definition referenced once, a rule stated in two places, a value derived twice from one source, a magic sentinel inside the valid range where null belongs, an exclusive threshold where the rule reads inclusive, a comment restating the line below or narrating rationale or recording the change that produced it, a per-field comment, a name coined for a branch's role in a comparison, a conditional wrapper reusing its primitive's word, speculative configurability, error handling for a state the program cannot reach, a versioned copy sitting beside a live file.

On a prose surface: nominalizations, noun stacks of three or more, buried subjects, a passage whose consecutive openings name unrelated things, em dashes, semicolons, transition words, negations that should be positive facts, contrastive phrasing against a superseded version, restated clauses and repeated paragraphs, degree adverbs and hedges, a category noun coined for a control-flow branch, an ablation called an "arm", a symbol rebound between sections, a symbol introduced for one reference, a claim in a summary position standing on neither a measured result nor a placeholder awaiting one, a bullet hard-wrapped at a column. Proposing a Limitations caveat is forbidden, so a concern about one goes to QUESTIONS for the author.

## Synthesis

Merge every report into `data/findings.md` under the agents' own prefixes, then run the three passes no agent could.

Dedupe. Two agents on adjacent surfaces report one cross-file duplication twice, once from each side. Keep the site that should change and cite both.

Rank globally rather than within a file set. A rule stated in two places outranks everything, since it fails silently and both copies keep running. A naming collision across surfaces comes next. A comment restating its line is last.

Carry the clean checks forward. Say which surfaces came back clean and which rules went unchecked, so the report says what it covered rather than only what it caught.

## The questionnaire

One entry per genuine ambiguity, and none for a case the rules already settle. Each entry gives the context, the options, and what each option costs at the sites it touches. Put the questions gating the most findings through `AskUserQuestion` and leave the rest in the file.

Never guess a settled name. Where an answer would coin one, that is a question and never a default.

Then stop. Applying the findings is a separate request. When it arrives, record the answers where the project keeps its rulings, since an ambiguity resolved once and written down nowhere comes back in the next audit.
