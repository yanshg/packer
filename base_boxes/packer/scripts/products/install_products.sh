#!/bin/bash -eux

os=${1:-$BOX_OS};
prod=${2:-$BOX_PROD} ;

orig_os=$os

[ -z "$os" ] && exit 0;
[ -z "$prod" ] && exit 0;

if [ -n "$TERM" ] && [ "$TERM" = unknown ] ; then
    TERM=dumb
    export TERM
fi

exit 0

