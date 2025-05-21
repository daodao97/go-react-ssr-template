FROM golang:1.24 AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y git

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN GIT_TAG=$(git describe --tags --always) \
    && echo "GIT_TAG=${GIT_TAG}" \
    && go build -ldflags="-s -w -X shipnow/conf.GitTag=${GIT_TAG}" -o myapp

RUN go install github.com/daodao97/goreact/cmd/goreact

# 使用基于debian的node镜像而不是latest，以确保兼容性
FROM node:latest AS node-builder
WORKDIR /app
COPY --from=builder /go/bin/goreact /usr/local/bin/goreact
COPY package.json ./
# 确保安装所有依赖，包括可选依赖
RUN npm i --legacy-peer-deps --registry=https://registry.npmmirror.com --include=optional
COPY frontend ./frontend
COPY tailwind.config.js ./
COPY postcss.config.js ./

RUN goreact

# 运行时阶段
FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache libc6-compat gcompat libstdc++

COPY --from=builder /app/myapp .
COPY --from=node-builder /app/build /app/build
COPY *.yaml /app/
COPY locales /app/locales

ENTRYPOINT ["./myapp"]