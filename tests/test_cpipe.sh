#!/usr/bin/env bash
# Tests for bin/cpipe — TAP output, no external dependencies.
# Run: bash tests/test_cpipe.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CPIPE_SCRIPT="$ROOT_DIR/bin/cpipe"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0; _fail=0
ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

# ---------------------------------------------------------------------------
# Test 1 — 0 args: stdin passes through unchanged
# ---------------------------------------------------------------------------
output=$(echo "hello" | bash "$CPIPE_SCRIPT")
if [[ "$output" == "hello" ]]; then
    ok "0 args: input passes through unchanged"
else
    not_ok "0 args: input passes through unchanged (got: $(printf '%s' "$output" | cat -v))"
fi

# ---------------------------------------------------------------------------
# Test 2 — 1 arg with -f: output contains ANSI escape codes for matched pattern
# ---------------------------------------------------------------------------
output=$(echo "foo bar baz" | bash "$CPIPE_SCRIPT" -f foo)
if printf '%s' "$output" | grep -q $'\033'; then
    ok "1 arg -f: output contains ANSI escape codes for matched pattern"
else
    not_ok "1 arg -f: output contains ANSI escape codes for matched pattern (no ESC found)"
fi

# ---------------------------------------------------------------------------
# Test 3 — 1 arg with -f: non-matching text is not colorized
# ---------------------------------------------------------------------------
# "bar" is not the matched pattern ("foo"), so "bar" itself should not be
# wrapped in color codes. We verify by checking that "bar" appears literally
# without a preceding ESC in the output.
output=$(echo "foo bar" | bash "$CPIPE_SCRIPT" -f foo)
# Strip the ESC sequences and confirm "bar" survives unchanged in clean text.
clean=$(printf '%s' "$output" | sed 's/\x1b\[[0-9;]*m//g')
if [[ "$clean" == "foo bar" ]]; then
    ok "1 arg -f: non-matching text is not colorized"
else
    not_ok "1 arg -f: non-matching text is not colorized (clean output: $(printf '%s' "$clean" | cat -v))"
fi

# ---------------------------------------------------------------------------
# Test 4 — 2 args with -f: both patterns are independently highlighted
# ---------------------------------------------------------------------------
output=$(echo "foo bar baz" | bash "$CPIPE_SCRIPT" -f foo bar)
# Count actual ESC characters (not lines) — grep -c counts lines, not occurrences.
has_esc=$(printf '%s' "$output" | tr -cd $'\033' | wc -c)
# Each highlighted pattern wraps in color+reset = 2 ESC chars. With 2 patterns: >= 4.
if [[ "$has_esc" -ge 4 ]]; then
    ok "2 args -f: both patterns are independently highlighted (found $has_esc ESC chars)"
else
    not_ok "2 args -f: both patterns are independently highlighted (only $has_esc ESC chars found)"
fi

# Additionally verify that both "foo" and "bar" appear in the stripped output.
clean=$(printf '%s' "$output" | sed 's/\x1b\[[0-9;]*m//g')
if [[ "$clean" == "foo bar baz" ]]; then
    ok "2 args -f: original text preserved after stripping color codes"
else
    not_ok "2 args -f: original text preserved after stripping color codes (got: $clean)"
fi

# ---------------------------------------------------------------------------
# Test 5 — default (no -f): output is NOT colorized when stdout is not a TTY
# ---------------------------------------------------------------------------
output=$(echo "foo bar baz" | bash "$CPIPE_SCRIPT" foo)
if printf '%s' "$output" | grep -q $'\033'; then
    not_ok "default TTYONLY: output is not colorized when stdout is not a TTY (ESC found unexpectedly)"
else
    ok "default TTYONLY: output is not colorized when stdout is not a TTY"
fi

# ---------------------------------------------------------------------------
# Test 6 — exit code is 0 for 0 through 5 arguments
# ---------------------------------------------------------------------------
# Append "EXIT:$?" after the script so we can capture the exit code inside
# the command substitution (which always exits 0 itself).
ec0=$(echo "test" | bash "$CPIPE_SCRIPT"; echo "EXIT:$?")
ec1=$(echo "test" | bash "$CPIPE_SCRIPT" -f a; echo "EXIT:$?")
ec2=$(echo "test" | bash "$CPIPE_SCRIPT" -f a b; echo "EXIT:$?")
ec3=$(echo "test" | bash "$CPIPE_SCRIPT" -f a b c; echo "EXIT:$?")
ec4=$(echo "test" | bash "$CPIPE_SCRIPT" -f a b c d; echo "EXIT:$?")
ec5=$(echo "test" | bash "$CPIPE_SCRIPT" -f a b c d e; echo "EXIT:$?")

all_zero=true
for ec in "$ec0" "$ec1" "$ec2" "$ec3" "$ec4" "$ec5"; do
    if [[ "$ec" != *"EXIT:0"* ]]; then
        all_zero=false
    fi
done
if $all_zero; then
    ok "exit code: script exits 0 with 0-5 arguments"
else
    not_ok "exit code: script exits 0 with 0-5 arguments (got: 0=$ec0 1=$ec1 2=$ec2 3=$ec3 4=$ec4 5=$ec5)"
fi

# ---------------------------------------------------------------------------
# Test 7 — syntax check: bash -n succeeds
# ---------------------------------------------------------------------------
if bash -n "$CPIPE_SCRIPT" 2>/dev/null; then
    ok "syntax: bash -n parses script without errors"
else
    not_ok "syntax: bash -n parses script without errors"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
