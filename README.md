# zshrc

> NOTE:
>
> Includes my full [vim configuration](https://github.com/jmervine/vimrc).

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

```
docker run --rm -it --net=host \
    -v /path/to/workspace:/root/workspace jmervine/zshrc:latest
```

