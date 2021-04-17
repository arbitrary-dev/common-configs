#!/bin/sh

echo "Stowing Zsh..."
stow --target $HOME zsh-user
sudo stow --target / zsh-root
if ! grep -q zshrc.d /etc/zsh/zshrc; then
  sudo sh -c \
    'printf "\nfor f in /etc/zsh/zshrc.d/*; do . \$f; done\n" >> /etc/zsh/zshrc'
fi
echo "Done!"

printf "\nStowing Vim...\n"
sudo stow --target /etc/vim vim-root
echo "Done!"
