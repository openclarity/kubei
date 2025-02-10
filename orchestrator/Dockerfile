# syntax=docker/dockerfile:1@sha256:93bfd3b68c109427185cd78b4779fc82b484b0b7618e36d0f104d4d801e66d25

# xx is a helper for cross-compilation
FROM --platform=$BUILDPLATFORM tonistiigi/xx:1.4.0@sha256:0cd3f05c72d6c9b038eb135f91376ee1169ef3a330d34e418e65e2a5c2e9c0d4 AS xx

FROM --platform=$BUILDPLATFORM golang:1.23.5-bullseye@sha256:8e328c125cb6eb11d501d9844323fcafb4a4abbd233e97657252bdc2d25c2496 AS builder

COPY --link --from=xx / /

ARG TARGETPLATFORM

RUN --mount=type=cache,id=${TARGETPLATFORM}-apt,target=/var/cache/apt,sharing=locked \
    apt-get update \
    && xx-apt-get install -y --no-install-recommends \
      gcc \
      libc6-dev

WORKDIR /build/orchestrator

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,source=.,target=/build,ro \
    xx-go mod download -x

ARG VERSION
ARG BUILD_TIMESTAMP
ARG COMMIT_HASH
ARG BUILD_OPTS

ENV CGO_ENABLED=1

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,source=.,target=/build,ro \
    xx-go build ${BUILD_OPTS} -ldflags="-s -w -extldflags -static \
     -X 'github.com/openclarity/openclarity/core/version.Version=${VERSION}' \
     -X 'github.com/openclarity/openclarity/core/version.CommitHash=${COMMIT_HASH}' \
     -X 'github.com/openclarity/openclarity/core/version.BuildTimestamp=${BUILD_TIMESTAMP}'" \
    -o /bin/openclarity-orchestrator ./cmd/main.go

RUN xx-verify /bin/openclarity-orchestrator

FROM alpine:3.21@sha256:21dc6063fd678b478f57c0e13f47560d0ea4eeba26dfc947b2a4f81f686b9f45

COPY --from=builder ["/bin/openclarity-orchestrator", "/bin/openclarity-orchestrator"]

RUN apk add --update --no-cache \
    ca-certificates \
    libc6-compat

ENTRYPOINT ["/bin/openclarity-orchestrator"]
