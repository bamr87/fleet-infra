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

Requires Terraform `>= 1.6` (the `required_version` in `main.tf`) and Helm. None of these commands needs cloud credentials or a running cluster, and CI runs them on every pull request: the Terraform ones in its `terraform` job, the Helm one in its `build` job.

```bash
# Check the formatting (the .tf files and tests/), then validate the root module without configuring a backend
terraform fmt -check -recursive
terraform init -backend=false && terraform validate

# Run the native tests in tests/: every run is a plan, so nothing is created and no state is kept
terraform test

# Lint the base chart and render it locally
helm lint charts/fleet-base && helm template charts/fleet-base
```

To see the outputs, run a plain `terraform init` (local state, no credentials) and then `terraform plan`. The plan shows the module's two outputs: `cluster_name` (variable `cluster_name`, default `fleet`) and `namespaces` (`fleet-system`, `fleet-apps`). Override the name with `terraform plan -var cluster_name=<name>`. The name must be a lowercase RFC 1123 label: at most 63 characters of `a-z`, `0-9` and `-`, starting and ending with a letter or digit; anything else fails validation. The module provisions nothing yet; k3s provisioning is FINFRA-003.

`local.namespaces` in `main.tf` is the source of truth for namespace names. The chart's `namespace` value must be one of them, and `terraform test` fails when it is not.

On a cluster, `helm install fleet-base charts/fleet-base` creates the `fleet-apps` Namespace and deploys the placeholder into it. If the namespace already exists, or you install with `-n fleet-apps --create-namespace`, add `--set createNamespace=false`; otherwise Helm stops on an ownership conflict over the Namespace. The Namespace carries `helm.sh/resource-policy: keep`, so `helm uninstall`, or turning `createNamespace` off later, leaves it and whatever runs in it; delete it with `kubectl delete namespace fleet-apps` when you mean to.

The placeholder runs `nginxinc/nginx-unprivileged` instead of the stock `nginx` image. It listens on 8080 and runs as uid 101, with its pid file and temp paths in `/tmp`, so it starts under the chart's hardened defaults: non-root, no privilege escalation, every capability dropped, the `RuntimeDefault` seccomp profile, and a read-only root filesystem with an `emptyDir` at `/tmp`. Stock nginx starts as root to bind port 80 and to switch to its worker user, so it cannot start under those settings.

## Layout

| Path | What it is |
| --- | --- |
| `main.tf` | Terraform root module: the `cluster_name` variable (validated as an RFC 1123 label), the namespace list (the source of truth for namespace names), and their outputs |
| `tests/` | `main.tftest.hcl`: native `terraform test` runs, all plan-only, for the defaults, the `cluster_name` validation and the chart's namespace |
| `charts/fleet-base/` | Base Helm chart (FINFRA-002); `values.yaml` holds every setting (`namespace`, `createNamespace`, `image`, `replicas`, `containerPort`, `resources`, the probes and the security contexts), `templates/namespace.yaml` renders the Namespace, and `templates/deployment.yaml` renders the hardened placeholder nginx Deployment |
| `features/features.yml`, `PRD.md` | Feature catalog (`FINFRA-NNN`) and requirements/roadmap |
| `docs/` | Constitution, amendments and ADRs |
| `.github/workflows/` | `ci.yml` (the fleet standard gate, the Helm `build` job and the `terraform` job: fmt, init, validate, test), `claude.yml` (`@claude` handler), `evolve.yml` (the `evolve` lane) |

## How it grows

The roadmap lives in [PRD.md](PRD.md) and [features/features.yml](features/features.yml) (ids `FINFRA-NNN`, most `status: planned`). Work arrives as pull requests from the hub's evolution and fan-out loops, the `@claude` handler, or the local `evolve` lane (off until `EVOLVE_ENABLED=true`). A human merges every PR. Rules: [docs/constitution.md](docs/constitution.md) · agent guide: [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)
