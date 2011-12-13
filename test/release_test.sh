#!/bin/sh

. lib/test_utils.sh

testRelease()
{
  read -d '' expected_release_output <<EOF
---
config_vars:
  JAVA_OPTS: -Xmx384m -Xss512k -XX:+UseCompressedOops


EOF

  capture ${BUILDPACK_HOME}/bin/release ${BUILD_DIR}
  assertEquals 0 ${rtrn}
  assertEquals "${expected_release_output}" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"
}
