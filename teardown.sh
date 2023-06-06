##!/usr/bin/env bash

# Stop the containers
docker stop dev-container-prady
# Remove the containers
docker rm dev-container-prady
# Remove the image
docker rmi dev-container-prady

# stop kind cluster
kind delete cluster --name prady

