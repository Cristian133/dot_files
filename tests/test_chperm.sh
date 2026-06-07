#!/usr/bin/env bash
# Tests for bin/chpermdir and bin/chpermfile — TAP output, no external dependencies.
# Run: bash tests/test_chperm.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHPERMDIR_SCRIPT="$ROOT_DIR/bin/chpermdir"
CHPERMFILE_SCRIPT="$ROOT_DIR/bin/chpermfile"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0; _fail=0
ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------
get_perm() { stat -c "%a" "$1"; }

# ---------------------------------------------------------------------------
# chpermdir tests
# ---------------------------------------------------------------------------

# Test 1 — "s" answer → all directories get permission 755
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/subdir"
chmod 777 "$TMP"
chmod 777 "$TMP/subdir"

echo "s" | (cd "$TMP" && bash "$CHPERMDIR_SCRIPT") 2>/dev/null

perm_root=$(get_perm "$TMP")
perm_sub=$(get_perm "$TMP/subdir")
if [[ "$perm_root" == "755" && "$perm_sub" == "755" ]]; then
    ok "chpermdir: s answer sets directories to 755"
else
    not_ok "chpermdir: s answer sets directories to 755 (got root=$perm_root sub=$perm_sub)"
fi

# Test 2 — "n" answer → directory permissions unchanged
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/subdir"
chmod 777 "$TMP"
chmod 777 "$TMP/subdir"

echo "n" | (cd "$TMP" && bash "$CHPERMDIR_SCRIPT") 2>/dev/null

perm_root=$(get_perm "$TMP")
perm_sub=$(get_perm "$TMP/subdir")
if [[ "$perm_root" == "777" && "$perm_sub" == "777" ]]; then
    ok "chpermdir: n answer leaves directory permissions unchanged"
else
    not_ok "chpermdir: n answer leaves directory permissions unchanged (got root=$perm_root sub=$perm_sub)"
fi

# Test 3 — empty input → permissions unchanged
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/subdir"
chmod 777 "$TMP"
chmod 777 "$TMP/subdir"

echo "" | (cd "$TMP" && bash "$CHPERMDIR_SCRIPT") 2>/dev/null

perm_root=$(get_perm "$TMP")
perm_sub=$(get_perm "$TMP/subdir")
if [[ "$perm_root" == "777" && "$perm_sub" == "777" ]]; then
    ok "chpermdir: empty input leaves directory permissions unchanged"
else
    not_ok "chpermdir: empty input leaves directory permissions unchanged (got root=$perm_root sub=$perm_sub)"
fi

# Test 4 — nested subdirs → chmod applied recursively
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/a/b/c"
chmod 777 "$TMP"
chmod 777 "$TMP/a"
chmod 777 "$TMP/a/b"
chmod 777 "$TMP/a/b/c"

echo "s" | (cd "$TMP" && bash "$CHPERMDIR_SCRIPT") 2>/dev/null

perm_a=$(get_perm "$TMP/a")
perm_b=$(get_perm "$TMP/a/b")
perm_c=$(get_perm "$TMP/a/b/c")
if [[ "$perm_a" == "755" && "$perm_b" == "755" && "$perm_c" == "755" ]]; then
    ok "chpermdir: chmod 755 applied recursively to nested subdirs"
else
    not_ok "chpermdir: chmod 755 applied recursively to nested subdirs (got a=$perm_a b=$perm_b c=$perm_c)"
fi

# Test 5 — script exits 0 regardless of answer ("s")
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
echo "s" | (cd "$TMP" && bash "$CHPERMDIR_SCRIPT") 2>/dev/null
exit_code=$?
if [[ "$exit_code" -eq 0 ]]; then
    ok "chpermdir: exits 0 when answer is s"
else
    not_ok "chpermdir: exits 0 when answer is s (got $exit_code)"
fi

# Test 5b — script exits 0 when answer is not "s"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
echo "n" | (cd "$TMP" && bash "$CHPERMDIR_SCRIPT") 2>/dev/null
exit_code=$?
if [[ "$exit_code" -eq 0 ]]; then
    ok "chpermdir: exits 0 when answer is n"
else
    not_ok "chpermdir: exits 0 when answer is n (got $exit_code)"
fi

# ---------------------------------------------------------------------------
# chpermfile tests
# ---------------------------------------------------------------------------

# Test 1 — "s" answer → all files get permission 644
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
touch "$TMP/file.txt"
chmod 777 "$TMP/file.txt"

echo "s" | (cd "$TMP" && bash "$CHPERMFILE_SCRIPT") 2>/dev/null

perm=$(get_perm "$TMP/file.txt")
if [[ "$perm" == "644" ]]; then
    ok "chpermfile: s answer sets files to 644"
else
    not_ok "chpermfile: s answer sets files to 644 (got $perm)"
fi

# Test 2 — "n" answer → file permissions unchanged
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
touch "$TMP/file.txt"
chmod 777 "$TMP/file.txt"

echo "n" | (cd "$TMP" && bash "$CHPERMFILE_SCRIPT") 2>/dev/null

perm=$(get_perm "$TMP/file.txt")
if [[ "$perm" == "777" ]]; then
    ok "chpermfile: n answer leaves file permissions unchanged"
else
    not_ok "chpermfile: n answer leaves file permissions unchanged (got $perm)"
fi

# Test 3 — files in subdirs → chmod applied recursively
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/a/b"
touch "$TMP/top.txt"
touch "$TMP/a/mid.txt"
touch "$TMP/a/b/deep.txt"
chmod 777 "$TMP/top.txt"
chmod 777 "$TMP/a/mid.txt"
chmod 777 "$TMP/a/b/deep.txt"

echo "s" | (cd "$TMP" && bash "$CHPERMFILE_SCRIPT") 2>/dev/null

perm_top=$(get_perm "$TMP/top.txt")
perm_mid=$(get_perm "$TMP/a/mid.txt")
perm_deep=$(get_perm "$TMP/a/b/deep.txt")
if [[ "$perm_top" == "644" && "$perm_mid" == "644" && "$perm_deep" == "644" ]]; then
    ok "chpermfile: chmod 644 applied recursively to files in subdirs"
else
    not_ok "chpermfile: chmod 644 applied recursively to files in subdirs (got top=$perm_top mid=$perm_mid deep=$perm_deep)"
fi

# Test 4 — script exits 0 regardless of answer ("s")
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
touch "$TMP/file.txt"
echo "s" | (cd "$TMP" && bash "$CHPERMFILE_SCRIPT") 2>/dev/null
exit_code=$?
if [[ "$exit_code" -eq 0 ]]; then
    ok "chpermfile: exits 0 when answer is s"
else
    not_ok "chpermfile: exits 0 when answer is s (got $exit_code)"
fi

# Test 4b — script exits 0 when answer is not "s"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
touch "$TMP/file.txt"
echo "n" | (cd "$TMP" && bash "$CHPERMFILE_SCRIPT") 2>/dev/null
exit_code=$?
if [[ "$exit_code" -eq 0 ]]; then
    ok "chpermfile: exits 0 when answer is n"
else
    not_ok "chpermfile: exits 0 when answer is n (got $exit_code)"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
