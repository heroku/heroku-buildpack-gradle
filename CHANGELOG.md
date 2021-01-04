# Gradle Buildpack Changelog

## main

* Actually execute tests

## v33

* Enable heroku-20 testing
* Ensure Gradle cache is used between /bin/test-compile and /bin/test runs (#82)

## v32

* Update tests

## v31

* Search for spring-boot-detect-plugin when detecting Spring Boot apps

## v30

* Exclude nodejs dir created by gradle-node-plugin from cache

## v28

* Disable Gradle welcome message

## v27

* Pass cache to JVM install to cache system.properties file

## v28

* Remove Gradle welcome message

## v27

* Add symlink from project .gradle to the cache
