APP=$(shell basename $(shell git remote get-url origin) | sed 's/\.git//')
REGISTRY := ghcr.io/mirrorfall
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=$(shell uname -s | tr '[:upper:]' '[:lower:]')
TARGETARCH=$(shell if [ $(shell uname -m) = "x86_64" ]; then echo "amd64"; elif [ $(shell uname -m) = "aarch64" ]; then echo "arm64"; else uname -m; fi)

format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v
get:
	go get
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o gobot -ldflags "-X="github.com/mirrorfall/gobot/cmd.appVersion=${VERSION}
image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} .
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
clean:
	rm -rf gobot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
dive:
	dive --ci --lowestEfficiency=0.9 ${REGISTRY}/${APP}:${VERSION}-{$TARGETOS}-${TARGETARCH}