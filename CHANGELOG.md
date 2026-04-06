# Changelog

All notable changes to cast-agents are documented here.

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
