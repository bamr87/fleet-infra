# fleet-infra

> GitOps infrastructure for the bamr87 fleet: Terraform/HCL provisioning, a k3s cluster, and Helm charts reconciled from git.

Infrastructure-as-code for running the fleet's services on a small k3s cluster, provisioned with Terraform and kept in sync from git with Helm and a GitOps controller.

**Status:** foundation (phase 1). Part of the [bamr87 fleet](https://github.com/bamr87/bamr87).

## Goals

- Provision a reproducible k3s cluster (local VM or cloud) from Terraform
- Package fleet services as Helm charts
- Reconcile cluster state from git (Flux/Argo CD) with PR-only changes

## Skills learned

- Terraform modules, state and providers
- Kubernetes/k3s operations
- Helm chart authoring
- GitOps workflows (Flux or Argo CD)

## Fleet tie-in

Hosts fleet services (ragio-ai, fredgar-ai, law-ai, fleet-observe) and replaces ad-hoc docker compose on the bench with declarative deploys.

## Quick start

```bash
terraform init -backend=false && terraform validate
helm lint charts/fleet-base
```

## How it grows

The roadmap lives in [PRD.md](PRD.md) and [features/features.yml](features/features.yml) (ids `FINFRA-NNN`, most `status: planned`). Work arrives as pull requests from the hub's evolution and fan-out loops, the `@claude` handler, or the local `evolve` lane (off until `EVOLVE_ENABLED=true`). A human merges every PR. Rules: [docs/constitution.md](docs/constitution.md) · agent guide: [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)
