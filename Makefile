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
	@cp src/styles.css docs/
	@mkdir -p docs/assets
	@cp src/assets/* docs/assets/
