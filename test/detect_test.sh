#!/bin/sh

capture()
{
  $@ >${stdoutF} 2>${stderrF}
  rtrn=$?
}

testDetect()
{
  capture ${BUILDPACK_HOME}/bin/detect ${BUILDPACK_FIXTURES}/basic
  assertEquals 0 ${rtrn}
  assertEquals "Gradle" "`cat ${stdoutF}`"
  assertNull "`cat ${stderrF}`"
}

testNoDetect()
{
  capture ${BUILDPACK_HOME}/bin/detect ${BUILDPACK_FIXTURES}/invalid_type
  assertEquals 1 ${rtrn}
  assertEquals "no" "`cat ${stdoutF}`"
  assertNull "`cat ${stderrF}`"
}

oneTimeSetUp()
{
  outputDir="${SHUNIT_TMPDIR}/output"
  mkdir "${outputDir}"
  stdoutF="${outputDir}/stdout"
  stderrF="${outputDir}/stderr"
	
  BUILDPACK_HOME=".."
  BUILDPACK_FIXTURES="${BUILDPACK_HOME}/test/fixtures"
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNIT_HOME?"'SHUNIT_HOME' environment variable must be set"}/src/shunit2
