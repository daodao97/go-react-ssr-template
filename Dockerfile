FROM node:latest AS node-builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build:css

# 构建阶段
FROM golang:1.24 AS builder
WORKDIR /app
# 安装 git
RUN apt-get update && apt-get install -y git

COPY --from=node-builder /app .
RUN go mod download rogchap.com/v8go
RUN go run ./cmd/build/...

# 获取 Git 信息并构建
RUN GIT_TAG=$(git describe --tags --always) \
    && echo "GIT_TAG=${GIT_TAG}" \
    && go build -ldflags="-s -w -X github.com/highercomve/go-react-ssr/modules/conf.GitTag=${GIT_TAG}" -o myapp
# 运行时阶段
FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache libc6-compat gcompat libstdc++

COPY --from=builder /app/myapp .
COPY --from=builder /app/build /app/build
COPY *.yaml /app/
COPY locales /app/locales

ENTRYPOINT ["./myapp"]