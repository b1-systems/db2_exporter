VERSION := 0.0.1
LDFLAGS := -X main.Version=$(VERSION)
GOFLAGS := -ldflags "$(LDFLAGS) -s -w"
GOARCH ?= $(subst x86_64,amd64,$(patsubst i%86,386,$(shell uname -m)))
IBM_DB_HOME=/home/twolter/.local/share/go/pkg/mod/github.com/ibmdb/clidriver
LD_LIBRARY_PATH=$IBM_DB_HOME/lib
CGO_LDFLAGS=-L$IBM_DB_HOME/lib
CGO_CFLAGS=-I$IBM_DB_HOME/include

linux:
	@echo build linux
	@mkdir -p ./dist/ibmdb2_exporter.$(VERSION).linux-${GOARCH}
	@PKG_CONFIG_PATH=${PWD} GOOS=linux go build $(GOFLAGS) -o ./dist/ibmdb2_exporter.$(VERSION).linux-${GOARCH}/ibmdb2_exporter
	@cp default-metrics.toml ./dist/ibmdb2_exporter.$(VERSION).linux-${GOARCH}
	@(cd dist ; tar cfz ibmdb2_exporter.$(VERSION).linux-${GOARCH}.tar.gz ibmdb2_exporter.$(VERSION).linux-${GOARCH})

aix:
	@echo build aix
	@mkdir -p ./dist/ibmdb2_exporter.$(VERSION).aix-ppc64
	@PKG_CONFIG_PATH=${PWD} CGO_ENABLED=0 GOOS=aix GOARCH=ppc64 go build $(GOFLAGS) -o ./dist/ibmdb2_exporter.$(VERSION).aix-ppc64/ibmdb2_exporter
	@cp default-metrics.toml ./dist/ibmdb2_exporter.$(VERSION).aix-ppc64
	@(cd dist ; tar cfz ibmdb2_exporter.$(VERSION).aix-ppc64.tar.gz ibmdb2_exporter.$(VERSION).aix-ppc64)


local-build:  linux

deps:
	@PKG_CONFIG_PATH=${PWD} go install

test:
	@echo test
	@PKG_CONFIG_PATH=${PWD} go test $$(go list ./... | grep -v /vendor/)

clean:
	@rm -rf ./dist
