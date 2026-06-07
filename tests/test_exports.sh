#!/usr/bin/env bash
# Tests for env/exports.sh — TAP output, no external dependencies.
# Run: bash tests/test_exports.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPORTS_FILE="$ROOT_DIR/env/exports.sh"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0
_fail=0

ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

# ---------------------------------------------------------------------------
# Helper: source exports.sh in a subshell and capture all vars in one shot
# ---------------------------------------------------------------------------
output=$(bash -c "source \"$EXPORTS_FILE\" && printf '%s\n' \"EDITOR=\$EDITOR\" \"DEV=\$DEV\" \"FONTS_PATH=\$FONTS_PATH\" \"NVM_VERSION=\$NVM_VERSION\" \"NODE_DEFAULT_VERSION=\$NODE_DEFAULT_VERSION\"")

get_var() {
    # Extract value for a given key from the captured output lines.
    local key="$1"
    printf '%s\n' "$output" | grep "^${key}=" | cut -d= -f2-
}

# ---------------------------------------------------------------------------
# Test 1 — each variable is set to the expected value after sourcing
# ---------------------------------------------------------------------------
editor_val=$(get_var EDITOR)
if [[ "$editor_val" == "vim" ]]; then
    ok "EDITOR is set to 'vim'"
else
    not_ok "EDITOR is set to 'vim' (got: '$editor_val')"
fi

dev_val=$(get_var DEV)
if [[ "$dev_val" == "dev" ]]; then
    ok "DEV is set to 'dev'"
else
    not_ok "DEV is set to 'dev' (got: '$dev_val')"
fi

fonts_val=$(get_var FONTS_PATH)
if [[ "$fonts_val" == *".local/share/fonts/"* ]]; then
    ok "FONTS_PATH contains '.local/share/fonts/'"
else
    not_ok "FONTS_PATH contains '.local/share/fonts/' (got: '$fonts_val')"
fi

nvm_val=$(get_var NVM_VERSION)
if [[ "$nvm_val" == "0.40.5" ]]; then
    ok "NVM_VERSION is set to '0.40.5'"
else
    not_ok "NVM_VERSION is set to '0.40.5' (got: '$nvm_val')"
fi

node_val=$(get_var NODE_DEFAULT_VERSION)
if [[ "$node_val" == "v22.22.3" ]]; then
    ok "NODE_DEFAULT_VERSION is set to 'v22.22.3'"
else
    not_ok "NODE_DEFAULT_VERSION is set to 'v22.22.3' (got: '$node_val')"
fi

# ---------------------------------------------------------------------------
# Test 2 — sourcing the file does NOT exit the shell (exit code 0)
# ---------------------------------------------------------------------------
if bash -c "source \"$EXPORTS_FILE\"" > /dev/null 2>&1; then
    ok "sourcing exports.sh exits with code 0"
else
    not_ok "sourcing exports.sh exits with code 0 (non-zero exit)"
fi

# ---------------------------------------------------------------------------
# Test 3 — FONTS_PATH includes $HOME (not a hardcoded path)
# ---------------------------------------------------------------------------
fonts_val=$(get_var FONTS_PATH)
subshell_home=$(bash -c 'echo "$HOME"')
if [[ "$fonts_val" == "$subshell_home"* ]]; then
    ok "FONTS_PATH starts with \$HOME (not hardcoded)"
else
    not_ok "FONTS_PATH starts with \$HOME (got: '$fonts_val', HOME: '$subshell_home')"
fi

# ---------------------------------------------------------------------------
# Test 4 — variables are exported (visible in subshells)
# ---------------------------------------------------------------------------
subshell_editor=$(bash -c "source \"$EXPORTS_FILE\" && bash -c 'echo \$EDITOR'")
if [[ "$subshell_editor" == "vim" ]]; then
    ok "EDITOR is exported and visible in a subshell"
else
    not_ok "EDITOR is exported and visible in a subshell (got: '$subshell_editor')"
fi

subshell_dev=$(bash -c "source \"$EXPORTS_FILE\" && bash -c 'echo \$DEV'")
if [[ "$subshell_dev" == "dev" ]]; then
    ok "DEV is exported and visible in a subshell"
else
    not_ok "DEV is exported and visible in a subshell (got: '$subshell_dev')"
fi

subshell_nvm=$(bash -c "source \"$EXPORTS_FILE\" && bash -c 'echo \$NVM_VERSION'")
if [[ "$subshell_nvm" == "0.40.5" ]]; then
    ok "NVM_VERSION is exported and visible in a subshell"
else
    not_ok "NVM_VERSION is exported and visible in a subshell (got: '$subshell_nvm')"
fi

subshell_node=$(bash -c "source \"$EXPORTS_FILE\" && bash -c 'echo \$NODE_DEFAULT_VERSION'")
if [[ "$subshell_node" == "v22.22.3" ]]; then
    ok "NODE_DEFAULT_VERSION is exported and visible in a subshell"
else
    not_ok "NODE_DEFAULT_VERSION is exported and visible in a subshell (got: '$subshell_node')"
fi

subshell_fonts=$(bash -c "source \"$EXPORTS_FILE\" && bash -c 'echo \$FONTS_PATH'")
if [[ "$subshell_fonts" == *".local/share/fonts/"* ]]; then
    ok "FONTS_PATH is exported and visible in a subshell"
else
    not_ok "FONTS_PATH is exported and visible in a subshell (got: '$subshell_fonts')"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
