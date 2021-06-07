FROM alpine:3.10.2 AS base
FROM base AS build-base

RUN apk update && \
    apk add \
    curl \
    jq

ENTRYPOINT ["sh", "-o", "pipefail", "-c"]


# Version Checkers
FROM build-base AS latest-kubectl-version

CMD [ \
    "curl -fs https://storage.googleapis.com/kubernetes-release/release/stable.txt | \
    sed -e 's/\\v\\(.*\\)$/\\1/'" \
]


FROM build-base AS latest-kustomize-release

WORKDIR /tmp

RUN curl -fs https://api.github.com/repos/kubernetes-sigs/kustomize/releases > .kustomize-latest-release


FROM latest-kustomize-release AS latest-kustomize-version

CMD [ \
    "cat .kustomize-latest-release | \
    jq -r 'first(.[] | select(.name | startswith(\"kustomize/\"))) | .name' | \
    sed -e 's/\\kustomize\\/v\\(.*\\)$/\\1/'" \
]

# Downloader
FROM build-base AS downloader

ARG TARGETOS
ARG TARGETARCH
ARG KUBECTL_VERSION
ARG KUSTOMIZE_VERSION

WORKDIR /downloads

RUN set -ex; curl -fL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -o kubectl && \
    chmod +x kubectl

RUN set -ex; curl -fL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz | tar xz && \
    chmod +x kustomize


# Runtime
FROM base AS runtime

LABEL maintainer="LINE Open Source <dl_oss_dev@linecorp.com>"

COPY --from=downloader /downloads/kubectl /usr/local/bin/kubectl
COPY --from=downloader /downloads/kustomize /usr/local/bin/kustomize

RUN set -ex; kubectl && kustomize

ENTRYPOINT ["sh"]
