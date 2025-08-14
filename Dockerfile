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

FROM ubuntu:24.04 AS node-builder
WORKDIR /app
RUN apt-get update && apt-get install -y nodejs npm
COPY --from=builder /go/bin/goreact /usr/local/bin/goreact
COPY package.json ./
RUN npm i --registry=https://registry.npmmirror.com
COPY frontend ./frontend
COPY tailwind.config.js ./
COPY postcss.config.js ./

RUN goreact

FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache libc6-compat gcompat libstdc++

COPY --from=builder /app/myapp .
COPY --from=node-builder /app/build /app/build
COPY *.yaml /app/
COPY locales /app/locales

ENTRYPOINT ["./myapp"]