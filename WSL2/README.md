# Source: https://gist.github.com/wojukasz/c44d5134c6383cb5dfe668aa85bc4325  

# Install WSL2 and Ubuntu

First run: [WSL2 Setup](https://github.com/OnkelDom/wsl2i)

Windows Tutorial: [Install WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10) (if needed)

# Install PowerShell 7
```
# You need administrator grants on normal PowerShell terminal
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
```

# Install SourceCodePro font
```
# You need administrator grants on normal PowerShell terminal
Invoke-WebRequest -Uri "https://fonts.google.com/download?family=Source%20Code%20Pro" -Outfile ~\source_code_pro.zip
Expand-Archive -Path ~\source_code_pro.zip -DestinationPath C:\Windows\Fonts
Remove-Item C:\Windows\Fonts\OFL.txt -Force
Remove-Item ~\source_code_pro.zip -Force
```

# Install BICEP in PowerShell7 Terminal
```
# Create the install folder
$installPath = "$env:USERPROFILE\.bicep"
$installDir = New-Item -ItemType Directory -Path $installPath -Force
$installDir.Attributes += 'Hidden'
# Fetch the latest Bicep CLI binary
(New-Object Net.WebClient).DownloadFile("https://github.com/Azure/bicep/releases/latest/download/bicep-win-x64.exe", "$installPath\bicep.exe")
# Add bicep to your PATH
$currentPath = (Get-Item -path "HKCU:\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
if (-not $currentPath.Contains("%USERPROFILE%\.bicep")) { setx PATH ($currentPath + ";%USERPROFILE%\.bicep") }
if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }
# Verify you can now access the 'bicep' command.
bicep --help
```

# Install PowerLine in PowerShell7 Terminal
```
# Setup for Native PowerShell on Windows
# Create the install folder
$installPath = "$env:USERPROFILE\.powerline-go"
$installDir = New-Item -ItemType Directory -Path $installPath -Force
$installDir.Attributes += 'Hidden'
 
# Fetch the Powerline-GO binary
(New-Object Net.WebClient).DownloadFile("https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-windows-amd64", "$installPath\powerline-go.exe")
# Add Powerline-Go to your PATH
$currentPath = (Get-Item -path "HKCU:\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
if (-not $currentPath.Contains("%USERPROFILE%\.powerline-go")) { setx PATH ($currentPath + ";%USERPROFILE%\.powerline-go") }
if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }
 
# Create Profile for current User
if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}
 
# Add Powerline Prompt to Profile
Add-Content -path $PROFILE -force @'
# Load powerline-go prompt
function global:prompt {
    $pwd = $ExecutionContext.SessionState.Path.CurrentLocation
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powerline-go"
    $startInfo.Arguments = "-shell bare"
    $startInfo.Environment["TERM"] = "xterm-256color"
    $startInfo.CreateNoWindow = $true
    $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $startInfo.RedirectStandardOutput = $true
    $startInfo.UseShellExecute = $false
    $startInfo.WorkingDirectory = $pwd
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $standardOut = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    $standardOut
}
'@
```

# Install PowerShell Modules in PowerShell7 Terminal
```
# Azure Ressources
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Install-Module AzureAD -Scope CurrentUser -Verbose
Install-Module Az.Resourcegraph -Scope CurrentUser
# Microsoft Store Objects
Import-Module Appx -Scope CurrentUser -UseWindowsPowerShell
```

# Install Windows Terminal
```
$releases = "https://api.github.com/repos/microsoft/terminal/releases/latest"
$url = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].assets.browser_download_url[0]
$filename = $url.Split("/")[-1]
Invoke-WebRequest -Uri $url -Out $filename
Add-AppxPackage -Path $filename
Remove-Item $filename -Force
```

# WSL2 config content

Edit %USERPROFILE%\.wslconfig in Windows to limit ressources
```
Add-Content -path $env:USERPROFILE\.wslconfig -force @"
[wsl2]
memory=8GB # limit memory in WSL2 to 4 GB
processors=4 # limit cpu cores to two
swap=0 # disable swap
"@
```

# Configure Windows Terminal

Open yout new Windows Terminal and with the downarrow button go to settings and edit the Ubuntu section. I have the following settings:
```json
{
  "guid": "blablabla",
  "hidden": false,
  "name": "Ubuntu",
  "colorScheme": "One Half Dark",
  "fontFace": "Source Code Pro for Powerline",
  "startingDirectory": "//wsl$/Ubuntu-20.04/home/onkeldom/",
  "fontSize": 11,
  "source": "Windows.Terminal.Wsl"
}
```

# Configure Ubuntu

### Set sudo without password
```bash
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/user_$USER > /dev/null
```

### Edit /etc/wsl.conf inside Ubuntu to improve performance
```bash
cat <<EOF | sudo tee /etc/wsl.conf
[automount]
enabled = true
options = "metadata"
mountFsTab = true
crossDistro = true
[interop]
enabled = false
appendWindowsPath = false
[network]
generateResolvConf = false
generateHosts = false
EOF
```

### Add SSH-Agent to add private key
```bash
cat <<EOF | sudo tee -a /etc/profile.d/ssh-agent.sh && sudo chmod a+x /etc/profile.d/ssh-agent.sh
# find ssh-agent
if [ -z "\$SSH_AUTH_SOCK" ]
then
  eval \$(ssh-agent) > /dev/null
  ssh-add -l > /dev/null || alias ssh='ssh-add -l > /dev/null || ssh-add && unalias ssh; ssh'
fi
EOF
```

### Install Powerline-Go
```bash
# Powerline-Go Anwendung runterladen
sudo curl -Lo /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64
# Powerline-Go Anwendung ausführbar machen
sudo chmod +x /usr/local/bin/powerline-go

# Prompt Shell file anlegen
$ cat <<EOF | sudo tee -a /etc/profile.d/powerline-prompt.sh && sudo chmod a+x /etc/profile.d/powerline-prompt.sh
# add powerline-go prompt
function _update_ps1() {
  PS1="$(/usr/local/bin/powerline-go -error $? -shell bash -hostname-only-if-ssh)"
}
if [ "$TERM" != "linux" ] && [ -f "/usr/local/bin/powerline-go" ]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
EOF

echo "source /etc/profile.d/powerline-prompt.sh" | tee -a ~/.bashrc 
```

### Install BICEP
```bash
# Download BICEP Binary
sudo curl -Lo /usr/local/bin/bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
# Set Execute Grants
sudo chmod +x /usr/local/bin/bicep
# Test bicep
bicep --help
```

### Install Aditional Repos
```bash
# Docker
wget -qO - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64 https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Azure CLI
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

# Microsoft (incl: Azure Function, MDATP, PowerShell)
echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/$(lsb_release -rs)/prod $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/microsoft-ubuntu-prod.list

# Terraform
curl -sL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/terraform.list

# Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# Helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible

# Golang
sudo add-apt-repository ppa:longsleep/golang-backports

sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io azure-cli software-properties-common terraform azure-functions-core-tools-3 powershell jq curl wget net-tools python3 python3-pip vim tmux whois telnet bzip2 nmap tcpdump strace rsync tig git pwgen screen dnsutils pastebinit ipcalc unrar-free tofrodos bash-completion apt-transport-https moreutils ansible software-properties-common kubectl helm golang-go
```

### Add PoweLine Prompt to PowerShell
```bash
# Start PowerShell
pwsh
# Create Profile for current User
if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}
# Add Powerline Prompt to Profile
Add-Content -path $PROFILE -force @"
# Load powerline-go prompt
function global:prompt {
    $pwd = $ExecutionContext.SessionState.Path.CurrentLocation
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powerline-go"
    $startInfo.Arguments = "-shell bare"
    $startInfo.Environment["TERM"] = "xterm-256color"
    $startInfo.CreateNoWindow = $true
    $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $startInfo.RedirectStandardOutput = $true
    $startInfo.UseShellExecute = $false
    $startInfo.WorkingDirectory = $pwd
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $standardOut = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    $standardOut
}
"@
```

## Add custom stuff

tmux multissh
```bash
$ cat <<EOF | tee -a ~/.ms.sh && chmod a+x ~/.ms.sh
#!/bin/bash
pane="$(tmux new-window -P -n "${*}" "ssh $1")"
pane1="$pane"
win="${pane/.*}"
tmux select-window -t "$win"
shift
c=1
while [ $# -gt 0 ]; do
    (( c++ ))
    pane=$(tmux split-window -P -t "$pane" -d "ssh $1")
    tmux select-layout -t "$win" tiled
    #tmux select-pane -t "$pane"
    shift
done
tmux set-window-option -t "$win" synchronize-panes
tmux select-layout -t "$win" tiled
tmux select-pane -t "$pane1"
EOF
```

tmux conf
```bash
$ cat <<EOF | tee -a ~/.tmux.conf
# last active window
bind-key C-a last-window

# Bind function keys to select windows
# -n means - no need to press ^B first.
bind 1 select-window -t 1
bind 2 select-window -t 2
bind 3 select-window -t 3
bind 4 select-window -t 4
bind 5 select-window -t 5
bind 6 select-window -t 6
bind 7 select-window -t 7
bind 8 select-window -t 8
bind 9 select-window -t 9
bind 0 select-window -t 10

# bind meta-cursor to select-pane
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R

# | and - for pane splitting
unbind % # Remove default binding since we�re replacing
bind | split-window -h
# of course this looses "delete buffer"
bind - split-window -v
# and synchronize (global input)
bind g set-window-option synchronize-panes

# open multi-ssh to somewhere (see my ms binary)
bind S command-prompt -p "Multi-SSH Target: " "split-window -d 'exec bash -c \"~/.ms.sh %1\"'"
# new-window with command
bind C command-prompt -p "Command: " "new-window -n %1 'exec %1'"

# ctrl+c to send to clipboard
bind C-c run "tmux save-buffer - | xclip -i -sel clipboard"
# ctrl+v to paste from clipboard
bind C-v run "tmux set-buffer \"$/xclip -o -sel clipboard)\"; tmux paste-buffer"

# reload the config
bind R source-file ~/.tmux.conf \; display-message "tmux.conf reloaded!"

# confirm before killing a window or the server
bind-key k confirm kill-window

# open a man page in new window
bind / command-prompt "split-window 'exec man %%'"

# Less ugly key for the copy mode
bind-key Escape copy-mode -u

# Start window numbering at 1
set -g base-index 1
# Like base-index, but set the starting index for pane numbers.
set-window-option -g pane-base-index 1

# No delay in command sequences
set -s escape-time 0

# Rather than constraining window size to the maximum size of any client
# connected to the *session*, constrain window size to the maximum size of any
# client connected to *that window*. Much more reasonable.
setw -g aggressive-resize on

# Activity monitoring
set -g visual-activity on

# I like Bash
set-option -g default-command /bin/bash
set-option -g default-shell /bin/bash

# Set the number of error or information messages to save in the message
# log for each client.  The default is 20.
set -g message-limit 100

# listen for activity on all windows
set -g bell-action any

# Set the maximum number of lines held in window history.
# This setting applies only to new windows - existing window
# histories are not resized and retain the limit at the point
# they were created.
set -g history-limit 100000

# don't rename windows automatically
set-option -g allow-rename off
EOF
```

vimrc
```bash
$ cat <<EOF | tee -a ~/.vimrc
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set paste
set number
set hlsearch

:nmap <C-N><C-I> :set invrelativenumber<CR>
:nmap <C-N><C-N> :set invnumber<CR>

set laststatus=2

set t_Co=256
" colorscheme
colorscheme slate

filetype on
filetype plugin on

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd FileType j2 setlocal shiftwidth=2 tabstop=2

syntax on

" csv plugin
hi CSVColumnEven        ctermbg=0 ctermfg=10
hi CSVColumnOdd         ctermbg=0 ctermfg=14
hi CSVColumnHeaderEven  ctermbg=0 ctermfg=2
hi CSVColumnHeaderOdd   ctermbg=0 ctermfg=6
EOF
```

aliases
```bash
$ cat <<EOF | tee -a ~/.bash_aliases
alias tmuxx='tmux at'
alias takeover="tmux detach -a"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
EOF
```

golang
```bash
mkdir -p ~/go/{bin,pkg,src}
echo 'export GOPATH="$HOME/go"' | tee -a ~/.bashrc
echo 'export PATH="$PATH:${GOPATH//://bin:}/bin"' | tee -a ~/.bashrc
```

gitconfig
```bash
$ cat <<EOF | tee -a ~/.gitconfig
[alias]
	 a = add
	 aa = add --all
	 ai = add --interactive
 	fp = fetch -p
 	s = status --short --branch
 	st = status
	 ci = commit
	 cm = commit -am
	 br = branch -vv
	 co = checkout
	 d = diff --ignore-all-space
	 df = diff
	 dc = diff --cached --ignore-all-space
	 dfc = diff --cached
	 dlb = branch -d
	 drb = push --delete origin
	 lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
	 logp = log -p
	 cp = cherry-pick
	 sh = stash
	 shl = stash list
	 shp = stash pop
	 rb = rebase
	 rba = rebase --abort
	 rbc = rebase --continue
	 rbs = rebase --skip
	 b = branch -av
	 branches = branch -av
	 tags = tag -l
	 remotes = remote -v
	 contributors = shortlog --summary --numbered
	 flowi  = flow init -d
	 upstream-develop = branch --set-upstream-to=origin/develop develop
	 flowfl = flow feature list
	 flowfs = flow feature start
	 flowfp = flow feature publish
	 flowft = flow feature track
	 cl = remote prune origin
  store-credentials = config credential.helper store
[core]
	 excludesfile = ~/.gitignore
	 attributesfile = ~/.gitattributes
	 pager = less -FXR
	 quotepath = false
	 whitespace = trailing-space,space-before-tab
	 editor = vim
	 trustctime = false
[push]
	 default = current
[pull]
	 rebase = true
[page]
	 color = true
[svn]
	 rmdir = true
	 brokenSymlinkWorkaround = false
[status]
	 submodulesummary = true
[color]
	 ui = auto
[color "branch"]
	 current = yellow reverse
	 local = yellow
	 remote = green
[color "diff"]
	 meta = yellow bold
	 frag = magenta bold
	 old = red bold
	 new = green bold
[color "status"]
	 added = yellow
	 changed = green
	 untracked = cyan
[merge]
	 tool = vimdiff
	 conflictstyle = diff3
	 log = true
	 stat = true
[commit]
	 template = ~/.gitmessage
[credential]
	 helper = store
[user]
	 email = dominik.lenhardt@outlook.de
	 name = Dominik Lenhardt
# You can define a proxyserver for every domain if needed
#[http "https://github.com"]
# 	proxy = http://proxy:3128
#[http "https://dvagazure.visualstudio.com"]
#	 proxy = http://proxy:3128
EOF
```

curlrc
```bash
$ cat <<EOF | tee -a ~/.curlrc
# Example Proxy config for curl
proxy=http://proxy-client.infra.dvag.net:3128
noproxy="127.0.0.1,::1,localhost,localhost6,.lan,.local,10.0.0.0/8,192.168.0.0/16"
EOF
```

wgetrc
```bash
$ cat <<EOF | tee -a ~/.wgetrc
# Example Proxy config for wget
use_proxy=on
http_proxy=http://proxy:3128
https_proxy=http://proxy:3128
ftp_proxy=http://proxy:3128
no_proxy="127.0.0.1,::1,localhost,localhost6,*.lan,*.local,10.0.0.0/8,192.168.0.0/16"
EOF
```

apt
```bash
$ cat <<EOF | sudo tee -a /etc/apt/apt.conf.d/01proxy
# Example Proxy config for apt
Acquire::http::Proxy "http://proxy:3128";
Acquire::https::Proxy "http://proxy:3128";
Acquire::ftp::Proxy "http://proxy:3128";
EOF
```

system proxy
```bash
$ cat <<EOF | sudo tee -a /etc/profile.d/01proxy $$ sudo chmod a+x /etc/profile.d/01proxy 
# Example Proxy config system
export http_proxy=http://proxy:3128
export HTTP_PROXY=http://proxy:3128
export ftp_proxy=http://proxy:3128
export FTP_PROXY=http://proxy:3128
export https_proxy=http://proxy:3128
export HTTPS_PROXY=http://proxy:3128
export no_proxy="localhost,localhost6,::1,127.0.0.1,*.lan,*.local,10.0.0.0/8,192.168.0.0/16"
export NO_PROXY="localhost,localhost6,::1,127.0.0.1,*.lan,*.local,10.0.0.0/8,192.168.0.0/16"
EOF
```

If you want to access your wsl2 with ssh follow this tutorial:
https://www.brianketelsen.com/blog/ssh-to-wsl2/
