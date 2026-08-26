# Adding A Formula

This guide is the default pattern for agents and maintainers when onboarding another 3 Leaps CLI into the tap.

## Prerequisites

The upstream repository should already satisfy the direct-binary default, or
have an explicit archive profile in `scripts/update-formula.rb`:

- publish GitHub releases from `3leaps/<app>`
- upload direct binaries for `darwin-arm64`, `linux-amd64`, and `linux-arm64`
- publish Windows binaries separately if needed
- sign release provenance with minisign and, where required, GPG
- expose a stable `--version` command

If the tool also supports Intel macOS, publish `darwin-amd64` as an additional asset.

## Release Asset Convention

This tap currently expects direct binary assets named:

```text
<app>-darwin-arm64
<app>-linux-amd64
<app>-linux-arm64
```

Optional:

```text
<app>-darwin-amd64
```

Decernor uses the existing versioned-archive profile. Add another archive
profile only when its release layout differs from both established patterns.

## First-Time Onboarding

1. Publish a real GitHub release from the upstream repository.
2. Run `make update APP=<app> TAG=vX.Y.Z` in this repository.
3. Review the generated formula in `Formula/<app>.rb`.
4. Run `make audit APP=<app>`.
5. Run `make test APP=<app>`.
6. Commit the formula and documentation updates.
7. Patch the upstream release checklist so the post-publish tap update becomes part of the normal release flow.

## Checklist Updates For Upstream Repos

Each upstream repository should document a post-publish step similar to:

```bash
cd ../homebrew-tap
make update APP=<app> TAG=v<version>
make audit APP=<app>
make test APP=<app>
git add Formula/<app>.rb
git commit -m "Update <app> Homebrew formula to v<version>"
git push origin main
```

## Current Seed Repositories

- `kitfly`
- `gonimbus`

Use these as the reference implementation before onboarding additional tools such as `mdmeld`, `authbolt`, or other 3 Leaps CLIs.
