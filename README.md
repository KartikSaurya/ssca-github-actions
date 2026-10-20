# SSCA GitHub Actions — sample workflows

Reference implementations for running **Harness SSCA** in GitHub Actions using the official marketplace composites from **[harness/github-actions](https://github.com/harness/github-actions)**.

Actions are published at the **repository root** (`sbom-generation/`, `slsa-generation/`, …). This repo contains **workflows only**—no vendored copies of those composites.

[![Harness SSCA docs](https://img.shields.io/badge/Docs-Harness%20SSCA-blue)](https://developer.harness.io/docs/software-supply-chain-assurance)
[![Marketplace actions](https://img.shields.io/badge/Actions-harness%2Fgithub--actions-000?labelColor=24292f)](https://github.com/harness/github-actions)

---

## Workflow matrix

Each row is a `workflow_dispatch` workflow under [`.github/workflows/`](.github/workflows/). All steps use `harness/github-actions/<action>@main` (pin a release tag in production).

| Workflow file | Artifact type | `SOURCE_TYPE` | Signing |
|---------------|---------------|---------------|---------|
| [`container-keyless.yml`](.github/workflows/container-keyless.yml) | Container image | `docker` | GitHub OIDC → Harness Fulcio (`OIDC_PROVIDER: non-harness`, `FULCIO_URL` in job env) |
| [`container-kms.yml`](.github/workflows/container-kms.yml) | Container image | `docker` | HashiCorp Vault (`KMS_KEY`, `VAULT_ADDR`, `VAULT_TOKEN`) |
| [`non-container-keyless.yml`](.github/workflows/non-container-keyless.yml) | Local file (zip) | `local` | Keyless |
| [`non-container-kms.yml`](.github/workflows/non-container-kms.yml) | Local file (zip) | `local` | Vault KMS |
| [`repo-keyless.yml`](.github/workflows/repo-keyless.yml) | Git repository | `repository` | Keyless |
| [`repo-kms.yml`](.github/workflows/repo-kms.yml) | Git repository | `repository` | Vault KMS |

### What each artifact type needs

| Type | Typical inputs | Job `env` (when applicable) |
|------|----------------|-----------------------------|
| **Container** | `SBOM_SOURCE` / `SLSA_SOURCE` / `SIGNING_SOURCE` = image ref; `DOCKER_USERNAME` / `DOCKER_PASSWORD` for private registries | `FULCIO_URL` for keyless |
| **Local** | `SBOM_SOURCE` = file path under workspace; `ARTIFACT_WORKSPACE`, `ARTIFACT_NAME`, `ARTIFACT_VERSION` | `FULCIO_URL` for keyless |
| **Repository** | `SBOM_SOURCE` = repo URL; `SOURCE_TYPE: repository` | `REPO_URL`, `REPO_PATH`, `REPO_VARIANT`, `REPO_VARIANT_TYPE`, `REPO_CLONED_CODEBASE`; `FULCIO_URL` for keyless |

Full input and signing documentation: **[harness/github-actions README](https://github.com/harness/github-actions/blob/main/README.md)**.

---

## Other sample workflows

| File | Purpose |
|------|---------|
| [`devsecops-workflow.yml`](.github/workflows/devsecops-workflow.yml) | Broader DevSecOps pipeline sample |
| [`devsecops.yml`](.github/workflows/devsecops.yml) | SBOM + policy enforcement |
| [`slsa-provenance.yml`](.github/workflows/slsa-provenance.yml) | SLSA generation |
| [`sbom-policy-enforcement.yml`](.github/workflows/sbom-policy-enforcement.yml) | Policy enforcement only |
| [`ssca-plugin-workflow.yml`](.github/workflows/ssca-plugin-workflow.yml) | Minimal plugin workflow |

---

## Before you run

1. Configure **GitHub Actions variables and secrets** for your Harness QA (or prod) account (`HARNESS_*`, `DOCKER_*`, `VAULT_*`, etc.).
2. For **keyless** workflows, set repository/workflow **`permissions: id-token: write`** and job env **`FULCIO_URL`**.
3. Ensure **`harness/github-actions@main`** (or your chosen tag) includes the composites you need—track [harness/github-actions](https://github.com/harness/github-actions) releases.
4. Open **Actions →** pick a workflow → **Run workflow**.

---

## Legacy root folders

This repository still contains **legacy V1** composite folders at the repo root (`sbom-generation/`, …) from the original layout. **Current workflows do not use them**; prefer the marketplace actions above.
