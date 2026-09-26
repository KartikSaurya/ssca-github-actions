#!/usr/bin/env bash
# Configure KartikSaurya/ssca-github-actions secrets/vars and dispatch V2 E2E.
# Requires: gh CLI logged in as KartikSaurya (gh api user → KartikSaurya)
# Usage: export VAULT_TOKEN HARNESS_API_KEY [DOCKER_USERNAME DOCKER_PASSWORD]; ./scripts/configure-e2e-secrets-and-run.sh

set -euo pipefail

REPO="${REPO:-KartikSaurya/ssca-github-actions}"
LOGIN="$(gh api user --jq .login)"
if [[ "$LOGIN" != "KartikSaurya" ]]; then
  echo "gh is logged in as '$LOGIN'; run: gh auth login (account KartikSaurya)" >&2
  exit 1
fi

: "${VAULT_TOKEN:?Set VAULT_TOKEN}"
: "${HARNESS_API_KEY:?Set HARNESS_API_KEY}"

gh secret set VAULT_ADDR -R "$REPO" -b 'https://vaultqa.harness.io'
gh secret set VAULT_TOKEN -R "$REPO" -b "$VAULT_TOKEN"
gh secret set HARNESS_API_KEY -R "$REPO" -b "$HARNESS_API_KEY"
if [[ -n "${DOCKER_USERNAME:-}" && -n "${DOCKER_PASSWORD:-}" ]]; then
  gh secret set DOCKER_USERNAME -R "$REPO" -b "$DOCKER_USERNAME"
  gh secret set DOCKER_PASSWORD -R "$REPO" -b "$DOCKER_PASSWORD"
fi

gh variable set HARNESS_ACCOUNT_URL -R "$REPO" -b 'https://saas-central-devspace.harness-test.com'
gh variable set HARNESS_ACCOUNT_ID -R "$REPO" -b '4JLD9j1VRGC2My2H9i2lrg'
gh variable set HARNESS_ORG_ID -R "$REPO" -b 'default'
gh variable set HARNESS_PROJECT_ID -R "$REPO" -b 'Github'
gh variable set HARNESS_SSCA_SERVICE_ENDPOINT -R "$REPO" -b 'https://saas-central-devspace.harness-test.com/gateway/ssca-manager/'
gh variable set FULCIO_URL -R "$REPO" -b 'https://saas-central-devspace.harness-test.com/gateway/harness-fulcio/'
gh variable set KMS_KEY -R "$REPO" -b 'SSCA_AUTOMATION_COSIGN_KEY'
gh variable set DEVSECOPS_TARGET_IMAGE -R "$REPO" -b 'kartikey366/nginx:test1'
gh variable set OPA_POLICY_SET_REF -R "$REPO" -b 'my_opa_policy_set'
gh variable set GIT_REPO_URL -R "$REPO" -b 'https://github.com/KartikSaurya/Buggy-App.git'
gh variable set GIT_BRANCH -R "$REPO" -b 'main'

gh workflow run v2-run-all-e2e.yml -R "$REPO" --ref main
echo "Dispatched v2-run-all-e2e on $REPO — see https://github.com/$REPO/actions"
