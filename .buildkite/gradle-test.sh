#!/usr/bin/env bash
set -euox pipefail

export GRADLE_OPTS="-Dorg.gradle.daemon=false"
export TERM="dumb"
./gradlew clean test --continue
