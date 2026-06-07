#!/usr/bin/env bash
# Run all test_*.sh files and print a summary.
# Exit code: 0 if all pass, 1 if any fail.

set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

total_pass=0
total_fail=0
failed_files=()

# Column width for file names
COL=35

printf '\n%-*s  %6s  %6s\n' "$COL" "Test file" "passed" "failed"
printf '%s\n' "$(printf '─%.0s' $(seq 1 $((COL + 16))))"

for file in "$TESTS_DIR"/test_*.sh; do
    name="$(basename "$file")"
    output=$(bash "$file" 2>&1)
    result=$(printf '%s' "$output" | grep '^# Results:' || true)

    pass=$(printf '%s' "$result" | grep -o '[0-9]* passed' | grep -o '[0-9]*' || echo 0)
    fail=$(printf '%s' "$result" | grep -o '[0-9]* failed' | grep -o '[0-9]*' || echo 0)

    total_pass=$((total_pass + pass))
    total_fail=$((total_fail + fail))

    if [[ "$fail" -eq 0 ]]; then
        status="OK"
    else
        status="FAIL"
        failed_files+=("$name")
    fi

    printf '%-*s  %6s  %6s  %s\n' "$COL" "$name" "$pass" "$fail" "$status"
done

printf '%s\n' "$(printf '─%.0s' $(seq 1 $((COL + 16))))"
printf '%-*s  %6d  %6d\n\n' "$COL" "TOTAL" "$total_pass" "$total_fail"

if [[ "${#failed_files[@]}" -gt 0 ]]; then
    printf 'Failed:\n'
    for f in "${failed_files[@]}"; do
        printf '  - %s\n' "$f"
    done
    printf '\n'
    exit 1
fi

printf 'All tests passed.\n\n'
