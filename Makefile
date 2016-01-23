# Makefile for Mesos Docker Image Builder
# Version 1.0
# Samuel Ng
#
# default: all

PACKAGE_DIR := $(dirname "$(readlink -f "$0")")

all: latest

latest:
	@./scripts/download_mesos.sh ||:
	@tar -czh . | docker build --rm -t mesos -
