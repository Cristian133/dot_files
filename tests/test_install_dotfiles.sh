#!/usr/bin/env bash
# Tests for sh/install_dotfiles.sh — TAP output, no external dependencies.
# Run: bash tests/test_install_dotfiles.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SCRIPT="$ROOT_DIR/sh/install_dotfiles.sh"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0
_fail=0

ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

assert_file_exists() {
    local path="$1" label="$2"
    if [[ -f "$path" ]]; then ok "$label"; else not_ok "$label (missing: $path)"; fi
}

assert_dir_exists() {
    local path="$1" label="$2"
    if [[ -d "$path" ]]; then ok "$label"; else not_ok "$label (missing: $path)"; fi
}

assert_same_content() {
    local src="$1" dst="$2" label="$3"
    if diff -q "$src" "$dst" > /dev/null 2>&1; then
        ok "$label"
    else
        not_ok "$label"
        diff "$src" "$dst" | head -5 | sed 's/^/  # /'
    fi
}

assert_exit_nonzero() {
    local label="$1"; shift
    if ! "$@" > /dev/null 2>&1; then ok "$label"; else not_ok "$label (expected failure)"; fi
}

# ---------------------------------------------------------------------------
# Source files and their expected destinations (relative to HOME)
# ---------------------------------------------------------------------------
declare -A DOTFILES=(
    ["git/gitconfig"]=".gitconfig"
    ["nano/nanorc"]=".nanorc"
    ["zsh/zshrc"]=".zshrc"
    ["zsh/alias.sh"]=".alias.sh"
    ["tmux/tmux.conf"]=".tmux.conf"
    ["htop/htoprc"]=".config/htop/htoprc"
)

# ---------------------------------------------------------------------------
# Test 1 — source files exist in the repo
# ---------------------------------------------------------------------------
for src in "${!DOTFILES[@]}"; do
    if [[ -f "$ROOT_DIR/$src" ]]; then
        ok "source file $src exists in repo"
    else
        not_ok "source file $src exists in repo"
    fi
done

# ---------------------------------------------------------------------------
# Helper: run the install script with an isolated HOME
# ---------------------------------------------------------------------------
run_install() {
    local fake_home="$1"
    HOME="$fake_home" bash "$INSTALL_SCRIPT"
}

# ---------------------------------------------------------------------------
# Test 2 — happy path: all files copied, extra dirs created
# ---------------------------------------------------------------------------
FAKE_HOME=$(mktemp -d)
trap 'rm -rf "$FAKE_HOME"' EXIT

# Pre-create the htop config dir (the script does not do this itself)
mkdir -p "$FAKE_HOME/.config/htop"

run_install "$FAKE_HOME"

for src in "${!DOTFILES[@]}"; do
    dst="${DOTFILES[$src]}"
    assert_file_exists "$FAKE_HOME/$dst"   "happy path: $dst is created"
    assert_same_content "$ROOT_DIR/$src" "$FAKE_HOME/$dst" \
        "happy path: $dst content matches source"
done

assert_dir_exists "$FAKE_HOME/.nano"       "happy path: ~/.nano dir is created"
assert_dir_exists "$FAKE_HOME/.cache/zsh"  "happy path: ~/.cache/zsh dir is created"

# ---------------------------------------------------------------------------
# Test 3 — idempotency: running twice produces the same result
# ---------------------------------------------------------------------------
run_install "$FAKE_HOME"

for src in "${!DOTFILES[@]}"; do
    dst="${DOTFILES[$src]}"
    assert_same_content "$ROOT_DIR/$src" "$FAKE_HOME/$dst" \
        "idempotent: $dst unchanged after second run"
done

# ---------------------------------------------------------------------------
# Test 4 — existing destination files are overwritten
# ---------------------------------------------------------------------------
FAKE_HOME2=$(mktemp -d)
trap 'rm -rf "$FAKE_HOME2"' EXIT
mkdir -p "$FAKE_HOME2/.config/htop"

echo "old content" > "$FAKE_HOME2/.gitconfig"
run_install "$FAKE_HOME2"
assert_same_content "$ROOT_DIR/git/gitconfig" "$FAKE_HOME2/.gitconfig" \
    "overwrite: existing .gitconfig is replaced"

# ---------------------------------------------------------------------------
# Test 5 — missing ~/.config/htop/ causes the script to fail
# This documents a known limitation: the script does not create this dir.
# ---------------------------------------------------------------------------
FAKE_HOME3=$(mktemp -d)
trap 'rm -rf "$FAKE_HOME3"' EXIT
# Intentionally do NOT create ~/.config/htop

assert_exit_nonzero \
    "missing ~/.config/htop/ causes non-zero exit" \
    env HOME="$FAKE_HOME3" bash "$INSTALL_SCRIPT"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
