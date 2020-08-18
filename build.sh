#!/bin/sh

elm make src/Main.elm --output=dist/main.js
cp src/index.html dist/
cp src/styles.css dist/
