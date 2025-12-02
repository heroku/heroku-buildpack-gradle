![gradle](https://raw.githubusercontent.com/heroku/buildpacks/refs/heads/main/assets/images/buildpack-banner-gradle.png)

# Heroku Buildpack: Gradle [![CI](https://github.com/heroku/heroku-buildpack-gradle/actions/workflows/ci.yml/badge.svg)](https://github.com/heroku/heroku-buildpack-gradle/actions/workflows/ci.yml)

This is the official [Heroku buildpack](https://devcenter.heroku.com/articles/buildpacks) for apps that use [Gradle](https://gradle.org/) as their build tool. It's primarily used to build [Java](https://www.java.com/) applications, but it can also build applications written in other JVM languages.

If you're using a different JVM build tool, use the appropriate buildpack:
* [Java buildpack](https://github.com/heroku/heroku-buildpack-java) for [Maven](https://maven.apache.org/) projects
* [Scala buildpack](https://github.com/heroku/heroku-buildpack-scala) for [sbt](https://www.scala-sbt.org/) projects
* [Clojure buildpack](https://github.com/heroku/heroku-buildpack-clojure) for [Leiningen](https://leiningen.org/) projects

## Table of Contents

- [Supported Gradle Versions](#supported-gradle-versions)
- [Getting Started](#getting-started)
- [Application Requirements](#application-requirements)
- [Configuration](#configuration)
  - [OpenJDK Version](#openjdk-version)
  - [Gradle Version](#gradle-version)
  - [Buildpack Configuration](#buildpack-configuration)
- [Documentation](#documentation)

## Supported Gradle Versions

This buildpack officially supports Gradle `8.x` and `9.x`. Gradle `9.x` is the current recommended version.

## Getting Started

See the [Getting Started with Gradle on Heroku](https://devcenter.heroku.com/articles/deploying-gradle-apps-on-heroku) tutorial.

## Application Requirements

Your app requires a `gradlew` script in the root directory. This script is created when you [install the Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) in your project.

## Configuration

### OpenJDK Version

Specify an OpenJDK version by creating a `system.properties` file in the root of your project directory and setting the `java.runtime.version` property. See the [Java Support article](https://devcenter.heroku.com/articles/java-support#supported-java-versions) for available versions and configuration instructions.

### Gradle Version

The buildpack uses the [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) to determine which Gradle version to use. To change the Gradle version, see [Upgrading the Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html#sec:upgrading_wrapper).

### Buildpack Configuration

Configure the buildpack by setting environment variables:

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `GRADLE_TASK` | Gradle task to execute | `stage`* |

\* The buildpack may use a different default task based on detected frameworks (e.g., `build` for [Spring Boot](https://spring.io/projects/spring-boot) and [Quarkus](https://quarkus.io/), `shadowJar` for [Micronaut](https://micronaut.io/)).

## Documentation

For more information about using Java on Heroku, see the [Java Support](https://devcenter.heroku.com/categories/java-support) documentation on Dev Center.
