#!/usr/bin/env bash
set -euo pipefail

echo "--- DOCKER_TAG is '$DOCKER_TAG'"

export GRADLE_OPTS="-Dorg.gradle.daemon=false"
export TERM="dumb"
./gradlew clean test --continue
