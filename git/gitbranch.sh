function rprompt-git-current-branch {
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
    if [[ -z $name ]]; then
        return
    fi

    echo "$name "
    # echo "%{$color%}$name%{$reset_color%} "
}

setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'
