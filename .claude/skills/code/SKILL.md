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

- One thing carries one name across every surface it crosses, and one name carries one thing. A second name is a defect even when both are apt, because the two drift and nothing raises. Apply the [prose naming caveats](../prose/SKILL.md#naming) for symbol spellings, descriptive phrases, and independent local bindings.
- Name an operation by what it does and a value by what it represents. Choose data names such as `source_text` and `tokens` instead of literal `input` and `output`. Name a method by how it works, never by its role in a comparison.
- A conditional operation and the primitive it wraps take distinct names. Suffix the caller with what gates it rather than reusing the primitive's own word.
- Related operations may both have qualified names that express how they differ, such as `search_exact` and `search_approximate`.
- Follow the [prose vocabulary rule](../prose/SKILL.md#naming) for descriptions of concepts, storage, and execution.
- A column or field of an enum type uses the enum's stem, so `thing_t` sits in `thing`. Add purpose qualifiers to distinguish roles, such as `requested_status` and `observed_status` for two fields of `status_t`. No name carries a `_kind`, `_type`, or `_family` suffix, which is a second name for what the type already says.
- In prose, use "type" for a classification.

## Duplication and abstraction

- State each rule once. Two places that must agree will stop agreeing, and the failure is silent because both still run.
- Count references, not call sites. A definition earns its place when its one caller names it twice. Inline a replaceable definition or computed intermediate referenced once. Parameters and names required by an interface are outside this rule. Count external or framework references only when you can identify their readers.
- Prefer composition to a named intermediate. If a value exists only to be fed to the next step, compose the steps and let the intermediate stay anonymous.
- Deriving a value in two places is duplication even when the derivations look different. Check what a thing is computed from, not how.

## Defaults and edges

- Represent optional values with an option type and check for absence before using the contained value. Never use a value from the valid range to mean disabled. Booleans are never optional. A Boolean may control whether an optional value is set.
- Choose comparisons to match the intended boundary behavior. Check equality and endpoint cases explicitly.
- Constraints guard the human writing a row by hand, not the code path. Keep a check that today's only writer cannot violate.
- Fix a bug where it originates. A defensive default downstream hides it and keeps it.

## Comments

For code comments and docstrings, follow the [Code comments and docstrings section](../prose/SKILL.md#code-comments-and-docstrings) of the `prose` skill.

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
- Write `ARRAY(SELECT ... ORDER BY ...)` instead of `array_agg(... ORDER BY ...)`, except when a grouped or LATERAL query computes multiple aggregates over the same rows in one scan.
- An EXISTS probe is written `SELECT FROM`, never `SELECT 1 FROM`.
- An ad-hoc schema change is one transaction, since a run that stops halfway leaves a schema nobody wrote down. Read what a rebuilt object should look like out of the catalog rather than retyping it. Dry-run the whole transaction against a scratch schema first, and carry a `lock_timeout` so it fails fast instead of queuing a lock request every later reader waits behind.
- When a column change collides with a dependent view, drop the view and recreate it from its source definition rather than fighting `CREATE OR REPLACE VIEW` column rules.

## Changing existing code

- Never write versioned copies of a file under suffixes like `_v2`, `_old`, or `.bak`. A file is either committed to version control, which is its history, or edited in place with none kept. Suffix copies plant stale artifacts beside live ones under near-identical names.
- Every changed line traces to the request. Do not improve adjacent code, comments, or formatting.
- Match the surrounding style for choices left open by mandatory rules and applicable project instructions.
- Remove what your change orphaned. Leave pre-existing dead code alone and mention it.
- Say what you deliberately left out and why. Scaling the work down is the author's call.

## Verification

- Assert meaningful invariants or compare results with expectations established independently of the implementation. Do not write assertions that test only constants or reproduce the calculation being tested.
- Type checkers and linters read past the inside of a string. A query naming a column that moved passes every check and fails on first execution. Run the thing.
- For a pure refactor, run the old and new implementations with the same inputs and starting state. Capture and diff their output, and compare the returned values, raised errors, and changed files or database rows that the refactor can affect. Report the checks run, the current implementation's results, and any behavior left unchecked. Follow the prose skill's [Positive framing section](../prose/SKILL.md#positive-framing) for writing comparisons with previous versions.
- Put an assertion in every rewrite script, so each substitution matches the count you expect. A silent zero-match is how a rename half-lands.
- Confirm a surface before calling it. Read a table's columns and types, or a function's signature, before writing the query or the call.
- Probe a destructive database change inside an explicit `BEGIN`/`ROLLBACK`. A rollback on an autocommit connection does nothing, and a sequence advances across a rollback either way.
- Never hand-edit a patch file. A hunk body edited without recomputing its `@@` counts is malformed. Apply the patches to pristine copies, edit the results, regenerate each patch with `diff`, and confirm every patch applies with zero failures and zero offsets.
- In an A/B comparison, verify which code, configuration, or schema revision each run consumed. Use evidence from the running program or database. Confirm that the runs consumed the intended distinct revisions before comparing results.
- Use the timing output already recorded by unmodified benchmark runs.
- A name absent from a file is not therefore free. A convention can reserve it without ever using it.
- Independent review finds what self-review does not, especially in a pass whose whole point was removing things. Get one before calling a repo-wide cleanup done.

## Reporting

- Say plainly what failed, what you skipped, and what you could not check. A summary that omits a failure is worse than no summary.
- Never report as verified what you inferred. If it was not run, say it was not run.
- Query the data before making a claim the data decides, and never guess a factual answer. If the data is missing, say so and say what run would supply it.
- Correct an error in one sentence and continue. Do not narrate the mistake.
