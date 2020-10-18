# NBG

Web gallery written in [ELM](https://elm-lang.org/), using [typed css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest). Hosted on [aterentic.github.io/nbg](https://aterentic.github.io/nbg).

Run **make build** command to compile project to **/docs** folder. This folder is hosted on github pages.

## Project structure

### /src

**Main.elm** is entry point which contains main view and update functions.

**Data.elm** contains data structures used to define content.

**Assets.elm** contains actual site data (article text and links to photos)

### /src/assets

Contains [Roboto](https://fonts.google.com/specimen/Roboto) font files. 

### /src/Components

Basic components and CSS utils.
