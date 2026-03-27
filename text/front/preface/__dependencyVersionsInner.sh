#!/bin/bash -

# This script prints the versions of the dependencies and software environment under which the book was built.
# It uses the basic dependency versions given in bookbase and adds python tool information.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

hasOutput=false  # Do we have some output and need a separator?

error="$(gcc --std=c23 --version 2>&1 >/dev/null || true)"
if [ -n "$error" ]; then
    error="$(gcc --std=c2x --version 2>&1 >/dev/null || true)"
    if [ -n "$error" ]; then
        echo "GCC does not support C23."
        echo "$gccVersion"
        exit 1
    else
        gccStd="c2x"
    fi
else
    gccStd="c23"
fi

gccVersion="$(gcc --std=$gccStd --version)"
gccVersion="$(grep "^gcc" <<< "$gccVersion")"
gccVersion="$(sed -n "s/gcc/gcc --std=$gccStd:/p" <<< "$gccVersion") $(gcc --std=$gccStd -dumpmachine)"
echo "$gccVersion"
hasOutput=true

# separator if we have anything
if [ "$hasOutput" = true ]; then
  echo ""
fi
