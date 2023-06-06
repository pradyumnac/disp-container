##!/usr/bin/env bash

# get user name
USERNAME=$(whoami)

# Stop the containers
docker stop dev-container-$USERNAME
# Remove the containers
docker rm dev-container-$USERNAME
# Remove the image
docker rmi img-$USERNAME

# stop kind cluster
# kind delete cluster --name dev
