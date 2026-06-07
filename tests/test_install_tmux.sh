#!/usr/bin/env bash
# Tests for sh/install_tmux.sh — TAP output, no external dependencies.
# git is replaced by a stub that logs calls and creates the expected directory.
# Run: bash tests/test_install_tmux.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SCRIPT="$ROOT_DIR/sh/install_tmux.sh"

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0; _fail=0
ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

assert_contains_file() {
    local file="$1" expected="$2" label="$3"
    if grep -qFe "$expected" "$file" 2>/dev/null; then
        ok "$label"
    else
        not_ok "$label"
        printf '  # expected in %s: %s\n' "$file" "$expected"
        printf '  # actual: %s\n' "$(cat "$file" 2>/dev/null)"
    fi
}

assert_file_exists() {
    local path="$1" label="$2"
    if [[ -f "$path" ]]; then ok "$label"; else not_ok "$label (missing: $path)"; fi
}

assert_dir_exists() {
    local path="$1" label="$2"
    if [[ -d "$path" ]]; then ok "$label"; else not_ok "$label (missing: $path)"; fi
}

assert_file_not_modified() {
    local path="$1" original_content="$2" label="$3"
    local current_content
    current_content="$(cat "$path" 2>/dev/null)"
    if [[ "$current_content" == "$original_content" ]]; then
        ok "$label"
    else
        not_ok "$label"
        printf '  # expected content: %s\n' "$original_content"
        printf '  # actual content:   %s\n' "$current_content"
    fi
}

assert_output_contains() {
    local output="$1" expected="$2" label="$3"
    if printf '%s' "$output" | grep -qFe "$expected"; then
        ok "$label"
    else
        not_ok "$label"
        printf '  # expected: %s\n' "$expected"
        printf '  # actual:   %s\n' "$output"
    fi
}

# ---------------------------------------------------------------------------
# Temp workspace and stubs
# ---------------------------------------------------------------------------
TMP=$(mktemp -d)
FAKE_BIN="$TMP/bin"
GIT_LOG="$TMP/git.log"
export GIT_LOG

mkdir -p "$FAKE_BIN"
trap 'rm -rf "$TMP"' EXIT

# Fake git: log all args, and on "clone" create the destination directory.
cat > "$FAKE_BIN/git" << 'STUB'
#!/usr/bin/env bash
echo "git $*" >> "${GIT_LOG}"
if [[ "$1" == "clone" ]]; then
    # Last positional argument is the destination directory.
    dest="${*: -1}"
    mkdir -p "$dest"
fi
exit 0
STUB
chmod +x "$FAKE_BIN/git"

# Helper: run the install script from sh/ with an isolated HOME and fake git.
run_install() {
    local fake_home="$1"
    : > "$GIT_LOG"
    (cd "$ROOT_DIR/sh" && HOME="$fake_home" PATH="$FAKE_BIN:$PATH" bash "$INSTALL_SCRIPT")
}

# Helper: run and capture combined stdout+stderr (script must not call exit 1
# so we disable set -e locally via a subshell).
run_install_output() {
    local fake_home="$1"
    : > "$GIT_LOG"
    (set +e; cd "$ROOT_DIR/sh" && HOME="$fake_home" PATH="$FAKE_BIN:$PATH" bash "$INSTALL_SCRIPT" 2>&1) || true
}

# ---------------------------------------------------------------------------
# Test 1 — git clone is called with the TPM URL
# ---------------------------------------------------------------------------
FAKE_HOME1="$TMP/home1"
mkdir -p "$FAKE_HOME1"
run_install "$FAKE_HOME1"

assert_contains_file "$GIT_LOG" "https://github.com/tmux-plugins/tpm" \
    "git clone is called with the TPM URL"

# ---------------------------------------------------------------------------
# Test 2 — git clone deposits files into \$HOME/.tmux/plugins/tpm
# ---------------------------------------------------------------------------
assert_dir_exists "$FAKE_HOME1/.tmux/plugins/tpm" \
    "git clone creates \$HOME/.tmux/plugins/tpm"

# ---------------------------------------------------------------------------
# Test 3 — when ~/.tmux.conf does NOT exist, the file is copied
# ---------------------------------------------------------------------------
FAKE_HOME2="$TMP/home2"
mkdir -p "$FAKE_HOME2"
# Ensure no pre-existing .tmux.conf
[[ ! -e "$FAKE_HOME2/.tmux.conf" ]] || rm -f "$FAKE_HOME2/.tmux.conf"

run_install "$FAKE_HOME2"

assert_file_exists "$FAKE_HOME2/.tmux.conf" \
    "~/.tmux.conf is created when it did not exist"

if [[ -f "$FAKE_HOME2/.tmux.conf" ]] && diff -q "$ROOT_DIR/tmux/tmux.conf" "$FAKE_HOME2/.tmux.conf" > /dev/null 2>&1; then
    ok "copied ~/.tmux.conf matches source tmux/tmux.conf"
else
    not_ok "copied ~/.tmux.conf matches source tmux/tmux.conf"
fi

# ---------------------------------------------------------------------------
# Test 4 — when ~/.tmux.conf already exists, it is NOT overwritten and
#           the script prints "already exists"
# ---------------------------------------------------------------------------
FAKE_HOME3="$TMP/home3"
mkdir -p "$FAKE_HOME3"
ORIGINAL_CONTENT="# sentinel - do not overwrite"
printf '%s\n' "$ORIGINAL_CONTENT" > "$FAKE_HOME3/.tmux.conf"

output=$(run_install_output "$FAKE_HOME3")

assert_file_not_modified "$FAKE_HOME3/.tmux.conf" "$ORIGINAL_CONTENT" \
    "existing ~/.tmux.conf is NOT overwritten"

assert_output_contains "$output" "already exists" \
    "script prints 'already exists' when ~/.tmux.conf is present"

# ---------------------------------------------------------------------------
# Test 5 — git clone failure: script continues (no set -e), exits 0
# ---------------------------------------------------------------------------
FAKE_HOME4="$TMP/home4"
mkdir -p "$FAKE_HOME4"

# Override the fake git to fail on clone
cat > "$FAKE_BIN/git" << 'STUB'
#!/usr/bin/env bash
echo "git $*" >> "${GIT_LOG}"
if [[ "$1" == "clone" ]]; then
    exit 1
fi
exit 0
STUB
chmod +x "$FAKE_BIN/git"

set +e
exit_code=0
(cd "$ROOT_DIR/sh" && HOME="$FAKE_HOME4" PATH="$FAKE_BIN:$PATH" bash "$INSTALL_SCRIPT" > /dev/null 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
    ok "git clone failure: script continues and exits 0 (no set -e)"
else
    not_ok "git clone failure: script continues and exits 0 (no set -e) — got exit $exit_code"
fi

# Also verify the rest of the script still ran: no pre-existing .tmux.conf means it gets copied
assert_file_exists "$FAKE_HOME4/.tmux.conf" \
    "git clone failure: script still copies ~/.tmux.conf (execution continued)"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
