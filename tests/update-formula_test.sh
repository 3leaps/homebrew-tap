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

echo "update-formula archive profile tests passed"
