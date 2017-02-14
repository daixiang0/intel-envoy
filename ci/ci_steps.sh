#!/bin/bash

# Script that lists all the steps take by the CI system when doing Envoy builds.
set -e

# Lint travis file.
travis lint .travis.yml --skip-completion-check
# Do a build matrix with different types of builds docs, coverage, normal, etc.
docker run -t -i -v $TRAVIS_BUILD_DIR:/source lyft/envoy-build:4c887e005b129b28d815d59f9983b1ed3eb9568f /bin/bash -c "cd /source && ci/do_ci.sh $TEST_TYPE"

# The following scripts are only relevant on a `normal` run.
# This script build a lyft/envoy image an that image is pushed on merge to master.
./ci/docker_push.sh
# This script runs on every PRs normal run to test the docker examples.
./ci/verify_examples.sh
