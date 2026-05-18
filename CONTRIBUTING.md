# Contributing

LinuxBenchHub is a personal project mid-build. The Ubuntu writeup and R parsers work; the Rails dashboard and the Fedora/Debian writeups are in progress. Bug fixes and reproducibility improvements are welcome; large features are best opened as issues first so we agree on direction before code review.

## Development setup

### Static benchmarks (R)

```bash
# R deps (one-time)
Rscript -e 'install.packages(c("xml2", "dplyr", "ggplot2", "tidyr"))'

# Re-parse an existing composite into summary stats + plots
Rscript benchmarks/ubuntu/Parse_composite_Ubuntu.R path/to/composite.xml
```

Lint rules for the R scripts are pinned in `.lintr` at repo root; run via `lintr::lint_dir(".")` if you have lintr installed.

### Rails dashboard

```bash
cd website

# Ruby version is pinned in website/.ruby-version (3.3.0)
# Use rbenv, asdf, or your Ruby version manager of choice.
bundle install

# Database, asset prep
bin/rails db:prepare

# Dev server
bin/rails server

# Background workers (BenchmarkJob runs through Sidekiq)
bundle exec sidekiq
```

The app expects **VMware Fusion Pro** and the `vmrun` CLI on the host machine for VM lifecycle operations. Without them, the dashboard renders and reads existing benchmark data, but launching new benchmarks will fail.

### Lint

The Rails app uses the omakase Ruby style (`website/.rubocop.yml`):

```bash
cd website && bundle exec rubocop --parallel
```

## Project-specific guardrails

- **Identical guest hardware is load-bearing.** Comparisons between distros are only valid because every VM uses the same VMware Fusion synthetic hardware profile (2&times; i5-7360U, 4 GB RAM, 21 GB disk, Intel 82545EM NIC). Don't merge a benchmark run captured on a different VM profile into the existing per-distro folders &mdash; either add a new folder with the new profile, or keep it out of `benchmarks/`.
- **`pts/composite.xml` is the contract between the R parser and the Rails ingester.** Both sides read the same XML; don't split them onto separate schemas. If you change the parser, change the ingester in the same PR.
- **The `.kamal/` config is not currently pointing at a live host.** Don't add a "deploy to prod" CI step without first confirming the deploy target exists.
- **Don't commit raw test runs that don't have a writeup.** Each `benchmarks/<distro>/` folder should track to the `<distro>.md` markdown writeup. Orphan raw data accretes fast and makes the repo confusing.
- **Devise migrations and seeds are not in a known-stable state.** Treat the database as scratch in development &mdash; don't write production data assumptions into seeds yet.

## Commit conventions

The existing log uses short imperative subjects. Examples:

```
Add Rails UJS support, update performance benchmarks controller for destroy action, and adjust JavaScript imports
Add rdoc for documentation, implement background job for benchmark execution, and enhance GUI with VM connection details
Trying to fix this
```

(The last one is honest about debugging state; that's fine when nothing in production depends on the message.) Match the imperative style. No AI co-author trailer.

## PR process

1. Open an issue first for anything that touches more than one of: benchmarks, R parsers, Rails dashboard. Easier to align on scope before code review.
2. Run the relevant lint and tests locally before opening the PR:
   - Static benchmarks: `Rscript -e 'lintr::lint_dir(".")'`
   - Rails: `cd website && bundle exec rubocop --parallel && bin/rails test`
3. CI (Ruby + R syntax) must be green.
4. Squash-merge into `main`.

## Scope

**In scope:**

- Finishing the Fedora 40 and Debian 12 writeups (`benchmarks/fedora/fedora.md`, `benchmarks/debian/debian.md`) from the captured raw `pts/*` data.
- Bug fixes in `BenchmarkJob`, the noVNC integration, and the Phoronix ingester.
- Adding new Phoronix tests to the matrix (with a new VM run for every existing distro to keep the comparison valid).
- Improving the R parser output (better plots, additional summary stats).
- Documentation and README clarifications.

**Out of scope:**

- Switching benchmarking tools (e.g. UnixBench, Geekbench) &mdash; the cross-distro comparison is anchored to Phoronix Test Suite.
- Replacing the Rails stack with a different web framework &mdash; the noVNC integration and Sidekiq jobs are non-trivial to port.
- Adding distros without going through the VM profile guardrail above.
- Bundling Phoronix Test Suite or noVNC source into this repo &mdash; both are referenced as external dependencies.

If you're unsure, open an issue and ask.
