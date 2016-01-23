#!/bin/bash

set -x
set -e

ROOT_DIR=`dirname "$(readlink -f "$0")"`/..

RELEASES_DIR=$ROOT_DIR/releases
VERSIONS_DIR=$RELEASES_DIR/versions

VERSION=`cat $ROOT_DIR/version`

MIRROR_URL=http://www.us.apache.org/dist/mesos

MESOS_DEFAULT_VERSION=0.26.0

unset MESOS_DEFAULT_VERSION
while read -r i; do
    if [[ $i == $MESOS_VERSION ]]; then
        MATCHES=$MESOS_VERSION
    fi
    MESOS_DEFAULT_VERSION=$i
done <<< "$VERSION"

if [[ -z $MATCHES ]] || [[ -z $MESOS_VERSION ]]; then
    MESOS_VERSION=$MESOS_DEFAULT_VERSION
fi

if [[ ! -d $VERSIONS_DIR ]]; then
    mkdir -p $VERSIONS_DIR
fi

if [[ ! -d $VERSIONS_DIR/mesos-$MESOS_VERSION ]]; then

    curl -sSL $MIRROR_URL/$MESOS_VERSION/mesos-$MESOS_VERSION.tar.gz | tar -xzf - -C $VERSIONS_DIR

    if [[ -f $RELEASES_DIR/current ]] || [[ -d $RELEASES_DIR/current ]] || [[ -L $RELEASES_DIR/current ]]; then
        rm -rf $RELEASES_DIR/current
    fi

    ln -s $VERSIONS_DIR/mesos-$MESOS_VERSION $RELEASES_DIR/current

fi

