# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

* Improve OpenJDK installation via `jvm-common` buildpack to prevent function overrides and fix environment variable handling. ([#181](https://github.com/heroku/heroku-buildpack-gradle/pull/181))

## [v48] - 2025-09-17

### Fixed

- Fix `stage` task detection to work regardless of whether task has a description. ([#177](https://github.com/heroku/heroku-buildpack-gradle/pull/177))

## [v47] - 2025-09-16

- Improve test-compile resilience and performance. ([#175](https://github.com/heroku/heroku-buildpack-gradle/pull/175))

## [v46] - 2025-09-15

### Fixed

- Guard against missing `gradlew` during daemon cleanup to prevent "No such file or directory" errors. ([#172](https://github.com/heroku/heroku-buildpack-gradle/pull/172))

## [v45] - 2025-09-12

### Fixed

- Fix build failures when users have `org.gradle.vfs.watch=true` in their project `gradle.properties` by explicitly disabling file system watching in buildpack configuration, as it's incompatible with `org.gradle.projectcachedir`. ([#170](https://github.com/heroku/heroku-buildpack-gradle/pull/170))

## [v44] - 2025-09-12

### Added

- Gradle daemon lifecycle management for faster builds. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))

### Changed

- Framework detection now uses Gradle dependency resolution instead of build file parsing for more reliable detection across all DSL syntax, version catalogs, and dependency sources. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))
- Improve error messages with detailed troubleshooting steps, documentation links, and local reproduction guidance. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))
- Improve detection error message with better user experience and guidance for other build tools. ([#168](https://github.com/heroku/heroku-buildpack-gradle/pull/168))

### Removed

- `GRADLE_TESTPACK_LEGACY_TASK` legacy feature. Always exclude `check` task during builds instead of just `test` task. ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))
- Gradle wrapper installation feature. Projects must include their own Gradle wrapper (`gradlew`). To add a wrapper, run `gradle wrapper` locally and commit the generated files. The buildpack's default wrapper provision was deprecated in 2014. (see [#17](https://github.com/heroku/heroku-buildpack-gradle/pull/17)) ([#165](https://github.com/heroku/heroku-buildpack-gradle/pull/165))

## [v43] - 2025-07-14

* Exclude JAR files with `plain`, `sources`, and `javadoc` file name suffixes from being used as default process types for Spring Boot and Micronaut apps. ([#152](https://github.com/heroku/heroku-buildpack-gradle/pull/152), [#155](https://github.com/heroku/heroku-buildpack-gradle/pull/155))

## [v42] - 2025-06-16

* This release is identical with `v40`, rolling back changes introduced in `v41`.

## [v41] - 2025-06-16

* Remove `heroku-20` support. ([#150](https://github.com/heroku/heroku-buildpack-gradle/pull/150))
* Exclude JAR files with `plain`, `sources`, and `javadoc` file name suffixes from being used as default process types for Spring Boot and Micronaut apps. ([#152](https://github.com/heroku/heroku-buildpack-gradle/pull/152))

## [v40] - 2024-10-04

* Remove `heroku-18` support. ([#128](https://github.com/heroku/heroku-buildpack-gradle/pull/128))
* Add default process type and build task detection for Micronaut and Quarkus. ([#144](https://github.com/heroku/heroku-buildpack-gradle/pull/144))

## [v39] - 2022-12-06

* Only use `--retry-connrefused` on Ubuntu based stacks. ([#115](https://github.com/heroku/heroku-buildpack-gradle/pull/115))
* Allow usage of Kotlin DSL files (`settings.gradle.kts`, `build.gradle.kts`). ([#103](https://github.com/heroku/heroku-buildpack-gradle/pull/103))

## [v38] - 2022-06-14

* Adjust `curl` retry and connection timeout handling.
* Vendor `buildpack-stdlib` rather than downloading it at build time.
* Switch to the recommended regional S3 domain instead of the global one.

## [v37] - 2022-06-07

* Add `heroku-22` support.

## [v36] - 2021-12-13

* Fix a bug causing Gradle daemon to be unintentionally used when executing builds.
* Remove `heroku-16` support.

## [v35] - 2021-02-23

* Update tests. ([#88](https://github.com/heroku/heroku-buildpack-gradle/pull/88), [#89](https://github.com/heroku/heroku-buildpack-gradle/pull/89), [#90](https://github.com/heroku/heroku-buildpack-gradle/pull/90))

## [v34] - 2021-01-05

* Run all tests defined by `check` task. (Set `GRADLE_TESTPACK_LEGACY_TASK` to a non-empty value to restore old behavior) ([#86](https://github.com/heroku/heroku-buildpack-gradle/pull/86))

## [v33] - 2020-12-01

* Enable `heroku-20` testing. ([#76](https://github.com/heroku/heroku-buildpack-gradle/pull/76))
* Ensure Gradle cache is used between `/bin/test-compile` and `/bin/test` runs. ([#82](https://github.com/heroku/heroku-buildpack-gradle/pull/82))

## [v32] - 2020-10-12

* Update tests. ([#68](https://github.com/heroku/heroku-buildpack-gradle/pull/68))

## [v31] - 2019-10-14

* Search for `spring-boot-detect-plugin` when detecting Spring Boot apps. ([#53](https://github.com/heroku/heroku-buildpack-gradle/pull/53))

## [v30] - 2019-04-18

* Exclude `nodejs` directory created by `gradle-node-plugin` from cache. ([#50](https://github.com/heroku/heroku-buildpack-gradle/pull/50))

## [v29] - 2019-03-18

* Pass cache to JVM install to cache `system.properties` file. ([#48](https://github.com/heroku/heroku-buildpack-gradle/pull/48))

## [v28] - 2019-02-04

* Disable Gradle welcome message. ([#46](https://github.com/heroku/heroku-buildpack-gradle/pull/46))

## [v27] - 2018-06-14

* Add symlink from project `.gradle` to the cache. ([#40](https://github.com/heroku/heroku-buildpack-gradle/pull/40))

[unreleased]: https://github.com/heroku/heroku-buildpack-gradle/compare/v48...main
[v48]: https://github.com/heroku/heroku-buildpack-gradle/compare/v47...v48
[v47]: https://github.com/heroku/heroku-buildpack-gradle/compare/v46...v47
[v46]: https://github.com/heroku/heroku-buildpack-gradle/compare/v45...v46
[v45]: https://github.com/heroku/heroku-buildpack-gradle/compare/v44...v45
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
[v34]: https://github.com/heroku/heroku-buildpack-gradle/compare/v33...v34
[v33]: https://github.com/heroku/heroku-buildpack-gradle/compare/v32...v33
[v32]: https://github.com/heroku/heroku-buildpack-gradle/compare/v31...v32
[v31]: https://github.com/heroku/heroku-buildpack-gradle/compare/v30...v31
[v30]: https://github.com/heroku/heroku-buildpack-gradle/compare/v29...v30
[v29]: https://github.com/heroku/heroku-buildpack-gradle/compare/v28...v29
[v28]: https://github.com/heroku/heroku-buildpack-gradle/compare/v27...v28
[v27]: https://github.com/heroku/heroku-buildpack-gradle/compare/v26...v27
