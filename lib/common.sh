#!/usr/bin/env bash

# This is technically redundant, since all consumers of this lib will have enabled these,
# however, it helps Shellcheck realise the options under which these functions will run.
set -euo pipefail

# Detects if the application has a custom 'stage' task available.
# This is the preferred way to define the build task for Heroku deployment.
# Uses gradlew to get the definitive list of available tasks.
has_stage_task() {
	local build_directory="${1}"

	# Use gradlew to list tasks and check if 'stage' is available
	# Redirect stderr to avoid noise if gradle wrapper has issues
	(cd "${build_directory}" && ./gradlew tasks --all 2>/dev/null | grep -q "^stage ")
}
