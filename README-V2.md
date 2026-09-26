# SSCA GitHub Actions — V2

V2 composite actions live alongside the existing V1 actions (`sbom-generation`, `slsa-generation`, …).  
They use the **V2 env vocabulary** (`SOURCE_TYPE`, `SBOM_SOURCE`, `SLSA_SOURCE`, `REPO_*`) and plugin subcommands (`github-orchestrate`, `github-enforce`, `github-provenance`, `github-slsa-verification`, `github-sign`, `github-verify`).

## V2 action directories

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

Each action runs the plugin via **Docker** on the runner (`plugin_image` input). Build images from [ssca-plugins](https://github.com/harness/ssca-plugins) after merging the GitHub V2 CLI branches, then push to a registry your workflow can pull.

Default image tags (override with `plugin_image` on each step):

- `harness/ssca-plugin:prod` — SSCA / repo SBOM
- `harness/slsa-plugin:prod` — SLSA
- `harness/ssca-artifact-signing-plugin:prod` — signing

## Secrets / variables

Configure in the repo (same as V1 flows):

- `HARNESS_API_KEY`
- `DOCKER_USERNAME` / `DOCKER_PASSWORD` (if pushing/pulling private images)
- Optional: `VAULT_URL`, `VAULT_TOKEN` (Vault signing)
- Optional repository variables: `SSCA_PLUGIN_IMAGE`, `SLSA_PLUGIN_IMAGE`, `ARTIFACT_SIGNING_PLUGIN_IMAGE` — pin your V2-built tags

## Keyless signing

Calling workflows must set:

```yaml
permissions:
  id-token: write
```

Set `keyless_type: non-harness` on the action inputs when using GitHub OIDC + Fulcio.

## Example workflows

- `.github/workflows/devsecops-v2.yml` — container image: SLSA → SBOM → policy enforcement
- `.github/workflows/repo-sbom-v2.yml` — repository SBOM on `workflow_dispatch`
