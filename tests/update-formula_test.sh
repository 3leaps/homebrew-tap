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
    {"name": "spanwit_0.2.0_darwin_arm64.tar.gz", "url": "https://example.invalid/spanwit-darwin-arm64", "digest": "sha256:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"},
    {"name": "spanwit_0.2.0_linux_amd64.tar.gz", "url": "https://example.invalid/spanwit-linux-amd64", "digest": "sha256:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"},
    {"name": "spanwit_0.2.0_linux_arm64.tar.gz", "url": "https://example.invalid/spanwit-linux-arm64", "digest": "sha256:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"},
    {"name": "spanwit_0.2.0_windows_amd64.zip", "url": "https://example.invalid/spanwit-windows-amd64", "digest": "sha256:0000000000000000000000000000000000000000000000000000000000000000"}
  ]
}
JSON

mkdir -p "${tmp_dir}/bin" "${tmp_dir}/work/Formula"
# shellcheck disable=SC2016 # The mock script must preserve its variables.
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -euo pipefail' \
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

echo "update-formula archive profile tests passed"
