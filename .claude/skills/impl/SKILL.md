---
name: impl
description: Fan out subagents to verify a list of code findings (dead code, redundancy, single-use abstractions, latent bugs, refactor proposals) against the repo before acting on any of them. Load whenever I paste a ranked or numbered list of code issues and ask to verify, validate, or check them.
---

# Verifying code findings

The input is a numbered list of claims about the code, usually produced by another review pass. The claims are hypotheses. The job is to establish which ones survive contact with the repo, and to report that. Implementing them is a separate request.

## Partition the claims

Group claims by the file or subsystem they touch, one agent per group. A group is coherent when its agent can answer every claim in it from one set of files. Claims that share a file go to the same agent, so no two agents read the same module and reach different conclusions.

Six to eight groups is the usual shape for a twenty-claim list. Never one agent per claim.

Use the `Explore` subagent type. State in every prompt that the agent is read-only and edits nothing.

## What each agent prompt carries

- The repo path, and an instruction to read `AGENTS.md` first for project conventions.
- The claims verbatim, with their original numbers, so the synthesis can zip verdicts back to the list.
- The verdict scale: CONFIRMED / REFUTED / PARTIAL, one per claim, with `file:line` evidence.
- The reader surface a "dead" or "only caller" claim has to clear, which is every directory `AGENTS.md` lists under repository layout. Patch files count, since they insert code that imports the package, and so do manifests, type stubs, and paper sources. Ad-hoc psql by the user is a real reader for user-facing views.
- The skeptical rule, stated outright. A claim of "only reader" is REFUTED by any additional reader anywhere.
- For the one or two claims that assert a bug, say which they are and demand a concrete failure scenario with inputs, or an explicit statement that the bug is unreachable and why.
- An instruction to load the `code` skill, so the agent judges the fix and not only the fact. Its rules on counting references and on naming a conditional wrapper both cut against naive inlining.
- Where a claim is testable, tell the agent to test it rather than reason about it: `psql` for catalog and dependency questions, `.venv/bin/python` for library semantics. Scratch scripts go in the session scratchpad, never in the repo tree.
- Tell the agent to say "I could not test this cleanly" instead of guessing.

## Synthesis

Report one line per claim: number, verdict, and the fact that decided it. Rank by what is now safe to act on. Name explicitly the claims that were REFUTED and what killed them, since those are the ones the review pass got wrong and would repeat.

Separate the claims that survive verification from the claims that survive judgment. A confirmed single-use helper whose inlining would hurt the call site is confirmed and still not worth doing. Say so.

Findings that need a run rather than a read go in their own list at the end, with the run that would settle each.

Then stop. Do not implement until asked. When implementation is asked for, verify a schema or runtime path change by running it, never by ruff and basedpyright alone. Exercise the change locally against the venv, and never by cloning the branch into a pod.
