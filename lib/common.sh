#!/usr/bin/env bash

export_env_dir() {
  env_dir=$1
  whitelist_regex=${2:-''}
  blacklist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH|JAVA_OPTS)$'}
  if [ -d "$env_dir" ]; then
    for e in $(ls $env_dir); do
      echo "$e" | grep -E "$whitelist_regex" | grep -qvE "$blacklist_regex" &&
      export "$e=$(cat $env_dir/$e)"
      :
    done
  fi
}

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
