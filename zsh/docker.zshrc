# History
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zshaddhistory(){
local line=${1%%$'\n'}
local cmd=${line%% *}
[[ ${cmd} != (ls)
&& ${cmd} != (cd)
&& ${cmd} != (rm)
]]
}

# Complement
autoload -U compinit
compinit
setopt correct

# Locales
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Prompt
export PS1="docker$ "
source /opt/git/gitbranch.sh
SPROMPT="%r is correct? [n,y,a,e]: "

# Title
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac
case "{$TERM}" in
screen)
    preexec() {
        echo -ne "\ek#${1%% *}\e\\"
    }
    precmd() {
        echo -ne "\ek$(basename $(pwd))\e\\"
    }
esac

# Directory names on tab
echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1}'| rev)\007"
function chpwd() {
    echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1}'| rev)\007"
    }

# Aliases
alias rm="rm -i"
alias ipython="ipython --no-banner"
