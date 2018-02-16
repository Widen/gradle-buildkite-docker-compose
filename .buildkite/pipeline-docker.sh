#!/usr/bin/env bash
set -euox pipefail

export DOCKER_TAG=$(echo "${BUILDKITE_BRANCH}-${BUILDKITE_COMMIT:0:8}" | tr '[:upper:]' '[:lower:]' | sed 's/\//-/g');
exprot THIS_BK_AGENT=$(buildkite-agent meta-data get name)
cat pipline-docker.yml
