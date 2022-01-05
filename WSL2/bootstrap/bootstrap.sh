#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

# general packages
sudo apt install git jq -y
sudo apt install keepassxc -y
# https://github.com/ibraheemdev/modern-unix
sudo apt install exa
sudp apt install ranger
# tmux: https://github.com/tmux/tmux/wiki/Installing
sudo apt install tmux -y
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# required by vim plugins
sudo apt-get install sqlite3 libsqlite3-dev
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Tmux post install:
# prefix + I (capital i, as in Install) to fetch the plugin.
# prefix + U  updates plugin(s)


# required for nvim
sudo apt install python3-venv python3-pip

# only on ubuntu otherwise
# nvim
#sudo apt-get install software-properties-common -y
# https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable
#sudo add-apt-repository ppa:neovim-ppa/unstable -y
#sudo apt-get install python-dev python3-dev python3-pip -y
#sudo apt install neovim lua-mpack -y
#
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim

# Go
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update -y
sudo apt install golang-go -y

go get github.com/cheat/cheat/cmd/cheat
# go install github.com/twpayne/chezmoi@latest
wget https://github.com/twpayne/chezmoi/releases/download/v2.1.5/chezmoi_2.1.5_linux_amd64.deb
sudo dpkg -i chezmoi_2.1.5_linux_amd64.deb

# required by dotfiles
sudo apt install direnv fzf -y

# install fonts
sudo apt install fonts-hack-ttf

# chezmoi dotfiles
/usr/bin/chezmoi init --apply --verbose git@github.com:wojukasz/chezmoi-dotfiles.git
#sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply wojukasz

# keybase: https://keybase.io/docs/the_app/install_linux
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install ./keybase_amd64.deb
run_keybase

# Powerline configs

# ZSH as default shell
sudo apt install zsh -y
sudo su
chsh -s $(which zsh)
chsh -s $(which zsh) wojukasz

# Clean up
sudo apt autoremove -y

# key for signing git commits

# ZSH
# if distro == ubuntu,debian do
# sudo apt install lua-nvim-dev


#fonts https://github.com/ryanoasis/nerd-fonts
#git clone git@github.com:ryanoasis/nerd-fonts.git
#cd nerd-fonts
#./install Hack

# PIP packages
# aws-parallelcluster (2.6.1)
# boto3 (1.17.112)
# botocore (1.20.112)
# neovim (0.2.0)
# ranger (1.8.1)



# WORK
# if hostname == "GEL-*" then

# sudo apt install docker.io -y

# AWS cli

# https://github.com/antonbabenko/pre-commit-terraform#ubuntu-1804

#sudo apt update -y
#sudo apt install -y gawk unzip software-properties-common
#sudo add-apt-repository ppa:deadsnakes/ppa -y
#sudo apt install -y python3.7 python3-pip
#pip3 install pre-commit

#curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64.tar.gz")" > terraform-docs.tgz && tar xzf terraform-docs.tgz && chmod +x terraform-docs && sudo mv terraform-docs /usr/bin/

#curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip && sudo mv tflint /usr/bin/

#curl -L "$(curl -s https://api.github.com/repos/tfsec/tfsec/releases/latest | grep -o -E "https://.+?tfsec-linux-amd64")" > tfsec && chmod +x tfsec && sudo mv tfsec /usr/bin/

#curl -L "$(curl -s https://api.github.com/repos/accurics/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz && tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz && sudo mv terrascan /usr/bin/

#python3.7 -m pip install -U checkov


# https://github.com/bridgecrewio/AirIAM
#pip3 install airiam

# install fonts on chromeos
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#chromechromeos
curl -fLo "Ubuntu Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Ubuntu/Regular/complete/Ubuntu%20Nerd%20Font%20Complete.ttf
