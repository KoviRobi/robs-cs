# About

This is a write-up of my knowledge of computer science, so I can spread the
~bugs~ ~pain~ joy to others.

## Hacking

### Update CI image

- Create a classic token with `write:packages` permission at <https://github.com/settings/tokens>.

- Log in using

  ```bash
  skopeo login ghcr.io
  ```

- Build the new image and upload

  ```bash
  BUILD_IMAGE=$(devenv build outputs.docker-typst)
  $BUILD_IMAGE |
    skopeo \
      --insecure-policy \
      copy \
      docker-archive:///dev/stdin \
      docker://ghcr.io/kovirobi/robs-cs-typst:latest
  ```
