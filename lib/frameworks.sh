#!/usr/bin/env bash

# This is technically redundant, since all consumers of this lib will have enabled these,
# however, it helps Shellcheck realise the options under which these functions will run.
set -euo pipefail

# Detects the primary framework used by the application by analyzing resolved dependencies.
# This is much more reliable than parsing build files as it handles all DSL syntax,
# version catalogs, variables, and transitive dependencies.
#
# Returns the detected framework name or empty string if none detected.
# Priority order: spring-boot-webapp-runner, spring-boot, micronaut, quarkus, ratpack (most specific first)
#
# Usage:
# ```
# framework=$(frameworks::detect "${BUILD_DIR}")
# case "${framework}" in
#     "spring-boot-webapp-runner") echo "Spring Boot with Webapp Runner detected" ;;
#     "spring-boot") echo "Spring Boot detected" ;;
#     "micronaut") echo "Micronaut detected" ;;
#     "quarkus") echo "Quarkus detected" ;;
#     "ratpack") echo "Ratpack detected" ;;
# esac
# ```
function frameworks::detect() {
	local build_directory="${1}"

	local dependencies
	dependencies=$(cd "${build_directory}" && ./gradlew heroku-list-all-dependencies --quiet 2>/dev/null || echo "")

	if grep -qs "org.springframework.boot:" <<<"${dependencies}"; then
		if grep -qs "webapp-runner" <<<"${dependencies}"; then
			echo "spring-boot-webapp-runner"
		else
			echo "spring-boot"
		fi
	elif grep -qs "io.micronaut:" <<<"${dependencies}"; then
		echo "micronaut"
	elif grep -qs "io.quarkus:" <<<"${dependencies}"; then
		echo "quarkus"
	elif grep -qs "io.ratpack:" <<<"${dependencies}"; then
		echo "ratpack"
	fi
}
