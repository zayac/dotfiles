# Path to your oh-my-zsh installation.
export ZSH=$HOME/.config/oh-my-zsh

ZSH_THEME="spaceship"
SPACESHIP_PROMPT_ORDER=(
  dir
  git
  hg
  char
)
SPACESHIP_PROMPT_ADD_NEWLINE=false

plugins=(history zsh-autosuggestions command-not-found)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg-242'

DISABLE_UPDATE_PROMPT="true"

source $ZSH/oh-my-zsh.sh

# ruby rbenv
# Required for command-t vim plugin.
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

#
# Other
#

source $HOME/.zsh/aliases
