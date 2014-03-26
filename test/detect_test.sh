#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetectSettingsGradle()
{
  touch ${BUILD_DIR}/settings.gradle

  detect

  assertAppDetected "Gradle"
}

testDetectBuildGradle()
{
  touch ${BUILD_DIR}/build.gradle
  
  detect

  assertAppDetected "Gradle"
}

testNoDetectMissingBuildGradleAndSettingsGradle()
{
  touch ${BUILD_DIR}/build.xml

  detect

  assertNoAppDetected
}
