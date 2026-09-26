# SSCA GitHub Actions — V2

V2 composite actions sit **next to** the existing V1 actions. They use the V2 env vocabulary (`SOURCE_TYPE`, `SBOM_SOURCE`, `SLSA_SOURCE`, `REPO_*`) and `github-*` plugin subcommands.

## V2 composite actions

| Directory | Plugin subcommand |
|-----------|-------------------|
| `sbom-generation-v2` | `github-orchestrate` (generation) |
| `sbom-ingestion-v2` | `github-orchestrate` (ingestion) |
| `sbom-policy-enforcement-v2` | `github-enforce` |
| `repo-sbom-generation-v2` | `github-orchestrate` (`SOURCE_TYPE=repository`) |
| `slsa-generation-v2` | `github-provenance` |
| `slsa-verification-v2` | `github-slsa-verification` |
| `artifact-signing-v2` | `github-sign` |
| `artifact-verification-v2` | `github-verify` |

Each action runs the plugin in **Docker** (`plugin_image` input). Build images from **ssca-plugins** with the GitHub V2 CLI merged, then push to a registry the runner can pull.

## V2 example workflows (by signing method)

Workflow file names describe **artifact type**, **steps**, and **signing method**.

### HashiCorp Vault KMS (not GCP KMS)

Requires secrets `VAULT_URL`, `VAULT_TOKEN`. Optional variable `VAULT_COSIGN_KEY_PATH` (default transit key path `cosign` in the workflow).

| Workflow file | What it runs |
|---------------|--------------|
| `container-devsecops-slsa-sbom-enforce-vault-kms-v2.yml` | Container: SLSA → SBOM → policy enforce |
| `container-artifact-sign-and-verify-vault-kms-v2.yml` | Container: cosign sign → verify |
| `repository-sbom-generate-vault-kms-v2.yml` | Repository SBOM (+ optional attest via `ATTEST_SBOM`) |

### Keyless OIDC (GitHub → Fulcio)

Requires `permissions: id-token: write`. Actions set `keyless_type: non-harness`.

| Workflow file | What it runs |
|---------------|--------------|
| `container-devsecops-slsa-sbom-enforce-keyless-oidc-v2.yml` | Container: SLSA → SBOM → policy enforce |
| `container-artifact-sign-and-verify-keyless-oidc-v2.yml` | Container: cosign sign → verify |
| `repository-sbom-generate-keyless-oidc-v2.yml` | Repository SBOM (+ optional attest) |

GCP Cloud KMS is **not** included in these samples; configure GCP KMS via plugin env in a custom workflow if needed.

## Repo configuration

**Secrets:** `HARNESS_API_KEY`, `VAULT_URL`, `VAULT_TOKEN` (Vault flows), optional `DOCKER_USERNAME` / `DOCKER_PASSWORD`

**Variables:** `HARNESS_ACCOUNT_URL`, `HARNESS_ACCOUNT_ID`, `HARNESS_ORG_ID`, `HARNESS_PROJECT_ID`, `DEVSECOPS_TARGET_IMAGE`, optional `SSCA_PLUGIN_IMAGE`, `SLSA_PLUGIN_IMAGE`, `ARTIFACT_SIGNING_PLUGIN_IMAGE`, `OPA_POLICY_SET_REF`, `VAULT_COSIGN_KEY_PATH`, `ATTEST_SBOM`, `ATTEST_SLSA`, `VERIFY_SBOM`

Run from **Actions** → pick the workflow name that matches your signing method → **Run workflow**.
