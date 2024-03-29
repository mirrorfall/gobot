APP=$(shell basename $(shell git remote get-url origin) | sed 's/\.git//')
REGISTRY=mirrorfall
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

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
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean:
	rm -rf gobot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
dive:
	dive --ci --lowestEfficiency=0.9 ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}