#!/bin/sh

capture()
{
  $@ >${STD_OUT} 2>${STD_ERR}
  rtrn=$?
}

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

setUp()
{
  BUILDPACK_HOME=".."
  OUTPUT_DIR="${SHUNIT_TMPDIR}/output"
  mkdir "${OUTPUT_DIR}"  
  FIXTURE_DIR="$(mktemp -d ${OUTPUT_DIR}/fixture.XXXX)"	
  STD_OUT="${OUTPUT_DIR}/stdout"
  STD_ERR="${OUTPUT_DIR}/stderr"
}

tearDown()
{
  rm -rf ${OUTPUT_DIR}
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNIT_HOME?"'SHUNIT_HOME' environment variable must be set"}/src/shunit2
