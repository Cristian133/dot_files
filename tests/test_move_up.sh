#!/usr/bin/env bash
# Tests for bin/move_up — TAP output, no external dependencies.
# Run: bash tests/test_move_up.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOVE_UP_SCRIPT="$ROOT_DIR/bin/move_up"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0; _fail=0

ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

# ---------------------------------------------------------------------------
# Helper: create a standard temp dir with a file structure
#   tmp/
#     subdir1/file1.txt
#     subdir2/file2.txt
#     top_level.txt
# ---------------------------------------------------------------------------
make_tmp_dir() {
    local tmpdir
    tmpdir="$(mktemp -d)"
    mkdir -p "$tmpdir/subdir1" "$tmpdir/subdir2"
    touch "$tmpdir/subdir1/file1.txt"
    touch "$tmpdir/subdir2/file2.txt"
    touch "$tmpdir/top_level.txt"
    echo "$tmpdir"
}

# ---------------------------------------------------------------------------
# Test 1 — "no" answer → prints "Operation cancelled.", exits 0, files not moved
# ---------------------------------------------------------------------------
TMP1="$(make_tmp_dir)"
output1="$(echo "no" | (cd "$TMP1" && bash "$MOVE_UP_SCRIPT") 2>&1)"
exit1=$?

if [[ "$output1" == *"Operation cancelled."* ]]; then
    ok '"no" answer prints "Operation cancelled."'
else
    not_ok '"no" answer prints "Operation cancelled." (got: '"$output1"')'
fi

if [[ $exit1 -eq 0 ]]; then
    ok '"no" answer exits with code 0'
else
    not_ok '"no" answer exits with code 0 (got: '"$exit1"')'
fi

if [[ -f "$TMP1/subdir1/file1.txt" && -f "$TMP1/subdir2/file2.txt" ]]; then
    ok '"no" answer leaves files in subdirectories untouched'
else
    not_ok '"no" answer leaves files in subdirectories untouched'
fi

rm -rf "$TMP1"

# ---------------------------------------------------------------------------
# Test 2 — "yes" answer → files from subdirs end up in the top-level dir
# ---------------------------------------------------------------------------
TMP2="$(make_tmp_dir)"
echo "yes" | (cd "$TMP2" && bash "$MOVE_UP_SCRIPT") 2>&1 > /dev/null

if [[ -f "$TMP2/file1.txt" && -f "$TMP2/file2.txt" ]]; then
    ok '"yes" answer moves subdir files to the top-level directory'
else
    not_ok '"yes" answer moves subdir files to the top-level directory'
fi

rm -rf "$TMP2"

# ---------------------------------------------------------------------------
# Test 3 — "yes" answer → empty subdirectories are deleted after the move
# ---------------------------------------------------------------------------
TMP3="$(make_tmp_dir)"
echo "yes" | (cd "$TMP3" && bash "$MOVE_UP_SCRIPT") 2>&1 > /dev/null

if [[ ! -d "$TMP3/subdir1" && ! -d "$TMP3/subdir2" ]]; then
    ok '"yes" answer deletes empty subdirectories after the move'
else
    not_ok '"yes" answer deletes empty subdirectories after the move'
fi

rm -rf "$TMP3"

# ---------------------------------------------------------------------------
# Test 4 — "yes" answer → prints the success messages
# ---------------------------------------------------------------------------
TMP4="$(make_tmp_dir)"
output4="$(echo "yes" | (cd "$TMP4" && bash "$MOVE_UP_SCRIPT") 2>&1)"

if [[ "$output4" == *"All files and subdirectories have been moved to the current working directory."* ]]; then
    ok '"yes" answer prints the first success message'
else
    not_ok '"yes" answer prints the first success message (got: '"$output4"')'
fi

if [[ "$output4" == *"Empty folders have been deleted."* ]]; then
    ok '"yes" answer prints the second success message'
else
    not_ok '"yes" answer prints the second success message (got: '"$output4"')'
fi

rm -rf "$TMP4"

# ---------------------------------------------------------------------------
# Test 5 — non-"yes" answer (e.g. "maybe") → operation cancelled
# ---------------------------------------------------------------------------
TMP5="$(make_tmp_dir)"
output5="$(echo "maybe" | (cd "$TMP5" && bash "$MOVE_UP_SCRIPT") 2>&1)"
exit5=$?

if [[ "$output5" == *"Operation cancelled."* ]]; then
    ok '"maybe" answer prints "Operation cancelled."'
else
    not_ok '"maybe" answer prints "Operation cancelled." (got: '"$output5"')'
fi

if [[ $exit5 -eq 0 ]]; then
    ok '"maybe" answer exits with code 0'
else
    not_ok '"maybe" answer exits with code 0 (got: '"$exit5"')'
fi

if [[ -f "$TMP5/subdir1/file1.txt" && -f "$TMP5/subdir2/file2.txt" ]]; then
    ok '"maybe" answer leaves files in subdirectories untouched'
else
    not_ok '"maybe" answer leaves files in subdirectories untouched'
fi

rm -rf "$TMP5"

# ---------------------------------------------------------------------------
# Test 6 — files already in top-level dir are unaffected after "yes"
# ---------------------------------------------------------------------------
TMP6="$(make_tmp_dir)"
echo "yes" | (cd "$TMP6" && bash "$MOVE_UP_SCRIPT") 2>&1 > /dev/null

if [[ -f "$TMP6/top_level.txt" ]]; then
    ok '"yes" answer leaves pre-existing top-level files in place'
else
    not_ok '"yes" answer leaves pre-existing top-level files in place'
fi

rm -rf "$TMP6"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
