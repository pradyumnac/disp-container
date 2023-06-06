##!/usr/bin/env bash

# Install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-darwin-arm64 && chmod +x ./kind-darwin-arm64 && sudo mv ./kind-darwin-arm64 ~/.local/bin/kind

# Build disposable dev container(Docker)
docker build -t dev-container-prady -f Dockerfile .

# Login to disposable dev container(Docker)
docker run -it --rm -v $(pwd):/repos dev-container-prady bash
