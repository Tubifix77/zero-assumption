# zero-assumption

> **v1.0.0** · MIT License · https://github.com/Tubifix77/zero-assumption

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

## Install & use

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

### Claude Desktop

Download the prebuilt skill package **[`dist/zero-assumption.skill`](dist/zero-assumption.skill)**
(a renamed `.zip` of the skill folder, which is the format the Claude apps accept). Then:

1. **Settings → Capabilities**: enable **Code execution** (required for custom skills).
2. **Customize → Skills → "+" → "+ Create skill" → Upload a skill**, and choose
   `zero-assumption.skill`.
3. **Restart Claude Desktop.** The skill is only indexed on reload — until you restart it will not
   appear and cannot be invoked.
4. Verify it shows up in your skills list. It then activates on factual requests (or invoke it
   explicitly).

> Note: Desktop skills are model-invoked from their description, not run as `/slash` commands. Also,
> the memory ledger needs a writable, persistent path; on Desktop it runs in the code-execution
> sandbox, so the ledger may not persist across separate conversations.

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

## License

[MIT](LICENSE) © 2026 Tubifix77
