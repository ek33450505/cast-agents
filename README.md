# cast-agents

[![CI](https://github.com/ek33450505/cast-agents/actions/workflows/ci.yml/badge.svg)](https://github.com/ek33450505/cast-agents/actions/workflows/ci.yml)
![version](https://img.shields.io/badge/version-0.4.0-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)
![agents](https://img.shields.io/badge/agents-22-purple)

22 specialist Claude Code agent definitions. Drop them into `~/.claude/agents/` and they are immediately available in any Claude Code session. Commit, review, debug, plan, research, test — each task goes to the right expert.

## What you get

Every agent is a markdown file with a YAML frontmatter block that Claude Code reads as a named sub-agent. Dispatch any agent by name from within a session:

> "Use the code-reviewer agent to review my changes"
> "Dispatch the debugger agent to fix this TypeScript error"
> "Use the researcher agent to analyze this architectural question"

Agents handle one concern well, use the right model for the job (haiku for speed, sonnet for reasoning), and always end with a structured `Status:` block so orchestrators can route their output reliably.

## Install

### Homebrew

```bash
brew tap ek33450505/cast-agents
brew install cast-agents
cast-agents install
```

### Manual

```bash
git clone --recurse-submodules https://github.com/ek33450505/cast-agents.git
cd cast-agents
bash install.sh
```

## Agent roster

### General-purpose agents

Work standalone with any Claude Code setup — no CAST framework required.

| Agent | Model | Effort | What it does |
|---|---|---|---|
| `api-contract` | sonnet | medium | API contract guardian. Detects breaking changes in REST endpoints, compares route signatures and response shapes, generates OpenAPI-style diffs |
| `bash-specialist` | haiku | low | Complex shell scripts, debugging Bash, BATS tests |
| `code-reviewer` | haiku | low | Immediate post-change code review |
| `code-writer` | sonnet | high | Feature implementation, refactors, bug fixes |
| `commit` | haiku | low | Semantic git commit message generation |
| `debugger` | sonnet | high | Error triage, root cause analysis, fixes |
| `dep-auditor` | haiku | low | Dependency auditor. Reviews package changes for transitive risk, known CVEs, version compatibility, and license concerns |
| `devops` | haiku | low | CI/CD, Docker, shell automation, deployments |
| `docs` | haiku | low | Documentation, changelogs, README files |
| `eval-writer` | sonnet | medium | Eval and benchmark fixture author for Claude API and CAST agent prompts. Generates regression fixtures that catch prompt-level behavior drift |
| `frontend-qa` | haiku | low | UI component review and accessibility checks |
| `migration-reviewer` | opus | high | Database schema change reviewer. Analyzes migration files for safety, generates rollback plans, validates ordering, and checks for data-loss risks |
| `perf-sentinel` | sonnet | medium | Performance regression detector. Runs benchmarks, interprets results in context of recent changes, and suggests git bisect targets |
| `planner` | sonnet | high | Write structured plans with Agent Dispatch Manifests |
| `pr-reviewer` | sonnet | medium | Holistic pull-request reviewer. Reads the full diff, commit history, and linked issues at PR-open time |
| `push` | haiku | low | Safe git push with pre-push validation |
| `release-notes` | haiku | low | Release notes generator. Creates structured changelogs from git commits, resolved issues, and breaking changes between two refs |
| `researcher` | sonnet | high | Deep investigation, multi-step analysis |
| `security` | sonnet | medium | Security audits, vulnerability assessment |
| `test-runner` | haiku | low | Run test suites, report failures |
| `test-writer` | haiku | low | Write tests for new features and edge cases |

### CAST-enhanced agents

Work standalone, but produce richer output when the CAST observability database (`cast.db`) is present.

| Agent | Model | Effort | What it does |
|---|---|---|---|
| `morning-briefing` | haiku | low | Daily briefing: git activity, plans, session summary |

## The Status block contract

Every agent ends its response with a structured Status block:

```
Status: DONE
Summary: Reviewed 3 files, found 2 issues, both addressed.
```

Valid values:

| Status | Meaning |
|---|---|
| `DONE` | Task completed successfully |
| `DONE_WITH_CONCERNS` | Completed, but human attention needed on something |
| `BLOCKED` | Cannot proceed — missing input, permission, or context |
| `NEEDS_CONTEXT` | Stopped to ask a clarifying question before continuing |

This contract is what makes automated orchestration reliable. The orchestrator reads the Status line to decide whether to continue, retry, or stop and wait for human intervention — no natural language parsing required.

Example `DONE_WITH_CONCERNS`:
```
Status: DONE_WITH_CONCERNS
Summary: Tests written for 5 functions.
Concerns: coverage/auth.ts is at 61% — below the 80% threshold. Consider adding edge case tests for token expiry.
```

## Model selection rationale

Haiku agents handle high-frequency, low-complexity tasks — commit messages, code review, push validation, running tests, doc writing, shell scripting, devops, morning briefings, dep auditing, release notes, and test writing. Sonnet agents handle reasoning-heavy work — writing code, debugging, planning, research, security review, API contracts, eval writing, PR review, and performance analysis. Opus is reserved for migration-reviewer, where the cost of a missed data-loss risk outweighs the model price difference. The 12 haiku / 9 sonnet / 1 opus split and the cost differences between models makes this worth understanding before you dispatch everything to sonnet.

Rule of thumb: if the task requires reading and deciding (not reading and writing), start with haiku.

## Usage examples

```
# After implementing a feature:
"Use the commit agent to commit my staged changes"

# After writing code:
"Use the code-reviewer agent to review the changes in src/api/"

# When something breaks:
"Dispatch the debugger agent — getting TypeError: Cannot read property 'id' of undefined in line 42"

# Before a complex task:
"Use the planner agent to write a plan for refactoring the auth module"

# Research question:
"Use the researcher agent to analyze tradeoffs between JWT and session-based auth for our stack"
```

## Works with CAST

These agents are extracted from [CAST](https://github.com/ek33450505/claude-agent-team) — a full multi-agent framework built on Claude Code with orchestration, hooks, observability (cast.db), and automated plan execution. If you want the complete framework — including the `planner` agent working at full capacity with ADM manifests, plus CI hooks and a dashboard — install CAST.

cast-agents is for teams and individuals who want the specialized agents without the full framework.

## The CAST Ecosystem

CAST is distributed as a constellation of independently-installable packages — pick what you need. All are MIT-licensed and Homebrew-tappable.

| Repo | One line |
|---|---|
| [claude-agent-team](https://github.com/ek33450505/claude-agent-team) | The full CAST framework — agents, hooks, routines, observability |
| [cast-agents](https://github.com/ek33450505/cast-agents) | 22 specialist agents (commit, debug, review, plan, test, research, …) ← **you are here** |
| [cast-hooks](https://github.com/ek33450505/cast-hooks) | 13 hook scripts — observability, safety gates, dispatch |
| [cast-memory](https://github.com/ek33450505/cast-memory) | Persistent agent memory with FTS5 search + MCP server |
| [cast-observe](https://github.com/ek33450505/cast-observe) | Session cost + token-spend tracking |
| [cast-security](https://github.com/ek33450505/cast-security) | Policy gates, PII redaction, audit trail |
| [cast-dash](https://github.com/ek33450505/cast-dash) | Terminal UI dashboard (Python + Textual) |
| [cast-parallel](https://github.com/ek33450505/cast-parallel) | Plan execution split across parallel git worktrees |
| [cast-claudes_journal](https://github.com/ek33450505/cast-claudes_journal) | Cross-session continuity via Obsidian vault |
| [cast-routines](https://github.com/ek33450505/cast-routines) | Scheduled Claude Code routines via YAML + cron |
| [cast-time](https://github.com/ek33450505/cast-time) | SessionStart hook injecting local time + timezone |
| [cast-doctor](https://github.com/ek33450505/cast-doctor) | Read-only health check for any Claude Code install |

## License

MIT — see [LICENSE](LICENSE)
