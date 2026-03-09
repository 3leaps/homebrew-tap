# Release Process

This repository tracks published GitHub release assets from repositories in the `3leaps` organization and exposes them as Homebrew formulae.

## Current Pattern

Each tap-managed application should publish release assets with this macOS/Linux naming convention:

```text
<app>-darwin-arm64
<app>-linux-amd64
<app>-linux-arm64
```

If a repository also supports Intel macOS, publish:

```text
<app>-darwin-amd64
```

The Homebrew formula installs the matching binary for the user platform and renames it to the stable command name in `bin/`.

Windows assets can still be published upstream, but they are ignored here.

## Updating a Formula

After the upstream release is published:

```bash
cd ~/dev/3leaps/homebrew-tap
make update APP=kitfly
make audit APP=kitfly
make test APP=kitfly
```

The updater script:

1. Reads the latest published release from GitHub.
2. Extracts the release tag and asset SHA256 digests.
3. Rewrites `Formula/<app>.rb`.

## Adding Another Tool

Before a new repository is added to this tap, confirm:

- The repository publishes GitHub releases under the `3leaps` org.
- macOS and Linux binaries exist for `amd64` and `arm64`.
- Asset names match the direct-binary convention above.
- The binary supports `--version` for the formula test block.
- The repository release checklist includes a post-publish tap update step.

Detailed onboarding guidance lives in [docs/adding-a-formula.md](/Users/davethompson/dev/3leaps/homebrew-tap/docs/adding-a-formula.md).
