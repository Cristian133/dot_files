#!/usr/bin/env bash
# Tests for sh/install_node.sh — TAP output, no external dependencies.
# Network calls (curl) and tool invocations (nvm, npm) are replaced by stubs.
# Run: bash tests/test_install_node.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SCRIPT="$ROOT_DIR/sh/install_node.sh"

NVM_VERSION="0.40.5"
NODE_DEFAULT_VERSION="v22.22.3"
EXPECTED_CURL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"

GLOBAL_PACKAGES=(n yarn npm pnpm @microsoft/rush @angular/cli)

# ---------------------------------------------------------------------------
# TAP harness
# ---------------------------------------------------------------------------
_pass=0
_fail=0

ok()     { echo "ok - $1";     _pass=$((_pass + 1)); }
not_ok() { echo "not ok - $1"; _fail=$((_fail + 1)); }

assert_contains_str() {
    local output="$1" expected="$2" label="$3"
    if printf '%s' "$output" | grep -qFe "$expected"; then
        ok "$label"
    else
        not_ok "$label"
        printf '  # expected: %s\n' "$expected"
        printf '  # actual:   %s\n' "$output"
    fi
}

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

assert_exit_nonzero() {
    local label="$1"; shift
    if ! "$@" > /dev/null 2>&1; then ok "$label"; else not_ok "$label (expected failure)"; fi
}

assert_exit_zero() {
    local label="$1"; shift
    if "$@" > /dev/null 2>&1; then ok "$label"; else not_ok "$label (expected success)"; fi
}

# ---------------------------------------------------------------------------
# Temp dir and stubs
# ---------------------------------------------------------------------------
TMP=$(mktemp -d)
FAKE_BIN="$TMP/bin"
mkdir -p "$FAKE_BIN"
trap 'rm -rf "$TMP"' EXIT

# Fake curl: log args, output nothing (nvm.sh is pre-created by test setup)
cat > "$FAKE_BIN/curl" << 'STUB'
#!/usr/bin/env bash
echo "$*" >> "${CURL_LOG}"
STUB
chmod +x "$FAKE_BIN/curl"

# Fake nvm binary: fallback when nvm.sh is not sourced
cat > "$FAKE_BIN/nvm" << 'STUB'
#!/usr/bin/env bash
echo "nvm $*" >> "${NVM_LOG}"
STUB
chmod +x "$FAKE_BIN/nvm"

# Fake npm
cat > "$FAKE_BIN/npm" << 'STUB'
#!/usr/bin/env bash
echo "npm $*" >> "${NPM_LOG}"
STUB
chmod +x "$FAKE_BIN/npm"

# Create a fake nvm.sh that defines the nvm shell function (logs calls)
make_nvm_sh() {
    local nvm_dir="$1"
    mkdir -p "$nvm_dir"
    cat > "$nvm_dir/nvm.sh" << 'NVMSH'
nvm() { echo "nvm $*" >> "${NVM_LOG}"; }
NVMSH
}

# Run the install script with isolated HOME and stubbed tools
run_install() {
    local fake_home="$1"; shift
    local extra_env=("$@")
    CURL_LOG="$TMP/curl.log"
    NVM_LOG="$TMP/nvm.log"
    NPM_LOG="$TMP/npm.log"
    export CURL_LOG NVM_LOG NPM_LOG
    : > "$CURL_LOG"; : > "$NVM_LOG"; : > "$NPM_LOG"
    env PATH="$FAKE_BIN:$PATH" HOME="$fake_home" \
        NVM_VERSION="$NVM_VERSION" \
        NODE_DEFAULT_VERSION="$NODE_DEFAULT_VERSION" \
        "${extra_env[@]}" \
        bash "$INSTALL_SCRIPT"
}

