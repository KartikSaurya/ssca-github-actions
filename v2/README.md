# SSCA GitHub Actions — V2

V2 lives under this directory; V1 actions remain at the repository root (`sbom-generation/`, `slsa-generation/`, …).

| Path | Contents |
|------|----------|
| `v2/*-v2/` | V2 composite actions (e.g. `v2/sbom-generation-v2/action.yml`) |
| `.github/workflows/*-v2.yml` | V2 example workflows (flat under `.github/workflows/` — GitHub does not register nested workflow subfolders) |

Workflows reference local actions as `uses: ./v2/<action-dir>`.

V2 uses env names (`SOURCE_TYPE`, `SBOM_SOURCE`, `REPO_*`, …) and `github-*` plugin subcommands.

## Vault KMS key: `KMS_KEY` (not `VAULT_COSIGN_KEY_PATH`)

V1 actions expose **`KMS_KEY`** for HashiCorp Vault transit signing (see `../sbom-generation/action.yml`).  
V2 actions use input **`kms_key`**, which maps to plugin env **`KMS_KEY`** (also accepted: `VAULT_COSIGN_KEY_PATH` in the plugin, but workflows/actions standardize on **`KMS_KEY`**).

Set repository variable **`KMS_KEY`** to your Vault transit key name (Jenkins/devspace sample: `SSCA_AUTOMATION_COSIGN_KEY`).

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

**Secrets:** `HARNESS_API_KEY`, `VAULT_ADDR`, `VAULT_TOKEN` (Vault flows), optional `DOCKER_USERNAME` / `DOCKER_PASSWORD`

**Variables (Jenkins/devspace-aligned defaults):**

| Variable | Example / purpose |
|----------|-------------------|
| `HARNESS_ACCOUNT_URL` | `https://saas-central-devspace.harness-test.com` |
| `HARNESS_ACCOUNT_ID` | `4JLD9j1VRGC2My2H9i2lrg` |
| `HARNESS_ORG_ID` | `default` |
| `HARNESS_PROJECT_ID` | `Github` |
| `HARNESS_SSCA_SERVICE_ENDPOINT` | `https://saas-central-devspace.harness-test.com/gateway/ssca-manager/` |
| `FULCIO_URL` | `https://saas-central-devspace.harness-test.com/gateway/harness-fulcio/` |
| `KMS_KEY` | `SSCA_AUTOMATION_COSIGN_KEY` |
| `DEVSECOPS_TARGET_IMAGE` | `kartikey366/nginx:test1` |
| `GIT_REPO_URL`, `GIT_BRANCH` | Repository SBOM samples (`Buggy-App`, `main`) |
| `OPA_POLICY_SET_REF` | `my_opa_policy_set` |

Non-container workflows build `artifacts/scs-sample-app.zip` in-runner (no `NON_CONTAINER_WORKSPACE` var required).

**Legacy variables (optional):**

| Variable | Used for |
|----------|----------|
| Plugin images (testing) | V2 workflows pin `harness/ssca-plugin:test-githubV2`, `harness/slsa-plugin:test-githubV2`, `harness/ssca-artifact-signing-plugin:test-githubV2` |
| `OPA_POLICY_SET_REF`, `ATTEST_SBOM`, `VERIFY_SBOM`, … | Optional behavior toggles |

Run from **Actions** → workflow name → **Run workflow**.
