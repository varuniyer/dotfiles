# Skill rulings

This file records decisions for the six user-authored skills in this directory. Each rule's canonical wording remains in its `SKILL.md`.

## Decisions on 2026-10-09

The user answered “all 4” to this question: “For the four remaining choices, should I use these recommendations: require inlining for helpers referenced once, allow abstracts and conclusions to summarize claims, allow precise prohibitions when positive wording would obscure the rule, and use ‘type’ for classifications while rephrasing ‘differs in kind’ and ‘suffix families’?” These choices govern CROSS-01, CROSS-02, CORE-Q1, and CROSS-03.

The user answered “all five” to these workflow proposals:

1. WFLOW-001: Use earlier diffs to locate moved evidence and verify the finding again.
2. WFLOW-002: Verify contradictions involving placeholder claims, preserve protection for missing measurements, and ask the author when the intended claim is unclear.
3. WFLOW-003: Give UNVERIFIABLE assertions an unresolved group and a required check. Handle PARTLY TRUE assertions by their supported, refuted, and unresolved parts.
4. WFLOW-004: Allow audit and impl agents to write their assigned reports and verification scripts in the session scratchpad while keeping the reviewed files read-only.
5. WFLOW-Q02: Run available checks within the authorized task and defer only checks whose required run, measurement, or data remains unavailable.

For YAML validation, the user instructed: “use nushell not py for yml”.

## Dispositions

| Finding | Disposition | Deciding fact |
|---|---|---|
| CORE-01 | APPLIED | The repeated Concision bullet was removed. Positive framing retains the instruction. |
| CORE-04 | APPLIED | The Claims rule now says “subject of a commit message”. |
| CORE-Q1 | APPLIED | Positive framing explicitly permits precise prohibitions when positive wording would obscure the rule. |
| CROSS-01 | APPLIED | Impl's example distinguishes one caller from one reference and preserves code's inlining requirement. |
| CROSS-02 | APPLIED | Prose and paper allow abstract and conclusion summaries while keeping detailed claims at one site. |
| CROSS-03 | APPLIED | Classification prose uses “type”, the rule has its own bullet, and the two approved expressions were rephrased. The branch-label and enum-suffix constraints remain. |
| WFLOW-001 | APPLIED | Fix uses earlier diffs to locate and verify current evidence, declines refuted findings, and defers subjects it cannot locate confidently. |
| WFLOW-002 | APPLIED | Fix declines findings based solely on missing placeholder measurements and checks contradictions under the author's intended claim. |
| WFLOW-003 | APPLIED | Paper gives unknown assertions an unresolved group and a required check, and separates the parts of PARTLY TRUE assertions. |
| WFLOW-004 | APPLIED | Audit and impl permit assigned reports and verification scripts in the scratchpad while protecting reviewed files. |
| WFLOW-Q02 | APPLIED | Fix and impl run available checks within the authorized task. Deferred findings retain the check that would settle them before cleanup. |

All eleven findings were applied. This pass declined or deferred none of them.

## Earlier audit candidates

The audit left CORE-02 and CORE-03 for a later prose pass. They are candidates outside this pass's eleven findings.

- CORE-02 compares the diagnostic advice in prose's Clarity section with “Get to the subject quickly, and to the verb quickly after it. Revise long openings” in Shape and elegance. A later pass must decide whether diagnosis and revision serve distinct purposes before proposing deletion.
- CORE-03 concerns “State the point once” after the Redundancy rule and “Hard ideas earn hard sentences. Nothing else does” after the Ethics rule on difficulty. A later pass must evaluate these echoes against the thematic repetition allowed by Cohesion and emphasis before proposing deletion.

## Decisions on 2026-10-11

These decisions govern the nine findings in the rule-clarity audit dated 2026-10-11. Its CORE identifiers are separate from those in the earlier audit.

- CORE-05: The user instructed “allow indep expect val.”
- CORE-03: The user instructed “bool should never be optional but bool can control the setting of optional vars.”
- FLOW-01: The user instructed “merge findings beforehand to account for conflicts.” Findings governed by the same decision belong under one owner before the dependency graph is built.
- CORE-04: The user instructed “as lkmg as they're not making redundant stuff that would be simplified with lateral or cte it's probably ok as long as its performant.” This permits scalar subqueries based on performance and duplication, without an outer-row limit. The existing preference for a view over an equally fast or faster CTE remains applicable.
- TERMS-02: The user instructed “use the repo's instructions for formatting/linting/other”.
- CORE-06: The user requested plain wording for the writing rules and questioned the need for a general exception. The existing grammar-advice bullets already say when to ignore conventional advice. Remove the redundant general exception and the unexplained label, and preserve the specific prose rules.

The user also instructed that the shared rules should remain independent of the assistant or tool. The README holds the Nushell commands for linking the shared skills into the assistant's skill directory.

## Dispositions on 2026-10-11

| Finding | Disposition | Deciding fact |
|---|---|---|
| CORE-01 | APPLIED | Necessary field comments belong in the containing class, record, or table's documentation. The limits on comment content and length remain. |
| CORE-02 | APPLIED | The comparison rule names current behavior and alternatives still under consideration, and omits superseded versions. |
| CORE-03 | APPLIED | Null represents an absent optional value. Booleans remain non-optional and may control whether an optional value is set. |
| CORE-04 | APPLIED | Scalar subqueries require checking plans and runtimes on representative data. LATERAL or a CTE simplifies repeated work. The view preference remains, and the outer-row limit is removed. |
| CORE-05 | APPLIED | Assertions may use independently established expected values. Assertions testing only constants or reproducing the tested calculation remain prohibited. |
| CORE-06 | APPLIED | The specific grammar-advice bullets already explain when to ignore conventional advice. The redundant general exception and unexplained label were removed. The specific prose rules remain. |
| FLOW-01 | APPLIED | Findings governed by one answer merge under one owner before graph construction. Conflicts are checked before assignment, and edges express only ordering dependencies. |
| TERMS-01 | APPLIED | Refactor checks use matching inputs and starting state, compare output and other affected observations, and report the cases checked and remaining coverage. Fix refers to code's rule. |
| TERMS-02 | APPLIED | Fix records exact check commands from repository instructions before editing and runs them at the specified stages. |

All nine findings were applied. No findings were declined or deferred.

The additional user requests were applied. Workflow skills describe required agent capabilities and questions without naming a particular assistant's agent types or question tool. The README creates the skill links with one Nushell command that expands the source directories automatically.

Verification passed for all six skill manifests using Nushell and for `git diff --check`. The README snippet created six links in a temporary destination, and every linked SKILL.md matched its source. The repository defines no further test suite or document-check target for these files.

## Decisions on 2026-10-15

The user kept the inlining requirement for single-use names and requested comments as the way to resolve unclear meaning. Comments may explain rationale when it meets the strict definition of semantic clarity in the code skill's Comments section.

The user prefers subqueries for SQL inlining, subject to measured performance. The code skill's SQL section holds the canonical rule.