# ---------------------------------------------------------------------------
# Test 1 — required variables missing → non-zero exit with error message
# ---------------------------------------------------------------------------
for missing_var in NODE_DEFAULT_VERSION NVM_VERSION; do
    output=$(env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" \
        NVM_VERSION="$NVM_VERSION" \
        NODE_DEFAULT_VERSION="$NODE_DEFAULT_VERSION" \
        bash "$INSTALL_SCRIPT" 2>&1 || true)

    # run again with the variable actually missing
    if [[ "$missing_var" == "NODE_DEFAULT_VERSION" ]]; then
        output=$(env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" \
            NVM_VERSION="$NVM_VERSION" bash "$INSTALL_SCRIPT" 2>&1 || true)
    else
        output=$(env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" \
            NODE_DEFAULT_VERSION="$NODE_DEFAULT_VERSION" bash "$INSTALL_SCRIPT" 2>&1 || true)
    fi

    assert_contains_str "$output" "$missing_var" \
        "$missing_var unset: error message names the variable"
    assert_contains_str "$output" "not defined" \
        "$missing_var unset: error message says 'not defined'"
done

assert_exit_nonzero \
    "NODE_DEFAULT_VERSION unset: exits non-zero" \
    env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" \
        NVM_VERSION="$NVM_VERSION" bash "$INSTALL_SCRIPT"

assert_exit_nonzero \
    "NVM_VERSION unset: exits non-zero" \
    env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" \
        NODE_DEFAULT_VERSION="$NODE_DEFAULT_VERSION" bash "$INSTALL_SCRIPT"

assert_exit_nonzero \
    "both variables unset: exits non-zero" \
    env -i HOME="$TMP" PATH="$FAKE_BIN:$PATH" bash "$INSTALL_SCRIPT"

# ---------------------------------------------------------------------------
# Test 2 — happy path
# ---------------------------------------------------------------------------
FAKE_HOME="$TMP/home"
make_nvm_sh "$FAKE_HOME/.nvm"

run_install "$FAKE_HOME"

assert_contains_file "$TMP/curl.log" "$EXPECTED_CURL_URL" \
    "happy path: curl called with correct NVM install URL"

assert_contains_file "$TMP/curl.log" "-o-" \
    "happy path: curl uses -o- flag (pipe to stdout)"

assert_contains_file "$TMP/nvm.log" "install $NODE_DEFAULT_VERSION" \
    "happy path: nvm install called with correct Node version"

for pkg in "${GLOBAL_PACKAGES[@]}"; do
    assert_contains_file "$TMP/npm.log" "$pkg" \
        "happy path: npm i -g includes $pkg"
done

assert_contains_file "$TMP/npm.log" "i -g" \
    "happy path: npm called with i -g"

# ---------------------------------------------------------------------------
# Test 3 — NVM_DIR respects XDG_CONFIG_HOME
# ---------------------------------------------------------------------------
FAKE_HOME2="$TMP/home2"
XDG_DIR="$TMP/xdg"
make_nvm_sh "$XDG_DIR/nvm"

CURL_LOG="$TMP/curl.log"
NVM_LOG="$TMP/nvm.log"
NPM_LOG="$TMP/npm.log"
export CURL_LOG NVM_LOG NPM_LOG
: > "$CURL_LOG"; : > "$NVM_LOG"; : > "$NPM_LOG"

env PATH="$FAKE_BIN:$PATH" HOME="$FAKE_HOME2" \
    XDG_CONFIG_HOME="$XDG_DIR" \
    NVM_VERSION="$NVM_VERSION" \
    NODE_DEFAULT_VERSION="$NODE_DEFAULT_VERSION" \
    bash "$INSTALL_SCRIPT"

assert_contains_file "$TMP/nvm.log" "install $NODE_DEFAULT_VERSION" \
    "XDG_CONFIG_HOME: nvm.sh loaded from \$XDG_CONFIG_HOME/nvm"

# ---------------------------------------------------------------------------
# Test 4 — nvm.sh absent: script does not exit non-zero (no set -e)
# ---------------------------------------------------------------------------
FAKE_HOME3="$TMP/home3"
mkdir -p "$FAKE_HOME3"
# Do NOT create nvm.sh — nvm binary fallback (FAKE_BIN/nvm) will be used

assert_exit_zero \
    "nvm.sh absent: script exits 0 (nvm binary fallback used)" \
    env PATH="$FAKE_BIN:$PATH" HOME="$FAKE_HOME3" \
        NVM_VERSION="$NVM_VERSION" \
        NODE_DEFAULT_VERSION="$NODE_DEFAULT_VERSION" \
        bash "$INSTALL_SCRIPT"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total=$((_pass + _fail))
printf '\n1..%d\n' "$total"
printf '# Results: %d passed, %d failed\n' "$_pass" "$_fail"
[[ $_fail -eq 0 ]]
