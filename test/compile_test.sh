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
  assertCaptured "Installing OpenJDK 1.6" 
  assertCaptured "Installing gradle-1.11"
  assertCaptured "${expected_stage_output}" 
  assertCaptured "BUILD SUCCESSFUL"
  assertTrue "Java should be present in runtime." "[ -d ${BUILD_DIR}/.jdk ]"
  assertTrue "Java version file should be present." "[ -f ${BUILD_DIR}/.jdk/version ]"
  assertTrue "System properties file should be present in build dir." "[ -f ${BUILD_DIR}/system.properties ]" 
  assertTrue "Gradle profile.d file should be present in build dir." "[ -f ${BUILD_DIR}/.profile.d/gradle.sh ]" 
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

  assertCapturedError "A problem occurred evaluating root project"
  assertCapturedError "${expected_stage_output}"
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
