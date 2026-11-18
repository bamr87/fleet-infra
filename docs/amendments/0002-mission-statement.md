<!-- kit: governance v0.1.0 -->
# 0002 — Missions

- **Status:** proposed
- **Date:** 2026-11-16
- **Proposed by:** Grok Bot (agent), at the maintainer's request
- **Ratified by:**
- **Affects:** constitution §1; PRD.md §1.1; FINFRA-008
- **Supersedes:** none
- **Related:** [PRD.md](../../PRD.md) §1.1

## Context

Constitution §1 was a single mission sentence or short paragraph, not one direction statement with exactly three numbered missions. The fleet rule is that every repo's constitution §1 uses that form, adopted through a numbered amendment the maintainer ratifies by merging. Mission 1 is the maintainer's own wording, adapted to this repo: provide data, tools, resources and transparency for all stakeholders, practitioners in the domain, and the general public. The ambition is the direction, not a claim that the work is already finished.

The earlier §1 text was:

> Infrastructure-as-code for running the fleet's services on a small k3s cluster, provisioned with Terraform and kept in sync from git with Helm and a GitOps controller. It is a learning-first portfolio project in the bamr87 fleet: Hosts fleet services (ragio-ai, fredgar-ai, law-ai, fleet-observe) and replaces ad-hoc docker compose on the bench with declarative deploys.

## Amendment

Retitle constitution §1 **Missions**. Replace the body of §1 with the following. Any invariants or other normative rules that already lived outside §1 are unchanged.

fleet-infra's direction is to become the ultimate open home for all things fleet infrastructure — data, tools, resources and transparency, gathered in one place that anyone can inspect and reuse.

1. **Provide data, tools, resources and transparency for all stakeholders, operators, infrastructure practitioners and the general public.** Operators, learners, service owners, and the general public are first-class audiences. The aim is a shared, open commons: the same sources, the same tools, and the same trail of evidence for everyone.
2. **Make running the fleet's services declarative, inspectable and reproducible.** Provision with Terraform, run a small k3s cluster, and keep Helm charts in sync from git with a GitOps controller.
3. **Put that platform in every operator's and learner's hands, and make hosting fleet services a matter of merging git.** The path replaces ad-hoc docker compose on the bench and hosts fleet services such as ragio-ai, fredgar-ai, law-ai and fleet-observe — an open toolkit for working with all things fleet infrastructure.

These missions set the course; they do not claim the work is finished. They serve the existing constitution and PRD purpose: infrastructure-as-code for a small k3s cluster, kept in sync from git. The earlier mission paragraph is absorbed into these three. Every feature must trace to them.

_Source: [../PRD.md](../PRD.md) §1.1._

## Consequences

Agents and reviewers judge fit against these three missions before inventing scope, treating them as the direction of the repo rather than a description of what already ships. The same text is added as PRD.md §1.1 so the constitution's `_Source:` line stays accurate. The PRD purpose, goals, feature catalog and invariants outside this addition are unchanged except for a new catalog entry (FINFRA-008) and a regenerated feature-catalog block where the repo already has one. This PR also aligns the README and AGENTS.md one-liners with the missions and links them to constitution §1.
