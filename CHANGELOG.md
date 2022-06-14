# Gradle Buildpack Changelog

## main

## v38

* Adjust curl retry and connection timeout handling
* Vendor buildpack-stdlib rather than downloading it at build time
* Switch to the recommended regional S3 domain instead of the global one

## v37

* Add heroku-22 support

## v36

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
