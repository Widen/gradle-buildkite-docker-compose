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

### Local Tasks

  - `./gradlew clean test` -- run unit tests

  - `./gradlew run` -- start HTTP server in foreground
      - Test endpoint: `http://localhost:8080/?name=blah`

  - `./gradlew clean integrationTest` -- run integration tests against HTTP server

  - Publish versioned JAR: for a release candidate use `./gradlew candidate`, for final use `./gradlew final`
      - Gradle will auto tag the release and push to the repo; buildkite will then run the build and upload the JAR artifacts to the Maven server

# Known Issues
  1. Uploaded test report HTML artifacts (e.g. CSS) do not correctly link without
     configuration of [`BUILDKITE_ARTIFACT_UPLOAD_DESTINATION`](https://buildkite.com/docs/agent/cli-artifact#using-your-own-private-aws-s3-bucket).
     One solution is to use our [cloudfront-auth](https://github.com/Widen/cloudfront-auth) project.
