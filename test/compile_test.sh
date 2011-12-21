#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  expected_stage_output="STAGING:${RANDOM}"
  
  cat > ${BUILD_DIR}/build.gradle <<EOF
task stage {
  println "${expected_stage_output}"
}
EOF

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 ${rtrn}
  assertContains "Installing gradle-1.0-milestone-5" "`cat ${STD_OUT}`"
  assertContains "${expected_stage_output}" "`cat ${STD_OUT}`"
  assertContains "BUILD SUCCESSFUL" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"
}


testCompile_Fail()
{
  expected_stage_output="STAGING:${RANDOM}"
  
  cat > ${BUILD_DIR}/build.gradle <<EOF
task stage {
  throw new GradleException("${expected_stage_output}")
}
EOF

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 1 ${rtrn}
  assertContains "Cause: ${expected_stage_output}" "`cat ${STD_OUT}`"
  assertContains "BUILD FAILED" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"

}


testCompile_Wrapper()
{
  touch ${BUILD_DIR}/build.gradle

  cat > ${BUILD_DIR}/gradlew <<EOF
#!/bin/sh
EOF
  chmod +x ${BUILD_DIR}/gradlew

  expected_gradlew_output=`cat <<EOF
-----> executing ./gradlew stage
EOF`

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 ${rtrn}
  assertEquals "${expected_gradlew_output}" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"
}
