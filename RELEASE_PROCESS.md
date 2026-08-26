# Release Process

This repository tracks published GitHub release assets from repositories in the `3leaps` organization and exposes them as Homebrew formulae.

## Current Pattern

Most tap-managed applications publish direct macOS/Linux binaries named:

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

Decernor is the archive profile. It publishes versioned archives containing the
`decernor` binary:

```text
decernor_<version>_darwin_amd64.tar.gz
decernor_<version>_darwin_arm64.tar.gz
decernor_<version>_linux_amd64.tar.gz
decernor_<version>_linux_arm64.tar.gz
```

Windows assets can still be published upstream, but they are ignored here.

## Updating a Formula

After the upstream release is published:

```bash
cd ~/dev/3leaps/homebrew-tap
make update APP=kitfly TAG=vX.Y.Z
make audit APP=kitfly
make test APP=kitfly
```

The updater script:

1. Reads the requested published release from GitHub, or the latest when no
   tag is supplied.
2. Extracts the release tag and asset SHA256 digests.
3. Rewrites `Formula/<app>.rb`.

## Adding Another Tool

Before a new repository is added to this tap, confirm:

- The repository publishes GitHub releases under the `3leaps` org.
- macOS and Linux binaries exist for `amd64` and `arm64`.
- Asset names match the direct-binary convention above or an explicit updater
  profile such as Decernor's versioned archives.
- The binary supports `--version` for the formula test block.
- The repository release checklist includes a post-publish tap update step.

Detailed onboarding guidance lives in [docs/adding-a-formula.md](/Users/davethompson/dev/3leaps/homebrew-tap/docs/adding-a-formula.md).
