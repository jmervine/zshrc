from jmervine/vimrc:latest

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
  curl -sL https://deb.nodesource.com/setup | bash - && \
  apt-get install -y nodejs && \
  apt-get autoremove -y && \
  apt-get purge && \
  rm -rf /var/lib/apt/lists/*

copy . /root/.dotfiles
run  cd /root/.dotfiles; make install HOME=/root

volume /root/.ssh

workdir /root
entrypoint /usr/bin/zsh
