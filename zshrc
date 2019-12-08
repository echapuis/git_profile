# Path to your oh-my-zsh installation.
export ZSH="/Users/eliottchapuis/.oh-my-zsh"

export EDITOR='sub'
eval "$(direnv hook zsh)"
LESS="-XRF"; export LESS

bindkey "^[^[[A" beginning-of-line
bindkey "^[^[[B" end-of-line
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word



ZSH_THEME="ys"

alias reload='source $ZSH/oh-my-zsh.sh && source ~/.fzf.zsh && source ~/.bash_profile && source $SAMSARA_PROFILE && source $COMPLETIONS && reset'