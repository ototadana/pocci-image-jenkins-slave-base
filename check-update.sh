#!/bin/bash

cd `dirname $0`

curl https://gist.githubusercontent.com/ototadana/d14847290ce41354c0a7/raw/get-newest-version-of-apt-package > checkupdate.tmp
IMAGE=`docker images |grep workspace-base | awk '{printf "%s:%s",$1,$2}'`
docker run --rm -it -e PACKAGES="firefox gitlab-ci-multi-runner google-chrome-stable" -v ${PWD}:/app ${IMAGE} sudo -E bash /app/checkupdate.tmp
