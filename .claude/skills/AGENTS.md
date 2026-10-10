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
