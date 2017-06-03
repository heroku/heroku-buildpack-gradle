#!/usr/bin/env bash

export BUILDPACK_STDLIB_URL="https://lang-common.s3.amazonaws.com/buildpack-stdlib/v7/stdlib.sh"

has_stage_task() {
  local buildDir=${1}
   test -f ${buildDir}/build.gradle &&
     test -n "$(grep "^ *task *stage" ${buildDir}/build.gradle)"
}

is_spring_boot() {
  local buildDir=${1}
   test -f ${buildDir}/build.gradle &&
     test -n "$(grep "^[^/].*org.springframework.boot:spring-boot" ${buildDir}/build.gradle)" &&
     test -z "$(grep "org.grails:grails-" ${buildDir}/build.gradle)"
}

is_ratpack() {
  local buildDir=${1}
  test -f ${buildDir}/build.gradle &&
    test -n "$(grep "^[^/].*io.ratpack.ratpack" ${buildDir}/build.gradle)"
}

is_grails() {
  local buildDir=${1}
   test -f ${buildDir}/build.gradle &&
     test -n "$(grep "^[^/].*org.grails:grails-" ${buildDir}/build.gradle)"
}

is_webapp_runner() {
  local buildDir=${1}
  test -f ${buildDir}/build.gradle &&
    test -n "$(grep "^[^/].*io.ratpack.ratpack" ${buildDir}/build.gradle)"
}

create_build_log_file() {
  local buildLogFile=".heroku/gradle-build.log"
  echo "" > $buildLogFile
  echo "$buildLogFile"
}

# sed -l basically makes sed replace and buffer through stdin to stdout
# so you get updates while the command runs and dont wait for the end
# e.g. sbt stage | indent
output() {
  local logfile="$1"
  local c='s/^/       /'

  case $(uname) in
    Darwin) tee -a "$logfile" | sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      tee -a "$logfile" | sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

cache_copy() {
  rel_dir=$1
  from_dir=$2
  to_dir=$3
  rm -rf $to_dir/$rel_dir
  if [ -d $from_dir/$rel_dir ]; then
    mkdir -p $to_dir/$rel_dir
    cp -pr $from_dir/$rel_dir/. $to_dir/$rel_dir
  fi
}

install_jdk() {
  local install_dir=${1}

  let start=$(nowms)
  JVM_COMMON_BUILDPACK=${JVM_COMMON_BUILDPACK:-https://codon-buildpacks.s3.amazonaws.com/buildpacks/heroku/jvm-common.tgz}
  mkdir -p /tmp/jvm-common
  curl --retry 3 --silent --location $JVM_COMMON_BUILDPACK | tar xzm -C /tmp/jvm-common --strip-components=1
  source /tmp/jvm-common/bin/util
  source /tmp/jvm-common/bin/java
  source /tmp/jvm-common/opt/jdbc.sh
  mtime "jvm-common.install.time" "${start}"

  let start=$(nowms)
  install_java_with_overlay ${install_dir}
  mtime "jvm.install.time" "${start}"
}
