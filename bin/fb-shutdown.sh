#!/usr/bin/sh
#shutdown script
xmessage "Are you sure you want to shut down your computer?" -center -title "Take action" -default "Cancel" -buttons "Cancel":1,"Reboot":2,"Shutdown":3,"Logout":4 

case $? in
    1)
        echo "Exit";;
    2)
        sudo reboot;;
    3)
        sudo shutdown;;
    4)
        killall `wmctrl -m | awk '/Name/ {print tolower($2)}'`
esac