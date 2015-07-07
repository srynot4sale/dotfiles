alias j "/home/aaronb/code/personal/jarvis/bin/python /home/aaronb/code/personal/jarvis/clients/cli.py"
alias l "ls --color=auto -alv"
alias rgrep "grep --color=auto -RniP"
alias top "atop"
alias mv "mv -i"

alias gcb '__git_ps1 "%s"'
alias psqlg 'psql gcb'

alias tks 'pushd ~/code/dev/tks; perl tks.pl ~/code/dev/tks/timesheets/(date "+%Y-%m")-catalyst.tks -f month'
alias tksedit 'vim -O ~/code/dev/tks/timesheets/(date "+%Y-%m")-catalyst.tks ~/.tksrc'
alias tksmake 'set -l FNAME ~/code/dev/tks/timesheets/(date "+%Y-%m")-catalyst.tks; tks -t month >> $FNAME; echo "Saved to $FNAME"; popd;'

alias decrypt_password '/home/aaronb/code/personal/dotfiles/decrypt_password.sh'

alias b '/bin/bash'

function whoami_if_other
    if test "$USER" != "aaronb"
        echo $USER
    end
end

function maxlength_pwd
    if test (pwd | head -c 12) = "/home/aaronb"
        set APWD (pwd | tail -c +13)
        echo "~$APWD"
    else
        echo $PWD
    end
end

function fish_prompt
    set_color red
    echo -n (hostname)
    echo -n " "
    set_color 00AFFF
    echo -n (maxlength_pwd)
    echo -n (whoami_if_other)
    set_color green
    echo  (__fish_git_prompt)
    set_color 00AFFF
    echo -n '> '
    set_color normal
end
