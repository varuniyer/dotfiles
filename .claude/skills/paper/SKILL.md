---
name: paper
description: Fan out subagents to fact-check reviewer criticisms or claimed issues in the paper against the paper source, the code, and the database. Load whenever I paste review points, referee assertions, or a list of paper problems and ask to verify, validate, rank, or rebut them.
---

# Verifying paper findings

The input is a set of assertions about the paper, usually a hostile review. Each assertion is a hypothesis about what the paper says, what the code does, or what the data shows. The job is to establish which are true, with evidence, before answering or conceding any of them.

## Partition the assertions

Group them into clusters by the argument they attack, one agent per cluster. Six clusters is the usual shape for a full review. Keep the reviewer's own numbering inside each cluster (1a, 1b, ...) so the synthesis maps back to the review.

Use the `general-purpose` subagent type. These agents need `psql` and `.venv/bin/python`, not only file reads.

## What each agent prompt carries

- The repo path, an instruction to read `AGENTS.md` first for the layout, and the source locations. The paper source and its PDF take the repository directory's own name, `latex/<repo>.tex` with the appendix merged in and `<repo>.pdf` beside it. The package and the schema are where `AGENTS.md` says. Reach the database through plain `psql -c "..."` with no `-h` or `-d`.
- Do not edit any files. Never edit `latex/custom.bib`.
- Every sub-assertion spelled out as its own question, phrased as what to check rather than what the reviewer said. A reviewer's compression of the paper is not the paper.
- The verdict scale: CONFIRMED / PARTLY TRUE / FALSE / UNVERIFIABLE, per sub-assertion, with line numbers and verbatim quotes for paper claims and `file:line` for code claims.
- One truthful rebuttal sentence per sub-assertion, or the statement that no truthful rebuttal exists. A rebuttal sentence is material for answering the reviewer, never text destined for the paper.
- The instruction to be adversarial toward both the reviewer and the paper, and to report what is actually there.
- For data claims, query the database. Where the data does not exist, say so plainly and name the run that would produce it. Never estimate a number the DB does not hold.
- Mark the sharpest technical assertion in each cluster and tell the agent to nail that one exactly, quoting both code paths where the claim is a mismatch between two of them.
- Where `AGENTS.md` records a decision as settled, the question for the agent is whether the paper's written argument is as strong as the repo's internal reasoning, not whether the decision was right.
- An instruction to load the `prose` skill, which governs the agent's own writing.

## Synthesis

Sort findings by what they demand, not by the reviewer's order:

1. Assertions that are FALSE, with the quote that refutes them. These cost nothing to answer.
2. Assertions that are true and fixable in text. These are the edit list.
3. Assertions that are true and need a run, a measurement, or unwritten code. These are the real gaps, and the ones where the reviewer has force.

Before an assertion reaches the edit list, find where the paper already covers its subject. Three dispositions follow, and none of them adds a second site.

- The paper states it clearly and correctly. Close it under 1 with the quote. There is no edit.
- The paper states it in a shape the reviewer did not expect, asserted where it should be argued, imprecise, overstated against what the work measures, or sitting where the argument does not reach it. Revise the site that already carries it. This is the common case and it is still one statement afterwards.
- The paper states it nowhere. Now it is an edit candidate, gated by the test below.

A missing statement becomes an edit only when a competent reader of the venue would be misled without it. Disclosures of the obvious never qualify: that a standard protocol is standard, that incomparable numbers were not compared, that a scoped-out method is out of scope, that a stated design choice is a design choice. A reviewer demanding an acknowledgment is making an assertion like any other, and the right disposition for most such demands is "true, obvious, no edit". The paper argues its claims, it does not narrate its innocence.

A second statement of a claim the paper makes elsewhere is a redundancy defect rather than a fix, and it stays one when the reviewer asks for it directly. Reader-path arguments are how that redundancy gets justified, so treat "a reader reaching the table first would not know" as a reason to check the existing statement is right, never as a reason to state it twice.

Report where the paper contradicts the code, since that is the finding that outranks everything else in the list.

Then stop. Edits to the paper come as a separate request. When they come, load the `prose` skill first, run `make check` after, and report what it flags. Never propose a Limitations caveat. Raise the concern here instead.
