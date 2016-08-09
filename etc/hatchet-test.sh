#!/usr/bin/env bash

gem install rspec-retry -v 0.4.0
gem install heroku_hatchet -v 1.4.1

hatchet install &&
HATCHET_RETRIES=3 \
HATCHET_DEPLOY_STRATEGY=git \
HATCHET_BUILDPACK_BASE="https://github.com/heroku/heroku-buildpack-gradle.git" \
HATCHET_BUILDPACK_BRANCH=$(git name-rev HEAD 2> /dev/null | sed 's#HEAD\ \(.*\)#\1#') \
rspec $@
