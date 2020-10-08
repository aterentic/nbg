.PHONY: help
help:
	@echo "NBG"

.PHONY: clean
clean:
	@rm -rf docs/*

.PHONY: build
build:
	@elm make src/Main.elm --output=docs/main.js
	@cp src/index.html docs/
	@mkdir -p docs/assets
	@cp -r src/assets/* docs/assets/
