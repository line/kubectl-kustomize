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


FROM build-base AS latest-kustomize-version

CMD [ \
    "curl -fs https://api.github.com/repos/kubernetes-sigs/kustomize/releases | \
    jq -r '.[0].name' | \
    sed -e 's/\\v\\(.*\\)$/\\1/'" \
]


# Downloader
FROM build-base AS downloader

ARG KUBECTL_VERSION
ARG KUSTOMIZE_VERSION

WORKDIR /downloads

RUN curl -fL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o kubectl && \
    chmod +x kubectl

RUN curl -fL https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64 -o kustomize && \
    chmod +x kustomize


# Runtime
FROM base AS runtime

LABEL maintainer="Sunghoon Kang <me@devholic.io>"

COPY --from=downloader /downloads/kubectl /usr/local/bin/kubectl
COPY --from=downloader /downloads/kustomize /usr/local/bin/kustomize

ENTRYPOINT ["sh"]
