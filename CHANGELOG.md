# Gradle Buildpack Changelog

## main

* Fix a bug causing Gradle daemon to be unintentionally used when executing builds 
* Remove heroku-16 support

## v35

* Update tests

## v34

* Run all tests defined by "check" task (Set `GRADLE_TESTPACK_LEGACY_TASK` to a non-empty value to restore old behavior)

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
