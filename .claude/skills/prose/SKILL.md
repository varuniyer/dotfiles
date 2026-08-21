---
name: prose
description: Writing and review rules for every kind of prose I write - paper and manuscript text, code comments, docstrings, commit messages, PR descriptions, docs, and chat replies. Load before drafting, editing, or reviewing any of it, and before any prose-cleanup pass.
---

# Prose

Apply these to every prose surface: paper text (abstract, body, table and figure captions, appendix), code comments and docstrings, commit messages and PR descriptions, documentation, writeups, and chat replies.

Chat replies are the surface these rules govern most often, so they carry no exemption. Every message sent in a session obeys them, including a one-line answer, a status report, a plan, a question back, and the sentences wrapped around a tool result or a diff. Load this file at the start of a session and hold it for the whole of it, rather than loading it only when a document is in view.

Sections below marked **(documents)** apply to papers, docs, and writeups. Everything else applies everywhere.

Obscurity is the standing temptation. Writing that is hard to read reads as intelligent, so the pull toward it is constant and you have to fight it on every pass. Assume any passage you cannot paraphrase on sight is unclear rather than deep, including your own.

## Ethics

- Write for the reader you would want to be. Style is a form of manners, and clarity is the courtesy.
- Match the difficulty of the prose to the difficulty of the idea and no further. Hard ideas earn hard sentences. Nothing else does.
- A complex subject never excuses unclear writing. Expertise is not a license for opacity, and a field's conventional density is not a reason to reproduce it.
- Read other people's obscurity charitably. Most of it is unintended and the writer cannot see it. Say so plainly when asked, and bring the rewrite with you.
- Obscurity that hides responsibility differs in kind, not degree. Prose that buries who did what, softens a danger, or dissolves an agent into a passive is misconduct rather than clumsiness. Never write it, and name it when you review it.

## Drafting

- Draft fast and revise after. Get the whole thing down without stopping to judge it, then make a separate pass to fix it. Editing while drafting produces less text and worse text.
- Every rule below is a revision rule. None of them applies to a first draft.

## Clarity: characters and actions

One rule matters more than the rest. Find the main characters, and express their actions as verbs.

- Make the main character the subject of the sentence. Make what that character does the verb.
- An abstract concept can be a main character. Give it a subject position and a verb rather than dissolving it into a chain of nouns.
- Resist nominalization, the turning of verbs into nouns ("resist" into "resistance", "react" into "reaction", "we analyzed" into "our analysis"). It is the main source of opaque academic prose, and it removes exactly the quality that makes writing clear.
- Rebuild a nominalized sentence with a subordinating word: because, if, when, although, why, how, whether, that.
- Prefer active verbs, with the exception in Cohesion below.
- Nominalizations that name a settled concept ("the swap", "the decomposition") or refer back to a previous sentence are fine. These rules have exceptions and this one has the most.

- Break noun stacks. Three or more nouns in a row become a phrase with a verb or a preposition.
- Cut metadiscourse, the words that narrate the writing rather than the subject ("it should be noted that", "in this section we show"). Keep only the few that orient the reader.
- You cannot judge your own clarity, because you already know what you meant. Reread as someone who does not, and treat a reader's confusion as a fact about the sentence.

Diagnosing a sentence, in order:

1. Read the first seven or eight words. The subject should be inside them and should name a character.
2. Count the words before the main verb. A long run means the sentence is buried.
3. List the sentence's characters and its verbs. If the characters are not subjects, or the actions are not verbs, rewrite.

## Cohesion and emphasis

Flow is what makes a passage readable, and cohesion is what makes flow.

- Open a sentence with information the reader already has, usually from the sentence before. Close it with what is new. Consecutive sentences should fit like puzzle pieces.
- This is the one good reason to use the passive. Where the passive puts the familiar term first, use it.
- The first few words set the point of view. The last few carry the emphasis. Put what you want remembered at the end, where the reader cannot predict it.
- Keep the opening clean. Delay the difficult or surprising material until after the subject and verb have landed.
- Revise for emphasis by trimming the end, shifting peripheral material left, and shifting new material right.
- Where clarity and cohesion pull against each other, cohesion wins.
- Cohesion is sentences fitting together. Coherence is the passage adding up to one thing. Both are required, and a passage of individually clear sentences can fail the second.
- Hold a consistent string of topics across a passage. Where the opening words of consecutive sentences name unrelated things, the passage is incoherent however clear each sentence is.
- Repeat a theme's words across a passage to hold it together, and let the closing sentence answer the opening one.

