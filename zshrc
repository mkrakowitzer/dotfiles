#!/usr/bin/env zsh
## Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
export EDITOR=nvim

# OS Specific setup
if [[ `uname` == "Darwin" ]]; then
  # use homebrew path last
  export PATH=$PATH:$(brew --prefix openssh)/bin
  export GPG_TTY=$(tty)
#elif [[ `uname` == "Linux" ]]; then
#
fi

export PATH=~/.local/bin:~/.local/go/bin:~/go/bin:~/.tfenv/bin:~/.local/n/bin:/home/krakowitzerm/.luarocks/bin/:~/cargo/bin:/usr/local/bin:~/.local/npm/bin:~/.local/python/bin:~/.local/openssh/bin:$PATH
export GOROOT=~/.local/go
export GOPATH=~/.local/go/pkg
export GOBIN=~/.local/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_THEME="robbyrussell"

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

if [ -f  ~/personal/secrets/secrets.env ]; then
  source ~/personal/secrets/secrets.env
fi

source ~/.kubectl-completion

export N_PREFIX="$HOME/.local/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
