# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo ships

`zero-assumption` is **not a runtime** — there is no Python/Ollama agent, no build system, no tests.
The deliverable is a *behavioral contract* shipped in two forms, both generated from one source file:

- `skills/zero-assumption/references/contract.md` — **the single source of truth.** It is
  simultaneously the portable system prompt (paste into any LLM) and the spec the Claude Code skill
  loads. Self-contained: rules, procedure, memory-ledger schema, citation format, refusals.
- `skills/zero-assumption/SKILL.md` — a thin Claude Code shim that loads and obeys the contract and
  maps its abstract steps to concrete tools (`WebSearch`/`WebFetch`, the ledger path).
- `skills/zero-assumption/assets/memory.template.md` — the empty schema for the runtime memory
  ledger (the ledger itself is runtime state, not committed).

### How to edit

Edit **`contract.md` and nowhere else** for any change to the agent's behavior. The rules live only
there; `SKILL.md` must stay a shim with no duplicated rules (this is what keeps the two forms from
drifting). If you change the ledger schema in the contract, mirror it in `assets/memory.template.md`.

## Core principle

`zero-assumption` is an agent that **does not trust itself as a knowledge source — only as a reasoning engine.** Every factual claim must be earned from the net (live lookup), never retrieved from model weights.

This is the central design constraint and should shape both how the agent is built and how you work in this repo:

- Treat the model's parametric memory as unreliable for any factual claim. Facts get sourced and verified at runtime, not recalled.
- When implementing features, prefer designs that fetch-then-reason over designs that assume-then-answer.
- The model's role is reasoning, planning, and synthesis over retrieved evidence — not being the evidence.
