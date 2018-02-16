# for better performance: pre-cached Gradle artifacts into `builder` image
FROM openjdk:8-jdk as builder
ENV GRADLE_OPTS="-Dorg.gradle.daemon=false" TERM="dumb"

WORKDIR /work
COPY . /work
RUN [ "./gradlew", "clean", "installDist" ]

FROM openjdk:8-jdk
ENV GRADLE_OPTS="-Dorg.gradle.daemon=false" TERM="dumb"

WORKDIR "/opt/app"
COPY --from=builder [ "/work/app/build/install/gbdc", "./" ]

EXPOSE 8080
ENTRYPOINT [ "bin/gbdc" ]
