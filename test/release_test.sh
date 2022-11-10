#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testRelease()
{
  # shellcheck disable=SC2039
  expected_release_output=$(echo -e "---\n{}")

  release

  assertCapturedEquals "${expected_release_output}"
}
