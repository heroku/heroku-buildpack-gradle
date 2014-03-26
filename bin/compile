#!/usr/bin/env bash
# bin/compile <build-dir> <cache-dir> <env-dir>

# fail fast
set -e

BIN_DIR=$(cd $(dirname $0); pwd) # absolute path
OPT_DIR=$(cd $BIN_DIR/../opt; pwd) 

# parse args
BUILD_DIR=$1
CACHE_DIR=$2
ENV_DIR=$3

GRADLE_DIST="gradle-1.0-milestone-5"
GRADLE_TASK="stage"

curl --silent --location http://heroku-jvm-common.s3.amazonaws.com/jvm-buildpack-common.tar.gz | tar xz
. bin/util
. bin/java

export_env_dir $ENV_DIR

# create default system.properties 
if [ ! -f ${BUILD_DIR}/system.properties ]; then
  echo "java.runtime.version=1.6" > ${BUILD_DIR}/system.properties
fi

# install JDK 
javaVersion=$(detect_java_version ${BUILD_DIR})
echo -n "-----> Installing OpenJDK ${javaVersion}... "
install_java ${BUILD_DIR} ${javaVersion}
jdk_overlay ${BUILD_DIR}
echo "done"

if [ ! -d $CACHE_DIR ] ; then
  mkdir $CACHE_DIR
fi

export GRADLE_USER_HOME=$CACHE_DIR

if [ -f $BUILD_DIR/gradlew ] ; then
  BUILDCMD="./gradlew"
  chmod +x ${BUILD_DIR}/gradlew
else
  if [ ! -d $CACHE_DIR/$GRADLE_DIST ] ; then
    cd $CACHE_DIR
    GRADLE_URL="http://heroku-jvm-buildpack-gradle.s3.amazonaws.com/$GRADLE_DIST.tar.gz"
    echo -n "-----> Installing $GRADLE_DIST....."
    curl --silent --location $GRADLE_URL | tar xz
    echo " done"
  fi
  BUILDCMD="gradle -I $OPT_DIR/init.gradle"
fi

BUILDCMD="$BUILDCMD $GRADLE_TASK"

cd $BUILD_DIR

export PATH=$CACHE_DIR/$GRADLE_DIST/bin:$PATH
 
# build app
echo "-----> Building Gradle app..."
echo "       WARNING: The Gradle buildpack is currently in Beta."
echo "-----> executing $BUILDCMD"

$BUILDCMD 2>&1 | sed -u 's/^/       /'

if [ "${PIPESTATUS[*]}" != "0 0" ]; then
  echo " !     Failed to build app"
  exit 1
fi

PROFILE_PATH="$BUILD_DIR/.profile.d/gradle.sh"
mkdir -p $(dirname $PROFILE_PATH)
echo 'export PATH="/app/.jdk/bin:$PATH"' >> $PROFILE_PATH
