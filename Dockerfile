FROM golang:1.22 as builder

WORKDIR /go/src/app
COPY . .
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/gobot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./gobot", "start"]