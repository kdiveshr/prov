#!/bin/bash

if [ "$CI_COMMIT_TAG" != "" ];
then
  export DOCKER_TAG="$CI_COMMIT_SHORT_SHA-$(date +%s)-$CI_COMMIT_TAG"
else
  export DOCKER_TAG="SNAPSHOT-$CI_COMMIT_SHORT_SHA-$(date +%s)"
fi