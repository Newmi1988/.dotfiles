# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export DOCKER_BUILDKIT=1

# add some os dependent path
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export PATH="/usr/share/git/git-jump:$PATH"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/Cellar/git/2.40.0/share/git-core/contrib/git-jump:$PATH"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
    git-auto-fetch
	zsh-autosuggestions
	docker
	helm
	pip
	rust
    you-should-use
    autoupdate
	)

source $ZSH/oh-my-zsh.sh

# os specific sources
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # fzf keybindings
    echo "Loading unix sources"
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Loading Mac Sources"
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# pyenv settings
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

eval "$(atuin init zsh)"
source $HOME/.config/atuin/_atuin


cx() {cd "$@" && l; }

alias psh="poetry shell"
alias pin="poetry install"
alias pup="poetry unpdate"
alias k="kubectl"
alias gcof='git checkout $(git branch | fzf-tmux -d15)'
alias v="fd --type f --hidden --exclude .git --exclude .venv | fzf-tmux --height 70% --info inline -p --preview-window '~3' --reverse  --preview 'bat --color=always {}' | xargs nvim"
alias ll="exa --long --git -g --octal-permissions"
alias lla="exa --long -a --git -g --octal-permissions"
alias cwd="erd --icons --prune --disk-usage physical --suppress-size"
alias ell='erd --long --human  --icons --hidden --no-git -d physical '
alias zj='zellij'

function zms {
    if [ -z "$1" ]
    then
        echo "No argument supplied. Starting session with random name"
        zellij
    else
        local destination=$(findgit "$1")
        local session_name=$(basename "$destination")
        cd $destination && {
            zellij a "$session_name" || {
                echo "Creating session: $session_name"
                zellij -s "$session_name"
            }
        }
    fi
}

function fzj {
    local zellij_sessions=$(zellij ls)
    # search sessions
    if [ -z "$zellij_sessions" ]
    then
        echo "No sessions found"
    else
        local session_name=$(echo $zellij_sessions | fzf )
        if [ -z "$session_name"]
        then
            echo "No session found!"
        else
            zellij a "$session_name"
        fi
    fi

}

function fzjk {
    local zellij_sessions=$(zellij ls)
    if [ -z "$zellij_sessions" ]
    then
        echo "No sessions found"
    else
        local session_to_kill=$(echo $zellij_sessions | fzf)
        zellij k "$session_to_kill"
    fi
}

# opam configuration
[[ ! -r /Users/newmi/.opam/opam-init/init.zsh ]] || source /Users/newmi/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# call neofetch at the and to disply info
neofetch

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
