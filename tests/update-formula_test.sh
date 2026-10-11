#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/var/tmp}/homebrew-tap-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fixture_path="${tmp_dir}/release.json"
cat >"${fixture_path}" <<'JSON'
{
  "tagName": "v0.1.5",
  "isDraft": false,
  "isPrerelease": false,
  "assets": [
    {"name": "SHA256SUMS", "url": "https://example.invalid/sums", "digest": ""},
    {"name": "SHA256SUMS.minisig", "url": "https://example.invalid/sums.minisig", "digest": ""},
    {"name": "decernor_0.1.5_darwin_amd64.tar.gz", "url": "https://example.invalid/darwin-amd64", "digest": "sha256:1111111111111111111111111111111111111111111111111111111111111111"},
    {"name": "decernor_0.1.5_darwin_arm64.tar.gz", "url": "https://example.invalid/darwin-arm64", "digest": "sha256:2222222222222222222222222222222222222222222222222222222222222222"},
    {"name": "decernor_0.1.5_linux_amd64.tar.gz", "url": "https://example.invalid/linux-amd64", "digest": "sha256:3333333333333333333333333333333333333333333333333333333333333333"},
    {"name": "decernor_0.1.5_linux_arm64.tar.gz", "url": "https://example.invalid/linux-arm64", "digest": "sha256:4444444444444444444444444444444444444444444444444444444444444444"}
  ]
}
JSON

sfetch_fixture_path="${tmp_dir}/sfetch-release.json"
cat >"${sfetch_fixture_path}" <<'JSON'
{
  "tagName": "v0.4.12",
  "isDraft": false,
  "isPrerelease": false,
  "assets": [
    {"name": "SHA256SUMS", "url": "https://example.invalid/sums", "digest": ""},
    {"name": "SHA256SUMS.minisig", "url": "https://example.invalid/sums.minisig", "digest": ""},
    {"name": "sfetch_darwin_arm64.tar.gz", "url": "https://example.invalid/sfetch-darwin-arm64", "digest": "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"},
    {"name": "sfetch_linux_amd64.tar.gz", "url": "https://example.invalid/sfetch-linux-amd64", "digest": "sha256:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"},
    {"name": "sfetch_linux_arm64.tar.gz", "url": "https://example.invalid/sfetch-linux-arm64", "digest": "sha256:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"}
  ]
}
JSON

spanwit_fixture_path="${tmp_dir}/spanwit-release.json"
cat >"${spanwit_fixture_path}" <<'JSON'
{
  "tagName": "v0.2.0",
  "isDraft": false,
  "isPrerelease": false,
  "assets": [
    {"name": "SHA256SUMS", "url": "https://example.invalid/sums", "digest": ""},
    {"name": "SHA256SUMS.minisig", "url": "https://example.invalid/sums.minisig", "digest": ""},
    {"name": "spanwit_0.2.0_darwin_arm64.tar.gz", "url": "https://example.invalid/spanwit-darwin-arm64", "digest": "sha256:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"},
    {"name": "spanwit_0.2.0_linux_amd64.tar.gz", "url": "https://example.invalid/spanwit-linux-amd64", "digest": "sha256:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"},
    {"name": "spanwit_0.2.0_linux_arm64.tar.gz", "url": "https://example.invalid/spanwit-linux-arm64", "digest": "sha256:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"},
    {"name": "spanwit_0.2.0_windows_amd64.zip", "url": "https://example.invalid/spanwit-windows-amd64", "digest": "sha256:0000000000000000000000000000000000000000000000000000000000000000"}
  ]
}
JSON

mkdir -p "${tmp_dir}/bin" "${tmp_dir}/work/Formula" "${tmp_dir}/sums"

# Throwaway minisign keys; nothing real is used or written outside tmp_dir.
minisign -G -W -p "${tmp_dir}/good.pub" -s "${tmp_dir}/good.key" >/dev/null
minisign -G -W -p "${tmp_dir}/other.pub" -s "${tmp_dir}/other.key" >/dev/null
good_key="$(sed -n 2p "${tmp_dir}/good.pub")"
keys_file="${tmp_dir}/keys.txt"
printf '%s %s\n' decernor "${good_key}" sfetch "${good_key}" spanwit "${good_key}" >"${keys_file}"
export TAP_MINISIGN_KEYS_FILE="${keys_file}"