## Punctuation and sentence shape

- No em dashes and no semicolons. Split into sentences, or use a comma or conjunction.
- Short declarative sentences, one idea each. No transition words ("However", "In contrast", "Moreover", "As such", "Crucially"). Dropping transitions removes most colons and dashes on its own, since those exist to join clauses.
- Split long sentences first, then prune. Splitting promotes transition clauses into standalone sentences that assert nothing. Delete those.
- Write logical conditions as symbols (`\land`, `\neg` in LaTeX, `and`/`not` in code prose), never as capitalized words (AND, NOT). Bind a symbol to the column or predicate first when the operands are long names.
- Keep proof bodies intact. There the chain of inference is the content, so the split-and-prune pass does not apply.
- In markdown, a bullet or a paragraph is one source line, never manually wrapped at a column. Editors wrap at display time, and hard breaks inside a logical line corrupt diffs, greps, and joins.

## Positive framing

- State what the thing does, not what it avoids. Scan for `not`, `no`, `did not`, `rather than`, `unlikely to`, `never` and convert each into the positive fact, preserving the empirical finding.
- Standard property terms ("non-deterministic", "unsupervised") are fine.
- Contrastive phrasing is allowed when both sides are live alternatives at the current moment. It is out when either side is a superseded version of the code, the document, or the data, since that drags in history the reader cannot act on. Describe a to c, never a to b to c.
- A comment or commit message describes what the code does today. No fixup, justification, migration, or legacy commentary.

## Redundancy

- Cut clauses that restate or elaborate the sentence's own point rather than adding information. State the point once.
- Collapse a claim-then-elaboration pair into one sentence only when the merge stays grammatical. Reread the merged sentence for subject-verb agreement and dangling negation before keeping it.
- Delete a paragraph outright, rather than trimming it, when it repeats a claim made elsewhere in the document.
- Cut a comment that restates what the line below it already shows. Comments carry only semantic constraints and gotchas the code cannot express. Never narrate design rationale, rejected alternatives, load order, file placement, or another library's or file's internal mechanics.
- Cut degree adverbs and intensifying adjectives ("purely", "substantially", "genuinely", "directly") when the sentence means the same thing without them. Keep one only when removing it erases a real contrast, or when the words sit inside quoted experimental text (prompts, code listings), where changing them changes the experiment.

## Concision

Section Redundancy cuts whole clauses and paragraphs. These cut words.

- Delete meaningless words and doubled words.
- Delete what the reader can infer.
- Replace a phrase with a word. "Carefully read what you have written" is "edit". "The one thing to do before anything else" is "first".
- Turn negatives into affirmatives, as Positive framing already requires.
- Cut hedges and stacked qualifiers. "There seems to be some evidence to suggest that the differences could derive from historical influences possibly traceable to X" is "Evidence suggests the differences stem from historical influences."
- Cut adjectives and adverbs that add no meaning. "In my personal opinion, it is necessary that we should not ignore the opportunity to think over each and every suggestion offered" is "We should consider each suggestion."

## Shape and elegance

- Get to the subject quickly, and to the verb quickly after it. Revise long openings.
- Consider opening with your point rather than building to it.
- Break a subordinate clause into its own sentence, or reduce it to a modifying phrase.
- When coordinating, order the elements short to long and simple to complex.
- Balance is the most visible feature of good sentences. Build it with and, or, nor, but, and yet.
- End on strength: a strong word or pair, a prepositional phrase with "of", or an echo of a word used earlier.
- Chiasmus, repeating two elements in reversed order, is available and easy to overuse. So is the suspended opening that delays the point. Use either once in a passage at most.
- Watch sentences under fifteen words and over thirty. Both are worth a second look, and neither is wrong by itself. Where this meets the short-declarative rule under Punctuation, that rule wins, and the count is only a prompt to reread.

## Which rules to obey

- Real rules make English English. Social rules mark standard from nonstandard. Invented rules were made up by grammarians, and they go whenever they cost clarity.
- Ignore the folklore: never open with "and" or "but", never split an infinitive, never end on a preposition. Follow one only where the sentence is better for it.
- Singular "they" is correct. Use it.
- Where a rule and the reader conflict, the reader wins. Correctness serves communication and never outranks it.
- The house rules in this file are not folklore. Follow them.

