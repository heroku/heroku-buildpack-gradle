# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]


## [v44] - 2025-09-12

### Added

- Gradle daemon lifecycle management for faster builds. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))

### Changed

- Framework detection now uses Gradle dependency resolution instead of build file parsing for more reliable detection across all DSL syntax, version catalogs, and dependency sources. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))
- Improved error messages with detailed troubleshooting steps, documentation links, and local reproduction guidance. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))
- Improve detection error message with better user experience and guidance for other build tools. ([#168](https://github.com/heroku/heroku-buildpack-gradle/pull/168))

### Removed

- `GRADLE_TESTPACK_LEGACY_TASK` legacy feature - always exclude `check` task during builds instead of just `test` task. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))
- Gradle wrapper installation feature. Projects must include their own Gradle wrapper (`gradlew`). To add a wrapper, run `gradle wrapper` locally and commit the generated files. The buildpack's default wrapper provision was deprecated in 2014 (see [#17](https://github.com/heroku/heroku-buildpack-gradle/pull/17)). ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))

## [v43] - 2025-07-14

* Exclude JAR files with `plain`, `sources` and `javadoc` file name suffixes from being used as default process types for Spring Boot and Micronaut apps. ([#152](https://github.com/heroku/heroku-buildpack-gradle/pull/152), [#155](https://github.com/heroku/heroku-buildpack-gradle/pull/155))

## [v42] - 2025-06-16

* This release is identical with `v40`, rolling back changes introduced in `v41`.

## [v41] - 2025-06-16

* Remove heroku-20 support ([#150](https://github.com/heroku/heroku-buildpack-gradle/pull/150))
* Exclude JAR files with `plain`, `sources` and `javadoc` file name suffixes from being used as default process types for Spring Boot and Micronaut apps. ([#152](https://github.com/heroku/heroku-buildpack-gradle/pull/152))

## [v40] - 2024-10-04

* Remove heroku-18 support ([#128](https://github.com/heroku/heroku-buildpack-gradle/pull/128))
* Add default process type and build task detection for Micronaut and Quarkus. ([#144](https://github.com/heroku/heroku-buildpack-gradle/pull/144))

## [v39] - 2022-12-06

* Only use `--retry-connrefused` on Ubuntu based stacks. ([#115](https://github.com/heroku/heroku-buildpack-gradle/pull/115))
* Allow usage of Kotlin DSL files (settings.gradle.kts, build.gradle.kts) ([#103](https://github.com/heroku/heroku-buildpack-gradle/pull/103))

## [v38] - 2022-06-14

* Adjust curl retry and connection timeout handling
* Vendor buildpack-stdlib rather than downloading it at build time
* Switch to the recommended regional S3 domain instead of the global one

## [v37] - 2022-06-07

* Add heroku-22 support

## [v36] - 2021-12-13

* Fix a bug causing Gradle daemon to be unintentionally used when executing builds 
* Remove heroku-16 support

## [v35] - 2021-02-23

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

[unreleased]: https://github.com/heroku/heroku-buildpack-gradle/compare/v44...main
[v44]: https://github.com/heroku/heroku-buildpack-gradle/compare/v43...v44
[v43]: https://github.com/heroku/heroku-buildpack-gradle/compare/v42...v43
[v42]: https://github.com/heroku/heroku-buildpack-gradle/compare/v41...v42
[v41]: https://github.com/heroku/heroku-buildpack-gradle/compare/v40...v41
[v40]: https://github.com/heroku/heroku-buildpack-gradle/compare/v39...v40
[v39]: https://github.com/heroku/heroku-buildpack-gradle/compare/v38...v39
[v38]: https://github.com/heroku/heroku-buildpack-gradle/compare/v37...v38
[v37]: https://github.com/heroku/heroku-buildpack-gradle/compare/v36...v37
[v36]: https://github.com/heroku/heroku-buildpack-gradle/compare/v35...v36
[v35]: https://github.com/heroku/heroku-buildpack-gradle/compare/v34...v35
