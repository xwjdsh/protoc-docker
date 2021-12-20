ARG PROTOC_GEN_GO_VERSION=v1.27.1
ARG PROTOC_GEN_GO_GRPC_VERSION=v1.1.0
ARG PROTOC_VERSION=3.19.1

FROM golang:1.18beta1-alpine3.15 AS builder1
ARG PROTOC_GEN_GO_VERSION
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VERSION}

FROM golang:1.18beta1-alpine3.15 AS builder2
ARG PROTOC_GEN_GO_GRPC_VERSION
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VERSION}

FROM alpine:3.15.0 AS builder3
ARG PROTOC_VERSION
RUN apk add --no-cache curl
RUN curl -L -o /tmp/protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
	unzip /tmp/protoc.zip -d /tmp/protoc

FROM alpine:3.15.0
RUN apk add gcompat
COPY --from=builder1 /go/bin/* /usr/local/bin
COPY --from=builder2 /go/bin/* /usr/local/bin
COPY --from=builder3 /tmp/protoc/bin/* /usr/local/bin
COPY --from=builder3 /tmp/protoc/include/* /usr/local/include/google
ENTRYPOINT [ "protoc", "--plugin=protoc-gen-go=/usr/local/bin/protoc-gen-go", "--plugin=protoc-gen-go-grpc=/usr/local/bin/protoc-gen-go-grpc" ]
