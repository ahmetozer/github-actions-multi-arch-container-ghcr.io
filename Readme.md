# Build and Push Multi Architecture Containers in Github Actions

This is an example repository to demonstrate Multi-Platform/Multi-arch container builds in GitHub actions to ghcr.io registry.

<!--
## Create a token for login

For publishing containers into your account, the system requires a token to the authentication.

- Open tokens page [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new)
- Create a Token with repo, write:packages and delete:packages permissions.
    ![](/img/Screenshot_1.jpg)
- Copy generated token.
    ![](/img/Screenshot_2.jpg)
- Open repository settings, click actions option which is under Secrets scope and create New repository secret.
    ![](/img/Screenshot_3.jpg)
-->

## Create a workflow

Create main.yml under the ".github/workflows" directory.

Fill and change yml file with your properties.  
In this example, github actions is triggered on master branch publish and builds container image with linux/amd64,linux/arm/v7,linux/arm64 platforms.

```yml
name: Build and publish container

on:
  push:
    branches: [master]

jobs:
  ghr_push:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'

    steps:
      - name: checkout
        uses: actions/checkout@v2

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Log-in to ghcr.io
        run: echo "${{ secrets.GITHUB_TOKEN }}" | docker login https://ghcr.io -u ${{ github.actor }} --password-stdin

      - name: Build and push container image
        run: |
          IMAGE_ID=$(echo ghcr.io/${{ github.repository }} | tr '[A-Z]' '[a-z]')
          # Strip git ref prefix from version
          VERSION=$(echo "${{ github.ref }}" | sed -e 's,.*/\(.*\),\1,')
          # Strip "v" prefix from tag name
          [[ "${{ github.ref }}" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')
          # when the branch is master, replace master with latest
          [ "$VERSION" == "master" ] && VERSION=latest
          echo IMAGE_ID=$IMAGE_ID
          echo VERSION=$VERSION
          # Build and Publish container image
          docker buildx build --push \
          --tag $IMAGE_ID:$VERSION \
          --platform linux/amd64,linux/arm/v7,linux/arm64 .
```

## Link repository

### Label

First method to linking repository with the containers is LABEL option in Dockerfile.

Create a `LABEL` instruction in `Dockerfile` to link package to source.

```Dockerfile
LABEL org.opencontainers.image.source="https://github.com/{Your username}/{your repository name}"

# Example

LABEL org.opencontainers.image.source="https://github.com/ahmetozer/github-actions-multi-arch-container-ghcr.io"
```

**NOTE**: If your `Dockerfile` has a multi stage, add `LABEL` after latest `FROM` option.

### Github Web

You can also connect repository to container package from github web.

Open `https://github.com/users/{username}/packages/container/package/{repo-name}` on your browser.

End of the page, you will see repository connect setting, clink to 'Connect Repository' button and select your repository.

![](/img/Screenshot_4.jpg)

## Change package visibility

By default, packages are private. To allow public access, change visibility of the package from private to public on https://github.com/users/{username}/packages/container/{repo-name}/settings page.

![](/img/Screenshot_5.jpg)