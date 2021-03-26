#!/bin/bash

if [ "$( kp build status angular-demo | grep Status | awk '{print $2}')" == "SUCCESS" ]; then
  echo "TBS image build failed"
  exit 1
elif [ "$( kp build status angular-demo | grep Revision | awk '{print $2}')" != "$(git rev-parse HEAD)" ]; then
  echo "TBS image build is at a different version: $( kp build status angular-demo | grep Revision | awk '{print $2}'), current version is $(git rev-parse HEAD)"
  exit 1
fi
