#!/usr/bin/env bash
set -euo pipefail

export GRADLE_OPTS="-Dorg.gradle.daemon=false"
export TERM="dumb"
./gradlew clean test --continue
