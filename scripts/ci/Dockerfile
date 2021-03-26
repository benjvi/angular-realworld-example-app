FROM  --platform=$TARGETPLATFORM ubuntu
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y -qq update && \
    apt-get install -y -qq wget jq curl git gnupg software-properties-common && \
    apt-get clean

RUN wget "https://storage.googleapis.com/kubernetes-release/release/$(wget -O- https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && install kubectl /usr/local/bin/
RUN wget "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.8.8/kustomize_v3.8.8_linux_amd64.tar.gz" -O k.tar.gz && tar -xvzf k.tar.gz && install kustomize /usr/local/bin && rm k.tar.gz

RUN wget "https://github.com/vmware-tanzu/kpack-cli/releases/download/v0.2.0/kp-linux-0.2.0" -O kp && install kp /usr/local/bin && rm kp

