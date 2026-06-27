# zero-assumption

> **v1.0.0** · https://github.com/Tubifix77/zero-assumption

An agent that doesn't trust itself as a knowledge source — only as a reasoning engine. Never assume
to know. Every factual claim is earned from the net (a live lookup) and cited, or refused — never
retrieved from model weights.

`zero-assumption` is **not a program.** It is a behavioral contract that needs no runtime — any
capable LLM or agent already has the tools to execute it. So it ships in two forms, from one source:

- **A portable system prompt** you can paste into any LLM/agent.
- **A Claude Code skill** that fires automatically and enforces the contract using Claude Code's own
  `WebSearch`/`WebFetch`.

Both are the *same* file — [`skills/zero-assumption/references/contract.md`](skills/zero-assumption/references/contract.md) —
so they cannot drift.

## How to use

### Any LLM or agent

Paste the contents of [`skills/zero-assumption/references/contract.md`](skills/zero-assumption/references/contract.md)
as the system prompt. The contract is self-contained (rules, procedure, memory-ledger schema,
citation format, and refusal templates are all inside it). The host just needs a way to look things
up and a place to write a markdown file.

### Claude Code

Copy the `skills/zero-assumption/` folder into `~/.claude/skills/` (available everywhere) or a
project's `.claude/skills/` (that project only). For example:

```bash
git clone https://github.com/Tubifix77/zero-assumption
cp -r zero-assumption/skills/zero-assumption ~/.claude/skills/
```

Claude Code auto-discovers it; the skill triggers whenever a response would include a factual claim.

## The memory ledger

While running, the agent maintains a **memory ledger** — a markdown file of facts it has earned from
the net, each stored with its source and retrieval date. It is the one memory the agent trusts,
*because every entry is cited* (the opposite of parametric memory). It does two jobs:

- **Consistency store** — repeated lookups resolve to the same recorded value and source.
- **Validator** — new claims are checked against it; contradictions are surfaced and resolved
  (old entry marked `superseded`), never silently overwritten.

It is also a **hard gate**: a fresh, registered entry is the *only* thing that lets the agent skip a
search. The model's belief that it "already knows" or "just looked something up" counts for nothing —
if a fact isn't in the ledger, it gets researched again. So every fact is registered the instant it's
verified; the cost of forgetting is a redundant search, never an unsourced claim.

The ledger is **runtime state**, not a shipped file. The agent creates it at
`./zero-assumption-memory.md` (standalone) or `.claude/zero-assumption/memory.md` (Claude Code),
seeded from [`skills/zero-assumption/assets/memory.template.md`](skills/zero-assumption/assets/memory.template.md).

## Editing

There is a single source of truth: **edit
[`contract.md`](skills/zero-assumption/references/contract.md) and nowhere else.** `SKILL.md` is a
thin shim that loads it; the asset is just the ledger's empty schema.
