#!/usr/bin/env bats

REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

setup() {
  export REAL_HOME="$HOME"
  export HOME="$(mktemp -d)"
  export PATH="$REPO_DIR/bin:$PATH"
  export CAST_SKIP_EXAMPLES=1
  export CI=true
}

teardown() {
  rm -rf "$HOME"
  export HOME="$REAL_HOME"
}

@test "install.sh exits 0" {
  run bash "$REPO_DIR/install.sh"
  [ $status -eq 0 ]
}

@test "install is idempotent" {
  run bash "$REPO_DIR/install.sh"
  [ $status -eq 0 ]
  run bash "$REPO_DIR/install.sh"
  [ $status -eq 0 ]
}

@test "~/.claude/agents/ directory is created" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  [ -d "$HOME/.claude/agents" ]
}

@test "all 17 agent .md files are installed" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  count="$(ls "$HOME/.claude/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')"
  [ "$count" -eq 17 ]
}

@test "commit.md is present after install" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  [ -f "$HOME/.claude/agents/commit.md" ]
}

@test "code-reviewer.md is present after install" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  [ -f "$HOME/.claude/agents/code-reviewer.md" ]
}

@test "orchestrator.md is present after install" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  [ -f "$HOME/.claude/agents/orchestrator.md" ]
}

@test "morning-briefing.md is present after install" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  [ -f "$HOME/.claude/agents/morning-briefing.md" ]
}

@test "bin/cast-agents is symlinked to ~/.local/bin/cast-agents" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  [ -L "$HOME/.local/bin/cast-agents" ]
}

@test "cast-agents --version works after install" {
  bash "$REPO_DIR/install.sh" >/dev/null 2>&1
  run cast-agents --version
  [ $status -eq 0 ]
  [[ "$output" == *"0.2.0"* ]]
}
