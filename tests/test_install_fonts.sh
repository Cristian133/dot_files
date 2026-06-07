#!/usr/bin/env bash
# Tests for sh/install_fonts.sh — TAP output, no external dependencies.
# Network calls are replaced by fake wget/unzip stubs injected via PATH.
# Run: bash tests/test_install_fonts.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SCRIPT="$ROOT_DIR/sh/install_fonts.sh"

EXPECTED_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaMono.zip"

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

assert_file_missing() {
    local path="$1" label="$2"
    if [[ ! -f "$path" ]]; then ok "$label"; else not_ok "$label (should be absent: $path)"; fi
}

assert_dir_exists() {
    local path="$1" label="$2"
    if [[ -d "$path" ]]; then ok "$label"; else not_ok "$label (missing: $path)"; fi
}

assert_contains() {
    local file="$1" expected="$2" label="$3"
    if grep -qFe "$expected" "$file" 2>/dev/null; then
        ok "$label"
    else
        not_ok "$label"
        printf '  # expected in %s: %s\n' "$file" "$expected"
        printf '  # actual content: %s\n' "$(cat "$file" 2>/dev/null)"
    fi
}

assert_exit_nonzero() {
    local label="$1"; shift
    if ! "$@" > /dev/null 2>&1; then ok "$label"; else not_ok "$label (expected failure)"; fi
}

# ---------------------------------------------------------------------------
# Shared temp dir for fake tool stubs (injected via PATH)
# ---------------------------------------------------------------------------
TMP=$(mktemp -d)
FAKE_BIN="$TMP/bin"
mkdir -p "$FAKE_BIN"
trap 'rm -rf "$TMP"' EXIT

# Fake wget: records its arguments to a log file, then creates an empty zip
# at the path given after -O so downstream unzip/rm work correctly.
cat > "$FAKE_BIN/wget" <<'EOF'
#!/usr/bin/env bash
echo "$*" >> "${WGET_LOG}"
prev=""
for arg in "$@"; do
    if [[ "$prev" == "-O" ]]; then
        touch "$arg"   # create the "downloaded" file so rm can delete it
    fi
    prev="$arg"
done
EOF
chmod +x "$FAKE_BIN/wget"

# Fake unzip: records its arguments and creates a dummy font file in CWD.
cat > "$FAKE_BIN/unzip" <<'EOF'
#!/usr/bin/env bash
echo "$*" >> "${UNZIP_LOG}"
touch CascadiaMono-Regular.ttf   # simulate extracted font file
EOF
chmod +x "$FAKE_BIN/unzip"

# Run the install script with fake tools and an isolated FONTS_PATH.
run_install() {
    local fonts_path="$1"
    WGET_LOG="$TMP/wget.log"
    UNZIP_LOG="$TMP/unzip.log"
    export WGET_LOG UNZIP_LOG
    : > "$WGET_LOG"
    : > "$UNZIP_LOG"
    PATH="$FAKE_BIN:$PATH" FONTS_PATH="$fonts_path" bash "$INSTALL_SCRIPT"
}

# ---------------------------------------------------------------------------
# Test 1 — FONTS_PATH not set → non-zero exit with error message
# ---------------------------------------------------------------------------
output=$(env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" bash "$INSTALL_SCRIPT" 2>&1 || true)
if echo "$output" | grep -q "FONTS_PATH is not defined"; then
    ok "FONTS_PATH unset: prints error message"
else
    not_ok "FONTS_PATH unset: prints error message"
fi
assert_exit_nonzero \
    "FONTS_PATH unset: exits non-zero" \
    env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" bash "$INSTALL_SCRIPT"

# ---------------------------------------------------------------------------
# Test 2 — happy path
# ---------------------------------------------------------------------------
FONTS_DIR="$TMP/fonts"

run_install "$FONTS_DIR"

assert_dir_exists "$FONTS_DIR" \
    "happy path: FONTS_PATH directory is created"

assert_contains "$TMP/wget.log" "$EXPECTED_URL" \
    "happy path: wget called with correct URL"

assert_contains "$TMP/wget.log" "-O $FONTS_DIR/CascadiaMono.zip" \
    "happy path: wget downloads to FONTS_PATH/CascadiaMono.zip"

assert_contains "$TMP/unzip.log" "CascadiaMono.zip" \
    "happy path: unzip called on CascadiaMono.zip"

assert_file_missing "$FONTS_DIR/CascadiaMono.zip" \
    "happy path: zip file removed after extraction"

assert_file_exists "$FONTS_DIR/CascadiaMono-Regular.ttf" \
    "happy path: extracted font file is present"

# ---------------------------------------------------------------------------
# Test 3 — FONTS_PATH already exists (mkdir -p is idempotent)
# ---------------------------------------------------------------------------
FONTS_DIR2="$TMP/fonts2"
mkdir -p "$FONTS_DIR2"

run_install "$FONTS_DIR2"

assert_dir_exists "$FONTS_DIR2" \
    "pre-existing FONTS_PATH: directory still present after install"
assert_file_missing "$FONTS_DIR2/CascadiaMono.zip" \
    "pre-existing FONTS_PATH: zip cleaned up"

# ---------------------------------------------------------------------------
# Test 4 — wget failure causes non-zero exit
# ---------------------------------------------------------------------------
cat > "$FAKE_BIN/wget" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
chmod +x "$FAKE_BIN/wget"

assert_exit_nonzero \
    "wget failure: script exits non-zero" \
    env PATH="$FAKE_BIN:$PATH" FONTS_PATH="$TMP/fonts3" bash "$INSTALL_SCRIPT"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
