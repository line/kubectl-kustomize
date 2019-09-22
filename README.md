# kubectl-kustomize

Docker image with kubectl and kustomize

[![GitHub Actions](https://github.com/devholic/kubectl-kustomize/workflows/Release/badge.svg)](https://github.com/devholic/kubectl-kustomize/actions?workflowID=Release) [![Docker Pulls](https://img.shields.io/docker/pulls/devholic/kubectl-kustomize)](https://hub.docker.com/r/devholic/kubectl-kustomize)

## Quickstart

```sh
docker run --rm -v {YOUR_LOCAL_K8S_CONFIG_DIR}:/root/.kube:ro -ti devholic/kubectl-kustomize:latest
```

## About this image

This image is built on [alpine](https://hub.docker.com/_/alpine) image with following two binaries:

- [kubectl](https://github.com/kubernetes/kubectl)
- [kustomize](https://github.com/kubernetes-sigs/kustomize)

Image will be released if new stable binaries released by using [GitHub Actions](https://github.com/features/actions). Binary version will be checked every 8 hours.
