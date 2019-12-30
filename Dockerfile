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


FROM latest-kustomize-release AS latest-kustomize-download-url

CMD [ \
    "cat .kustomize-latest-release | \
    jq -r 'first(.[] | select(.name | startswith(\"kustomize/\"))) | \
    first(.assets[] | select((.name | contains(\"linux\")) and (.name | contains(\"amd64\")))) | .browser_download_url'" \
]


# Downloader
FROM build-base AS downloader

ARG KUBECTL_VERSION
ARG KUSTOMIZE_DOWNLOAD_URL

WORKDIR /downloads

RUN curl -fL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o kubectl && \
    chmod +x kubectl

RUN curl -fL ${KUSTOMIZE_DOWNLOAD_URL} | tar xz && \
    chmod +x kustomize


# Runtime
FROM base AS runtime

LABEL maintainer="Sunghoon Kang <me@devholic.io>"

COPY --from=downloader /downloads/kubectl /usr/local/bin/kubectl
COPY --from=downloader /downloads/kustomize /usr/local/bin/kustomize

ENTRYPOINT ["sh"]
