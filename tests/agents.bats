#!/usr/bin/env bats

REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
AGENTS_DIR="$REPO_DIR/agents"

# ── Frontmatter helpers ────────────────────────────────────────────────────────

_has_field() {
  local file="$1"
  local field="$2"
  grep -q "^${field}:" "$file" 2>/dev/null
}

_get_model() {
  grep -m1 '^model:' "$1" 2>/dev/null | sed 's/model:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# ── File presence ──────────────────────────────────────────────────────────────

@test "all 22 agent files are present" {
  count="$(ls "$AGENTS_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')"
  [ "$count" -eq 22 ]
}

@test "commit.md exists" {
  [ -f "$AGENTS_DIR/commit.md" ]
}

@test "code-reviewer.md exists" {
  [ -f "$AGENTS_DIR/code-reviewer.md" ]
}

@test "code-writer.md exists" {
  [ -f "$AGENTS_DIR/code-writer.md" ]
}


@test "planner.md exists" {
  [ -f "$AGENTS_DIR/planner.md" ]
}

@test "debugger.md exists" {
  [ -f "$AGENTS_DIR/debugger.md" ]
}

@test "morning-briefing.md exists" {
  [ -f "$AGENTS_DIR/morning-briefing.md" ]
}

@test "api-contract.md exists" {
  [ -f "$AGENTS_DIR/api-contract.md" ]
}

@test "dep-auditor.md exists" {
  [ -f "$AGENTS_DIR/dep-auditor.md" ]
}

@test "eval-writer.md exists" {
  [ -f "$AGENTS_DIR/eval-writer.md" ]
}

@test "migration-reviewer.md exists" {
  [ -f "$AGENTS_DIR/migration-reviewer.md" ]
}

@test "perf-sentinel.md exists" {
  [ -f "$AGENTS_DIR/perf-sentinel.md" ]
}

@test "pr-reviewer.md exists" {
  [ -f "$AGENTS_DIR/pr-reviewer.md" ]
}

@test "release-notes.md exists" {
  [ -f "$AGENTS_DIR/release-notes.md" ]
}

# ── Frontmatter: commit.md ─────────────────────────────────────────────────────

@test "commit.md has name field" {
  _has_field "$AGENTS_DIR/commit.md" "name"
}

@test "commit.md has model field" {
  _has_field "$AGENTS_DIR/commit.md" "model"
}

@test "commit.md has description field" {
  _has_field "$AGENTS_DIR/commit.md" "description"
}

@test "commit.md uses haiku model" {
  model="$(_get_model "$AGENTS_DIR/commit.md")"
  [ "$model" = "haiku" ]
}

# ── Frontmatter: code-writer.md ────────────────────────────────────────────────

@test "code-writer.md has name field" {
  _has_field "$AGENTS_DIR/code-writer.md" "name"
}

@test "code-writer.md has model field" {
  _has_field "$AGENTS_DIR/code-writer.md" "model"
}

@test "code-writer.md has description field" {
  _has_field "$AGENTS_DIR/code-writer.md" "description"
}

@test "code-writer.md uses sonnet model" {
  model="$(_get_model "$AGENTS_DIR/code-writer.md")"
  [ "$model" = "sonnet" ]
}

# ── Frontmatter: code-reviewer.md ─────────────────────────────────────────────

@test "code-reviewer.md has name field" {
  _has_field "$AGENTS_DIR/code-reviewer.md" "name"
}

@test "code-reviewer.md has model field" {
  _has_field "$AGENTS_DIR/code-reviewer.md" "model"
}

@test "code-reviewer.md has description field" {
  _has_field "$AGENTS_DIR/code-reviewer.md" "description"
}

@test "code-reviewer.md uses haiku model" {
  model="$(_get_model "$AGENTS_DIR/code-reviewer.md")"
  [ "$model" = "haiku" ]
}


# ── Frontmatter: debugger.md ───────────────────────────────────────────────────

@test "debugger.md has name field" {
  _has_field "$AGENTS_DIR/debugger.md" "name"
}

@test "debugger.md has model field" {
  _has_field "$AGENTS_DIR/debugger.md" "model"
}

@test "debugger.md has description field" {
  _has_field "$AGENTS_DIR/debugger.md" "description"
}

@test "debugger.md uses sonnet model" {
  model="$(_get_model "$AGENTS_DIR/debugger.md")"
  [ "$model" = "sonnet" ]
}

# ── Model values are valid ─────────────────────────────────────────────────────

@test "all agents use haiku, sonnet, or opus model" {
  for f in "$AGENTS_DIR"/*.md; do
    model="$(_get_model "$f")"
    [ "$model" = "haiku" ] || [ "$model" = "sonnet" ] || [ "$model" = "opus" ]
  done
}
