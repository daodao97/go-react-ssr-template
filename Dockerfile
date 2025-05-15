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

COPY . .
RUN go mod download

# 获取 Git 信息并静态编译
RUN GIT_TAG=$(git describe --tags --always) \
    && echo "GIT_TAG=${GIT_TAG}" \
    && CGO_ENABLED=0 go build -ldflags="-s -w -X shipnow/conf.GitTag=${GIT_TAG}" -o myapp

# 运行时阶段
FROM alpine:latest
WORKDIR /app

# 安装基本依赖
RUN apk add --no-cache ca-certificates tzdata

COPY --from=builder /app/myapp .
COPY --from=node-builder /app/build /app/build
COPY *.yaml /app/
COPY locales /app/locales

# 确保可执行权限
RUN chmod +x ./myapp

ENTRYPOINT ["./myapp"]