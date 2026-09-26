# ssca-github-actions

Harness SSCA GitHub composite actions and sample workflows.

## Layout

| Version | Composite actions | Workflows |
|---------|-------------------|-----------|
| **V1** (legacy) | Repo root: `sbom-generation/`, `slsa-generation/`, … | `.github/workflows/devsecops-workflow.yml`, … |
| **V2** | [`v2/`](v2/) (e.g. `v2/sbom-generation-v2/`) | [`.github/workflows/v2/`](.github/workflows/v2/) |

See **[v2/README.md](v2/README.md)** for V2 signing methods (`KMS_KEY` / keyless OIDC), configuration, and the workflow matrix.
