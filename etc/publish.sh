#!/bin/sh

if [ ! -z "$1" ]; then
  pushd . > /dev/null 2>&1
  cd /tmp &&
  git clone git@github.com:heroku/heroku-buildpack-gradle.git &&
  cd heroku-buildpack-gradle &&
  git checkout master &&
  find . ! -name '.' ! -name '..' ! -name 'bin' -maxdepth 1 -print0 | xargs -0 rm -rf -- &&
  heroku buildpacks:publish $1/gradle
  popd > /dev/null 2>&1
  echo "Cleaning up..."
  rm -rf /tmp/heroku-buildpack-gradle
  echo "Done."
else
  echo "You must provide a buildkit organization as an argument!"
  exit 1
fi
