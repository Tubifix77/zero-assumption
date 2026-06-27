# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo ships

`zero-assumption` is **not a runtime** — there is no Python/Ollama agent, no build system, no tests.
Released as **v1.0.0**. The deliverable is a *behavioral contract* shipped in two forms that share a
single source file (no build step — the skill loads the contract directly):

- `skills/zero-assumption/references/contract.md` — **the single source of truth.** It is
  simultaneously the portable system prompt (paste into any LLM) and the spec the Claude Code skill
  loads. Self-contained: rules, procedure, memory-ledger schema, citation format, refusals.
- `skills/zero-assumption/SKILL.md` — a thin Claude Code shim that loads and obeys the contract and
  maps its abstract steps to concrete tools (`WebSearch`/`WebFetch`, the ledger path).
- `skills/zero-assumption/assets/memory.template.md` — the empty schema for the runtime memory
  ledger (the ledger itself is runtime state, not committed).
- `dist/zero-assumption.skill` — a **generated** artifact: a renamed `.zip` of
  `skills/zero-assumption/` (folder at the archive root), for upload to Claude Desktop. Built by
  `scripts/build-skill.ps1`. Do not hand-edit it.

### How to edit

Edit **`contract.md` and nowhere else** for any change to the agent's behavior. The rules live only
there; `SKILL.md` must stay a shim with no duplicated rules (this is what keeps the two forms from
drifting). If you change the ledger schema in the contract, mirror it in `assets/memory.template.md`.

After any change under `skills/zero-assumption/`, **rebuild the package** so it doesn't go stale:
`pwsh scripts/build-skill.ps1` (regenerates `dist/zero-assumption.skill`).

## Core principle

`zero-assumption` is an agent that **does not trust itself as a knowledge source — only as a reasoning engine.** Every factual claim must be earned from the net (live lookup), never retrieved from model weights.

The contract realizes this through three rules (full text in `references/contract.md`):

- **Cite or refuse** — every factual claim needs a live, cited lookup *this turn*; otherwise the agent refuses to assert it rather than answering from parametric memory. There is no "fairly sure" tier.
- **The ledger is the only key to skipping a search** — a fresh, registered, `verified` row is the *sole* authorization to reuse a fact. Confidence or "I just looked this up" never qualifies; an unregistered fact is re-researched. So facts are registered the instant they are verified.
- **Volatile facts re-verify; contradictions supersede** — `volatile` entries are re-fetched on every use; a contradicting lookup marks the old row `superseded` and records the new one, never overwriting silently.

When editing this repo, preserve these guarantees — change them in `references/contract.md`, not by loosening the shim.
