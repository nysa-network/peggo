#install packages for build layer
FROM golang:1.19-alpine as builder
RUN apk add --no-cache git gcc make perl jq libc-dev linux-headers

#build binary
WORKDIR /src
COPY . .
RUN go mod download

#install binary
RUN make install

#build main container
FROM alpine:latest
RUN apk add --update --no-cache ca-certificates curl
COPY --from=builder /go/bin/* /usr/local/bin/

#configure container
VOLUME /apps/data
WORKDIR /root/.injectived/peggo

#default command
CMD peggo orchestrator