## Naming

- Do not coin or repeat a category noun (a "tier", a "hierarchy", a named "structure") for something that is a control-flow branch or a conjunction of conditions. Name the branch once, in the algorithm or the single canonical place that defines it, then refer to it everywhere else by what it does. A recurring proper-noun-like label for an if/else is the same defect as a restated clause, spread across the document.
- Name a branch or variant by what it does, never by its role in a comparison. "Fallback" is wrong for a branch that runs a full rule.
- Never call an ablation or method variant an "arm".
- One concept carries one name for the whole document, and one name carries one concept. A second name is a defect even when both are apt, because the reader has to discover they are the same thing and the two drift once they are apart. The inverse is as bad, one name covering several things, and it hides better, since each site reads fine on its own. A project's `AGENTS.md` records the instances that project has actually paid for.
- Neither name looks wrong at its own site, so a second name is never found by reading either passage. Find it by asking what one thing is called everywhere, and check the definition sites first, since that is where the second name is born and where every later use inherits it.
- Notation obeys these rules. A symbol is a name. Bind it once, and if a section rebinds it, that is the same defect as calling one thing two things, with the added cost that the proofs keep type-checking. Prefer a mark that says what was done (a prime for a different computation, a subscript for a different input) over a fresh letter, and never introduce a letter for a set or an object referenced once.
- Bind a symbol with "Let $X$ be ...", never "Write $X$ for ...". This holds in running prose as well as in the hypothesis of a lemma, so one binding form covers the document. Where a sentence binds two symbols, repeat the verb instead of eliding it: "Let $L$ be the context logits, and let $L^{\varnothing}$ be the document-free logits."
- Implementation vocabulary belongs in the implementation section. "Row", "buffer", "batch", "call" and their kin name where a thing sits in some machine, not what it is, and the reader of a method section has no machine in view.

## Claims

- Every claim in a summary position (abstract, Contributions list, Conclusion, commit message subject, PR description) must correspond to a measured result or a specific tested scope.
- Cut a qualifier that names no metric the work actually reports (e.g. "holistic quality" beside metrics that are all named elsewhere).
- Scope claims to what was tested ("among the settings we test") instead of stating them as absolutes. A commit message says what changed, never that it is better unless a measurement says so.
- State what the statistics show and stop there. Mechanistic explanations require data that probes the mechanism.

## Sources

- Quote accurately, paraphrase into your own sentence structure rather than swapping synonyms, and cite in the form the field uses.
- Decide three things per source: how much to bring in, whether to quote, paraphrase, or summarize, and how to attribute it.
- Quote when the wording is the evidence. Paraphrase when the content is. Summarize when only the conclusion bears on your argument.

## Structure (documents)

- Before trimming a formal result (a lemma, proposition, or named mechanism), check whether it derives something not already visible on the page such as an implicit threshold recovered from an unconditional rule. A result that instead re-narrates a fact already stated in closed form is a cut. A result that derives something is load-bearing even when verbose, so tighten the prose around it instead.
- A derivation or result used by exactly one downstream argument belongs colocated with that argument, not in a shared section implying broader relevance.
- Describe the current protocol directly. Delete descriptions of superseded intermediate states instead of narrating the history.

An introduction runs shared context, then the problem, then the point.

- A problem has a condition and a cost. State both. The cost is what answers "so what", and without it the reader has no reason to continue.
- A practical problem asks for an action. A conceptual problem asks for an understanding. Say which one you are posing.
- Motivate before you inform. A reader needs a reason to care before they need the facts.

Sections and conclusions:

- Open each section with a short frame, then state its point.
- Order sections chronologically, coordinately with each supporting the thesis equally, or logically with each depending on the last. Pick one and hold it.
- A conclusion restates the point, gives its implications, and echoes the opening.

## Limitations (documents)

Never propose adding a serious caveat to a Limitations section. Raise the concern in chat and let the author decide what a reviewer sees. A caveat naming an unresolved weakness with no answer attached hands reviewers a framing they may not have reached alone. The one thing that may enter the paper is a preemptive rebuttal, a concern stated together with its disposal in the same passage, and only when the author asks for it. The same restraint applies to appendices: keep protocol descriptions brief and skip nuances the reader does not need.
