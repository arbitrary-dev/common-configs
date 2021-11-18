#!/bin/sh

if ! which stow >/dev/null 2>&1; then
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

echo
echo "Stowing $HOME..."
mkdir -p $HOME/.vim
stow --target $HOME user
echo "Done!"

# Fixes bug #XXX in Stow
if find -name .zshrc -execdir mv {} dot-zshrc \; -print0 | grep -qz .; then
  echo
  echo "Renamed .zshrc's to dot-zshrc's"
fi
