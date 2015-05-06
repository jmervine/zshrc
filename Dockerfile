from jmervine/vimrc:latest

env NODE_VERSION=0.12.2

run \
  apt-get update && \
  apt-get install -y zsh \
                     sudo \
                     tmux \
                     openssh-client \
                     python \
                     python-dev \
                     python-pip \
                     curl && \
  apt-get autoremove -y && \
  apt-get purge && \
  rm -rf /var/lib/apt/lists/*

run \
  curl -s http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz | gunzip -c | tar -xf - -C /

env PATH /node-v${NODE_VERSION}-linux-x64/bin:$PATH

copy . /root/.zsh
run  cd /root/.zsh; make install HOME=/root

volume /root/.ssh

workdir /root
entrypoint /usr/bin/zsh
