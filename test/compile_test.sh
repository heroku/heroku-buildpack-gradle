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

  compile
  
  assertCapturedSuccess
  assertCaptured "Installing gradle-1.0-milestone-5" 
  assertCaptured "${expected_stage_output}" 
  assertCaptured "BUILD SUCCESSFUL" 
}


testCompile_Fail()
{
  expected_stage_output="STAGING:${RANDOM}"
  
  cat > ${BUILD_DIR}/build.gradle <<EOF
task stage {
  throw new GradleException("${expected_stage_output}")
}
EOF

  compile
  
  assertCapturedError "Cause: ${expected_stage_output}"
  assertCapturedError "BUILD FAILED"
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

  compile
  
  assertCapturedSuccess
  assertCaptured "${expected_gradlew_output}" 
}
