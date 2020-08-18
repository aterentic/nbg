#!/bin/sh

elm make src/Main.elm --output=docs/main.js
cp src/index.html docs/
cp src/styles.css docs/
