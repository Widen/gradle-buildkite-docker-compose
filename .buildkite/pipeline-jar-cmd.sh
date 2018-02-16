#!/usr/bin/env bash
set -euox pipefail

export GRADLE_OPTS="-Dorg.gradle.daemon=false"
export TERM="dumb"

if [ "$BUILDKITE_TAG" == "" ]; then
    git checkout $BUILDKITE_BRANCH
    git reset --hard $BUILDKITE_COMMIT
fi

GRADLE_VERSION=$(./gradlew -version | grep Gradle | cut -d ' ' -f 2)

if [ "$BUILDKITE_PULL_REQUEST" != "false" ]; then
  echo -e "Build Pull Request #$BUILDKITE_PULL_REQUEST => Branch [$BUILDKITE_BRANCH]"
  ./gradlew clean test $GRADLE_SWITCHES
elif [ "$BUILDKITE_PULL_REQUEST" == "false" ] && [ "$BUILDKITE_TAG" == "" ]; then
  echo -e 'Build Push => Branch ['$BUILDKITE_BRANCH']'
  ./gradlew clean test $GRADLE_SWITCHES
elif [ "$BUILDKITE_PULL_REQUEST" == "false" ] && [ "$BUILDKITE_TAG" != "" ]; then
  echo -e 'Build Branch for Release => Branch ['$BUILDKITE_BRANCH']  Tag ['$BUILDKITE_TAG']'
  ./gradlew clean test $GRADLE_SWITCHES
  RELEASE_VERSION=`echo $BUILDKITE_TAG | cut -c 2-` # expecting tags to be prefixed with a `v` (e.g. `v1.2.3`)
  case "$BUILDKITE_TAG" in
  *-rc\.*)
    ./gradlew -Prelease.disableGitChecks=true -Prelease.version=$RELEASE_VERSION candidate release publish2 $GRADLE_SWITCHES
    ;;
  *)
    ./gradlew -Prelease.disableGitChecks=true -Prelease.version=$RELEASE_VERSION final release publish2 $GRADLE_SWITCHES
    ;;
  esac
else
  echo -e 'WARN: Should not be here => Branch ['$BUILDKITE_BRANCH']  Tag ['$BUILDKITE_TAG']  Pull Request ['$BUILDKITE_PULL_REQUEST']'
  exit 1
fi
