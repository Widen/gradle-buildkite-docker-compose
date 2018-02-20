#!/usr/bin/env bash
set -euo pipefail

export DOCKER_TAG=$(echo "${BUILDKITE_BRANCH}-${BUILDKITE_COMMIT:0:8}" | tr '[:upper:]' '[:lower:]' | sed 's/\//-/g')

cat <<YAML
steps:

  - name: ":junit: Unit Tests"
    command: .buildkite/test.sh
    artifact_paths: "app/build/reports/tests/test/**/*"
    plugins:
      docker-compose#v1.8.3:
        image: openjdk:8-jdk
        run: java

  - name: ":docker: Docker Image"
    plugins:
      docker-compose#v1.8.3:
        build:
          - app
        image-name: ${DOCKER_TAG}
        image-repository: ${DOCKER_IMAGE_REPO}

  - wait

  - name: ":junit: Integration Tests"
    command: .buildkite/test-integration.sh
    artifact_paths: "app/build/reports/integTest/**/*"
    plugins:
      docker-compose#v1.8.3:
        run: integ

  - wait

  - name: ":truck: Publish JAR"
    command: .buildkite/jar.sh
    plugins:
      docker-compose#v1.8.3:
        run: java
        environment:
          - BUILDKITE_BRANCH
          - BUILDKITE_BUILD_NUMBER
          - BUILDKITE_COMMIT
          - BUILDKITE_PIPELINE_DEFAULT_BRANCH
          - BUILDKITE_PULL_REQUEST
          - BUILDKITE_TAG
          - MAVEN_REPO_USER
          - MAVEN_REPO_PASS
YAML
