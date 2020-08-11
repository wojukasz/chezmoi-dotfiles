# Easier navigation
# .., ..., ...., ....., and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias cdd="cd ~/Downloads/"
alias cdg="cd ~/git/"
alias cdot="cd ~/.local/share/chezmoi"
alias cdgo="cd \$GOPATH"

# Archlinux aliases
alias makepkg='chrt --idle 0 ionice -c idle makepkg'

# Override Docker with Podman
if command -v podman &>/dev/null; then
  alias fpm='podman run --rm -v "${WORKSPACE}:/source" -v /etc/passwd:/etc/passwd:ro --user=$(id -u):$(id -g) claranet/fpm'
else
  alias fpm='docker run --rm -v "${WORKSPACE}:/source" -v /etc/passwd:/etc/passwd:ro --user=$(id -u):$(id -g) claranet/fpm'
fi

if command -v podman &>/dev/null; then
  alias saws="podman run -it --rm -e AWS_DEEFAULT_REGION=$AWS_DEFAULT_REGION AWS_ACCESS_KEY_ID=$AWS_DEFAULT_REGION AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN ASSUMED_ROLE=$ASSUMED_ROLE -v $HOME/.aws:/root/.aws joshdvir/saws"
else
  alias saws="docker run -it --rm -e AWS_DEEFAULT_REGION=$AWS_DEFAULT_REGION AWS_ACCESS_KEY_ID=$AWS_DEFAULT_REGION AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN ASSUMED_ROLE=$ASSUMED_ROLE -v $HOME/.aws:/root/.aws joshdvir/saws"
fi

# SSH key aliases
alias key='ssh-add ~/.ssh/ssh_keys/id_bashton_alan'
alias keyaur="ssh-add ~/.ssh/ssh_keys/id_aur"
alias keyb='ssh-add ~/.ssh/ssh_keys/id_bashton'
alias keycl='ssh-add -D'
alias keyp='ssh-add ~/.ssh/ssh_keys/id_personal'
alias keypa='ssh-add ~/.ssh/ssh_keys/id_alan-aws'
alias keypo='ssh-add ~/.ssh/ssh_keys/id_personal_old'
alias kmse='export EYAML_CONFIG=$PWD/.kms-eyaml.yaml'

# Servicenow script aliases
alias snowrep='~/git/bashton-servicenow/reports.py'
alias snowtick='~/git/bashton-servicenow/view-ticket.py --nobox'
alias snowticks='~/git/bashton-servicenow/sn-tickets.py --team mario'
alias snowticks-luigi="~/git/bashton-servicenow/sn-tickets.py --team luigi"

# Taskwarrior aliases
alias tw='task +work'
alias tp='task +personal'

# Use Neovim instead of Vim
if command -v nvim &>/dev/null; then
  alias vim='nvim'
  alias vi='nvim'
elif command -v vim &>/dev/null; then
  alias vi='vim'
fi

if uname -a | grep 'Darwin' &> /dev/null; then
  alias ll='ls -G';
  alias ls='ls -G';
  if command -v tree &>/dev/null; then
    alias lt='tree -C';
  fi
else
  if command -v exa &>/dev/null; then
    alias ll='exa -l --grid --git';
    alias ls='exa';
    alias lt='exa --tree --git --long';
  else
    alias ll='ls --color=auto -l';
    alias ls='ls --color=auto';
    if command -v tree &>/dev/null; then
      alias lt='tree -C';
    fi
  fi
fi
