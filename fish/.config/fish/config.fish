#{{{ env & path
set -x SCRIPTS "~/.scripts"
set -x EDITOR vim
set -x PAGER less
set -x KEYTIMEOUT 1  # Reduce vi-mode lag

# Android
export ANDROID_HOME="/opt/android-sdk/"
export ANDROID_TOOLS="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
#}}}

fish_vi_key_bindings

#{{{ Abbreviations
## To functions
abbr -a cd c

abbr -a e vim
abbr -a edit vim
abbr -a er vr
abbr -a vi vim
abbr -a vim fuzzy_edit
abbr -a vr fuzzy_edit readme

alias git hub
abbr -a ga git add
abbr -a gb git branch
abbr -a gc git commit
abbr -a gco git checkout
abbr -a gs git status -sb
abbr -a gro git remote rm origin
abbr -a gao git remote add origin
abbr -a gl git log --format=format:'%C(auto)%h %C(green)%aN%Creset %Cblue%cr%Creset %s'
abbr -a gd git diff --color always | diff-so-fancy | less -RSFXi
abbr -a dl darcs log
abbr -a dr darcs record
abbr -a dw darcs whatsnew

abbr -a ex exit
abbr -a exi exit
abbr -a ext exit
abbr -a exti exit

abbr -a am alsamixer -g -c 0
abbr -a artisan php artisan
abbr -a cdmem cd /mnt/mem1
abbr -a cdmeme cdmem
abbr -a clip xclip -selection clipboard -i
abbr -a df df -h
abbr -a dhcp sudo dhclient enp3s0
abbr -a dog less -RSFXin
abbr -a dotpng dot -Tpng -O
abbr -a du du -h
abbr -a dud du -h -d 0
abbr -a free free -h
abbr -a grep grep --line-number --ignore-case --color=auto
# abbr -a ll l | less -R
# abbr -a LL L | less -R
abbr -a lsl command ls -lLh --color
abbr -a lsls command ls -lLha --color
# abbr -a lg la
abbr -a m mpv
abbr -a mail mutt
abbr -a meme mem
abbr -a mkdir mkdir -p
abbr -a moretmp sudo mount -o remount,size=10G,noatime /tmp
abbr -a ns nativescript
abbr -a o $SCRIPTS/open.sh
abbr -a p ping 8.8.8.8
# Reminder: text snippet sharing
abbr -a pastebin sprunge
abbr -a pb sprunge
abbr -a qgis qgis --nologo
abbr -a s sxiv -a -q&
abbr -a S sxiv -a -q ./*&
abbr -a suod sudo
abbr -a sys sudo systemctl
abbr -a time command time -p
abbr -a tte trans -b -t en
abbr -a tts trans -b -t es
abbr -a vhex vim -b
abbr -a re vim report.md
abbr -a ro zathura report.pdf&
abbr -a woman command man
abbr -a ghc stack ghc
abbr -a se stack exec
abbr -a sb stack build
abbr -a stage stage.sh
abbr -a st stage
abbr -a ink inkscape
abbr -a inks inkscape
abbr -a r R --quiet
abbr -a R R --quiet
abbr -a bat command bat --theme GitHub
abbr -a vnmap nmap -sV --script=vulscan/vulscan.nse
abbr -a octave octave -q
abbr -a prog progress
abbr -a ch cht.sh
abbr -a gdb gdb -q
abbr -a ssh sshrc
abbr -a winbox wine ~/.local/bin/winbox.exe&
abbr -a svgo svgo --config='{ \"plugins\": [{ \"removeViewBox\": false }, { \"removeDimensions\": true }] }'
abbr -a yesod stack exec -- yesod
abbr -a hakyll stack exec site
abbr -a shake stack exec -- shake
# abbr -a md pandoc -s -f markdown -t man "$1" | command man -l -
# abbr -a h command hoogle $@ | HsColour --tty
# abbr -a hi command hoogle --info $@ | HsColour --tty
#}}}


#{{{ Bindings
bind --user \co echo\ -n\ \(clear\ \|\ string\ replace\ \\e\\\[3J\ \"\"\)\;\ commandline\ -f\ repaint
#}}}


#{{{ Functions
set SORT_CMD sort

function list_dir
    echo
    find "$argv/" -maxdepth 1 -not -path '*/\.*' -printf \
        "[%y]\t%P\n" | tail -n +2 | eval $SORT_CMD  \
        | sed -r "s/\[[d]\](.*)/ D\1/" \
        | sed -r "s/\[[f]\](.*)/ F\1/" \
        | sed -r "s/\[[l]\](.*)/ L\1/"

    set SORT_CMD sort
end

function L
    set SORT_CMD sort -r
    l
end

function l
    if test (count $argv) -eq 0
        set l_dir "."
    else if test -d "$argv"
        set l_dir "$argv"
    else
        set l_dir (find -L . -maxdepth 1 -type d -not -path '*/\.*' \
            -printf "%P\n" | fzf -q "$argv" -1 -0)

        if test "$l_dir" = ""
            echo
            echo -e "\t No such directory \"$argv\"    ¯\_(ツ)_/¯"
            echo
            return 1
        end
    end

    list_dir $l_dir
end

function c
    if test (count $argv) -gt 0
        cd "$argv" && l
        if test $status -ne 0
            cd_fzf $argv
        end
    else
        cd ~ && clear
    end
end

function cd_fzf
    set go_dir (find -L . -maxdepth 1 -type d -not -path '*/\.*' -printf "%P\n" | fzf -q "$argv" -1 -0)

    if test "$go_dir" != ""
        cd "./$go_dir"
    else
        cd_fasd $argv;
    end
end

function cd_fasd
    set go_dir (fasd -d $argv)

    if test "$go_dir" = ""
        echo
        echo -e "\t No directory \"$argv\"    ¯\_(ツ)_/¯"
        echo
    else
        echo
        cat ~/.ascii_art/spacecraft
        echo
        cd "$go_dir"
    end
end

#}}}

# vim:fdm=marker
