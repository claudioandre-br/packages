#!/bin/sh

DIR="$(dirname $0)"
export SNAP="$DIR"

# snap info
if [ -z ${SNAP+x} ]; then
   echo "========================================================"
   echo "Set the SNAP env var to point to the right location"
   echo "Something like this: export SNAP=/snap/john-the-ripper/12"
   echo "========================================================"
   exit 0
fi

#export SNAP="/snap/john-the-ripper/12"
export SNAP_USER_DATA="$HOME$SNAP"

if [ ! -d "$SNAP_USER_DATA" ]; then
   mkdir -p "$SNAP_USER_DATA"
fi
export HOME="$SNAP_USER_DATA"

export PATH="$SNAP/bin:$SNAP/usr/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/lib:$SNAP/usr/lib:$SNAP/lib/x86_64-linux-gnu:$SNAP/usr/lib/x86_64-linux-gnu"
export LD_LIBRARY_PATH="$SNAP/usr/local/lib:$LD_LIBRARY_PATH"

LD_LIBRARY_PATH=$SNAP_LIBRARY_PATH:$LD_LIBRARY_PATH
exec "$SNAP/run/john-opencl" "$@"
