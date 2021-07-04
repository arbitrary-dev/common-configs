#!/bin/sh

if ! which stow >/dev/null 2>&1; then
  echo "Stow not found! Please install it."
  exit 1
fi

echo "Stowing Zsh..."
stow --target $HOME zsh-user
sudo stow --target / zsh-root
if ! grep -q zshrc.d /etc/zsh/zshrc; then
  sudo sh -c \
    'printf "\nfor f in /etc/zsh/zshrc.d/*; do . \$f; done\n" >> /etc/zsh/zshrc'
fi
echo "Done!"

echo
echo "Stowing Vim..."
stow --target $HOME/.vim vim-user
sudo stow --target /etc/vim vim-root
echo "Done!"
