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

Requires Terraform `>= 1.6` (the `required_version` in `main.tf`) and Helm. Neither step needs cloud credentials or a running cluster.

```bash
# Validate the Terraform root module without configuring a backend
terraform init -backend=false && terraform validate

# Lint the base chart and render it locally (the same command the CI `build` job runs)
helm lint charts/fleet-base && helm template charts/fleet-base
```

To see the outputs, run a plain `terraform init` (local state, no credentials) and then `terraform plan`. The plan shows the module's two outputs: `cluster_name` (variable `cluster_name`, default `fleet`) and `namespaces` (`fleet-system`, `fleet-apps`). Override the name with `terraform plan -var cluster_name=<name>`. The module provisions nothing yet; k3s provisioning is FINFRA-003.

## Layout

| Path | What it is |
| --- | --- |
| `main.tf` | Terraform root module: the `cluster_name` variable, the namespace list, and their outputs |
| `charts/fleet-base/` | Base Helm chart; `values.yaml` sets `namespace`, `image` and `replicas`, and `templates/deployment.yaml` renders a placeholder nginx Deployment. It does not render the Namespace object yet (FINFRA-002) |
| `features/features.yml`, `PRD.md` | Feature catalog (`FINFRA-NNN`) and requirements/roadmap |
| `docs/` | Constitution, amendments and ADRs |
| `.github/workflows/` | `ci.yml` (the fleet standard gate plus the Helm `build` job), `claude.yml` (`@claude` handler), `evolve.yml` (the `evolve` lane) |

## How it grows

The roadmap lives in [PRD.md](PRD.md) and [features/features.yml](features/features.yml) (ids `FINFRA-NNN`, most `status: planned`). Work arrives as pull requests from the hub's evolution and fan-out loops, the `@claude` handler, or the local `evolve` lane (off until `EVOLVE_ENABLED=true`). A human merges every PR. Rules: [docs/constitution.md](docs/constitution.md) · agent guide: [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)
