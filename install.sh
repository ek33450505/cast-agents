#!/bin/bash
# install.sh — cast-agents manual installer
# For users who clone the repo instead of using Homebrew.
# Completes in under 30 seconds.
#
# Usage: bash install.sh

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CA_VERSION="$(cat "${REPO_DIR}/VERSION" 2>/dev/null || echo "unknown")"

# ── Colors ────────────────────────────────────────────────────────────────────
if [ -t 1 ] && [ "${TERM:-}" != "dumb" ]; then
  C_BOLD='\033[1m'
  C_GREEN='\033[0;32m'
  C_YELLOW='\033[0;33m'
  C_RED='\033[0;31m'
  C_RESET='\033[0m'
else
  C_BOLD='' C_GREEN='' C_YELLOW='' C_RED='' C_RESET=''
fi

_ok()   { printf "${C_GREEN}  [ok]${C_RESET} %s\n" "$*"; }
_warn() { printf "${C_YELLOW}  [warn]${C_RESET} %s\n" "$*" >&2; }
_fail() { printf "${C_RED}  [fail]${C_RESET} %s\n" "$*" >&2; }
_step() { printf "\n${C_BOLD}%s${C_RESET}\n" "$*"; }

# ── Banner ────────────────────────────────────────────────────────────────────
printf "\n${C_BOLD}cast-agents v${CA_VERSION} installer${C_RESET}\n"
printf "══════════════════════════════════════\n\n"

# ── Step 1: Check prerequisites ───────────────────────────────────────────────
_step "Checking prerequisites..."
# No hard dependencies — agents are pure markdown files
_ok "No required dependencies (agents are pure markdown)"

# ── Step 2: Create agent directory ────────────────────────────────────────────
_step "Creating directories..."
AGENTS_DST="${HOME}/.claude/agents"
BACKUP_DIR="${HOME}/.claude/backups/cast-agents-$(date +%Y%m%d-%H%M%S)"
if mkdir -p "$AGENTS_DST" 2>/dev/null; then
  _ok "~/.claude/agents/"
else
  _fail "Could not create ~/.claude/agents/ — check permissions"
  exit 1
fi

# ── Step 2b: Backup existing agents ──────────────────────────────────────────
if ls "${AGENTS_DST}"/*.md 2>/dev/null | head -1 | grep -q .; then
  if mkdir -p "$BACKUP_DIR" 2>/dev/null && cp "${AGENTS_DST}"/*.md "$BACKUP_DIR/" 2>/dev/null; then
    _ok "Backed up existing agents to ${BACKUP_DIR}"
  else
    _warn "Could not create backup — continuing without backup"
  fi
fi

# ── Step 3: Copy agent files ──────────────────────────────────────────────────
_step "Installing agent definitions..."
copied=0
errors=0
for f in "${REPO_DIR}/agents/"*.md; do
  [ -f "$f" ] || continue
  base="$(basename "$f")"
  dest="${AGENTS_DST}/${base}"
  if cp "$f" "$dest" 2>/dev/null; then
    _ok "${base}"
    copied=$((copied + 1))
  else
    _fail "Could not copy ${base}"
    errors=$((errors + 1))
  fi
done

if [ "$copied" -eq 0 ]; then
  _fail "No agent files found in ${REPO_DIR}/agents/"
  exit 1
fi

if [ "$errors" -gt 0 ]; then
  _warn "${errors} agent(s) failed to copy — check permissions on ~/.claude/agents/"
fi

# ── Step 4: Optionally copy examples ─────────────────────────────────────────
_step "Example scripts..."
EXAMPLES_SRC="${REPO_DIR}/examples"
EXAMPLES_DST="${HOME}/.claude/scripts"

if [ "${CI:-}" = "true" ] || [ "${CAST_SKIP_EXAMPLES:-}" = "1" ]; then
  _ok "Skipping (CI=true or CAST_SKIP_EXAMPLES=1)"
else
  printf "  Copy example scripts to ~/.claude/scripts/? [Y/n] "
  read -r reply 2>/dev/null || reply="n"
  case "${reply}" in
    [Yy]*|"")
      mkdir -p "$EXAMPLES_DST"
      for f in "${EXAMPLES_SRC}"/*; do
        [ -f "$f" ] || continue
        base="$(basename "$f")"
        if cp "$f" "${EXAMPLES_DST}/${base}" 2>/dev/null; then
          chmod +x "${EXAMPLES_DST}/${base}" 2>/dev/null || true
          _ok "${base} → ~/.claude/scripts/"
        else
          _warn "Could not copy ${base}"
        fi
      done
      ;;
    *)
      _ok "Skipped — run manually: cp ${EXAMPLES_SRC}/* ~/.claude/scripts/"
      ;;
  esac
fi

# ── Step 5: Symlink CLI ────────────────────────────────────────────────────────
_step "Installing CLI..."
LOCAL_BIN="${HOME}/.local/bin"
CLI_SRC="${REPO_DIR}/bin/cast-agents"
CLI_DST="${LOCAL_BIN}/cast-agents"

if mkdir -p "$LOCAL_BIN" 2>/dev/null; then
  if ln -sf "$CLI_SRC" "$CLI_DST" 2>/dev/null; then
    _ok "cast-agents → ~/.local/bin/cast-agents"
    if ! echo "$PATH" | grep -q "${LOCAL_BIN}"; then
      printf "\n  ${C_YELLOW}Note:${C_RESET} Add ~/.local/bin to your PATH:\n"
      printf "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc\n"
    fi
  else
    _warn "Could not symlink to ~/.local/bin — run from repo: ${CLI_SRC}"
  fi
else
  _warn "Could not create ~/.local/bin — run from repo: ${CLI_SRC}"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n${C_BOLD}══════════════════════════════════════${C_RESET}\n"
printf "${C_GREEN}cast-agents v${CA_VERSION} installed.${C_RESET}\n\n"
printf "  Agents:  ${HOME}/.claude/agents/ (${copied} files)\n"
printf "  CLI:     ${CLI_DST}\n"
printf "\n${C_BOLD}Next steps:${C_RESET}\n"
printf "  1. Start Claude Code\n"
printf "  2. Run: cast-agents list\n"
printf "  3. Dispatch an agent: \"Use the code-reviewer agent to review my changes\"\n\n"
