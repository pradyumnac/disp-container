from alpine:3.16

RUN export KUBE_EDITOR="nvim"
RUN mkdir -p /root/.config

# install utils & kubectl
RUN apk add --no-cache curl neovim bash git openssl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl

# Install helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

WORKDIR /repo




