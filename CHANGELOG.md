# Changelog

All notable changes to cast-agents are documented here.

## [0.5.0] — 2026-05-25 — Canonical Sync

Surfaced by the 2026-05-25 CAST ecosystem audit. Brings cast-agents back in line with `claude-agent-team` after several months of one-way drift.

### Added
- `agents/merge.md` — re-introduced from canonical (CAST registry lists `merge` as a haiku 4.5 agent; v0.4.0 removed it as the skill-equivalent shipped, but the standalone agent definition is still canonical).

### Changed
- 6 agents synced to canonical: `commit.md` (Scope Discipline section), `morning-briefing.md` (placeholder email in User-Agent header), `planner.md` (placeholder path in example), `push.md` (ABSOLUTE PROHIBITION git stash section), `researcher.md` (Pre-flight scope check hard rule), `test-runner.md` (pre-existing failure rule).
- Tests + docs-check workflow updated: `22` → `23` agent assertions across `tests/agents.bats`, `tests/install.bats`, and `.github/workflows/docs-check.yml`.

### Fixed
- PR-review workflow: added `id-token: write` permission so `anthropics/claude-code-action` can request an OIDC token.

## [0.4.0] — 2026-05-11 — CAST v7 Sync

**Synced with claude-agent-team v7 (Backend Lockdown).** Agent count: 17 → 22.

### Added
- 7 new agents from CAST v7: `api-contract`, `dep-auditor`, `eval-writer`, `migration-reviewer` (opus model), `perf-sentinel`, `pr-reviewer`, `release-notes`
- Stub `cast-conventions` skill so v7 agents' `skills: [cast-conventions]` frontmatter resolves cleanly for standalone users (real skill ships with CAST framework)
- `install.sh` step that copies the `skills/` directory tree to `~/.claude/skills/`
- 7 new BATS existence tests in `tests/agents.bats`; model validation loop extended to allow `opus`

### Changed
- 15 existing agents synced to CAST v7 spec: front-loaded `Status emission (MANDATORY)` blocks, output caps (`| tail -100`, `git --no-pager`), mandatory `## Handoff` blocks, `## Operational hard rules` git-surgery prohibitions, the de-lied `test-runner` description (Phase 4.11 — agent no longer claims debugger dispatch it can't perform)
- 10 of the synced agents now write to `~/.claude/agent-status/<agent>-<ts>.json` BEFORE prose summaries via `cast_write_status` (truncation resilience, Phase 4.9)

### Removed
- `agents/merge.md` — `/merge` became a skill in CAST v4.5a
- `agents/orchestrator.md` — removed in CAST v6.0 (subagents cannot dispatch further agents — structural limitation)

### Tests
- `tests/agents.bats`: count assertion 17 → 15 → 22 across batches; 31/31 pass

### Notes
- This release is the first cast-agents sync since CAST v4.4 (early April 2026). cast-agents now ships agents that are spec-compatible with CAST v7 — both as a standalone tap and as the agent layer of a CAST install.

## [0.3.0] — 2026-04-06

### Changed

- Synced all 17 agents with upstream CAST v4.4 token efficiency release
- 6 agents downgraded from Sonnet to Haiku: bash-specialist, devops, docs, merge, morning-briefing, test-writer
- All Haiku agents set to `effort: low` (was medium for 6 agents)
- Boilerplate compressed: 4 verbose sections (Event Registration, Context Limit Recovery, Agent Memory, Status Block) replaced with compact 4-line Agent Protocol in all 17 agents (~210 tokens saved per agent)
- Response Budget sections added to all 17 agents
- Orchestrator: added Output Compression Rules, tiered preamble logic (full vs minimal)
- Researcher: added WebFetch Efficiency guidelines and URL caching guidance

### Impact

- ~$23-40/month estimated savings from model downgrades, reduced extended thinking, and prompt compression
- 11 agents on Haiku ($1/MTok), 6 on Sonnet ($3/MTok)

## [0.2.0] — 2026-04-03

### Changed

- Synced `code-reviewer.md` with upstream CAST v4.2 — added `background: true` flag
- Synced `morning-briefing.md` with upstream CAST v4.2 — fixed cast.db path (`~/.claude/cast.db`), updated AppleScript error handling, added `initialPrompt` field, updated description
- Synced `push.md` with upstream CAST v4.2 — added sandbox note for BATS test gate

### Added

- `install.sh` now backs up existing `~/.claude/agents/*.md` files to `~/.claude/backups/cast-agents-<timestamp>/` before overwriting

## [0.1.0] — 2026-04-02

### Added

- 17 Claude Code agent definitions (14 general-purpose, 2 CAST-framework, 1 CAST-enhanced)
- Status block contract (`DONE` | `DONE_WITH_CONCERNS` | `BLOCKED` | `NEEDS_CONTEXT`) for reliable orchestration
- `cast-agents` CLI — `list`, `install`, `info`, `--version` subcommands
- Homebrew formula via `ek33450505/cast-agents` tap (`brew tap ek33450505/cast-agents`)
- `install.sh` manual installer — copies all 17 agents to `~/.claude/agents/` and symlinks CLI
- Morning briefing SDK example (`examples/cast-morning-briefing-sdk.py`)
- Weekly report script example (`examples/cast-weekly-report.sh`)
- BATS test suite — `install.bats`, `cli.bats`, `agents.bats`
- GitHub Actions CI workflow
