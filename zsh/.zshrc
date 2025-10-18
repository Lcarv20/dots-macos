# Created by Zap installer
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "paulirish/git-open"
plug "Aloxaf/fzf-tab"
plug "Freed-Wu/fzf-tab-source"
plug "Lcarv20/web-search"
plug "wintermi/zsh-starship"
plug "wintermi/zsh-mise"


plugins=(...web-search)

export XDG_CONFIG_HOME="$HOME/.config"

# Ruby stuff I guess
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

#BOB (nvim v-manager)-------------------------------------------------------
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
#HomeBrew-------------------------------------------------------------
export PATH=/opt/homebrew/sbin:$PATH
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Default Editor -------------------------------------------------------------
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"

## VIVID
# export LS_COLORS="$(vivid generate one-dark)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

# ------------------------------
# --- ALIASES
# ------------------------------
# Better ls
alias ls="lsd"
alias l="lsd -l"
alias lt="lsd --tree"
alias la="lsd -a"
alias ll="lsd -l"
alias lla="lsd -la"

# Better CD
alias cd="z"

# Neovim
alias v="nvim"
alias m="NVIM_APPNAME=mvim nvim"
alias mvim="NVIM_APPNAME=mvim nvim"
alias mvide="NVIM_APPNAME=mvim neovide --frame=transparent"

if command -v bat &> /dev/null; then
  # alias cat="bat -pp --theme \"1337\""
  # alias catt="bat --theme \"1337\""
  alias cat="bat -pp"
  alias catt="bat"
fi

# Editor for commit messages
# VS Code
alias vscommit='GIT_EDITOR="code --wait" git commit'
# Zed
alias zcommit='GIT_EDITOR="zed --wait" git commit'
# Xcode
alias xcommit='GIT_EDITOR="xed -w" git commit'

# completions dir
fpath+=~/.zfunc
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# TUNR OFF NEXT TELEMETRY
export NEXT_TELEMETRY_DISABLED=1

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# bun bin
export PATH="$HOME/.bun/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"

eval "$(starship init zsh)"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Code below is for transient prompt in zsh with starship   +
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
precmd_functions=(zvm_init "${(@)precmd_functions:#zvm_init}")
precmd_functions+=(set-long-prompt)
zvm_after_init_commands+=("zle -N zle-line-finish; zle-line-finish() { set-short-prompt }")

set-long-prompt() {
    PROMPT=$(starship prompt)
    RPROMPT=""
}

export COLUMNS=$(($COLUMNS + ($COLUMNS*0.1)))
set-short-prompt() {
    # setting this doesn't seem to actually work
    PROMPT="$(STARSHIP_KEYMAP=${KEYMAP:-viins} starship module character)"
    RPROMPT=$'%{\e[999C%}\e[8D%F{8}%*%f ' # remove if you don't want right prompt
    zle .reset-prompt 2>/dev/null # hide the errors on ctrl+c
}

zle-keymap-select() {
    set-short-prompt
}
zle -N zle-keymap-select

zle-line-finish() { set-short-prompt }
zle -N zle-line-finish

trap 'set-short-prompt; return 130' INT

# try to fix vi mode indication (not working 100%)
zvm_after_init_commands+=('
  function zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] ||
       [[ $1 = "block" ]]; then
      echo -ne "\e[1 q"
      STARSHIP_KEYMAP=vicmd
    elif [[ ${KEYMAP} == main ]] ||
         [[ ${KEYMAP} == viins ]] ||
         [[ ${KEYMAP} = "" ]] ||
         [[ $1 = "beam" ]]; then
      echo -ne "\e[5 q"
      STARSHIP_KEYMAP=viins
    fi
    zle reset-prompt
  }
  zle -N zle-keymap-select

  # Ensure vi mode is set
  zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
  }
  zle -N zle-line-init
')

set-short-prompt() {
  if [[ $PROMPT != '%# ' ]]; then
    PROMPT="$(starship prompt --profile transient)"
    zle .reset-prompt 2>/dev/null # hide the errors on ctrl+c
  fi
}

$HOME/.dotfiles/zsh/poke-colorscript

# Added by Windsurf
export PATH="/Users/lcarv/.codeium/windsurf/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/lcarv/.lmstudio/bin"
# End of LM Studio CLI section

# Focus Editor
export PATH="/Applications/Focus.app/Contents/MacOS:$PATH"

