#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

WRAPPER_DIR=${BUILDPACK_HOME}/opt/wrapper

installWrapper() {
  cp -r "$WRAPPER_DIR"/* ${BUILD_DIR}
}

requestOpenJdk8() {
  cat > ${BUILD_DIR}/system.properties <<EOF
java.runtime.version=8
EOF
}

testCompileWithoutWrapper()
{
  requestOpenJdk8
  cat > ${BUILD_DIR}/build.gradle <<EOF
task stage << {
  println "${expected_stage_output}"
}
EOF

  compile
  assertCapturedSuccess
  assertCaptured "Installing Gradle Wrapper"
}

testCompileWithWrapper()
{
  requestOpenJdk8
  installWrapper
  expected_stage_output="STAGING:${RANDOM}"

  cat > ${BUILD_DIR}/build.gradle <<EOF
task stage << {
  println "${expected_stage_output}"
}
EOF

  compile
  assertCapturedSuccess
  assertCaptured "Installing Azul Zulu OpenJDK 1.8"
  assertCaptured "${expected_stage_output}"
  assertCaptured "BUILD SUCCESSFUL"
  assertTrue "Java should be present in runtime." "[ -d ${BUILD_DIR}/.jdk ]"
  assertTrue "Gradle profile.d file should be present in build dir." "[ -f ${BUILD_DIR}/.profile.d/jvmcommon.sh ]"
  assertTrue "GRADLE_USER_HOME should be CACHE_DIR/.gradle." "[ -d ${CACHE_DIR}/.gradle ]"
}

testCompileWithCustomTask()
{
  requestOpenJdk8
  installWrapper
  expected_stage_output="STAGING:${RANDOM}"

  cat > ${BUILD_DIR}/build.gradle <<EOF
task foo << {
  println "${expected_stage_output}"
}
EOF

  echo -n "foo" > ${ENV_DIR}/GRADLE_TASK
  compile

  assertCapturedSuccess
  assertCaptured "executing ./gradlew foo"
}

testCompile_Fail()
{
  requestOpenJdk8
  installWrapper
  expected_stage_output="STAGING:${RANDOM}"

  cat > ${BUILD_DIR}/build.gradle <<EOF
task stage << {
  throw new GradleException("${expected_stage_output}")
}
EOF

  compile
  assertCapturedError "${expected_stage_output}"
  assertCapturedError "BUILD FAILED"
}
