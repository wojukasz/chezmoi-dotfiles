#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

# https://github.com/ibraheemdev/modern-unix
sudo apt install git jq direnv ranger fzf fonts-hack-ttf keepassxc -y

# tmux: https://github.com/tmux/tmux/wiki/Installing
sudo apt install tmux -y
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# Tmux post install:
# prefix + I (capital i, as in Install) to fetch the plugin.
# prefix + U  updates plugin(s)


# only on ubuntu otherwise nvim
sudo apt install software-properties-common -y
# https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update -y
sudo apt upgrade -y
sudo apt install neovim -y

# required by vim plugins
sudo apt install sqlite3 libsqlite3-dev python3-pip python3-venv luajit lua5.1 lua-mpack -y
pip3 install neovim
pip3 install pyvim
pip3 install ranger

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update -y
sudo apt install gh -y

sudo add-apt-repository universe
sudo apt update -y
sudo apt upgrade -y
sudo apt install python2 python2-dev -y
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
pip2 install neovim

# Go
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update -y
sudo apt install golang-go -y

go get github.com/cheat/cheat/cmd/cheat
go install github.com/twpayne/chezmoi@latest
/home/wojukasz/go/bin/chezmoi init --apply --verbose git@github.com:wojukasz/chezmoi-dotfiles.git

# ZSH as default shell
sudo apt install zsh -y
chsh -s $(which zsh)
/usr/bin/zsh

# Clean up
sudo apt autoremove -y
