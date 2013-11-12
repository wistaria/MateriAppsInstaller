#!/bin/sh

if [ -z "$BUILDDIR" ]; then
  BUILDDIR="$HOME/build"
fi
mkdir -p "$BUILDDIR"
