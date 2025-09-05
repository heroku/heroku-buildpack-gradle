#!/usr/bin/env bash

set -euo pipefail

gradle_build_file() {
	local buildDir="${1}"
	if [ -f "${buildDir}/build.gradle.kts" ]; then
		echo "${buildDir}/build.gradle.kts"
	else
		echo "${buildDir}/build.gradle"
	fi
}


cache_copy() {
	rel_dir="${1}"
	from_dir="${2}"
	to_dir="${3}"
	rm -rf "${to_dir}/${rel_dir}"
	if [ -d "${from_dir}/${rel_dir}" ]; then
		mkdir -p "${to_dir}/${rel_dir}"
		cp -pr "${from_dir}/${rel_dir}"/. "${to_dir}/${rel_dir}"
	fi
}


# Detects if the application has a custom 'stage' task defined in the build file.
# This is the preferred way to define the build task for Heroku deployment.
has_stage_task() {
	local build_directory="${1}"
	local gradle_file
	gradle_file="$(gradle_build_file "${build_directory}")"
	
	[[ -f "${gradle_file}" ]] && grep -qs "^ *task *stage" "${gradle_file}"
}
