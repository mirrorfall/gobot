VERSION:=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

build:
	go build -v -o gobot -ldflags "-X="github.com/mirrorfall/gobot/cmd.appVersion=${VERSION}