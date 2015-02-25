# zshrc

```
# Install
##
git clone https://github.com/jmervine/zshrc.git ~/.dotfiles
cd ~/.dotfiles
make install

# Uninstall
##
cd ~/.dotfiles
make uninstall
```

## Docker

> NOTE:
>
> The docker image contains my full [vim configuration](https://github.com/jmervine/vimrc).


```
docker run --rm -it --net=host \
    -v /path/to/workspace:/root/workspace jmervine/zshrc:latest
```

