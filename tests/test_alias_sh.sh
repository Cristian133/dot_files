#!/usr/bin/env bash
# Tests for zsh/alias.sh — TAP output, no external dependencies.
# Run: bash tests/test_alias_sh.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ALIAS_FILE="$ROOT_DIR/zsh/alias.sh"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0
_fail=0

ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

# ---------------------------------------------------------------------------
# Helper: get an alias value after sourcing alias.sh in a bare bash subshell
# ---------------------------------------------------------------------------
get_alias() {
    # Returns the raw "alias name='value'" line, or empty if not defined.
    bash --norc -c "source '$ALIAS_FILE'; alias $1" 2>/dev/null
}

# ---------------------------------------------------------------------------
# Test 1 — file sources without error (exit code 0)
# ---------------------------------------------------------------------------
if bash --norc -c "source '$ALIAS_FILE'" > /dev/null 2>&1; then
    ok "alias.sh sources without error (exit 0)"
else
    not_ok "alias.sh sources without error (exit 0)"
fi

# ---------------------------------------------------------------------------
# Test 2 — bash can parse alias.sh without syntax errors (-n flag)
# ---------------------------------------------------------------------------
if bash -n "$ALIAS_FILE" 2>/dev/null; then
    ok "alias.sh has no syntax errors (bash -n)"
else
    not_ok "alias.sh has no syntax errors (bash -n)"
fi

# ---------------------------------------------------------------------------
# Test 3 — EDITOR is exported and set to "nvim"
# ---------------------------------------------------------------------------
editor_val=$(bash --norc -c "source '$ALIAS_FILE'; echo \"\$EDITOR\"" 2>/dev/null)
if [[ "$editor_val" == "nvim" ]]; then
    ok "EDITOR is set to 'nvim'"
else
    not_ok "EDITOR is set to 'nvim' (got: '$editor_val')"
fi

# ---------------------------------------------------------------------------
# Tests 4-12 — each key alias is defined
# ---------------------------------------------------------------------------
for alias_name in vi ll la ls grep mkdir .. ... ....; do
    result=$(get_alias "$alias_name")
    if [[ -n "$result" ]]; then
        ok "alias '$alias_name' is defined"
    else
        not_ok "alias '$alias_name' is defined"
    fi
done

# ---------------------------------------------------------------------------
# Test 13 — vi expands to nvim
# ---------------------------------------------------------------------------
vi_val=$(get_alias vi)
if [[ "$vi_val" == *"nvim"* ]]; then
    ok "alias 'vi' expands to 'nvim'"
else
    not_ok "alias 'vi' expands to 'nvim' (got: '$vi_val')"
fi

# ---------------------------------------------------------------------------
# Test 14 — ll contains -lhF
# ---------------------------------------------------------------------------
ll_val=$(get_alias ll)
if [[ "$ll_val" == *"-lhF"* ]]; then
    ok "alias 'll' contains '-lhF'"
else
    not_ok "alias 'll' contains '-lhF' (got: '$ll_val')"
fi

# ---------------------------------------------------------------------------
# Test 15 — la contains -lahF
# ---------------------------------------------------------------------------
la_val=$(get_alias la)
if [[ "$la_val" == *"-lahF"* ]]; then
    ok "alias 'la' contains '-lahF'"
else
    not_ok "alias 'la' contains '-lahF' (got: '$la_val')"
fi

# ---------------------------------------------------------------------------
# Test 16 — grep alias contains --color=auto
# ---------------------------------------------------------------------------
grep_val=$(get_alias grep)
if [[ "$grep_val" == *"--color=auto"* ]]; then
    ok "alias 'grep' contains '--color=auto'"
else
    not_ok "alias 'grep' contains '--color=auto' (got: '$grep_val')"
fi

# ---------------------------------------------------------------------------
# Test 17 — mkdir alias is mkdir -p
# ---------------------------------------------------------------------------
mkdir_val=$(get_alias mkdir)
if [[ "$mkdir_val" == *"mkdir -p"* ]]; then
    ok "alias 'mkdir' is 'mkdir -p'"
else
    not_ok "alias 'mkdir' is 'mkdir -p' (got: '$mkdir_val')"
fi

# ---------------------------------------------------------------------------
# Test 18 — l. function is defined after sourcing
# ---------------------------------------------------------------------------
func_def=$(bash --norc -c "source '$ALIAS_FILE'; declare -f l." 2>/dev/null)
if [[ -n "$func_def" ]]; then
    ok "function 'l.' is defined"
else
    not_ok "function 'l.' is defined"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
