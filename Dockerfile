# syntax=docker/dockerfile:1

ARG TS_VERSION=latest

FROM golang:1.25 AS build
ENV GOTOOLCHAIN=auto
ARG TS_VERSION

WORKDIR /src
RUN go env -w GOPROXY=https://proxy.golang.org,direct

# 安装 derper（从 tailscale 源码编译）
RUN go install tailscale.com/cmd/derper@${TS_VERSION}

# 运行镜像用更小的基础镜像
FROM debian:bookworm-slim
COPY --from=build /go/bin/derper /usr/local/bin/derper

EXPOSE 443/tcp
EXPOSE 3478/udp

ENTRYPOINT ["/usr/local/bin/derper"]
