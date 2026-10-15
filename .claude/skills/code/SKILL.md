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
- Name a thing by what it does, never by its role in a comparison, its position in a pipeline, or its type. Coining a type label for a branch or a conjunction of conditions spreads that same defect across a file.
- A conditional operation and the primitive it wraps take distinct names. Suffix the caller with what gates it rather than reusing the primitive's own word.
- Mark the exception, not the default. The common case is bare and the variant carries the mark, and the mark says what differs.
- Implementation vocabulary stays in the implementation. Words naming where a value sits in some machine do not belong in the description of what it is.
- A name the project has recorded as settled binds every later edit. The rejected side reads naturally at its own site, so check the record before coining or reviving a name.
- A column or field of an enum type takes the enum's stem as its name, so `thing_t` sits in `thing`. No name carries a `_kind`, `_type`, or `_family` suffix, which is a second name for what the type already says.
- In prose, use "type" for a classification.

## Duplication and abstraction

- State each rule once. Two places that must agree will stop agreeing, and the failure is silent because both still run.
- Count references, not call sites. A definition earns its place when its one caller names it twice. A name referenced once does not, and the expression goes inline.
- Prefer composition to a named intermediate. If a value exists only to be fed to the next step, compose the steps and let the intermediate stay anonymous.
- Deriving a value in two places is duplication even when the derivations look different. Check what a thing is computed from, not how.

## Defaults and edges

- Represent an absent optional value with the language's null and check for null before using it. Never use a value from the valid range to mean disabled. Booleans are never optional. A Boolean may control whether an optional value is set.
- Choose comparisons to match the intended boundary behavior. Check equality and endpoint cases explicitly.
- Constraints guard the human writing a row by hand, not the code path. Keep a check that today's only writer cannot violate.
- Fix a bug where it originates. A defensive default downstream hides it and keeps it.

## Comments

- Use comments for semantic clarity. A comment qualifies only when it supplies a fact the code and names leave implicit about what a value represents, what behavior is required, or what condition correctness depends on. The fact must resolve a concrete ambiguity that affects behavior, validity, or correct use.
- Rationale qualifies when it explains how an implementation choice preserves that meaning, behavior, or condition. Omit comments that only restate operations, narrate implementation steps, or record change history.
- Explain a field's purpose through its name. Put any necessary comment about the field in the documentation for its containing class, record, or table.
- Cap a doc comment at 3 lines. A schema object takes one comment of at most 2 lines above the statement creating it, stating what the object holds beyond what its name says. An enum whose members are its definition and a trigger named for what it fires on both earn none.

## Python

- All imports sit at module top level, never inside a function. Restructure a genuine cycle.
- Never use `typing.cast` or `# type: ignore`. Use the already-typed surface, or add or extend a stub.
- A stub changes in the same edit as the surface it covers, never as a follow-up. A stub default is spelled `= ...`.
- A vocabulary the database holds as an enum gets a matching `Literal` union, and fields carry it instead of `str`. The database already validates the value on insert, so what the union adds is the comparison check. A comparison against a value outside it is a type error, where a bare `str` lets the branch fall silently through.
- A formatter's config states a line width only where the tool's default differs from the project's. Width never decides a refactor, since the formatter reflows whatever an inlined expression becomes.

## SQL

- The database owns concurrency protection, locking, and atomic multi-step writes, in its own functions and triggers. Correctness must hold for a write typed by hand, with no application code in the way.
- Writers fail loudly on collision. Never write `ON CONFLICT`.
- Prefer a subquery at the use site for a query referenced once. Keep a single-use CTE only when its SQL semantics are required or representative execution plans and measured runtimes show a benefit.
- Never use a CTE where a separate view does the same work as fast or faster.
- Use LATERAL when the inner query returns multiple rows or columns per outer row. Check correlated scalar subqueries in the SELECT list with execution plans and measured runtimes on representative data at expected outer-row counts. Use LATERAL or a CTE when it simplifies redundant work.
- Write `ARRAY(SELECT ... ORDER BY ...)` instead of `array_agg(... ORDER BY ...)`, except when a grouped or LATERAL query computes multiple aggregates over the same rows in one scan. A FROM-less subquery is pulled up and its expression substituted at every reference, so the array builds once per reference and the scan repeats.
- An EXISTS probe is written `SELECT FROM`, never `SELECT 1 FROM`.
- An ad-hoc schema change is one transaction, since a run that stops halfway leaves a schema nobody wrote down. Read what a rebuilt object should look like out of the catalog rather than retyping it. Dry-run the whole transaction against a scratch schema first, and carry a `lock_timeout` so it fails fast instead of queuing a lock request every later reader waits behind.
- When a column change collides with a dependent view, drop the view and recreate it from its source definition rather than fighting `CREATE OR REPLACE VIEW` column rules.

## Changing existing code

- Never write versioned copies of a file under suffixes like `_v2`, `_old`, or `.bak`. A file is either committed to version control, which is its history, or edited in place with none kept. Suffix copies plant stale artifacts beside live ones under near-identical names.
- Every changed line traces to the request. Do not improve adjacent code, comments, or formatting.
- Match the surrounding style even where it differs from your preference.
- Remove what your change orphaned. Leave pre-existing dead code alone and mention it.
- Say what you deliberately left out and why. Scaling the work down is the author's call.

## Verification

- Assert meaningful invariants or compare results with expectations established independently of the implementation. Do not write assertions that test only constants or reproduce the calculation being tested.
- Type checkers and linters read past the inside of a string. A query naming a column that moved passes every check and fails on first execution. Run the thing.
- For a pure refactor, run the old and new implementations with the same inputs and starting state. Capture and diff their output, and compare the returned values, raised errors, and changed files or database rows that the refactor can affect. Report the differences, the cases checked, and any behavior the comparison did not cover.
- Put an assertion in every rewrite script, so each substitution matches the count you expect. A silent zero-match is how a rename half-lands.
- Counting with a regex undercounts whatever the regex was not written for. Count with a script over the raw text, and treat a surprising count as a bug in the count.
- Confirm a surface before calling it. Read a table's columns and types, or a function's signature, before writing the query or the call.
- Probe a destructive database change inside an explicit `BEGIN`/`ROLLBACK`. A rollback on an autocommit connection does nothing, and a sequence advances across a rollback either way.
- Never hand-edit a patch file. A hunk body edited without recomputing its `@@` counts is malformed. Apply the patches to pristine copies, edit the results, regenerate each patch with `diff`, and confirm every patch applies with zero failures and zero offsets.
- A rewritten file and a loaded edit are two facts. An A/B comparison reads which variant each pass loaded off the running code object, never off the file, and asserts the two passes differ before it compares their outputs.
- Never add timing instrumentation to a run whose speed is being measured, since the instrument perturbs the measurement. Compare what unmodified runs already record.
- A name absent from a file is not therefore free. A convention can reserve it without ever using it.
- Independent review finds what self-review does not, especially in a pass whose whole point was removing things. Get one before calling a large cleanup done.

## Reporting

- Say plainly what failed, what you skipped, and what you could not check. A summary that omits a failure is worse than no summary.
- Never report as verified what you inferred. If it was not run, say it was not run.
- Query the data before making a claim the data decides, and never guess a factual answer. If the data is missing, say so and say what run would supply it.
- Correct an error in one sentence and continue. Do not narrate the mistake.
