#!/usr/bin/env bash
# Tests for setup_system.sh — TAP output, no external dependencies.
# Run: bash tests/test_setup_system.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETUP_SCRIPT="$ROOT_DIR/setup_system.sh"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0
_fail=0

ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

assert_contains() {
    local output="$1" expected="$2" label="$3"
    if printf '%s' "$output" | grep -qF "$expected"; then
        ok "$label"
    else
        not_ok "$label"
        printf '  # expected to contain: %s\n' "$expected"
        printf '  # actual: %s\n' "$output"
    fi
}

assert_not_contains() {
    local output="$1" unexpected="$2" label="$3"
    if ! printf '%s' "$output" | grep -qF "$unexpected"; then
        ok "$label"
    else
        not_ok "$label"
        printf '  # expected NOT to contain: %s\n' "$unexpected"
    fi
}

# ---------------------------------------------------------------------------
# Setup: extract and source only the execute_script function
# ---------------------------------------------------------------------------
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Pull just the function definition (lines up to and including the first
# top-level closing brace, which closes execute_script).
sed -n '1,/^}$/p' "$SETUP_SCRIPT" > "$TMP/func.sh"
# shellcheck disable=SC1090
source "$TMP/func.sh"

FAKE_SCRIPT="$TMP/fake.sh"
printf '#!/usr/bin/env bash\necho "script_ran"\n' > "$FAKE_SCRIPT"
chmod +x "$FAKE_SCRIPT"

# ---------------------------------------------------------------------------
# Unit tests: execute_script response handling
# ---------------------------------------------------------------------------

run() { echo "$1" | execute_script "Run it?" "$FAKE_SCRIPT"; }

out=$(run "yes")
assert_contains     "$out" "script_ran" '"yes" runs the script'

out=$(run "y")
assert_contains     "$out" "script_ran" '"y" runs the script'

out=$(run "YES")
assert_contains     "$out" "script_ran" '"YES" (uppercase) runs the script'

out=$(run "Yes")
assert_contains     "$out" "script_ran" '"Yes" (mixed case) runs the script'

out=$(run "no")
assert_not_contains "$out" "script_ran" '"no" skips the script'
assert_contains     "$out" "Skipping"   '"no" prints Skipping'

out=$(run "n")
assert_not_contains "$out" "script_ran" '"n" skips the script'

out=$(run "")
assert_not_contains "$out" "script_ran" 'empty input skips the script'

out=$(run "maybe")
assert_not_contains "$out" "script_ran" 'unrecognised input skips the script'

# ---------------------------------------------------------------------------
# Unit tests: execute_script with missing script
# ---------------------------------------------------------------------------

out=$(echo "yes" | execute_script "Run it?" "$TMP/nonexistent.sh")
assert_contains     "$out" "does not exist" 'missing script prints "does not exist"'
assert_not_contains "$out" "script_ran"     'missing script does not execute anything'

# ---------------------------------------------------------------------------
# Structure tests: questions array and tasks map
# ---------------------------------------------------------------------------

EXPECTED_SCRIPTS=(
    "env/exports.sh"
    "sh/install_deps.sh"
    "sh/install_vim.sh"
    "sh/install_neovim.sh"
    "sh/install_git.sh"
    "sh/install_dotfiles.sh"
    "sh/install_fonts.sh"
    "sh/install_zsh.sh"
    "sh/install_tmux.sh"
    "sh/install_node.sh"
)

# All 10 questions present
q_count=$(grep -cE '^\s+"(First of all|Do you want)' "$SETUP_SCRIPT")
if [[ "$q_count" -eq 10 ]]; then
    ok "questions array has exactly 10 entries"
else
    not_ok "questions array has exactly 10 entries (found $q_count)"
fi

# Each expected script is referenced in the tasks map
for script in "${EXPECTED_SCRIPTS[@]}"; do
    if grep -qF "\"$script\"" "$SETUP_SCRIPT"; then
        ok "tasks map references $script"
    else
        not_ok "tasks map references $script"
    fi
done

# Each referenced script exists on disk
for script in "${EXPECTED_SCRIPTS[@]}"; do
    if [[ -f "$ROOT_DIR/$script" ]]; then
        ok "$script exists on disk"
    else
        not_ok "$script exists on disk"
    fi
done

# questions array and tasks map have the same length (no orphan entries)
q_arr_len=$(grep -cE '^\s+"(First of all|Do you want)' "$SETUP_SCRIPT")
t_map_len=$(grep -cE '^\s+\[".+"]=".+"' "$SETUP_SCRIPT")
if [[ "$q_arr_len" -eq "$t_map_len" ]]; then
    ok "questions array and tasks map have equal length ($q_arr_len)"
else
    not_ok "questions array and tasks map length mismatch (questions=$q_arr_len, tasks=$t_map_len)"
fi

# ---------------------------------------------------------------------------
# Integration test: full script run with all "no" answers
# ---------------------------------------------------------------------------

# 10 questions → 10 "no" responses
NO_INPUT=$(printf 'no\n%.0s' {1..10})

out=$(printf '%s\n' "$NO_INPUT" | bash "$SETUP_SCRIPT" 2>&1)
assert_contains     "$out" "Process complete!" 'full run prints "Process complete!"'
assert_not_contains "$out" "Executing"         'all-no run executes nothing'

# Each question prompt appears in the output (i.e. the loop runs all entries)
for script in "${EXPECTED_SCRIPTS[@]}"; do
    assert_contains "$out" "Skipping $script" "all-no run skips $script"
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
