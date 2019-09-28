#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh
. ${BUILDPACK_HOME}/lib/common.sh

test_is_spring_boot_plugin() {
  cat > ${BUILD_DIR}/build.gradle <<EOF
plugins {
	id 'org.springframework.boot' version '2.1.8.RELEASE'
}
EOF
  capture is_spring_boot ${BUILD_DIR}
  assertCapturedSuccess
}

