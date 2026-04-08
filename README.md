# hello-world-ui

Simple static UI for the GitOps demo. The repository intentionally keeps the application small so the focus stays on the delivery model: source in Git, image built in CI, Helm package in the app repo, and deployment state promoted through the GitOps repo.

## Layout

```text
src/                          static UI source
nginx/default.conf            runtime web server config
Dockerfile                    multi-stage image build
deploy/helm/hello-world-ui/   Helm chart for Kubernetes deployment
.github/workflows/ci.yaml     scan, build, push, and GitOps promotion workflow
```

## Local image build

```bash
docker build --build-arg APP_VERSION=local -t hello-world-ui:local .
docker run --rm -p 8080:8080 hello-world-ui:local
```

Then open `http://localhost:8080`.

## CI/CD flow

The GitHub Actions workflow does the following:

1. Runs a Semgrep source scan.
2. Runs a Trivy filesystem scan.
3. Builds the Docker image with the Git SHA as `APP_VERSION`.
4. Runs a Trivy image scan.
5. Pushes the image to GHCR on `main`.
6. Updates the image tag in the GitOps repo so Argo CD deploys from Git.

For the local demo, make the published GHCR package public so the cluster can pull it without an image pull secret.

### Required GitHub configuration

Repository variables:

- `GITOPS_REPO`: `404ControlsNotFound/gitops-infra`
- `GITOPS_VALUES_FILE`: `environments/local/hello-world-ui-values.yaml`

Repository secret:

- `GITOPS_REPO_TOKEN`: PAT with `contents:write` access to the GitOps repo

For a stronger production pattern, replace the direct push to `main` with an automated pull request plus branch protection.
