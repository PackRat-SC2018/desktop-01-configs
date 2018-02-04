#!/bin/awk -f

function get_date()
{
        DATE_CMD | getline STROUT; close(DATE_CMD)
        STROUT = "^fg("TX2")"STROUT
        return STROUT
}

function get_mem()
{
        check = 0
        while ((getline < MEMINFO) > 0) {
                if ($1 ~ /^MemTotal:/){ TOTALMEM = $2 ; check += 1; continue }
                if ($1 ~ /^MemFree:/) { FREEMEM  = $2 ; check += 1; continue }
                if ($1 ~ /^Buffers:/) { FREEMEM += $2 ; check += 1; continue }
                if ($1 ~ /^Cached:/)  { FREEMEM += $2 ; check += 1 }
                if (check == 4) { break }
        }
        close(MEMINFO)
        USEDMEM = (TOTALMEM - FREEMEM)
        UBARS   = int(USEDMEM * 100 / TOTALMEM)
        FBARS   = int(FREEMEM * 100 / TOTALMEM)
        if (UBARS >= 95) { FGCOL = "^fg("RED")" } else { FGCOL = "^fg("GRN")" }
        STROUT = "^fg(white)MEM:^p(2;4)"FGCOL"^r("UBARS"x16)^fg("BAR")^r("FBARS"x16)"
        return STROUT
}

function cpu_usage()
{
        # Calculate the CPU usage since we last checked.
        check = 0; TOTALCPU0 = 0; TOTALCPU1 = 0
        while ((getline < STAT) > 0) {
                if ($0 ~ /^cpu0 /) {
                        check += 1; IDLECPU0 = $5; for (x=2; x<=NF; x++) { TOTALCPU0 += $x; continue }
                }
                if ($0 ~ /^cpu1 /) {
                        check += 1; IDLECPU1 = $5; for (x=2; x<=NF; x++) { TOTALCPU1 += $x }
                }
                if (check == 2) { break }
        }
        close(STAT)
        DIFF_IDLE0 = IDLECPU0 - LASTIDLECPU0
        DIFF_IDLE1 = IDLECPU1 - LASTIDLECPU1
        DIFF_TOTAL0 = TOTALCPU0 - LASTTOTALCPU0
        DIFF_TOTAL1 = TOTALCPU1 - LASTTOTALCPU1
        DIFF_USAGE0 = int((100 * (DIFF_TOTAL0 - DIFF_IDLE0)) / DIFF_TOTAL0)
        DIFF_USAGE1 = int((100 * (DIFF_TOTAL1 - DIFF_IDLE1)) / DIFF_TOTAL1)
        if (DIFF_USAGE0 >= 95) { FG="^fg("RED")" } else { FG="^fg("GRN")" }
        STROUT = "^fg(white)CPU:^p(2;4)"FG"^r("DIFF_USAGE0"x8)^fg("BAR")^r("100-DIFF_USAGE0"x8)"
        if (DIFF_USAGE1 >= 95) { FG="^fg("RED")" } else { FG="^fg("GRN")" }
        STROUT = STROUT"^p(-100;8)"FG"^r("DIFF_USAGE1"x8)^fg("BAR")^r("100-DIFF_USAGE1"x8)"
        LASTTOTALCPU0 = TOTALCPU0; LASTIDLECPU0 = IDLECPU0
        LASTTOTALCPU1 = TOTALCPU1; LASTIDLECPU1 = IDLECPU1
        return STROUT
}

function disk_space()
{
        STROUT = ""
        while ((DF_CMD | getline) > 0) {
                if ($6 !~ /Mounted|\/dev\/shm/) {
                        DEVUSED = $2 - $4
                        UBARS = int(DEVUSED * 100 / $2)
                        FBARS = int($4 * 100 / $2)
                        if (UBARS >= 95) { FGCOL = "^fg("RED")" } else { FGCOL = "^fg("GRN")" }
                        STROUT = STROUT"^pa(;0)^fg(white)"$6":^p(2;4)"FGCOL"^r("UBARS"x16)^fg("BAR")^r("FBARS"x16) "
                }
        }
        close(DF_CMD)
        return STROUT
}

function interfaces()
{
        STROUT = ""
        while ((IPGLOBAL_CMD | getline) > 0) {
                if ($0 ~ /^[ ]*inet /) {
                        LOC = "/sys/class/net/"$NF"/statistics/rx_bytes"
                        getline RXBN[$NF] < LOC; close(LOC)
                        LOC = "/sys/class/net/"$NF"/statistics/tx_bytes"
                        getline TXBN[$NF] < LOC; close(LOC)
                        RXR[$NF] = int((RXBN[$NF] - RXB[$NF]) / 1024); RXB[$NF] = RXBN[$NF]
                        TXR[$NF] = int((TXBN[$NF] - TXB[$NF]) / 1024); TXB[$NF] = TXBN[$NF]
                        STROUT = STROUT "^fg(white)"$NF"^fg("BAR") "TXR[$NF]"^fg("GRY")^p(2)UkB/s ^fg("BAR")"RXR[$NF]"^fg("GRY")^p(2)DkB/s"
                        IPLABEL_CMD  = "/sbin/ip addr show label "$NF; IPADDR = ""
                        while ((IPLABEL_CMD | getline) > 0) {
                                if ($0 ~ /inet /) { gsub("/.*","",$2); IPADDR = $2; break }
                        }
                        close(IPLABEL_CMD)
                        STROUT = STROUT" ^fg("BAR")"IPADDR
                }
        }
        close(IPGLOBAL_CMD)
        return STROUT
}

