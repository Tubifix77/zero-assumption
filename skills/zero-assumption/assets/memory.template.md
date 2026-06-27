# Zero-Assumption Memory Ledger

Every row is a fact earned from a live lookup and trusted *only* because it carries a source.
Never add a fact from memory. See the `zero-assumption` contract §5 for read/validate/write,
staleness, and the contradiction protocol.

- **claim** — short, stable identifier for the fact
- **value** — the verified answer
- **source** — URL or identifier that substantiates it
- **retrieved** — ISO date (YYYY-MM-DD) fetched
- **freshness** — `volatile` (re-verify every use) or `stable` (reuse while verified)
- **status** — `verified` (trusted) or `superseded` (history only, not reused)

| claim | value | source | retrieved | freshness | status |
|-------|-------|--------|-----------|-----------|--------|
