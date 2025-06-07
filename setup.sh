#!/bin/sh

set -e

if ! command -v stow >/dev/null 2>&1; then
	echo "Stow not found! Please install it."
	exit 1
fi

if [ "$HOME" = "/root" ]; then
	echo "Please run as ordinary user!"
	exit 1
fi

if [ "`dirname $0`" != "." ]; then
	echo "Should be run as ./`basename $0`"
	exit 1
fi

echo "Stowing $HOME..."
mkdir -p $HOME/.vim
mkdir -p $HOME/.gnupg
stow --target $HOME user
echo "Done!"
echo

[ -z "${HOME##*com.termux*}" ] && TERMUX=1
if [ -n "$TERMUX" ]; then
	echo "I see you use Termux, nerd!"
	echo

	echo "Stowing zshrc.d/ ..."
	mkdir -p $HOME/.zshrc.d
	stow --target $HOME/.zshrc.d --dir etc/zsh zshrc.d
	if [ ! -f $HOME/.zshenv ] || ! grep -q ZSHRC_D $HOME/.zshenv; then
		echo "export ZSHRC_D=$HOME/.zshrc.d" >> $HOME/.zshenv
	fi
	echo "Done!"
	echo

	echo "Stowing vimrc.local ..."
	stow --target $HOME/.vim --dir etc vim
	echo "Done!"
	echo

	echo "Stowing .gitconfig ..."
	if [ -f $HOME/.gitconfig ]; then
		if [ ! -L $HOME/.gitconfig ]; then
			mv -v $HOME/.gitconfig etc/gitconfig
			ln -sv $PWD/etc/gitconfig $HOME/.gitconfig
		fi
	else
		ln -sv $PWD/etc/gitconfig $HOME/.gitconfig
	fi
	echo "Done!"
	echo

	echo "Stowing .termux/ ..."
	mkdir -p $HOME/.termux
	stow --target $HOME/.termux termux
	echo "Done!"
	echo
else
	echo "Stowing /etc..."
	sudo stow --target /etc etc
	if ! grep -q zshrc.d /etc/zsh/zshrc; then
		sudo sh -c \
			'printf "\nfor f in /etc/zsh/zshrc.d/*; do . \$f; done\n" >> /etc/zsh/zshrc'
	fi
	echo "Done!"
	echo

	echo
	echo "Stowing /root..."
	sudo stow --target /root root
	echo "Done!"
	echo
fi

# Fixes bug #XXX in Stow
if find -name .zshrc -execdir mv {} dot-zshrc \; -print0 | grep -qz .; then
	echo "Renamed .zshrc's to dot-zshrc's"
fi