function workspaces(display)
{
        RS = "},{"; FS = ","; XPOS = 1681; STROUT = ""
        while ((I3SOCK_CMD | getline) > 0) {
                NEEDCOLOR = 1
                if ($NF ~ /true/) {             TAGCOLOR = "#FF5555"; TEXTCOLOR = "#FFFFFF"; NEEDCOLOR = 0 }
                if (NEEDCOLOR && $3 ~ /true/) { TAGCOLOR = "#FFFFFF"; TEXTCOLOR = "#000000"; NEEDCOLOR = 0 }
                if (NEEDCOLOR) {                TAGCOLOR = "#A0A0A0"; TEXTCOLOR = "#000000" }
                gsub(/"|\[|\]|{|}/,"")
                split($2, ONAME, ":")
                split($(NF-1), OUTPUT, ":")
                if (OUTPUT[2] == display && display == "xinerama-0") {
                        STROUT = STROUT"^fg("TAGCOLOR")^r(30x22)^p(-21)^fg("TEXTCOLOR")"ONAME[2]"^p(+11)"; XPOS -= 32; continue
                }
                if (OUTPUT[2] == display && display == "xinerama-1") {
                        STROUT = STROUT"^fg("TAGCOLOR")^r(30x22)^p(-21)^fg("TEXTCOLOR")"ONAME[2]"^p(+11)"; XPOS = 1
                }
        }
        close(I3SOCK_CMD)
        STROUT = "^pa("XPOS";1)"STROUT
        RS = "\n"; FS = " "
        return STROUT
}

function show_help ()
{
        print
        print "This script is called \"dzen2-wrapper\""
        print "This is a wrapper/startup script for feeding various information"
        print "into one or more Dzen2 status bars. To start it from your WM or"
        print "from xinitrc or from CLI, I suggest a command like:"
        print "`/path/to/dzen2-wrapper [option] & disown`"
        print "This script accepts one of three options: stop, nostop, and help;"
        print "stop:   stop all dzen2's and wrapper scripts, and exit."
        print "nostop: start new instance without stopping any other instances."
        print "help:   show this help info you're reading now."
        print
        print "License: GPLv3 or greater. Warranty: none."
        print "Author:  GrapefruiTgirl"
        print "Thanks:  Members of the linuxquestions.org community."
        print
}

BEGIN{
if (ARGV[1] ~ /help|-h/) { show_help(); exit 0 }

if ("nostop" !=  ARGV[1]) {
# Yes, this killing code is not good. I could be less delicate/more brutal
# but for now, it is what it is. Note: "nostop" option passed to the script
# can be handy if you want to run a second+ X session somewhere and want
# dzen2's there as well as on your initial session.
        RS="\n"; FS = " "; count = 0
        PS_CMD1 = "ps --no-headers -C dzen2 2>/dev/null"
        PS_CMD2 = "ps --no-headers -C dzen2 >/dev/null 2>&1"
# NOTE: Next line must have the filename of this as the argument to -C
        PS_CMD3 = "ps --no-headers -C dzen2-wrapper 2>/dev/null"
        while ((PS_CMD3 | getline) >0) {
                if ($1 != PROCINFO["pid"]) { system("kill -9 "$1" >/dev/null 2>&1") }
        }
        close(PS_CMD3)
        while (system(PS_CMD2) == 0) {
                while ((PS_CMD1 | getline) >0) {
                        system("kill -9 "$1" 2>/dev/null")
                }
                close(PS_CMD1)
                count += 1; system("/bin/sleep 1")
                if (count >=5) {
                        print "dzen2-wrapper error: unkillable zombie dzen2's." > "/dev/stderr"; exit 1
                }
        }
        close(PS_CMD2)
}

# See if we're being told to stop all Dzen2's and not restart:
if ("stop" == ARGV[1]) { exit 0 }

# VARIABLES: Define colors and things:
TX1="#DBDADA"                           # medium grey text
TX2="#F9F9F9"                           # light grey text
GRY="#909090"                           # dark grey text
BAR="#A6F09D"                           # green background of bar-graphs
GRN="#65A765"                           # light green (normal)
RED="#FF0000"                           # light red/pink (warning)
LASTTOTALCPU0 = 0; LASTIDLECPU0 = 0     # zero some vars for \
LASTTOTALCPU1 = 0; LASTIDLECPU1 = 0     # ..the CPU load reader
delete ARGV                             # we don't need ARGV anymore.

# COMMANDS & /proc files for use w/getline:
DATE_CMD     = "date +'%H:%M:%S %a %x'"
DF_CMD       = "df"
IPGLOBAL_CMD = "/sbin/ip addr show scope global"
I3SOCK_CMD   = "i3-msg -s /tmp/i3-ipc.sock -t get_workspaces"
MEMINFO      = "/proc/meminfo"
STAT         = "/proc/stat"

while (1) {
        system("/bin/sleep .98")

print "^ib(1)^pa(0;0)^fg("BAR")^ro(1680x24)^pa(2;0)"get_date()"^pa(;0) "get_mem()"^pa(;0) "cpu_usage()"^pa(;0) "disk_space()" "workspaces("xinerama-0") |\
 "dzen2 -fn -xos4-terminus-medium-r-normal-*-12-120-72-72-c-*-iso10646-1 -bg black -ta l -h 24 -u -p -xs 1 -dock -e 'sigusr1=exit'"

print "^ib(1)^pa(0;0)^fg("BAR")^ro(1680x24)^pa(0;0)"workspaces("xinerama-1")"^pa(;0) "interfaces() |\
 "dzen2 -fn -xos4-terminus-medium-r-normal-*-12-120-72-72-c-*-iso10646-1 -bg black -ta l -h 24 -u -p -xs 2 -dock -e 'sigusr1=exit'"

} # end of while(1)

} # end of BEGIN

END{}