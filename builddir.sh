#!/bin/sh

if [ -z "$BUILD_DIR" ]; then
  BUILD_DIR="$HOME/build"
fi
mkdir -p "$BUILD_DIR"
