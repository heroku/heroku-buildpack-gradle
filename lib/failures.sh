#!/usr/bin/env bash

set -euo pipefail

handle_gradle_errors() {
	local log_file="$1"

	# Load required libraries
	BUILDPACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
	source "${BUILDPACK_DIR}/lib/output.sh"
	source "${BUILDPACK_DIR}/lib/metrics.sh"

	local header="Failed to run Gradle!"

	local previousVersion="You can also try reverting to the previous version of the buildpack by running:
$ heroku buildpacks:set https://github.com/heroku/heroku-buildpack-gradle#previous-version"

	local footer="Thanks,
Heroku"

	if grep -qi "Task 'stage' not found in root project" "$log_file"; then
		output::error <<-EOF
			${header}
			It looks like your project does not contain a 'stage' task, which Heroku needs in order
			to build your app. Our Dev Center article on preparing a Gradle application for Heroku
			describes how to create this task:
			https://devcenter.heroku.com/articles/deploying-gradle-apps-on-heroku

			If you're stilling having trouble, please submit a ticket so we can help:
			https://help.heroku.com

			${footer}
		EOF
		
		metrics::set_string "failure_reason" "gradle_build::stage_task_not_found"
		exit 1
	elif grep -qi "Could not find or load main class org.gradle.wrapper.GradleWrapperMain" "$log_file"; then
		output::error <<-EOF
			${header}
			It looks like you don't have a gradle-wrapper.jar file checked into your Git repo.
			Heroku needs this JAR file in order to run Gradle.  Our Dev Center article on preparing
			a Gradle application for Heroku describes how to fix this:
			https://devcenter.heroku.com/articles/deploying-gradle-apps-on-heroku

			If you're stilling having trouble, please submit a ticket so we can help:
			https://help.heroku.com

			${footer}
		EOF
		
		metrics::set_string "failure_reason" "gradle_build::missing_wrapper_jar"
		exit 1
	else
		output::error <<-EOF
			${header}
			We're sorry this build is failing. If you can't find the issue in application
			code, please submit a ticket so we can help: https://help.heroku.com
			${previousVersion}

			${footer}
		EOF
		
		metrics::set_string "failure_reason" "gradle_build::generic_failure"
		exit 1
	fi
}
