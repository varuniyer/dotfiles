---
name: fix
description: Fan out subagents to verify and apply the findings in data/findings.md, ask about the fixes the rules leave open, run the gates, and delete the file once every finding carries a disposition. Load whenever I ask to fix, apply, or work through a findings file.
---

# Applying a findings file

`data/findings.md` is the input, usually written by the `audit` skill. Every entry is still a hypothesis. An entry that convinced one auditor can die at the line, and applying it unchecked writes a defect the audit invented. The job is to apply what holds, decline what does not, and leave the tree in a state the gates pass.

## Settle the ambiguities before fanning out

Read the whole file first and collect every finding whose fix the rules leave open. Ask about all of them in one pass through `AskUserQuestion`, before a single agent launches. An answer arriving mid-flight never reaches the agents that already finished, and their work then rests on a reading the author replaced.

Where the audit shipped a questionnaire, its answers are the input. Carry each answer verbatim into the prompt of the agent whose findings it governs, rather than paraphrasing it.

A finding whose fix would change behavior is a question and never a default. A style pass that quietly corrects a latent bug is two changes wearing one commit, and the measurement that would have caught a mistake in the second one never ran.

## Order the findings, then parallelize each level

The audit already partitioned the files, one label per disjoint set, so the labels are the nodes and no repartitioning is needed. Two shapes need care. A cross-surface label edits files every other label owns, so it takes a level to itself. Labels splitting one file by line range are one writer between them, so they collapse into a single node.

Edges run from the fix that must land first to the fix that must land after, and they come from three places.

- A cross-file rename precedes every local edit in the files it renames. An edit written against the old name lands on text the rename already moved.
- A finding whose quote sits inside a passage another finding rewrites comes after that one.
- Two findings the same answer governs share an edge, so one reading reaches both rather than two agents interpreting it apart.

A cycle means two findings each presume the other. Merge them into one node under one owner rather than choosing an order.

Then walk the graph in topological levels. A level is an antichain of labels, and since the labels partition the files, every label in it writes files no other label in it touches. The whole level fans out at once, one agent per label, and the pass costs as many rounds as the graph is deep rather than as many as it has labels.

Levels make attribution cheap. Run the fast gates after each level rather than once at the end, and a break belongs to the level that just landed.

Run available checks within the authorized task. Findings whose required run, measurement, or data remains unavailable sit outside the graph. They go on a deferred list, each with the check that would settle it, and none is ever guessed closed.

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
- The audit's clean-check record, so nothing already cleared gets re-litigated.
- The placeholder convention, where the document has one. Decline findings based solely on a placeholder's missing measurements. Verify contradictions between passages and resolve them under the author's intended claim while preserving the placeholder convention. Ask the author when the intended claim is unclear.
- The ban on widening a fix. Deleting a constraint, dropping a check, or scaling a rule back is a proposal to bring back, never an application.
- The assertion rule for any scripted substitution. Every rewrite script asserts its match count against the number expected. A silent zero-match is how a rename half-lands.
- The instruction to stop a finding and report it rather than choose, whenever the fix turns out ambiguous once the code is in view. A new question is cheaper than a wrong edit.
- The disposition scale: APPLIED, DECLINED, or DEFERRED, one per finding, carrying the diff for the first and the reason for the other two.
- An instruction to say what it could not do rather than approximate it.
- A one-paragraph reply summary. The dispositions belong in the file it writes.

## Verification

Run the fast gates after every level, and the full suite once the last level lands. A formatter, a linter, and a type checker between them read past the inside of every string, so they prove nothing about a query, a template, or a manifest key. A change reaching one of those is verified by running the thing that reads it.

Prove a pure refactor inert. Capture the output before, capture it after, and diff them. A fix claiming to alter nothing owes that diff.

Where a document carries its own check target, run it and report what it flags.

A failing gate blocks the next level rather than the whole pass. Fix it, or say plainly which finding caused it and back that one out before going on.

## A second questionnaire

Agents surface ambiguities the first pass could not see, since a fix reads differently with the surrounding code in view. Collect them level by level and ask once per round, so the next level launches with the answers already in hand. Reopen only the findings those answers govern.

## Reporting and cleanup

One line per finding: identifier, disposition, and the fact that decided it. Group the declined ones together with their reasons, since those are what the next audit raises again unless the reason lives somewhere durable.

Record the resolved ambiguities where the project keeps its rulings, before deleting anything. Each answer cost the author a decision, and an unrecorded decision returns as the same question.

Delete `data/findings.md` once every finding carries a disposition and the gates pass. Until that moment it is the only copy of the list. A deferred finding survives the deletion only when the check that would settle it is written down elsewhere first, so write it down first.

Then stop. Committing, pushing, and launching are a separate request.
