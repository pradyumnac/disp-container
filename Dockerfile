from alpine:latest

# install curl & kubectl
RUN apk add --no-cache curl neovim
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN export KUBE_EDITOR="nvim"

RUN kubectl get nodes



