FROM golang:1.24 AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y git nodejs npm

COPY go.mod go.sum ./
RUN go mod download

RUN go install github.com/daodao97/goreact/cmd/goreact

COPY package.json ./
RUN npm i --registry=https://registry.npmmirror.com
COPY frontend ./frontend
COPY tailwind.config.js ./
COPY postcss.config.js ./

RUN goreact

COPY . .
RUN GIT_TAG=$(git describe --tags --always) \
    && echo "GIT_TAG=${GIT_TAG}" \
    && go build -ldflags="-s -w -X shipnow/conf.GitTag=${GIT_TAG}" -o myapp

FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache libc6-compat gcompat libstdc++

COPY --from=builder /app/myapp .
COPY --from=builder /app/build /app/build
COPY *.yaml /app/
COPY locales /app/locales

ENTRYPOINT ["./myapp"]