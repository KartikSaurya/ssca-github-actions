# SSCA GitHub Actions — V2

V2 composite actions live under **`v2/<action>/`** (no `-v2` suffix — the folder is already V2).  
V1 actions remain at the repository root (`sbom-generation/`, `slsa-generation/`, …).

Workflows reference local actions as `uses: ./v2/<action>`.

## E2E workflows (6 total)

| Workflow | Signing | Step order |
|----------|---------|------------|
| [`container-kms.yml`](../.github/workflows/container-kms.yml) | Vault KMS | sbom-generation → sbom-ingestion → sbom-policy-enforcement → slsa-attest → slsa-verify → artifact-sign → artifact-verify |
| [`non-container-kms.yml`](../.github/workflows/non-container-kms.yml) | Vault KMS | Same (local artifact) |
| [`repo-kms.yml`](../.github/workflows/repo-kms.yml) | Vault KMS | sbom-generation (`repo-sbom-generation`) → sbom-ingestion → sbom-policy-enforcement |
| [`container-keyless.yml`](../.github/workflows/container-keyless.yml) | Keyless OIDC | Full container sequence |
| [`non-container-keyless.yml`](../.github/workflows/non-container-keyless.yml) | Keyless OIDC | Full non-container sequence |
| [`repo-keyless.yml`](../.github/workflows/repo-keyless.yml) | Keyless OIDC | Repo SBOM sequence only |

Generation writes to `SBOM_LOCAL_PATH` (default `/tmp/sbom`) with `attest_sbom: false`; ingestion attests/uploads.

Repository mode has no SLSA or artifact-signing flows (plugin support is SBOM-only).

## Composite actions in `v2/`

| Directory | Purpose |
|-----------|---------|
| `sbom-generation` | Container / local SBOM orchestrate |
| `repo-sbom-generation` | Repository SBOM orchestrate |
| `sbom-policy-enforcement` | SBOM verify + OPA enforce |
| `slsa-generation` / `slsa-verification` | SLSA attest / verify |
| `artifact-signing` / `artifact-verification` | Cosign sign / verify |
| `sbom-ingestion` | Optional ingestion path |

## Configuration

**Secrets:** `HARNESS_API_KEY`, `VAULT_ADDR`, `VAULT_TOKEN`, optional `DOCKER_USERNAME` / `DOCKER_PASSWORD`

**Variables:** `HARNESS_*`, `HARNESS_PROJECT_ID=Github`, `KMS_KEY`, `DEVSECOPS_TARGET_IMAGE`, `FULCIO_URL`, `OPA_POLICY_SET_REF`, `GIT_REPO_URL`, `GIT_BRANCH`

See [`scripts/configure-e2e-secrets-and-run.sh`](../scripts/configure-e2e-secrets-and-run.sh) to configure the repo and dispatch a workflow.
