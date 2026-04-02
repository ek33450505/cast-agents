# Security Policy

## Supported Versions

| Version | Support Status |
|---|---|
| 0.1.x | Full support — security fixes backported |
| < 0.1 | No longer supported |

## Reporting a Vulnerability

**Do NOT open a public GitHub issue for security vulnerabilities.**

Report privately using [GitHub Security Advisories](https://github.com/ek33450505/cast-agents/security/advisories/new).

### What to Include

- **cast-agents version** — output of `cast-agents --version`
- **Operating system** — macOS / Linux, version
- **Which file** — e.g., `install.sh`, `bin/cast-agents`, specific agent definition
- **Steps to reproduce** — minimal, clear reproduction steps
- **Impact** — what an attacker could do

### Response Timeline

| Severity | Acknowledgment | Fix Target |
|---|---|---|
| Critical | 48 hours | 14 days |
| High | 48 hours | 30 days |
| Medium / Low | 5 business days | Next release |

## Security Design Notes

cast-agents is a library of markdown files with no runtime dependencies. Key design decisions:

- **No executables shipped in agents/** — agent definitions are pure markdown/YAML configuration, not executable code
- **No network calls** — `install.sh` and `bin/cast-agents` make no remote requests
- **No settings.json merge** — agents do not wire hooks; there is no hook injection surface
- **install.sh is idempotent** — safe to re-run; copies files, does not execute them
- **CLI is read-only for list/info** — only `install` subcommand writes to `~/.claude/agents/`

## Out of Scope

- Vulnerabilities in the Claude API or Anthropic services — report to [Anthropic](https://www.anthropic.com/security)
- Vulnerabilities in third-party tools (bash, Homebrew)
- Issues requiring physical access to the machine
- Agent system prompt content — prompts are configuration, not security boundaries
