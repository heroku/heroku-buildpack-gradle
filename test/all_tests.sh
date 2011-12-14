#!/bin/sh

for f in *_test.sh; do
  echo "Running ${f}"
  ${SHUNIT_HOME?"'SHUNIT_HOME' environment variable must be set"}/src/shunit2 ${f}
done

