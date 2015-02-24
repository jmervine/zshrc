from jmervine/vimrc:latest

run \
  apt-get update && \
  apt-get install -y zsh \
                     tmux \
                     openssh-client

copy . /root/.dotfiles
run  cd /root/.dotfiles; make install HOME=/root

volume /root/.ssh

workdir /root
entrypoint /usr/bin/zsh
