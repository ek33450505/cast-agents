---
name: cast-conventions
description: Stub skill for standalone cast-agents users. CAST framework users get the full version automatically.
user-invocable: false
---

# cast-conventions (Stub)

This is a **stub** for standalone `cast-agents` users.

## Why this file exists

Several agents in this package declare `skills: [cast-conventions]` in their
frontmatter. That reference is resolved by the Claude Code agent runner at
dispatch time. Without a matching skill file at `~/.claude/skills/cast-conventions/SKILL.md`,
the runner logs a warning and continues — your agents still work, but the
warning is noisy.

This stub silences the warning.

## What the real skill does

The full `cast-conventions` skill ships with the
[CAST framework](https://github.com/ek33450505/claude-agent-team). It injects
shared agent protocol rules (status block format, commit conventions, error
routing, code-review gates, facts emission) into every agent at dispatch time.

## As a standalone cast-agents user

Your agents are self-contained — the conventions are already baked into each
agent's own instructions. You do not need the CAST framework for the agents
to work correctly. This stub exists only to satisfy the skill reference
cleanly.

If you want the full CAST framework (recommended for power users building
multi-agent pipelines), see:
https://github.com/ek33450505/claude-agent-team
