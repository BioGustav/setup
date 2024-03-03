export ZSH="$HOME/.oh-my-zsh"
source /usr/local/bin/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle command-not-found

# Other bundles.
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting # has to be the last bundle!

# Tell Antigen that you're done.
antigen apply

plugins=(
	git
	rust
)

source $ZSH/oh-my-zsh.sh

# User configuration
if [[ -e ~/.config/aliases ]]; then
  source ~/.config/aliases
fi

# jetbrains toolbox
export PATH=/home/biog/.local/share/JetBrains/Toolbox/scripts:$PATH

eval "$(oh-my-posh init zsh --config ~/.config/themes/style_biog.omp.json)"
