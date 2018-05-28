#!/usr/bin/env bash

export BUILDPACK_STDLIB_URL="https://lang-common.s3.amazonaws.com/buildpack-stdlib/v7/stdlib.sh"

gradle_build_file() {
  local buildDir=${1}
  if [ -f ${buildDir}/build.gradle.kts ]; then
    echo "${buildDir}/build.gradle.kts"
  else
    echo "${buildDir}/build.gradle"
  fi
}

has_stage_task() {
  local gradleFile="$(gradle_build_file ${1})"
   test -f ${gradleFile} &&
     test -n "$(grep "^ *task *stage" ${gradleFile})"
}

is_spring_boot() {
  local gradleFile="$(gradle_build_file ${1})"
   test -f ${gradleFile} &&
     test -n "$(grep "^[^/].*org.springframework.boot:spring-boot" ${gradleFile})" &&
     test -z "$(grep "org.grails:grails-" ${gradleFile})"
}

is_ratpack() {
  local gradleFile="$(gradle_build_file ${1})"
  test -f ${gradleFile} &&
    test -n "$(grep "^[^/].*io.ratpack.ratpack" ${gradleFile})"
}

is_grails() {
  local gradleFile="$(gradle_build_file ${1})"
   test -f ${gradleFile} &&
     test -n "$(grep "^[^/].*org.grails:grails-" ${gradleFile})"
}

is_webapp_runner() {
  local gradleFile="$(gradle_build_file ${1})"
  test -f ${gradleFile} &&
    test -n "$(grep "^[^/].*io.ratpack.ratpack" ${gradleFile})"
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
  JVM_COMMON_BUILDPACK=${JVM_COMMON_BUILDPACK:-https://buildpack-registry.s3.amazonaws.com/buildpacks/heroku/jvm.tgz}
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
