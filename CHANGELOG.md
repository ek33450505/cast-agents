# Changelog

All notable changes to cast-agents are documented here.

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
