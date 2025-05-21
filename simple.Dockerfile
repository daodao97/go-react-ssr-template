# 构建阶段
FROM golang:1.24 AS builder
WORKDIR /app
# 安装 git
RUN apt-get install -y git
COPY . .
RUN go mod download rogchap.com/v8go

# 获取 Git 信息并构建
RUN GIT_TAG=$(git describe --tags --always) \
    && echo "GIT_TAG=${GIT_TAG}" \
    && go build -ldflags="-s -w -X shipnow/conf.GitTag=${GIT_TAG}" -o myapp

RUN ls -la
# 运行时阶段
FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache libc6-compat gcompat libstdc++

COPY --from=builder /app/myapp .
COPY ./build /app/build
COPY *.yaml /app/
COPY locales /app/locales

ENTRYPOINT ["./myapp"]