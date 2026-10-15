---
name: fix
description: Fan out subagents to verify and apply the findings in data/findings.md, ask about the fixes the rules leave open, run the gates, and delete the file once every finding carries a disposition. Load whenever I ask to fix, apply, or work through a findings file.
---

# Applying a findings file

`data/findings.md` is the input, usually written by the `audit` skill. Every entry is still a hypothesis. An entry that convinced one auditor can die at the line, and applying it unchecked writes a defect the audit invented. The job is to apply what holds, decline what does not, and leave the tree in a state the gates pass.

## Settle the ambiguities before fanning out

Read the whole file first and collect every finding whose fix the rules leave open. Ask about all of them in one questionnaire, before a single agent launches. An answer arriving mid-flight never reaches the agents that already finished, and their work then rests on a reading the author replaced.

Where the audit shipped a questionnaire, its answers are the input. Carry each answer verbatim into the prompt of the agent whose findings it governs, rather than paraphrasing it.

Apply behavior changes the author has already authorized. Ask about unresolved intent or scope. Propose unrelated bug fixes separately.

## Order the findings, then parallelize each level

The audit already partitioned the files, one label per disjoint set. Before building the dependency graph, merge labels governed by the same answer under one owner. Also merge labels splitting one file by line range. Check the merged findings for conflicting edits and ask about any conflict the settled answers leave unresolved. Each resulting label is one node. A cross-surface label edits files every other label owns, so it takes a level to itself.

Edges run from each prerequisite fix to the findings that need it for editing, execution, or verification. The following cases require edges.

- A cross-file rename precedes every local edit in the files it renames. An edit written against the old name lands on text the rename already moved.
- A finding whose quote sits inside a passage another finding rewrites comes after that one.

A cycle means two findings each presume the other. Merge them into one node under one owner rather than choosing an order.

Then walk the graph in topological levels. A level is an antichain of labels, and since the labels partition the files, every label in it writes files no other label in it touches. Fan out the ready work in each level, one agent per label. Each finding starts when its prerequisites are satisfied.

Run the checks recorded for each level after it lands.

Run available checks within the authorized task. Mark findings with unavailable required runs, measurements, or data as deferred and retain their dependency edges. Record the check that would settle each one. Defer or re-plan dependent work that needs the missing result. Continue independent work.

## One writer per file, always

The partition gives this for free inside a level, and it is the invariant to check before launching one. Two agents editing one file lose each other's edits, and the loser is silent. Writing is where the audit's tolerance for overlapping reads stops.

Route by file rather than by auditor. Every finding against one file reaches that file's owner whichever agent raised it, so the edits compose instead of fighting.

A later level reads files an earlier level changed, so line numbers have moved. Every agent re-reads the quoted text at the cited line before editing. Use the earlier levels' diffs to locate the finding's current subject and verify it again. Decline the finding when the current evidence refutes it. Defer it when its subject cannot be located confidently.

## What each agent prompt carries

- The repo path, the path to the full `code` and `prose` skill text, and an instruction to read that file whole and `AGENTS.md` next. A hook preview truncates, and an agent holding half the rules writes fixes against half of them.
- Its findings verbatim, with their original identifiers, so the report zips back to the file.
- Which level it belongs to and what the levels before it changed, so it knows which files have already moved under its quotes.
- The settled answer to every ambiguity touching those findings.
- The confirmation process under [One writer per file, always](#one-writer-per-file-always), with the earlier levels' diffs.
- The scope rule, stated outright. Every changed line traces to a finding. No adjacent comment, no drive-by rename, no reformatting the finding did not ask for. This is the failure mode that makes an apply pass unreviewable and buries the real edits.
- The audit's clean-check record and the evidence behind it, to guide verification.
- The placeholder convention, where the document has one. Decline findings based solely on a placeholder's missing measurements. Verify contradictions between passages and resolve them under the author's intended claim while preserving the placeholder convention. Ask the author when the intended claim is unclear.
- The ban on widening a fix. Remove checks orphaned by the requested change. Propose removing or weakening a non-orphaned check or constraint unless the author has already authorized it.
- The assertion rule for any scripted substitution. Every rewrite script asserts its match count against the number expected. A silent zero-match is how a rename half-lands.
- The instruction to stop a finding and report it rather than choose, whenever the fix turns out ambiguous once the code is in view. A new question is cheaper than a wrong edit.
- The disposition scale: APPLIED, DECLINED, or DEFERRED, one per finding, carrying the diff for the first and the reason for the other two.
- An instruction to say what it could not do rather than approximate it.
- A one-paragraph reply summary. The dispositions belong in the file it writes.

## Verification

Before editing, read the repository's instructions for formatting, linting, tests, and other checks. Record the exact commands required after each level and after the full pass. Establish baseline results for the relevant checks before editing, or reproduce a disputed failure against unchanged state before attributing it to an edit. Run the recorded commands at their stated stages, and name any required command that could not run.

A formatter, a linter, and a type checker between them read past the inside of every string, so they prove nothing about a query, a template, or a manifest key. A change reaching one of those is verified by running the thing that reads it.

Verify and report refactors under the code skill's Verification section.

Where a document carries its own check target, run it and report what it flags.

A failing gate pauses work that depends on it. Fix failures caused by the edits, or identify and back out the finding responsible. Report existing failures separately and keep their repair within the authorized scope. After a rollback, reassess dependent readiness and continue independent work.

## A second questionnaire

Agents surface ambiguities the first pass could not see, since a fix reads differently with the surrounding code in view. Collect them level by level and ask once per round, so the next level launches with the answers already in hand. Reopen only the findings those answers govern.

## Reporting and cleanup

One line per finding: identifier, disposition, and the fact that decided it. Group the declined ones together with their reasons, since those are what the next audit raises again unless the reason lives somewhere durable.

Record the resolved ambiguities where the project keeps its rulings, before deleting anything. Each answer cost the author a decision, and an unrecorded decision returns as the same question.

Delete `data/findings.md` once every finding carries a disposition and the gates pass. Before deletion, preserve each deferred finding's identifier, unresolved subject, reason for deferral, and required check in a durable project record. Name that destination in the report.

Then stop. Committing, pushing, and launching are a separate request.
