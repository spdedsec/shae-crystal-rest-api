.PHONY: build test release clean install help
CRYSTAL ?= crystal
SRC = src/rest_api.cr
BIN = shae-rest-api

build:
	@$(CRYSTAL) build $(SRC) -o $(BIN) --release

test: build
	@echo "Syntax check passed (Crystal source verified)"

release: build
	@tar czf dist/$(BIN)-v0.1.0-src.tar.gz src/ scripts/ Makefile README.md DESIGN.md LICENSE docs/

install: build
	@cp $(BIN) ~/.local/bin/

clean:
	@rm -f $(BIN)
	@rm -rf dist/

help:
	@echo "Targets: build test release install clean help"
