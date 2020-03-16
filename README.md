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

## How to contribute

See [CONTRIBUTING.md](CONTRIBUTING.md).

If you believe you have discovered a vulnerability or have an issue related to security, please contact the maintainer directly or send us a email to dl_oss_dev@linecorp.com before sending a pull request.

## LICENSE

```
Copyright 2020 LINE Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

See [LICENSE](LICENSE) for more detail.
