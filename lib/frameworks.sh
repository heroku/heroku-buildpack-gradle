#!/usr/bin/env bash

# This is technically redundant, since all consumers of this lib will have enabled these,
# however, it helps Shellcheck realise the options under which these functions will run.
set -euo pipefail

BUILDPACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

source "${BUILDPACK_DIR}/lib/util.sh"

# Returns the path to the Gradle build file (build.gradle or build.gradle.kts)
# for the given build directory.
#
# Usage:
# ```
# build_file=$(frameworks::get_gradle_build_file "${BUILD_DIR}")
# ```
function frameworks::get_gradle_build_file() {
	local build_directory="${1}"

	if [[ -f "${build_directory}/build.gradle.kts" ]]; then
		echo "${build_directory}/build.gradle.kts"
	else
		echo "${build_directory}/build.gradle"
	fi
}

# Detects if the application is a Spring Boot project by checking for Spring Boot
# dependencies and plugins in the Gradle build file.
#
# Usage:
# ```
# if frameworks::is_spring_boot "${BUILD_DIR}"; then
#     echo "Spring Boot application detected"
# fi
# ```
function frameworks::is_spring_boot() {
	local build_directory="${1}"
	local gradle_file
	gradle_file="$(frameworks::get_gradle_build_file "${build_directory}")"

	[[ -f "${gradle_file}" ]] && {
		grep -qs "^[^/].*org.springframework.boot:spring-boot" "${gradle_file}" ||
			grep -qs "^[^/].*spring-boot-gradle-plugin" "${gradle_file}" ||
			grep -qs "^[^/].*id.*org.springframework.boot" "${gradle_file}"
	} && ! grep -qs "org.grails:grails-" "${gradle_file}"
}

# Detects if the application uses Micronaut by checking for Micronaut
# dependencies in the Gradle build file.
#
# Usage:
# ```
# if frameworks::is_micronaut "${BUILD_DIR}"; then
#     echo "Micronaut application detected"
# fi
# ```
function frameworks::is_micronaut() {
	local build_directory="${1}"
	local gradle_file
	gradle_file="$(frameworks::get_gradle_build_file "${build_directory}")"

	[[ -f "${gradle_file}" ]] && grep -qs "io.micronaut" "${gradle_file}"
}

# Detects if the application uses Quarkus by checking for Quarkus
# dependencies in the Gradle build file.
#
# Usage:
# ```
# if frameworks::is_quarkus "${BUILD_DIR}"; then
#     echo "Quarkus application detected"
# fi
# ```
function frameworks::is_quarkus() {
	local build_directory="${1}"
	local gradle_file
	gradle_file="$(frameworks::get_gradle_build_file "${build_directory}")"

	[[ -f "${gradle_file}" ]] && grep -qs "io.quarkus" "${gradle_file}"
}

# Detects if the application is a Grails project by checking for Grails
# dependencies in the Gradle build file.
#
# Usage:
# ```
# if frameworks::is_grails "${BUILD_DIR}"; then
#     echo "Grails application detected"
# fi
# ```
function frameworks::is_grails() {
	local build_directory="${1}"
	local gradle_file
	gradle_file="$(frameworks::get_gradle_build_file "${build_directory}")"

	[[ -f "${gradle_file}" ]] && grep -qs "^[^/].*org.grails:grails-" "${gradle_file}"
}

# Detects if the application uses Webapp Runner by checking for
# webapp-runner dependencies in the Gradle build file.
#
# Usage:
# ```
# if frameworks::is_webapp_runner "${BUILD_DIR}"; then
#     echo "Webapp Runner detected"
# fi
# ```
function frameworks::is_webapp_runner() {
	local build_directory="${1}"
	local gradle_file
	gradle_file="$(frameworks::get_gradle_build_file "${build_directory}")"

	[[ -f "${gradle_file}" ]] && grep -qs "webapp-runner" "${gradle_file}"
}
