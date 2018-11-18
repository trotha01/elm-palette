#!/usr/bin/env bash

set -e

BIN_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
PROJECT_DIR="$(dirname "$BIN_DIR")"
EXAMPLE_DIR="$PROJECT_DIR/examples/"

# compile
$PROJECT_DIR/bin/build

# remove *.js from .gitignore
# compatible with both GNU and BSD/Mac sed
sed -i.bak '/elm.js/d' .gitignore
rm .gitignore.bak

echo "ls"
ls

# init branch and commit
git init
git config user.name "Trevor Rothaus (via Travis CI)"
git config user.email "trotha01@gmail.com"
git checkout -b gh-pages
git add .
git status
git commit -m "Deploy to GitHub Pages [skip ci]"
git push --force "https://${GITHUB_TOKEN}@github.com/trotha01/elm-palette.git" gh-pages
