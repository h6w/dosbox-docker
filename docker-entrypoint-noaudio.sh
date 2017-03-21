#!/bin/sh
set -e

CMD=${1:-dosbox}

exec $CMD

exit 0
