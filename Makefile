CWD=$(shell pwd)

install:
	make $(HOME)/.dotfiles
	make $(HOME)/.zshrc
	make $(HOME)/.bashrc
	make $(HOME)/.gitconfig
	make $(HOME)/.gitignore
	make $(HOME)/.xmodmap
	make $(HOME)/.tmux.conf
	make thefuck

uninstall:
	-test -L $(HOME)/.dotfiles  && rm -vf $(HOME)/.dotfiles
	-test -L $(HOME)/.zshrc     && rm -vf $(HOME)/.zshrc
	-test -L $(HOME)/.bashrc    && rm -vf $(HOME)/.bashrc
	-test -L $(HOME)/.gitconfig && rm -vf $(HOME)/.gitconfig
	-test -L $(HOME)/.gitignore && rm -vf $(HOME)/.gitignore
	-test -L $(HOME)/.xmodmap   && rm -vf $(HOME)/.xmodmap
	-test -L $(HOME)/.tmux.conf && rm -vf $(HOME)/.tmux.conf

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

$(HOME)/.dotfiles:
	ln -s $(CWD) $(HOME)/.dotfiles

$(HOME)/.zshrc:
	ln -s $(CWD)/_zshrc $(HOME)/.zshrc

$(HOME)/.bashrc:
	ln -s $(CWD)/_bashrc $(HOME)/.bashrc

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

thefuck:
	# Installing 'thefuck'.
	# It requires sudo for pip install.
	-@which thefuck > /dev/null || \
		( which brew > /dev/null && brew install thefuck ) || \
		( which pip > /dev/null && sudo pip install thefuck ) || \
		echo "Requires either brew or pip to install 'thefuck'"

docker:
	docker build -t jmervine/zshrc:latest .
