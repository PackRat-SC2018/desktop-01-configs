# Begin ~/.bash_profile
#

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

# export PATH="${PATH}:$HOME/bin:$HOME/conky:./"

# If user ID is greater than or equal to 1000 & if ~/bin exists and is a directory & if ~/bin is not already in your $PATH
# then export ~/bin to your $PATH.
if [[ $UID -ge 1000 && -d $HOME/bin && -z $(echo $PATH | grep -o $HOME/bin) ]]
then
    export PATH=${PATH}:$HOME/bin:/$HOME/conky:./
fi

export EDITOR="$(if [[ -n $DISPLAY ]]; then echo 'subl3'; else echo 'nano'; fi)"

if [ -n "$DISPLAY" ]; then
    export BROWSER=firefox
else 
    export BROWSER=w3m
fi

export PS1='\[\033[0;36m\] ┌ ─ [\l] ─ \[\033[1;34m\][\w]\n \[\033[0;36m\]└ ─ > \[\033[0;37m\]$ \[\033[0;37m\]'

# export LC_ALL=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LANGUAGE=en_US.UTF-8
