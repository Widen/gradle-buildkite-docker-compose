#!/usr/bin/env bash
set -euox pipefail

./gradlew clean test --continue
