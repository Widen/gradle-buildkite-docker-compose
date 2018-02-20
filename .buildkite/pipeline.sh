#!/usr/bin/env bash
set -euo pipefail

DOCKER_TAG=$(echo "${BUILDKITE_BRANCH}-${BUILDKITE_COMMIT:0:8}" | tr '[:upper:]' '[:lower:]' | sed 's/\//-/g')
#buildkite-agent meta-data set build-docker-tag $DOCKER_TAG

cat .buildkite/pipeline.yml
