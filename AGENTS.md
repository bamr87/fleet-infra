<!-- kit: sdlc v0.2.0 · AGENTS.md is the CANONICAL agent instructions file (decision D4, UPS-AGENT-07/08).
     Keep these six `##` headings (UPS-AGENT-07 checks they exist, in any order; add your own headings as needed). CLAUDE.md is a pointer to this file and carries no rules of its own. -->

# fleet-infra

## What this repo is

GitOps infrastructure for the bamr87 fleet: Terraform/HCL provisioning, a k3s cluster, and Helm charts reconciled from git. Infrastructure-as-code for running the fleet's services on a small k3s cluster, provisioned with Terraform and kept in sync from git with Helm and a GitOps controller.

**Read [docs/constitution.md](docs/constitution.md) first.** "Done" for a change means: CI green, the feature catalog entry and PRD block updated in the same PR, and a human merged it.

## Stack & commands

```bash
terraform init -backend=false && terraform validate
helm lint charts/fleet-base
```

## Layout

- `docs/` — constitution, amendments, ADRs
- `features/features.yml` — the feature catalog (prefix `FINFRA-`)
- `PRD.md` — requirements (FRn/NFRn) and the phased roadmap
- `.github/` — CI, the `@claude` handler, the `evolve` lane (off by default), issue forms
- `.claude/agents/builder.md` — the role the evolve lane runs as
- everything else — the terraform, hcl skeleton

## Conventions

- **Backlog of record:** GitHub Issues with the fleet labels. Pick up issues labelled `agent:ready`; never touch `agent:hold` or `human-review`. <!-- File-backlog repos: "BACKLOG.md (append-only, BL-YYYYMMDD-NN), declared in .github/sdlc.yml" -->
- **Definition of Done:** the checklist in `.github/pull_request_template.md` (the fleet default is inherited when the repo has none). Every box is ticked before merge.
- **Decisions:** ADRs in `docs/adr/NNNN-slug.md`, indexed in `docs/adr/README.md`. Add one for anything hard to reverse.
- **Commits:** Conventional Commits (`feat fix docs style refactor test chore perf ci build`). The PR title is the squash subject.
- **Branches:** `feature/`, `fix/`, `docs/`, `refactor/`, `test/` or `chore/` off `main`.
- **Changelog:** `CHANGELOG.md` is written by release-please from the PR titles. Never edit it, or a version number, by hand.
- **Never:** push to `main` directly, commit lockfiles or secrets, suppress type errors, leave empty exception handlers, or edit generated files by hand.

## Fleet context

Continuous evolution: the hub's weekly repo-evolution loop and backlog fan-out open PRs here (never merge); the local `evolve` lane builds the next `status: planned` feature only when the `EVOLVE_ENABLED` repo variable is `true`.

Member of the bamr87 fleet. The standards live in the hub: <https://github.com/bamr87/bamr87/tree/main/specs> (the Universal Project Standard). The repo's SDLC declaration is `.github/sdlc.yml`. Commit here first; the hub bumps its submodule pointer afterwards.

## Standard deviations

none
<!-- Or one line per waived row, matching .github/sdlc.yml `deviations:`:
- UPS-WORK-07 waived until 2027-01-01: reason -->
