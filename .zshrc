source ~/.zsh/antigen.zsh

#########################################################################
# If antigen is installed, do antigen things
if type "antigen" > /dev/null;
then
    # Bundles
    # Compat shim
    antigen use oh-my-zsh
    # Bundles from omz repo
    antigen bundle command-not-found
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle zsh-users/zsh-autosuggestions


    # Theme
    export LANGUAGE="en"
    export LC_CTYPE="en_NZ.UTF-8"
    export LANG="en_NZ.UTF-8"

    antigen apply
fi


# Theme config (modified from YS theme)

# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PRIVILEGES USER@MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % ys @ ys-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n)\
%{$fg[white]%}@\
%{$fg[green]%}%m \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${git_info}\
 \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"

function +vi-git-untracked() {
    VCS_WORKDIR_HALF_DIRTY=false
}
function +vi-git-aheadbehind() {
}
function +vi-git-stash() {
}
function +vi-git-remotebranch() {
}
function +vi-vcs-detect-changes() {
    vcs_visual_identifier='VCS_GIT_ICON'
    VCS_WORKDIR_DIRTY=false
}
function +vi-svn-detect-changes() {
}


# History arrows
bindkey "^[OA" up-line-or-local-history
bindkey "^[OB" down-line-or-local-history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

bindkey "^[[1;5A" up-line-or-history    # [CTRL] + Cursor up
bindkey "^[[1;5B" down-line-or-history  # [CTRL] + Cursor down


# Navigation arrows
# Alt-back and forward to skip over words
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word


# FZF config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Wrap SSH with a different colour background
#ssh() {
#    echo -ne '\e]11;#702222\a'
#    command ssh "$@"
#    echo -ne '\e]11;#000000\a'
#}

########################################################################
## PATH
export PATH="${HOME}/code/dotfiles/bin:${PATH}"

########################################################################
# ALIASES
alias psql=pgcli
