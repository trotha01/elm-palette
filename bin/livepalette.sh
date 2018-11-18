#!/usr/bin/env bash

# This file is used to move the saved palette from
# the download directory to the src directory.
#
# on osx use with
# fswatch -0 ~/Downloads/ | xargs -0 -n 1 -I {} ./livepalette.sh

BIN_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
PROJECT_DIR="$(dirname "$BIN_DIR")"
EXAMPLE_DIR="$PROJECT_DIR/examples/"

if [ -f ~/Downloads/Palette.elm ]; then
  mv ~/Downloads/Palette.elm $EXAMPLE_DIR/src/ExamplePalette.elm
fi
