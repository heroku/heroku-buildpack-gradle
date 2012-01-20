#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  touch ${BUILD_DIR}/build.gradle
  
  detect

  assertAppDetected "Gradle"
}

testNoDetectMissingBuildGradle()
{
  touch ${BUILD_DIR}/build.xml

  detect

  assertNoAppDetected
}
