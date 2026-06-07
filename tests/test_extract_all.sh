#!/usr/bin/env bash
# Tests for bin/extract_all — TAP output, no external dependencies beyond standard tools.
# Run: bash tests/test_extract_all.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXTRACT_SCRIPT="$ROOT_DIR/bin/extract_all"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0; _fail=0

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

# ---------------------------------------------------------------------------
# Helper: run extract_all inside a given directory, capture output + exit code
# ---------------------------------------------------------------------------
run_extract() {
    local dir="$1"
    (cd "$dir" && bash "$EXTRACT_SCRIPT" 2>&1)
}

# ---------------------------------------------------------------------------
# Test 1 — script exits successfully and prints "Extraction complete!"
# Use a simple single-archive temp dir to test basic run behaviour.
# ---------------------------------------------------------------------------
TMP_BASIC=$(mktemp -d)
trap 'rm -rf "$TMP_BASIC"' EXIT

(cd "$TMP_BASIC" && echo "hello" > sample.txt && zip test.zip sample.txt && rm sample.txt)

OUTPUT=$(run_extract "$TMP_BASIC")
EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
    ok "script exits with code 0"
else
    not_ok "script exits with code 0 (got $EXIT_CODE)"
fi

if echo "$OUTPUT" | grep -q "Extraction complete!"; then
    ok "script prints 'Extraction complete!'"
else
    not_ok "script prints 'Extraction complete!'"
fi

# ---------------------------------------------------------------------------
# Test 2 — .zip → extracts to directory named file-without-extension
# find produces ./test.zip  →  ${file%.*} = ./test  →  directory ./test/
# ---------------------------------------------------------------------------
assert_dir_exists "$TMP_BASIC/test" ".zip extracts to 'test/' directory"

# ---------------------------------------------------------------------------
# Test 3 — .tar.gz → extracts to directory ./test.tar/
# find produces ./test.tar.gz  →  ${file%.*} = ./test.tar
# ---------------------------------------------------------------------------
TMP_TARGZ=$(mktemp -d)
trap 'rm -rf "$TMP_TARGZ"' EXIT

(cd "$TMP_TARGZ" && echo "hello" > sample.txt && tar -czf test.tar.gz sample.txt && rm sample.txt)
run_extract "$TMP_TARGZ" > /dev/null

assert_dir_exists "$TMP_TARGZ/test.tar" ".tar.gz extracts to 'test.tar/' directory"
assert_file_exists "$TMP_TARGZ/test.tar/sample.txt" ".tar.gz extracts sample.txt into 'test.tar/'"

# ---------------------------------------------------------------------------
# Test 4 — .tar.bz2 → extracts to directory ./test.tar/
# find produces ./test.tar.bz2  →  ${file%.*} = ./test.tar
# ---------------------------------------------------------------------------
TMP_TARBZ2=$(mktemp -d)
trap 'rm -rf "$TMP_TARBZ2"' EXIT

(cd "$TMP_TARBZ2" && echo "hello" > sample.txt && tar -cjf test.tar.bz2 sample.txt && rm sample.txt)
run_extract "$TMP_TARBZ2" > /dev/null

assert_dir_exists "$TMP_TARBZ2/test.tar" ".tar.bz2 extracts to 'test.tar/' directory"
assert_file_exists "$TMP_TARBZ2/test.tar/sample.txt" ".tar.bz2 extracts sample.txt into 'test.tar/'"

# ---------------------------------------------------------------------------
# Test 5 — .tar.xz → extracts to directory ./test.tar/
# find produces ./test.tar.xz  →  ${file%.*} = ./test.tar
# ---------------------------------------------------------------------------
TMP_TARXZ=$(mktemp -d)
trap 'rm -rf "$TMP_TARXZ"' EXIT

(cd "$TMP_TARXZ" && echo "hello" > sample.txt && tar -cJf test.tar.xz sample.txt && rm sample.txt)
run_extract "$TMP_TARXZ" > /dev/null

assert_dir_exists "$TMP_TARXZ/test.tar" ".tar.xz extracts to 'test.tar/' directory"
assert_file_exists "$TMP_TARXZ/test.tar/sample.txt" ".tar.xz extracts sample.txt into 'test.tar/'"

# ---------------------------------------------------------------------------
# Test 6 — .tar → extracts to directory ./test/
# find produces ./test.tar  →  ${file%.*} = ./test
# ---------------------------------------------------------------------------
TMP_TAR=$(mktemp -d)
trap 'rm -rf "$TMP_TAR"' EXIT

(cd "$TMP_TAR" && echo "hello" > sample.txt && tar -cf test.tar sample.txt && rm sample.txt)
run_extract "$TMP_TAR" > /dev/null

assert_dir_exists "$TMP_TAR/test" ".tar extracts to 'test/' directory"
assert_file_exists "$TMP_TAR/test/sample.txt" ".tar extracts sample.txt into 'test/'"

# ---------------------------------------------------------------------------
# Test 7 — .gz (single file) → gunzip output written to file-without-.gz
# find produces ./test.gz  →  ${file%.gz} = ./test  →  plain file ./test
# ---------------------------------------------------------------------------
TMP_GZ=$(mktemp -d)
trap 'rm -rf "$TMP_GZ"' EXIT

(cd "$TMP_GZ" && echo "hello" > sample.txt && gzip -c sample.txt > test.gz && rm sample.txt)
run_extract "$TMP_GZ" > /dev/null

assert_file_exists "$TMP_GZ/test" ".gz extracts to 'test' file"

# ---------------------------------------------------------------------------
# Test 8 — .bz2 (single file) → bunzip2 output written to file-without-.bz2
# find produces ./test.bz2  →  ${file%.bz2} = ./test  →  plain file ./test
# ---------------------------------------------------------------------------
TMP_BZ2=$(mktemp -d)
trap 'rm -rf "$TMP_BZ2"' EXIT

(cd "$TMP_BZ2" && echo "hello" > sample.txt && bzip2 -c sample.txt > test.bz2 && rm sample.txt)
run_extract "$TMP_BZ2" > /dev/null

assert_file_exists "$TMP_BZ2/test" ".bz2 extracts to 'test' file"

# ---------------------------------------------------------------------------
# Test 9 — .xz (single file) → unxz output written to file-without-.xz
# find produces ./test.xz  →  ${file%.xz} = ./test  →  plain file ./test
# ---------------------------------------------------------------------------
TMP_XZ=$(mktemp -d)
trap 'rm -rf "$TMP_XZ"' EXIT

(cd "$TMP_XZ" && echo "hello" > sample.txt && xz -c sample.txt > test.xz && rm sample.txt)
run_extract "$TMP_XZ" > /dev/null

assert_file_exists "$TMP_XZ/test" ".xz extracts to 'test' file"

# ---------------------------------------------------------------------------
# Test 10 — unsupported format → extract_file prints "Skipping"
# The find in extract_all only matches known extensions, so unsupported files
# are never passed to extract_file via find. We test extract_file directly by
# sourcing the script's function in isolation.
# ---------------------------------------------------------------------------
SKIP_OUTPUT=$(
    bash --norc --noprofile -c '
        source '"$EXTRACT_SCRIPT"'
        extract_file "./dummy.abc"
    ' 2>&1
)
if echo "$SKIP_OUTPUT" | grep -q "Skipping"; then
    ok "unsupported format prints 'Skipping'"
else
    not_ok "unsupported format prints 'Skipping'"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
