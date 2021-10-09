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

echo "Stowing Zsh..."
stow --target $HOME zsh-user
sudo stow --target / zsh-root
if ! grep -q zshrc.d /etc/zsh/zshrc; then
  sudo sh -c \
    'printf "\nfor f in /etc/zsh/zshrc.d/*; do . \$f; done\n" >> /etc/zsh/zshrc'
fi
if find -name .zshrc -execdir mv {} dot-zshrc \; -print0 | grep -qz .; then
  # Fixes bug #XXX in Stow
  echo "Renamed .zshrc's to dot-zshrc's"
fi
echo "Done!"

echo
echo "Stowing Vim..."
stow --target $HOME/.vim vim-user
sudo stow --target /etc/vim vim-root
echo "Done!"

echo
echo "Stowing Git..."
sudo stow --target /etc git-root
echo "Done!"
