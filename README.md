# 3 Leaps Homebrew Tap

Official Homebrew tap for CLI tools published from the [3leaps GitHub organization](https://github.com/3leaps).

This tap is the distribution layer for installable macOS and Linux binaries released from 3 Leaps repositories. Windows binaries are still published in upstream GitHub releases, but Homebrew only consumes the macOS and Linux assets.

## Available Formulae

- `kitfly` - Turn your writing into a website
- `gonimbus` - Cloud object storage crawl, inspect, and streaming CLI

## Quick Start

```bash
brew tap 3leaps/tap
brew install 3leaps/tap/kitfly
brew install 3leaps/tap/gonimbus
```

Or install by short name after tapping:

```bash
brew tap 3leaps/tap
brew install kitfly
brew install gonimbus
```

## Supported Platforms

Homebrew formulae in this repository install prebuilt binaries for the platforms each tool actually publishes. The baseline 3 Leaps pattern is:

- macOS ARM64
- Linux ARM64
- Linux AMD64

Some tools also publish macOS AMD64 assets. Upstream release workflows can additionally publish Windows AMD64 and Windows ARM64 binaries, but those assets are not used by Homebrew.

## Maintainer Workflow

After an upstream GitHub release is published:

```bash
make update APP=kitfly
make audit APP=kitfly
make test APP=kitfly
```

The generic updater reads the latest published GitHub release metadata from the target repository and rewrites the formula with the release tag and per-platform SHA256 digests.

Use `make release APP=<name>` to run the full local tap workflow.

## Documentation

- [Release process](/Users/davethompson/dev/3leaps/homebrew-tap/RELEASE_PROCESS.md)
- [Adding another formula](/Users/davethompson/dev/3leaps/homebrew-tap/docs/adding-a-formula.md)

## Repository Layout

```text
Formula/              Homebrew formulae
docs/                 Maintainer and agent guides
scripts/              Local automation for updating formulae
Makefile              Common tap maintenance targets
```
