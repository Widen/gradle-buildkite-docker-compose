#!/usr/bin/env bash
set -euo pipefail

export DOCKER_TAG=$(echo "${BUILDKITE_BRANCH}-${BUILDKITE_COMMIT:0:8}" | tr '[:upper:]' '[:lower:]' | sed 's/\//-/g');
cat .buildkite/pipeline-docker.yml
