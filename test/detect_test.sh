#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetectGradlew()
{
  touch ${BUILD_DIR}/gradlew
  detect
  assertAppDetected "Gradle"
}

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

testNoDetectAntProject()
{
  touch ${BUILD_DIR}/build.xml
  detect
  assertNoAppDetected
}

testNoDetectMavenProject()
{
  touch ${BUILD_DIR}/pom.xml
  detect
  assertNoAppDetected
}
