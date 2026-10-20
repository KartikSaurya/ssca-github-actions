# ssca-github-actions

Sample GitHub workflows for Harness SSCA using the official marketplace composites in [harness/github-actions](https://github.com/harness/github-actions).

Composites live at the **repository root** in `harness/github-actions` (for example `harness/github-actions/sbom-generation@main`). This repo does not vend local copies of those actions—workflows reference the marketplace only.

## E2E workflows

| Workflow | Artifact | Signing |
|----------|----------|---------|
| `container-keyless.yml` | Container image | GitHub OIDC → Harness Fulcio |
| `container-kms.yml` | Container image | HashiCorp Vault (`KMS_KEY`) |
| `non-container-keyless.yml` | Zip / local artifact | Keyless |
| `non-container-kms.yml` | Zip / local artifact | Vault KMS |
| `repo-keyless.yml` | Git repository | Keyless |
| `repo-kms.yml` | Git repository | Vault KMS |

Legacy samples (`devsecops*.yml`, `ssca-plugin-workflow.yml`, `slsa-provenance.yml`, `sbom-policy-enforcement.yml`) also use `harness/github-actions/*@main`.

Configure Harness QA variables and secrets on the repo before dispatching `workflow_dispatch` runs.
