# bash aliases
# created 20 Jan 2017
#==================================================#
alias ll='ls -lh -F --group-directories-first'
alias la='ls -A --group-directories-first'
alias ls='ls -hNCF --color --group-directories-first'
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
# alias nano='nano -w -B -S'
alias dfh='df -hT'
alias dfk='df -kT'
alias du='du -h'
alias duh='du -hca'
alias path='echo -e ${PATH//:/\\n}'
alias emacs='emacs -nw'
alias listusb='ls -l /dev/disk/by-id/*usb*'
alias sinfo='inxi -CSI -tcm3 -W 29803 --alt 31'
alias screenfetch='screenfetch -n'
alias ninfo='neofetch --backend off'
alias shotdate='date +%A_%s'
alias sshot='import -window root -quality 100 ~/pictures/screen-import-$(shotdate).png'
alias scrotpng='scrot -q 100 -c -d 5 ~/pictures/scrot-shot-%B_%e_%s.png'
alias scrotjpg='scrot -q 100 -c -d 5 ~/pictures/scrot-shot-%a_%e_%s.jpg'
alias kconky='killall -SIGUSR1 conky'
alias ktint2='killall -SIGUSR1 tint2'
alias kpolybar='killall -SIGUSR1 polybar'
alias ufont='fc-cache -f -v'
alias rufont='sudo fc-cache -f -v'
alias prmount='sudo mount -o rw,umask=000'
alias usbmnt='sudo mount -o rw,umask=000 /dev/sdc1 /media/usbhd'
alias win7mnt='sudo mount -o rw,umask=000 /dev/sda5 /mnt/Win7'
alias mntcdrive='sudo mount -o rw,umask=000 /dev/sda3 /mnt/WinC'
alias hprint='lpr -P HP_Officejet_6100'

#alias getvideo='youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best''
#alias getaudio='youtube-dl -x -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best''
alias takeshot='neofetch ; scrotpng'
#alias getmp3='youtube-dl -x  --no-mtime --audio-format mp3 -o ~/temp'
alias localip='ip route get 1'

# Functions
# Extract archives
extract () {
if [ -f $1 ] ; then
case $1 in
*.tar.bz2) tar xjf $1 ;;
*.tar.gz) tar xzf $1 ;;
*.bz2) bunzip2 $1 ;;
*.rar) rar x $1 ;;
*.gz) gunzip $1 ;;
*.tar) tar xf $1 ;;
*.tbz2) tar xjf $1 ;;
*.tgz) tar xzf $1 ;;
*.zip) unzip $1 ;;
*.Z) uncompress $1 ;;
*.7z) 7z x $1 ;;
*) echo "'$1' cannot be extracted via extract()" ;;
esac
else
echo "'$1' is not a valid file"
fi
}

