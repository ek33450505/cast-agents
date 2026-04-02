# Contributing to cast-agents

Thank you for your interest in cast-agents! This guide covers how to update agent definitions, add new agents, and contribute tests.

## Prerequisites

- **bats-core** — test runner, included as a git submodule at `tests/bats/`
- **Bash 4+** — all scripts target Bash 4 (macOS ships Bash 3; install via `brew install bash`)
- **Claude Code CLI** — for testing agent behavior end-to-end

## Quick Start

```bash
git clone --recurse-submodules https://github.com/ek33450505/cast-agents
cd cast-agents
bash install.sh
tests/bats/bin/bats tests/
```

## Agent File Format

Agent definitions live in `agents/*.md`. Each file has two parts:

1. **YAML frontmatter** (between `---` delimiters) — defines the agent's identity and configuration
2. **Markdown body** — the agent's system prompt

Required frontmatter fields:

| Field | Values | Description |
|---|---|---|
| `name` | string | Agent identifier (must match filename without `.md`) |
| `description` | string | One-line description shown in `cast-agents list` |
| `model` | `haiku` or `sonnet` | Claude model to use |
| `effort` | `low`, `medium`, `high` | Expected task complexity |
| `tools` | list | Tools the agent is allowed to use |

Example:
```yaml
---
name: my-agent
description: "Does something specific well."
tools: Read, Bash, Glob, Grep
model: haiku
effort: low
---
```

## The Status Block Contract

Every agent must end its response with a `Status:` line. This is not optional — orchestrators and the CAST framework depend on it for routing decisions.

Valid values: `DONE` | `DONE_WITH_CONCERNS` | `BLOCKED` | `NEEDS_CONTEXT`

Add this to the end of the agent's system prompt:

```markdown
## Status Block

End every response with one of:

Status: DONE
Status: DONE_WITH_CONCERNS
Status: BLOCKED
Status: NEEDS_CONTEXT
```

## Adding a New Agent

1. Create `agents/<name>.md` with required frontmatter
2. Write the system prompt (be specific about what the agent does and what it does not do)
3. Add the Status block contract at the end
4. Update the agent roster table in `README.md`
5. Add frontmatter validation in `tests/agents.bats`

## Adding a BATS Test

Tests live in `tests/<file>.bats`. Scope:

| File | Scope |
|---|---|
| `tests/install.bats` | install.sh behavior and idempotency |
| `tests/cli.bats` | cast-agents CLI subcommands |
| `tests/agents.bats` | Frontmatter validation for all agent files |

Rules:
- Test exit codes for every CLI subcommand
- Validate required frontmatter fields (name, model, description) for every agent
- Use `skip` guards for system-dependent tests

## PR Checklist

- [ ] `tests/bats/bin/bats tests/` passes locally
- [ ] New agent: frontmatter has required fields (name, model, description, tools, effort)
- [ ] New agent: system prompt ends with Status block contract
- [ ] New agent: added to `README.md` roster table with correct tier (general/cast-framework/cast-enhanced)
- [ ] New agent: frontmatter test added in `tests/agents.bats`
- [ ] `CHANGELOG.md` updated for any user-visible changes
- [ ] No hardcoded absolute paths in agent system prompts — use `$HOME` or env vars
