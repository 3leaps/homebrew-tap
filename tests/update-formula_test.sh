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

mkdir -p "${tmp_dir}/bin" "${tmp_dir}/work/Formula"
# shellcheck disable=SC2016 # The mock script must preserve its variables.
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  'if [[ "$1" != "release" || "$2" != "view" || "$3" != "v0.1.5" ]]; then' \
  '  echo "unexpected gh arguments: $*" >&2' \
  '  exit 1' \
  'fi' \
  'cat "${RELEASE_FIXTURE:?}"' >"${tmp_dir}/bin/gh"
chmod +x "${tmp_dir}/bin/gh"

(
  cd "${tmp_dir}/work"
  PATH="${tmp_dir}/bin:${PATH}" RELEASE_FIXTURE="${fixture_path}" \
    ruby "${root_dir}/scripts/update-formula.rb" decernor v0.1.5
)

formula_path="${tmp_dir}/work/Formula/decernor.rb"
grep -q 'https://example.invalid/darwin-amd64' "${formula_path}"
grep -q 'https://example.invalid/darwin-arm64' "${formula_path}"
grep -q 'https://example.invalid/linux-amd64' "${formula_path}"
grep -q 'https://example.invalid/linux-arm64' "${formula_path}"
grep -q 'bin.install "decernor"' "${formula_path}"

echo "update-formula archive profile test passed"
