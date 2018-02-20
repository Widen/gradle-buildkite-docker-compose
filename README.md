## Trivial Non-Trivial Gradle / Buildkite / Docker Compose experimentation project

An example Java project that combines several technologies in a non-trivial manner.
The two main artifacts are:

  - An application whose main source is in the `app` directory. The Gradle application plugin is
    used to package all the required files.
  - A library whose main source is in the `json` directory. It's common that a project needs to
    export shared classes. The Gradle Nebula Maven publish plugin is used to uploaded a compiled JAR
    to a Maven server.

The Buildkite CI system has been used to create a realistic build and release system.

  - Unit tests and building the application Docker image are done in parallel.
  - If both tasks are successful, the Docker image is run and the integration tests are executed.

Project versioning is automatically controlled by [Nebula Release](https://github.com/nebula-plugins/nebula-release-plugin) Gradle plugin.

  - We expect developers to publish JAR snapshots of the `json` module from their local workstation: `./gradlew devSnapshot` or `./gradlew snapshot`.
    Values for `MAVEN_REPO_URL`, `MAVEN_REPO_USER` and `MAVEN_REPO_PASS` will need to be present in `~/.gradle/gradle.properties` or in the project `gradle.properties` file.
  - To release final version execute `./gradlew final` or `./gradlew candidate`
      - The next available semantic version number tag will be created (e.g. `v1.2.0` or `v1.2.0-rc.1`) and pushed to the Git repo
      - When Buildkite runs the pipeline for the new Git tag the library JAR is generated and uploaded to the Maven server.

## Buildkite Pipeline Config
  1. Create a new pipeline with forked repo
  1. Enable `Build Tags` option in Github settings of pipeline
  1. Add pipeline upload step of `.buildkite/pipeline.sh | buildkite-agent pipeline upload`
  1. Add these pipeline environment variables (values are specific to your site):
     - `DOCKER_LOGIN_USER=x`
     - `DOCKER_LOGIN_PASSWORD=x`
     - `DOCKER_LOGIN_SERVER=x` (e.g. `quay.io`)
     - `DOCKER_IMAGE_REPO=x` (e.g. `quay.io/myorg/myrepo`)
     - `MAVEN_REPO_USER=x`
     - `MAVEN_REPO_PASS=x`
     - `MAVEN_REPO_URL=x` (e.g. `https://myorg.jfrog.io/myorg/libs-releases`)

### Local Tasks

  - `./gradlew clean test` -- run unit tests

  - `./gradlew run` -- start HTTP server in foreground
      - Test endpoint: `http://localhost:8080/?name=blah`

  - `./gradlew clean integrationTest` -- run integration tests against HTTP server

  - Publish versioned JAR:
      - snapshot: `./gradlew devSnapshot` or `./gradlew snapshot` (no tag, will publish JAR directly)
      - release: `./gradlew candidate` or `./gradlew final` (creates tag, will have CI server publish JAR)

# Known Issues
  1. Uploaded test report HTML artifacts (e.g. CSS) do not correctly link without
     configuration of [`BUILDKITE_ARTIFACT_UPLOAD_DESTINATION`](https://buildkite.com/docs/agent/cli-artifact#using-your-own-private-aws-s3-bucket).
     One solution is to use our [cloudfront-auth](https://github.com/Widen/cloudfront-auth) project.
