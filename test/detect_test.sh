#!/bin/sh

testDetect()
{
  touch ${FIXTURE_DIR}/build.gradle
  
  capture ${BUILDPACK_HOME}/bin/detect ${FIXTURE_DIR}
  
  assertEquals 0 ${rtrn}
  assertEquals "Gradle" "`cat ${STD_OUT}`"
  assertNull "`cat ${STD_ERR}`"
}

testNoDetectMissingBuildGradle()
{
  touch ${FIXTURE_DIR}/build.xml

  capture ${BUILDPACK_HOME}/bin/detect ${FIXTURE_DIR}/missing_build_gradle_file
 
  assertEquals 1 ${rtrn}
  assertEquals "no" "`cat ${STD_OUT}`"
  assertNull "`cat ${STD_ERR}`"
}

# load and run shUnit2
. test_runner
