#!/usr/bin/env bats

REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

setup_file() {
  export SHARED_HOME="$(mktemp -d)"
  CI=true CAST_SKIP_EXAMPLES=1 HOME="$SHARED_HOME" bash "$REPO_DIR/install.sh" >/dev/null 2>&1
}

teardown_file() {
  rm -rf "$SHARED_HOME"
}

setup() {
  export HOME="$SHARED_HOME"
  export PATH="$REPO_DIR/bin:$PATH"
}

@test "--version exits 0 and shows 0.2.0" {
  run cast-agents --version
  [ $status -eq 0 ]
  [[ "$output" == *"0.2.0"* ]]
}

@test "--help exits 0" {
  run cast-agents --help
  [ $status -eq 0 ]
}

@test "list exits 0" {
  run cast-agents list
  [ $status -eq 0 ]
}

@test "list output contains 'commit'" {
  run cast-agents list
  [ $status -eq 0 ]
  [[ "$output" == *"commit"* ]]
}

@test "list output contains 'haiku'" {
  run cast-agents list
  [ $status -eq 0 ]
  [[ "$output" == *"haiku"* ]]
}

@test "list output contains 'sonnet'" {
  run cast-agents list
  [ $status -eq 0 ]
  [[ "$output" == *"sonnet"* ]]
}

@test "info commit exits 0 and outputs frontmatter" {
  run cast-agents info commit
  [ $status -eq 0 ]
  [[ "$output" == *"name"* ]]
}

@test "install commit installs commit.md to ~/.claude/agents/" {
  run cast-agents install commit
  [ $status -eq 0 ]
  [ -f "$HOME/.claude/agents/commit.md" ]
}

@test "install (no args) installs all agents" {
  run cast-agents install
  [ $status -eq 0 ]
  [ -f "$HOME/.claude/agents/code-reviewer.md" ]
  [ -f "$HOME/.claude/agents/orchestrator.md" ]
}

@test "info nonexistent-agent exits non-zero" {
  run cast-agents info this-does-not-exist
  [ $status -ne 0 ]
}

@test "unknown subcommand exits non-zero" {
  run cast-agents bogus-subcommand
  [ $status -ne 0 ]
}
