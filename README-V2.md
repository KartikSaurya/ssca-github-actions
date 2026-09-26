# SSCA GitHub Actions — V2

V2 composite actions sit next to the existing V1 actions. They use V2 env names (`SOURCE_TYPE`, `SBOM_SOURCE`, `REPO_*`, …) and `github-*` plugin subcommands.

## Vault KMS key: `KMS_KEY` (not `VAULT_COSIGN_KEY_PATH`)

V1 actions expose **`KMS_KEY`** for HashiCorp Vault transit signing (see `sbom-generation/action.yml`).  
V2 actions use input **`kms_key`**, which maps to plugin env **`KMS_KEY`** (also accepted: `VAULT_COSIGN_KEY_PATH` in the plugin, but workflows/actions standardize on **`KMS_KEY`**).

Set repository variable **`KMS_KEY`** to your Vault transit key name (default in samples: `cosign`).

## V2 workflows (by artifact type × signing method)

| Artifact type | Vault KMS (`KMS_KEY`) | Keyless OIDC |
|---------------|------------------------|--------------|
| **Container** — SLSA + SBOM + enforce | `container-devsecops-slsa-sbom-enforce-vault-kms-v2.yml` | `container-devsecops-slsa-sbom-enforce-keyless-oidc-v2.yml` |
| **Container** — sign + verify | `container-artifact-sign-and-verify-vault-kms-v2.yml` | `container-artifact-sign-and-verify-keyless-oidc-v2.yml` |
| **Non-container** (`local`) — SBOM generate | `non-container-sbom-generate-vault-kms-v2.yml` | `non-container-sbom-generate-keyless-oidc-v2.yml` |
| **Non-container** — SBOM enforce | `non-container-sbom-enforce-vault-kms-v2.yml` | `non-container-sbom-enforce-keyless-oidc-v2.yml` |
| **Non-container** — sign + verify | `non-container-artifact-sign-and-verify-vault-kms-v2.yml` | `non-container-artifact-sign-and-verify-keyless-oidc-v2.yml` |
| **Repository** — SBOM generate | `repository-sbom-generate-vault-kms-v2.yml` | `repository-sbom-generate-keyless-oidc-v2.yml` |
| **Repository** — SBOM enforce | `repository-sbom-enforce-vault-kms-v2.yml` | `repository-sbom-enforce-keyless-oidc-v2.yml` |

GCP Cloud KMS is not covered by these samples (use plugin GCP env vars in a custom workflow if needed).

## Configuration

**Secrets:** `HARNESS_API_KEY`, `VAULT_URL`, `VAULT_TOKEN` (Vault flows), optional `DOCKER_USERNAME` / `DOCKER_PASSWORD`

**Variables:**

| Variable | Used for |
|----------|----------|
| `HARNESS_ACCOUNT_URL`, `HARNESS_ACCOUNT_ID`, `HARNESS_ORG_ID`, `HARNESS_PROJECT_ID` | All flows |
| `KMS_KEY` | Vault KMS transit key path (same as V1) |
| `DEVSECOPS_TARGET_IMAGE` | Container image ref |
| `NON_CONTAINER_WORKSPACE` | Path to file in repo, e.g. `dist/app.jar` |
| `NON_CONTAINER_ARTIFACT_NAME`, `NON_CONTAINER_ARTIFACT_VERSION` | Optional non-container metadata |
| `SSCA_PLUGIN_IMAGE`, `SLSA_PLUGIN_IMAGE`, `ARTIFACT_SIGNING_PLUGIN_IMAGE` | Pin V2-built plugin images |
| `OPA_POLICY_SET_REF`, `ATTEST_SBOM`, `VERIFY_SBOM`, … | Optional behavior toggles |

Run from **Actions** → workflow name → **Run workflow**.
