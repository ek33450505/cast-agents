# cast-agents

[![CI](https://github.com/ek33450505/cast-agents/actions/workflows/ci.yml/badge.svg)](https://github.com/ek33450505/cast-agents/actions/workflows/ci.yml)
![version](https://img.shields.io/badge/version-0.3.0-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)
![agents](https://img.shields.io/badge/agents-17-purple)

17 specialist Claude Code agent definitions. Drop them into `~/.claude/agents/` and they are immediately available in any Claude Code session. Commit, review, debug, plan, research, test — each task goes to the right expert.

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
| `bash-specialist` | haiku | low | Complex shell scripts, debugging Bash, BATS tests |
| `code-reviewer` | haiku | low | Immediate post-change code review |
| `code-writer` | sonnet | high | Feature implementation, refactors, bug fixes |
| `commit` | haiku | low | Semantic git commit message generation |
| `debugger` | sonnet | high | Error triage, root cause analysis, fixes |
| `devops` | haiku | low | CI/CD, Docker, shell automation, deployments |
| `docs` | haiku | low | Documentation, changelogs, README files |
| `frontend-qa` | haiku | low | UI component review and accessibility checks |
| `merge` | haiku | low | Git merges, rebases, conflict resolution |
| `push` | haiku | low | Safe git push with pre-push validation |
| `researcher` | sonnet | high | Deep investigation, multi-step analysis |
| `security` | sonnet | medium | Security audits, vulnerability assessment |
| `test-runner` | haiku | low | Run test suites, report failures |
| `test-writer` | haiku | low | Write tests for new features and edge cases |

### CAST framework agents

Require the CAST orchestrator and Agent Dispatch Manifest (ADM) format. See [claude-agent-team](https://github.com/ek33450505/claude-agent-team) for the full framework.

| Agent | Model | Effort | What it does |
|---|---|---|---|
| `orchestrator` | sonnet | high | Execute multi-agent plans from ADM manifests |
| `planner` | sonnet | high | Write structured plans with Agent Dispatch Manifests |

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

Haiku agents handle high-frequency, low-complexity tasks — commit messages, code review, push validation, running tests, doc writing, merge operations, shell scripting, devops, morning briefings, and test writing. Sonnet agents handle reasoning-heavy work — writing code, debugging, planning, research, security review, and orchestration. The 11 haiku / 6 sonnet split and the 12x cost difference between models makes this worth understanding before you dispatch everything to sonnet.

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

These agents are extracted from [CAST](https://github.com/ek33450505/claude-agent-team) — a full multi-agent framework built on Claude Code with orchestration, hooks, observability (cast.db), and automated plan execution. If you want the complete framework — including the `orchestrator` and `planner` agents working at full capacity, plus CI hooks and a dashboard — install CAST.

cast-agents is for teams and individuals who want the specialized agents without the full framework.

## CAST Ecosystem

Each CAST component ships as a standalone Homebrew package. Mix and match to build your own stack.

| Package | What It Does | Install |
|---------|-------------|---------|
| **cast-agents** | 17 specialist Claude Code agents | `brew tap ek33450505/cast-agents && brew install cast-agents` |
| [cast-hooks](https://github.com/ek33450505/cast-hooks) | 13 hook scripts — observability, safety gates, dispatch | `brew tap ek33450505/cast-hooks && brew install cast-hooks` |
| [cast-observe](https://github.com/ek33450505/cast-observe) | Session cost + token spend tracking | `brew tap ek33450505/cast-observe && brew install cast-observe` |
| [cast-security](https://github.com/ek33450505/cast-security) | Policy gates, PII redaction, audit trail | `brew tap ek33450505/cast-security && brew install cast-security` |
| [cast-dash](https://github.com/ek33450505/cast-dash) | Terminal UI dashboard (Python + Textual) | `brew tap ek33450505/cast-dash && brew install cast-dash` |
| [cast-memory](https://github.com/ek33450505/cast-memory) | Persistent memory for Claude Code agents | `brew tap ek33450505/cast-memory && brew install cast-memory` |
| [cast-parallel](https://github.com/ek33450505/cast-parallel) | Parallel plan execution across dual worktrees | `brew tap ek33450505/cast-parallel && brew install cast-parallel` |

## License

MIT — see [LICENSE](LICENSE)
