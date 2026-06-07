#!/usr/bin/env bash
# Tests for sh/install_vim.sh — TAP output, no external dependencies.
# Run: bash tests/test_install_vim.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SCRIPT="$ROOT_DIR/sh/install_vim.sh"

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
# Source files expected to exist in the repo
# ---------------------------------------------------------------------------
SOURCE_FILES=(
    "vim/vimrc"
    "vim/hybrid.vim"
    "vim/vim-sml/LICENSE"
    "vim/vim-sml/after/syntax/sml.vim"
    "vim/vim-sml/ftdetect/sml.vim"
    "vim/vim-sml/ftplugin/sml.vim"
    "vim/vim-sml/ftplugin/mlbasis.vim"
    "vim/vim-sml/ftplugin/mllex.vim"
    "vim/vim-sml/ftplugin/smlcm.vim"
    "vim/vim-sml/indent/sml.vim"
    "vim/vim-sml/indent/smlcm.vim"
    "vim/vim-sml/syntax/sml.vim"
    "vim/vim-sml/syntax/mlbasis.vim"
    "vim/vim-sml/syntax/mllex.vim"
    "vim/vim-sml/syntax/smackspec.vim"
    "vim/vim-sml/syntax/smlcm.vim"
)

# ---------------------------------------------------------------------------
# Test 1 — source files exist in the repo
# ---------------------------------------------------------------------------
for src in "${SOURCE_FILES[@]}"; do
    if [[ -f "$ROOT_DIR/$src" ]]; then
        ok "source $src exists in repo"
    else
        not_ok "source $src exists in repo"
    fi
done

# ---------------------------------------------------------------------------
# Helper: run the install script with an isolated HOME, from repo root
# ---------------------------------------------------------------------------
run_install() {
    local fake_home="$1"
    HOME="$fake_home" bash "$INSTALL_SCRIPT"
}

# ---------------------------------------------------------------------------
# Test 2 — happy path (run from repo root)
# ---------------------------------------------------------------------------
FAKE_HOME=$(mktemp -d)
trap 'rm -rf "$FAKE_HOME"' EXIT

run_install "$FAKE_HOME"

# ~/.vim subdirs created
for dir in backups colors swaps undo; do
    assert_dir_exists "$FAKE_HOME/.vim/$dir" "happy path: ~/.vim/$dir created"
done

# vimrc copied
assert_file_exists "$FAKE_HOME/.vimrc"               "happy path: ~/.vimrc created"
assert_same_content "$ROOT_DIR/vim/vimrc" "$FAKE_HOME/.vimrc" \
    "happy path: ~/.vimrc content matches source"

# hybrid colorscheme copied
assert_file_exists "$FAKE_HOME/.vim/colors/hybrid.vim" \
    "happy path: ~/.vim/colors/hybrid.vim created"
assert_same_content "$ROOT_DIR/vim/hybrid.vim" "$FAKE_HOME/.vim/colors/hybrid.vim" \
    "happy path: hybrid.vim content matches source"

# vim-sml files copied into ~/.vim/
VIM_SML_FILES=(
    "LICENSE"
    "after/syntax/sml.vim"
    "ftdetect/sml.vim"
    "ftplugin/sml.vim"
    "ftplugin/mlbasis.vim"
    "ftplugin/mllex.vim"
    "ftplugin/smlcm.vim"
    "indent/sml.vim"
    "indent/smlcm.vim"
    "syntax/sml.vim"
    "syntax/mlbasis.vim"
    "syntax/mllex.vim"
    "syntax/smackspec.vim"
    "syntax/smlcm.vim"
)

for f in "${VIM_SML_FILES[@]}"; do
    assert_file_exists "$FAKE_HOME/.vim/$f" "happy path: vim-sml $f copied to ~/.vim/"
    assert_same_content "$ROOT_DIR/vim/vim-sml/$f" "$FAKE_HOME/.vim/$f" \
        "happy path: vim-sml $f content matches source"
done

# ---------------------------------------------------------------------------
# Test 3 — idempotency: running twice produces the same result
# ---------------------------------------------------------------------------
run_install "$FAKE_HOME"

assert_same_content "$ROOT_DIR/vim/vimrc" "$FAKE_HOME/.vimrc" \
    "idempotent: ~/.vimrc unchanged after second run"
assert_same_content "$ROOT_DIR/vim/hybrid.vim" "$FAKE_HOME/.vim/colors/hybrid.vim" \
    "idempotent: hybrid.vim unchanged after second run"

# ---------------------------------------------------------------------------
# Test 4 — existing ~/.vimrc is overwritten
# ---------------------------------------------------------------------------
FAKE_HOME2=$(mktemp -d)
trap 'rm -rf "$FAKE_HOME2"' EXIT

echo "old content" > "$FAKE_HOME2/.vimrc"
run_install "$FAKE_HOME2"
assert_same_content "$ROOT_DIR/vim/vimrc" "$FAKE_HOME2/.vimrc" \
    "overwrite: stale ~/.vimrc is replaced"

# ---------------------------------------------------------------------------
# Test 5 — fails when run from wrong directory (relative paths won't resolve)
# ---------------------------------------------------------------------------
assert_exit_nonzero \
    "wrong working directory causes non-zero exit" \
    env HOME="$(mktemp -d)" bash -c "cd /tmp && bash '$INSTALL_SCRIPT'"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
