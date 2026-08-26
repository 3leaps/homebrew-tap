# 3 Leaps Homebrew Tap

[![brew test-bot](https://github.com/3leaps/homebrew-tap/actions/workflows/tests.yml/badge.svg)](https://github.com/3leaps/homebrew-tap/actions/workflows/tests.yml)

Official Homebrew tap for CLI tools published from the [3leaps GitHub organization](https://github.com/3leaps).

This tap is the distribution layer for installable macOS and Linux binaries released from 3 Leaps repositories. Windows binaries are still published in upstream GitHub releases, but Homebrew only consumes the macOS and Linux assets.

## Available Formulae

- `decernor` - Local key-material hygiene and readiness checks
- `kitfly` - Turn your writing into a website
- `gonimbus` - Cloud object storage crawl, inspect, and streaming CLI
- `mdmeld` - Pack directory trees into markdown archives for AI sharing
- `seclusor` - Git-trackable secrets management with age encryption

## Quick Start

```bash
brew tap 3leaps/tap
brew install 3leaps/tap/decernor
brew install 3leaps/tap/kitfly
brew install 3leaps/tap/gonimbus
brew install 3leaps/tap/mdmeld
brew install 3leaps/tap/seclusor
```

Or install by short name after tapping:

```bash
brew tap 3leaps/tap
brew install decernor
brew install kitfly
brew install gonimbus
brew install mdmeld
brew install seclusor
```

## Supported Platforms

Homebrew formulae in this repository install prebuilt binaries for the platforms each tool actually publishes. The baseline 3 Leaps pattern is:

- macOS ARM64
- Linux ARM64
- Linux AMD64

Some tools also publish macOS AMD64 assets. Upstream release workflows can additionally publish Windows AMD64 and Windows ARM64 binaries, but those assets are not used by Homebrew.

Formula support follows each published release. Decernor supports macOS Intel
and Apple Silicon plus Linux AMD64/ARM64; formulae without an Intel macOS asset
report an unsupported-architecture error on that platform.

## Maintainer Workflow

After an upstream GitHub release is published:

```bash
make update APP=kitfly TAG=vX.Y.Z
make audit APP=kitfly
make test APP=kitfly
```

The generic updater reads the requested published GitHub release metadata and
rewrites the formula with the release tag and per-platform SHA256 digests. Omit
`TAG` only when intentionally updating to the latest published release.

Use `make release APP=<name>` to run the full local tap workflow.

CI runs `brew test-bot` on every push and pull request. For branch protection, require `test-bot (ubuntu-24.04)` and `test-bot (macos-latest)`.

## Documentation

- [Release process](RELEASE_PROCESS.md)
- [Adding another formula](docs/adding-a-formula.md)

## Repository Layout

```text
Formula/              Homebrew formulae
docs/                 Maintainer and agent guides
scripts/              Local automation for updating formulae
Makefile              Common tap maintenance targets
```
