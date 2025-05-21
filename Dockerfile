FROM --platform=linux/arm64 node:latest AS node-builder
WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm i

# 构建阶段 - 包含 Go 和 Node 环境
FROM golang:1.24 AS builder
WORKDIR /app

# 安装 git 和 nodejs
RUN apt-get update && apt-get install -y git curl
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# 复制 Node.js 部分
COPY --from=node-builder /app/node_modules /app/node_modules
COPY --from=node-builder /app/package.json /app/package.json
COPY --from=node-builder /app/package-lock.json /app/package-lock.json

# 先复制不常变动的配置文件
COPY go.mod go.sum ./ 
RUN go mod download

# 确认 Node.js 和 npm 可用
RUN node --version && npm --version
COPY . .
RUN go run ./cmd/build/...

# 获取 Git 信息并构建
RUN GIT_TAG=$(git describe --tags --always) \
    && echo "GIT_TAG=${GIT_TAG}" \
    && go build -ldflags="-s -w -X shipnow/conf.GitTag=${GIT_TAG}" -o myapp
# 运行时阶段
FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache libc6-compat gcompat libstdc++

COPY --from=builder /app/myapp .
COPY --from=builder /app/build /app/build
COPY *.yaml /app/
COPY locales /app/locales

ENTRYPOINT ["./myapp"]