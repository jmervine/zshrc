CWD=$(shell pwd)

# Test install target below.
test:
	#  RUN
	mkdir test
	make install HOME=$(CWD)/test
	#  VALIDATE
	test -L $(CWD)/test/.dotfiles
	test -L $(CWD)/test/.zshrc
	test -L $(CWD)/test/.gitconfig
	test -L $(CWD)/test/.gitignore
	test -L $(CWD)/test/.xmodmap
	test -L $(CWD)/test/.tmux.conf

clean:
	make uninstall HOME=$(CWD)/test
	rm -r test

install:
	make $(HOME)/.dotfiles
	make $(HOME)/.zshrc
	make $(HOME)/.gitconfig
	make $(HOME)/.gitignore
	make $(HOME)/.xmodmap
	make $(HOME)/.tmux.conf

uninstall:
	rm -vf $(HOME)/.dotfiles
	rm -vf $(HOME)/.zshrc
	rm -vf $(HOME)/.gitconfig
	rm -vf $(HOME)/.gitignore
	rm -vf $(HOME)/.xmodmap
	rm -vf $(HOME)/.tmux.conf

$(HOME)/.dotfiles:
	ln -s $(CWD) $(HOME)/.dotfiles

$(HOME)/.zshrc:
	ln -s $(CWD)/_zshrc $(HOME)/.zshrc

$(HOME)/.gitconfig:
	ln -s $(CWD)/_gitconfig $(HOME)/.gitconfig

$(HOME)/.gitignore:
	ln -s $(CWD)/_gitignore $(HOME)/.gitignore

$(HOME)/.xmodmap:
	ln -s $(CWD)/_xmodmap $(HOME)/.xmodmap

ifeq "$(shell uname)" "Darwin"
$(HOME)/.tmux.conf: reattach-to-user-namespace
	ln -s $(CWD)/_tmux.conf $(HOME)/.tmux.conf

reattach-to-user-namespace:
	@# be slick
	which reattach-to-user-namespace || \
		if which port; then sudo port install tmux-pasteboard; else brew install reattach-to-user-namespace; fi
else
$(HOME)/.tmux.conf:
	ln -s $(CWD)/_tmux.conf $(HOME)/.tmux.conf
endif
