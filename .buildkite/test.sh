#!/usr/bin/env bash
set -euo pipefail

echo "docker user is ${DOCKER_LOGIN_USER}"
echo "docker tag is ${DOCKER_TAG}"

export GRADLE_OPTS="-Dorg.gradle.daemon=false"
export TERM="dumb"
./gradlew clean test --continue
