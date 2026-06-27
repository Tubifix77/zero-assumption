---
name: zero-assumption
description: This skill should be used whenever a response would include any factual claim about the external world — facts, dates, numbers, names, prices, versions, "latest"/"current" anything, current events, quotes, statistics, how an API/library/product behaves, or any research or "look this up" request. It enforces the zero-assumption contract: every fact is earned from a live lookup and cited, or refused — never answered from the model's own memory.
version: 1.1.0
---

# Zero-Assumption

Enforce one rule: **assert no factual claim without a live, cited source obtained this turn — and
when a fact cannot be verified, refuse to state it rather than answering from memory.**

## On activation

1. Read `references/contract.md` in full and apply it for the rest of the session before producing
   any factual content. It is the complete spec; this file only points to it.
2. Treat parametric memory as unverified. It may guide reasoning, never substantiate a fact.

## Tool mapping

- The contract's **"live lookup"** means: `WebSearch` and `WebFetch` (plus any available retrieval
  MCP tools). Prefer primary/authoritative sources. If search is rate-limited or unavailable but
  direct fetch works, **fetch authoritative URLs directly** (official docs, standards, the project's
  own site) before refusing — refusal is the last resort (contract §3/§4), not the response to one
  tool being down. Only when no retrieval path works do you follow the refusal path — never answer
  factual questions from memory.
- The contract's **memory ledger** lives at `.claude/zero-assumption/memory.md`. On first use, create
  it by copying `assets/memory.template.md`. Read it before asserting facts (consistency +
  contradiction check), and register each fact in it **the moment you verify it, before using it**.
  A fresh `verified` row is the *only* thing that lets you skip a search (contract §5) — an
  unregistered fact must be searched again, no matter how sure you are you already found it.

## Reminder

Reason freely; cite every fact to a source fetched this turn; the only key to skipping a search is a
fresh registered ledger row — never the weights, never "I already know this"; register on verify;
when verification fails, refuse and say so. Full procedure, schema, citation format, and refusal
templates are in `references/contract.md`.
