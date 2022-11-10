# Heroku buildpack: Gradle [![CI](https://github.com/heroku/heroku-buildpack-gradle/actions/workflows/ci.yml/badge.svg)](https://github.com/heroku/heroku-buildpack-gradle/actions/workflows/ci.yml)

![](https://cloud.githubusercontent.com/assets/51578/18790734/e1a0bba8-817d-11e6-864e-de501a437ec5.png)

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for Gradle apps.
It uses Gradle to build your application and OpenJDK to run it.

## Usage

1. Install the [Gradle Wrapper](http://www.gradle.org/docs/current/userguide/gradle_wrapper.html) into your project.
    - This allows control over the Gradle version and exact distribution to be used.
2. Specify the Java version to be used as per [these instructions](https://devcenter.heroku.com/articles/java-support#specifying-a-java-version).
3. If you are not using Spring Boot or Ratpack, then follow the instructions for [configuring your build](https://devcenter.heroku.com/articles/deploying-gradle-apps-on-heroku).

You do not need to explicitly declare that your project should use this buildpack.
The presence of a `gradlew` script in the root of your project will allow the fact that your app is built with Gradle to detected.

The `bin` directory of the installed JDK is placed on the `PATH` for process execution (i.e. the `java` command is available to start the app).
