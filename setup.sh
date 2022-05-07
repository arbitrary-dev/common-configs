#!/bin/sh

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

echo
echo "Stowing $HOME..."
mkdir -p $HOME/.vim
stow --target $HOME user
echo "Done!"

if [ -n "$TERMUX_VERSION" ]; then
  echo "Stowing zshrc.d/ ..."
  mkdir -p $HOME/.zshrc.d
  stow --target $HOME/.zshrc.d --dir etc/zsh zshrc.d
  if [ ! -f $HOME/.zshenv ] || ! grep -q ZSHRC_D $HOME/.zshenv; then
    echo "export ZSHRC_D=$HOME/.zshrc.d" >> $HOME/.zshenv
  fi
  echo "Done!"

  echo "Stowing vimrc.local ..."
  stow --target $HOME/.vim --dir etc vim
  echo "Done!"

  echo "Stowing .gitconfig ..."
  [ -f $HOME/.gitconfig ] && mv $HOME/.gitconfig etc/gitconfig
  rm -rf $HOME/.gitconfig
  ln -sv $PWD/etc/gitconfig $HOME/.gitconfig
  echo "Done!"

  echo "Stowing .termux/ ..."
  mkdir -p $HOME/.termux
  stow --target $HOME/.termux termux
  echo "Done!"
else
  echo "Stowing /etc..."
  sudo stow --target /etc etc
  if ! grep -q zshrc.d /etc/zsh/zshrc; then
    sudo sh -c \
      'printf "\nfor f in /etc/zsh/zshrc.d/*; do . \$f; done\n" >> /etc/zsh/zshrc'
  fi
  echo "Done!"

  echo
  echo "Stowing /root..."
  sudo stow --target /root root
  echo "Done!"
fi

# Fixes bug #XXX in Stow
if find -name .zshrc -execdir mv {} dot-zshrc \; -print0 | grep -qz .; then
  echo
  echo "Renamed .zshrc's to dot-zshrc's"
fi
