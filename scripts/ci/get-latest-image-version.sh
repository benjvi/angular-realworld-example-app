#!/bin/sh
IMG="$(kp image status angular-demo | grep | awk '{print $2}')"
echo "$IMG"
echo "$IMG" > img-version
