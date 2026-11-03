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

The user kept the inlining requirement for single-use names and requested comments as the way to resolve unclear meaning. Comments may explain rationale when it meets the strict definition of semantic clarity in the prose skill's Code comments and docstrings section.

The user prefers subqueries for SQL inlining, subject to measured performance. The code skill's SQL section holds the canonical rule.

The user requested "option type" to distinguish the type from the value that represents absence. The code skill holds the canonical rule.

The user requested clarifying the prose rules flagged as vague using Joseph M. Williams's discussion in [Style: Toward Clarity and Grace](https://s3.amazonaws.com/arena-attachments/1408171/244bf97521118f6fcbe692b0b98dcc7d.pdf). The clarity and cohesion clarification follows chapter 3, p. 48. The guidance on introducing unfamiliar technical terms follows chapter 4, pp. 73–75. The restrictions on implementation details and Limitations caveats remain user instructions.

The user requested that the prose skill hold the canonical code-comment and docstring rules and that the code skill reference them. This resolves CORE-R01 from the 2026-10-15 review.

The user removed blanket protection for settled choices and names. A review exemption must be an explicit exception in the target project's `AGENTS.md`. Decision records and previous clean checks supply context and evidence without granting an exemption. This resolves FLOW-01 from the 2026-10-15 review.

The user questioned what proof evidence requires and discussed Lean as a possible formalization, without requesting it as a requirement. The Claims section now distinguishes empirical evidence, supporting proofs, and inspected changes. Proof review checks the argument against its claimed conclusion and assumptions. Formalization is optional and includes checking that the formal statement and assumptions match the written claim. Audit refers to the canonical Claims section. This resolves CORE-R04 and the dependent checklist drift FLOW-03 from the 2026-10-15 review.

The user allowed source URLs in comments when applicable. The prose skill's Code comments and docstrings section holds the allowance.

The user clarified that the extra caution about removing or weakening checks applies to non-orphaned checks. Checks orphaned by the requested change follow the code skill's removal rule. An authorized removal may proceed within that scope. This resolves FLOW-02 from the 2026-10-15 review.

The user confines comparisons with previous versions to commit messages. Comments and other prose surfaces describe current behavior. Refactor verification still compares implementations. Its reports state the checks run, current results, and coverage gaps. The code skill's Verification section holds the procedure, and the prose skill's Positive framing section holds the writing rule. This resolves CORE-R02 from the 2026-10-15 review.

The user approved the naming clarifications for CROSS2-03, CROSS2-04, and CROSS2-05. Prose's Naming section holds the caveats for descriptive explanations, Greek-symbol spellings in code, and independent local bindings. Code references those caveats and permits purpose qualifiers for enum fields with different roles.

The user requires "type" when discussing a classification. The branch-naming wording in code, prose, and audit follows that terminology. The user found the timing instructions vague and contrived. Code's Verification section states the requirement to use timing output already recorded by unmodified benchmark runs.

The user defined a large cleanup as repo-wide and confirmed that comment delimiters count toward the line cap. Code's independent-review trigger and prose's comment rule hold those instructions. These resolve REVIEW-Q01 and REVIEW-Q02.

Shared skill instructions use generic paths and never name a particular project. The user accepts generic paths derived from the target repository, so FLOW2-08 is declined. The user requested removing the sample-count instruction if redundant. A search of all six skills found it only in prose's Claims section, so it is retained and REVIEW-Q03 is declined.

The user clarified that two types may both have qualified names and that input and output values are named for what they represent. Code's Naming section holds both instructions. The user's prediction/label example is context-specific. Prose's branch-description rule states its aim concretely, giving a condition directly and permitting consistent repetition of an operation's functional name. Audit follows that wording. These resolve CROSS2-06, CROSS2-01, and CROSS2-02.

## Dispositions for the remaining fifteen clarifications

The user authorized these edits with “ok snd for the 15 use prose rules to fix them”. The canonical wording remains in the skills.

| Finding | Disposition | Deciding fact |
|---|---|---|
| CROSS2-07 | APPLIED | A passage's subject governs implementation vocabulary in documents and chat. Code refers to prose's canonical rule. |
| CORE2-01 | APPLIED | Single-use inlining covers replaceable definitions and computed intermediates. Parameters and required interface names retain their bindings. Identified external readers count. |
| CORE2-05 | APPLIED | Comparisons verify which code, configuration, or schema revision each run consumed before comparing results. |
| FLOW2-03 | APPLIED | Failure attribution requires baseline results or reproduction against unchanged state. Existing failures are reported separately. |
| FLOW2-04 | APPLIED | The graph includes prerequisites for editing, execution, and verification. |
| FLOW2-05 | APPLIED | Deferred prerequisites retain their edges. Dependent work is deferred or re-planned, and readiness is reassessed after rollback. |
| FLOW2-01 | APPLIED | Paper review separates truth from the edit decision and includes true assertions needing no change. |
| FLOW2-02 | APPLIED | Code review includes UNVERIFIABLE. PARTIAL separates supported, refuted, and unresolved parts. |
| CORE2-06 | APPLIED | Assertions use declarative form. Questions obtain information or decisions. |
| CORE2-07 | APPLIED | The signpost restriction preserves words needed for conditions, sequence, and logical relationships. |
| CORE2-02 | APPLIED | Surrounding style governs choices left open by mandatory rules and project instructions. |
| FLOW2-06 | APPLIED | Existing authorization carries forward. Questions concern unresolved intent or scope. Unrelated bug fixes remain separate proposals. |
| FLOW2-07 | APPLIED | Reviewed sources stay read-only. Reports, scripts, disposable check outputs, and redirected caches belong in scratch. |
| FLOW2-09 | APPLIED | Deferred findings retain their identifiers, subjects, reasons, and required checks in a durable project record. The report names the destination. |
| FLOW2-10 | APPLIED | A claim that stands alone may form its own group. Claims sharing a file retain one owner. |

All fifteen were applied. None was declined or deferred in this pass. Independent source reviews checked the revised rules against concrete cases. Verification uses Nushell to validate all six manifests and their Codex links, plus `git diff --check -- .claude/skills`.
