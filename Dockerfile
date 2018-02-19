# For better performance: pre-cached Gradle artifacts into `builder` image
# To avoid repeating this before all `./gradlew` commands; add to `builder` image: ENV GRADLE_OPTS="-Dorg.gradle.daemon=false" TERM="dumb"
FROM openjdk:8-jdk as builder

WORKDIR /work
COPY . /work
RUN [ "./gradlew", "clean", "installDist" ]

FROM openjdk:8-jdk

WORKDIR "/opt/app"
COPY --from=builder [ "/work/app/build/install/gbdc", "./" ]

EXPOSE 8080
ENTRYPOINT [ "bin/gbdc" ]
