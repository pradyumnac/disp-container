#!/usr/bin/env bash

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
          [ $(uname -m) = arm64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-darwin-arm64 && chmod +x ./kind-darwin-arm64 && sudo mv ./kind-darwin-arm64 ~/.local/bin/kind

          # For Intel Macs
          [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-darwin-amd64 && chmod +x ./kind-darwin-amd64 && sudo mv ./kind-darwin-amd64 ~/.local/bin/kind
          ;;
      "Linux")
          echo "Linux Installation for kind $KIND_VERSION"
          # For AMD64 / x86_64
          [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64 && chmod +x ./kind-linux-amd64 && sudo mv ./kind-linux-amd64 ~/.local/bin/kind
          # For ARM64
          [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-arm64 && chmod +x ./kind-linux-arm64 && sudo mv ./kind-linux-arm64 ~/.local/bin/kind
          ;;
      *)
          echo "Unsupported OS"
          exit 1
          ;;
  esac
fi

# Start kind cluster
kind create cluster --name dev --image kindest/node:v1.27.2

# Build disposable dev container(Docker)
docker build -t dev-container-$USERNAME -f Dockerfile .

# Login to disposable dev container(Docker)
docker run -it --rm -v $(pwd):/repos dev-container-$USERNAME bash
