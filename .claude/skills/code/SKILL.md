---
name: code
description: How I want code written and changed - naming, duplication, abstraction, comments, change scope, and what counts as verified. Load before writing or editing code in any language, and before any cleanup, dedup, or refactor pass.
---

# Code

These apply to every language and every surface: application code, SQL, schema definitions, build files, scripts, and configuration. The `prose` skill governs the words. This governs the rest.

## Before writing

- State assumptions out loud. When two readings of a request lead to materially different code, say both and ask. When they lead to the same code, pick one and note it.
- Push back before implementing, not after. A simpler approach, a wrong premise, or a request that cannot work is worth one paragraph up front and is worthless once the code exists.
- Write nothing speculative. No configurability, no extension point, no error handling for a state the program cannot reach.

## Naming

- One thing carries one name across every surface it crosses, and one name carries one thing. A second name is a defect even when both are apt, because the two drift and nothing raises.
- Name a thing by what it does, never by its role in a comparison, its position in a pipeline, or the category it belongs to. Coining a category noun for a branch or a conjunction of conditions spreads that same defect across a file.
- A conditional operation and the primitive it wraps take distinct names. Suffix the caller with what gates it rather than reusing the primitive's own word.
- Mark the exception, not the default. The common case is bare and the variant carries the mark, and the mark says what differs.
- Implementation vocabulary stays in the implementation. Words naming where a value sits in some machine do not belong in the description of what it is.

## Duplication and abstraction

- State each rule once. Two places that must agree will stop agreeing, and the failure is silent because both still run.
- Count references, not call sites. A definition earns its place when its one caller names it twice. A name referenced once does not, and the expression goes inline.
- Prefer composition to a named intermediate. If a value exists only to be fed to the next step, compose the steps and let the intermediate stay anonymous.
- Deriving a value in two places is duplication even when the derivations look different. Check what a thing is computed from, not how.

## Defaults and edges

- Inactive means absent. Use the language's null and branch on it, never a magic sentinel inside the valid range.
- Thresholds compare inclusively, so the extreme value is a true no-op.
- Constraints guard the human writing a row by hand, not the code path. Keep a check that today's only writer cannot violate.
- Fix a bug where it originates. A defensive default downstream hides it and keeps it.

## Comments

- A comment carries a semantic constraint or a gotcha the code cannot express. Nothing else.
- Never restate what the line below shows, never narrate rationale, rejected alternatives, load order, file placement, or another library's internals, and never record the change that produced the code.
- Comments attach to units, not to fields. A per-field comment is a sign the field is misnamed.

## Changing existing code

- Never write versioned copies of a file under suffixes like `_v2`, `_old`, or `.bak`. A file is either committed to version control, which is its history, or edited in place with none kept. Suffix copies plant stale artifacts beside live ones under near-identical names.
- Every changed line traces to the request. Do not improve adjacent code, comments, or formatting.
- Match the surrounding style even where it differs from your preference.
- Remove what your change orphaned. Leave pre-existing dead code alone and mention it.
- Say what you deliberately left out and why. Scaling the work down is the author's call.

## Verification

- Type checkers and linters read past the inside of a string. A query naming a column that moved passes every check and fails on first execution. Run the thing.
- A pure refactor is provable. Capture the output before, capture it after, and diff them. If the change was supposed to alter nothing, prove it altered nothing.
- Put an assertion in every rewrite script, so each substitution matches the count you expect. A silent zero-match is how a rename half-lands.
- Counting with a regex undercounts whatever the regex was not written for. Count with a script over the raw text, and treat a surprising count as a bug in the count.
- A name absent from a file is not therefore free. A convention can reserve it without ever using it.
- Independent review finds what self-review does not, especially in a pass whose whole point was removing things. Get one before calling a large cleanup done.

## Reporting

- Say plainly what failed, what you skipped, and what you could not check. A summary that omits a failure is worse than no summary.
- Never report as verified what you inferred. If it was not run, say it was not run.
- Correct an error in one sentence and continue. Do not narrate the mistake.