# write_sums <dir> <signing key> <trusted comment> <digest> <name> [<digest> <name> ...]
write_sums() {
  local dir="$1" key="$2" comment="$3"
  shift 3
  mkdir -p "${dir}"
  : >"${dir}/SHA256SUMS"
  while [[ $# -gt 0 ]]
  do
    printf '%s  %s\n' "$1" "$2" >>"${dir}/SHA256SUMS"
    shift 2
  done
  minisign -S -W -s "${key}" -t "${comment}" -m "${dir}/SHA256SUMS" >/dev/null
}

d1=1111111111111111111111111111111111111111111111111111111111111111
d2=2222222222222222222222222222222222222222222222222222222222222222
d3=3333333333333333333333333333333333333333333333333333333333333333
d4=4444444444444444444444444444444444444444444444444444444444444444
write_sums "${tmp_dir}/sums/v0.1.5" "${tmp_dir}/good.key" "decernor v0.1.5" \
  "${d1}" decernor_0.1.5_darwin_amd64.tar.gz "${d2}" decernor_0.1.5_darwin_arm64.tar.gz \
  "${d3}" decernor_0.1.5_linux_amd64.tar.gz "${d4}" decernor_0.1.5_linux_arm64.tar.gz
sa=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
sb=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
sc=cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
write_sums "${tmp_dir}/sums/v0.4.12" "${tmp_dir}/good.key" "sfetch v0.4.12 2026-01-01T00:00:00Z" \
  "${sa}" sfetch_darwin_arm64.tar.gz "${sb}" sfetch_linux_amd64.tar.gz "${sc}" sfetch_linux_arm64.tar.gz
dd=dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
de=eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
df=ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
d0=0000000000000000000000000000000000000000000000000000000000000000
write_sums "${tmp_dir}/sums/v0.2.0" "${tmp_dir}/good.key" "spanwit v0.2.0 2026-01-01T00:00:00Z" \
  "${dd}" spanwit_0.2.0_darwin_arm64.tar.gz "${de}" spanwit_0.2.0_linux_amd64.tar.gz \
  "${df}" spanwit_0.2.0_linux_arm64.tar.gz "${d0}" spanwit_0.2.0_windows_amd64.zip
# shellcheck disable=SC2016 # The mock script must preserve its variables.
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  'if [[ "$1" == "release" && "$2" == "download" ]]; then' \
  '  tag="$3"; dir=""' \
  '  shift 3' \
  '  while [[ $# -gt 0 ]]; do [[ "$1" == "--dir" ]] && dir="$2"; shift; done' \
  '  cp "${SUMS_FIXTURE_DIR:?}/${tag}/SHA256SUMS" "${SUMS_FIXTURE_DIR}/${tag}/SHA256SUMS.minisig" "${dir:?}/"' \
  '  exit 0' \
  'fi' \
  'if [[ "$1" != "release" || "$2" != "view" ]]; then' \
  '  echo "unexpected gh arguments: $*" >&2' \
  '  exit 1' \
  'fi' \
  'case "$3" in' \
  '  v0.1.5) cat "${DECERNOR_RELEASE_FIXTURE:?}" ;;' \
  '  v0.4.12) cat "${SFETCH_RELEASE_FIXTURE:?}" ;;' \
  '  v0.2.0) cat "${SPANWIT_RELEASE_FIXTURE:?}" ;;' \
  '  *) echo "unexpected release tag: $3" >&2; exit 1 ;;' \
  'esac' >"${tmp_dir}/bin/gh"
chmod +x "${tmp_dir}/bin/gh"
export SUMS_FIXTURE_DIR="${tmp_dir}/sums"

(
  cd "${tmp_dir}/work"
  PATH="${tmp_dir}/bin:${PATH}" DECERNOR_RELEASE_FIXTURE="${fixture_path}" \
    SFETCH_RELEASE_FIXTURE="${sfetch_fixture_path}" \
    ruby "${root_dir}/scripts/update-formula.rb" decernor v0.1.5

  PATH="${tmp_dir}/bin:${PATH}" DECERNOR_RELEASE_FIXTURE="${fixture_path}" \
    SFETCH_RELEASE_FIXTURE="${sfetch_fixture_path}" \
    ruby "${root_dir}/scripts/update-formula.rb" sfetch v0.4.12

  PATH="${tmp_dir}/bin:${PATH}" SPANWIT_RELEASE_FIXTURE="${spanwit_fixture_path}" \
    ruby "${root_dir}/scripts/update-formula.rb" spanwit v0.2.0
)

formula_path="${tmp_dir}/work/Formula/decernor.rb"
grep -q 'https://example.invalid/darwin-amd64' "${formula_path}"
grep -q 'https://example.invalid/darwin-arm64' "${formula_path}"
grep -q 'https://example.invalid/linux-amd64' "${formula_path}"
grep -q 'https://example.invalid/linux-arm64' "${formula_path}"
grep -q 'bin.install "decernor"' "${formula_path}"

sfetch_formula_path="${tmp_dir}/work/Formula/sfetch.rb"
grep -q 'https://example.invalid/sfetch-darwin-arm64' "${sfetch_formula_path}"
grep -q 'https://example.invalid/sfetch-linux-amd64' "${sfetch_formula_path}"
grep -q 'https://example.invalid/sfetch-linux-arm64' "${sfetch_formula_path}"
grep -q 'bin.install "sfetch"' "${sfetch_formula_path}"

# Versioned archive profile without an Intel macOS asset: arm-only macOS.
spanwit_formula_path="${tmp_dir}/work/Formula/spanwit.rb"
grep -q 'https://example.invalid/spanwit-darwin-arm64' "${spanwit_formula_path}"
grep -q 'https://example.invalid/spanwit-linux-amd64' "${spanwit_formula_path}"
grep -q 'https://example.invalid/spanwit-linux-arm64' "${spanwit_formula_path}"
grep -q 'depends_on arch: :arm64' "${spanwit_formula_path}"
grep -q 'bin.install "spanwit"' "${spanwit_formula_path}"
grep -q 'system bin/"spanwit", "version"' "${spanwit_formula_path}"
# Each digest lands on its own platform stanza (catches swapped or truncated hashes).
assert_stanza() {
  local file="$1"
  local url="$2"
  local digest="$3"
  if ! grep -A1 "url \"${url}\"" "${file}" | grep -q "sha256 \"${digest}\""
  then
    echo "expected sha256 ${digest} under ${url} in ${file}" >&2
    exit 1
  fi
}
assert_stanza "${formula_path}" https://example.invalid/darwin-amd64 1111111111111111111111111111111111111111111111111111111111111111
assert_stanza "${formula_path}" https://example.invalid/darwin-arm64 2222222222222222222222222222222222222222222222222222222222222222
assert_stanza "${formula_path}" https://example.invalid/linux-amd64 3333333333333333333333333333333333333333333333333333333333333333
assert_stanza "${formula_path}" https://example.invalid/linux-arm64 4444444444444444444444444444444444444444444444444444444444444444
assert_stanza "${spanwit_formula_path}" https://example.invalid/spanwit-darwin-arm64 dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
assert_stanza "${spanwit_formula_path}" https://example.invalid/spanwit-linux-amd64 eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
assert_stanza "${spanwit_formula_path}" https://example.invalid/spanwit-linux-arm64 ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

grep -q 'def caveats' "${spanwit_formula_path}"
grep -q 'unless you pass --execute' "${spanwit_formula_path}"
grep -q 'https://github.com/3leaps/spanwit#readme' "${spanwit_formula_path}"
if grep -q 'def caveats' "${formula_path}"
then
  echo "decernor formula must not gain caveats" >&2
  exit 1
fi

if grep -q 'darwin_amd64\|windows' "${spanwit_formula_path}"
then
  echo "spanwit formula must not reference Intel macOS or Windows assets" >&2
  exit 1
fi

# Refusals: every case must exit non-zero and leave the formula untouched.
# expect_refusal <label> <expected error text> <env prefix...>
expect_refusal() {
  local label="$1"
  local reason="$2"
  shift 2
  local before err
  before="$(shasum -a 256 "${spanwit_formula_path}")"
  if err="$(cd "${tmp_dir}/work" && PATH="${tmp_dir}/bin:${PATH}" SPANWIT_RELEASE_FIXTURE="${spanwit_fixture_path}" "$@" \
    ruby "${root_dir}/scripts/update-formula.rb" spanwit v0.2.0 2>&1 >/dev/null)"
  then
    echo "expected refusal: ${label}" >&2
    exit 1
  fi
  if [[ "${err}" != *"${reason}"* ]]
  then
    echo "${label} refused for the wrong reason: ${err}" >&2
    exit 1
  fi
  if [[ "$(shasum -a 256 "${spanwit_formula_path}")" != "${before}" ]]
  then
    echo "refused run still rewrote the formula: ${label}" >&2
    exit 1
  fi
}
reset_spanwit_sums() {
  write_sums "${tmp_dir}/sums/v0.2.0" "${tmp_dir}/good.key" "spanwit v0.2.0 2026-01-01T00:00:00Z" \
    "${dd}" spanwit_0.2.0_darwin_arm64.tar.gz "${de}" spanwit_0.2.0_linux_amd64.tar.gz \
    "${df}" spanwit_0.2.0_linux_arm64.tar.gz "${d0}" spanwit_0.2.0_windows_amd64.zip
}

# Signed by a key that is not the pinned one.
write_sums "${tmp_dir}/sums/v0.2.0" "${tmp_dir}/other.key" "spanwit v0.2.0 2026-01-01T00:00:00Z" \
  "${dd}" spanwit_0.2.0_darwin_arm64.tar.gz "${de}" spanwit_0.2.0_linux_amd64.tar.gz \
  "${df}" spanwit_0.2.0_linux_arm64.tar.gz
expect_refusal "signature from an unpinned key" "does not verify against the pinned key" env

# Manifest edited after signing.
reset_spanwit_sums
sed -i.bak "s/${dd}/${de}/" "${tmp_dir}/sums/v0.2.0/SHA256SUMS"
expect_refusal "manifest changed after signing" "does not verify against the pinned key" env

# A validly signed manifest for a different tag replayed under this one.
write_sums "${tmp_dir}/sums/v0.2.0" "${tmp_dir}/good.key" "spanwit v0.1.9 2026-01-01T00:00:00Z" \
  "${dd}" spanwit_0.2.0_darwin_arm64.tar.gz "${de}" spanwit_0.2.0_linux_amd64.tar.gz \
  "${df}" spanwit_0.2.0_linux_arm64.tar.gz
expect_refusal "signed manifest for another tag" "is signed for v0.1.9" env

# An archive missing from the signed manifest.
write_sums "${tmp_dir}/sums/v0.2.0" "${tmp_dir}/good.key" "spanwit v0.2.0 2026-01-01T00:00:00Z" \
  "${dd}" spanwit_0.2.0_darwin_arm64.tar.gz "${de}" spanwit_0.2.0_linux_amd64.tar.gz
expect_refusal "archive not in signed manifest" "is not listed in the signed SHA256SUMS" env

# GitHub digest disagrees with the signed manifest.
reset_spanwit_sums
mismatch_fixture="${tmp_dir}/spanwit-mismatch.json"
sed "s/sha256:${dd}/sha256:${de}/" "${spanwit_fixture_path}" >"${mismatch_fixture}"
if (cd "${tmp_dir}/work" && PATH="${tmp_dir}/bin:${PATH}" SPANWIT_RELEASE_FIXTURE="${mismatch_fixture}" \
  ruby "${root_dir}/scripts/update-formula.rb" spanwit v0.2.0) >/dev/null 2>&1
then
  echo "expected refusal: GitHub digest differs from signed manifest" >&2
  exit 1
fi

# A name listed twice in the signed manifest.
write_sums "${tmp_dir}/sums/v0.2.0" "${tmp_dir}/good.key" "spanwit v0.2.0 2026-01-01T00:00:00Z" \
  "${dd}" spanwit_0.2.0_darwin_arm64.tar.gz "${de}" spanwit_0.2.0_linux_amd64.tar.gz \
  "${df}" spanwit_0.2.0_linux_arm64.tar.gz "${de}" spanwit_0.2.0_darwin_arm64.tar.gz
expect_refusal "duplicate name in signed manifest" "is listed twice" env
reset_spanwit_sums

# No pinned key for the app.
printf '%s %s\n' decernor "${good_key}" >"${tmp_dir}/keys-nospanwit.txt"
expect_refusal "no pinned key" "no pinned minisign key" env TAP_MINISIGN_KEYS_FILE="${tmp_dir}/keys-nospanwit.txt"
other_key="$(sed -n 2p "${tmp_dir}/other.pub")"
printf '%s %s\n' spanwit "${good_key}" spanwit "${other_key}" >"${tmp_dir}/keys-dup.txt"
expect_refusal "two pinned keys" "no pinned minisign key" env TAP_MINISIGN_KEYS_FILE="${tmp_dir}/keys-dup.txt"

# Release without signature assets.
nosig_fixture="${tmp_dir}/spanwit-nosig.json"
grep -v 'SHA256SUMS' "${spanwit_fixture_path}" >"${nosig_fixture}"
if (cd "${tmp_dir}/work" && PATH="${tmp_dir}/bin:${PATH}" SPANWIT_RELEASE_FIXTURE="${nosig_fixture}" \
  ruby "${root_dir}/scripts/update-formula.rb" spanwit v0.2.0) >/dev/null 2>&1
then
  echo "expected refusal: release without SHA256SUMS assets" >&2
  exit 1
fi

echo "update-formula archive profile and signed-checksum tests passed"
