#!/bin/bash
#
# Loads provisioned docker image tarballs and starts containers.
#
set -e pipefail

# Just print some status
docker --version
docker info
docker images -a

for f in images/*.tar.gz
do
  echo "Loading $f image into docker"
  docker load < $f
  # List what we have now...
  docker images
  # extract service name - strip version and extension from filename
  name=`basename $f | sed -E s/-[a-f0-9\.]\+\.tar\.gz$//`
  # This script is defined in cloud-config.yaml
  service=/etc/systemd/system/docker-$name.service
  # Enable the service now that the docker image it will start is loaded into docker
  sudo systemctl enable $service
  rm $f
  echo "Done loading $f."
done
