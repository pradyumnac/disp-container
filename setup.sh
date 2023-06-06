#!/usr/bin/env bash

set -e

KIND_VERSION=0.19.0
USERNAME=$(whoami)

# Install Kind if not installed
if ! command -v kind &> /dev/null
then
  echo "Installing Kind"
  # Check linux architecture
  ARCH=$(uname)

  case $ARCH in
      "Darwin")
          echo "MacOS"
          # for m1 chip
          [ $(uname -m) = arm64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-darwin-arm64 && chmod +x ./kind-darwin-arm64 && sudo mv ./kind-darwin-arm64 /usr/local/bin/kind

          # For Intel Macs
          [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-darwin-amd64 && chmod +x ./kind-darwin-amd64 && sudo mv ./kind-darwin-amd64 /usr/local/bin/kind
          ;;
      "Linux")
          echo "Linux Installation for kind $KIND_VERSION"
          # For AMD64 / x86_64
          [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64 && chmod +x ./kind-linux-amd64 && sudo mv ./kind-linux-amd64 /usr/local/bin/kind
          # For ARM64
          [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-arm64 && chmod +x ./kind-linux-arm64 && sudo mv ./kind-linux-arm64 /usr/local/bin/kind
          ;;
      *)
          echo "Unsupported OS"
          exit 1
          ;;
  esac
fi

# Start kind cluster if not exist
if ! kind get clusters | grep -w dev &> /dev/null
then
  kind create cluster --name dev --image kindest/node:v1.27.2
else
  echo "Kind Cluster already exists"
fi

# Build disposable dev container(Docker) if not exists
if ! docker images | grep -w img-$USERNAME &> /dev/null
then
  echo "Building disposable dev container(Docker)"
  docker build -t img-$USERNAME -f Dockerfile .
else
  echo "Disposable dev container(Docker) already exists"
fi

# Login to disposable dev container(Docker)
docker run -it --rm -v "${HOME}:/root/" -v "${PWD}:/work" -w /work --net host --name dev-container-$USERNAME img-$USERNAME bash
