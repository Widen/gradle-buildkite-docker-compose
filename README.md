## Trivial Non-Trivial Gradle / Buildkite / Docker Compose experimentation project

### Configuration

  - application source is in `app` directory
    - app has unit tests (no external dependencies) and integration tests (requires `app` to be running for HTTP tests)
    - runtime output is a Docker image of the command `./gradlew installDist`
  - JAR artifact in `json` directory
    - JAR file uploaded to remote Maven repo

# Buildkite Pipelines

### Test and Push Container On Each Commit
  1. Required pipeline environment variables:
     - DOCKER_LOGIN_USER=x
     - DOCKER_LOGIN_PASSWORD=x
     - DOCKER_LOGIN_SERVER=x
     - DOCKER_IMAGE_REPO=x
     - MAVEN_REPO_USER=x
     - MAVEN_REPO_PASS=x

  1. checkout repo
  1. concurrently run two containers:
     - unit tests
     - build and push docker app image (uses multi-stage Docker command)
  1. *wait for previous steps to complete successfully*
  1. start app container (using new image)
  1. start gradle container
  1. run `integrationTest` task in Gradle container that exercises app container
  1. *wait for previous steps to complete successfully*
  1. do other tasks (e.g. update kubernetes deployments, add latest tag, etc.)

### Publish Tagged JAR
  1. checkout repo
  1. fixup repo with branch name (grgit reads the repo directly; no way to use ENV vars)
  1. run unit tests
  1. push JAR to remote Maven repo

### Tasks

  - `./gradlew clean test` -- run unit tests

  - `./gradlew run` -- start HTTP server in foreground
      - Test endpoint: `http://localhost:8080/?name=blah`

  - `./gradlew clean integrationTest` -- run integration tests against HTTP server
