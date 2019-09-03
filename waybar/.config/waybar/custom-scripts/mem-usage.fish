#!/usr/bin/env fish

function print_ticks
  for x in (seq $argv)
    printf '∎'
  end
end

set MEM_TOTAL (math -s2 "15954 / 1024") # 15954 MB, check: "vmstat -w -S M -a -s"
set MEM_USED (cat /proc/meminfo | awk 'NR==7, NR==8 {print $2}')
set MEM_USED (math "$MEM_USED[1] + $MEM_USED[2]")
set MEM_USED (math -s2 "$MEM_USED / 1024 / 1024") # conversion from KB to GB.
set MEM_USED_PERC (math -s0 "$MEM_USED / $MEM_TOTAL * 100")

set ACTIVE_TICKS (math "ceil($MEM_USED_PERC / 5)")
set DEACTIVE_TICKS (math 20 - $ACTIVE_TICKS)

set ACTIVE_TICKS (print_ticks $ACTIVE_TICKS)
set DEACTIVE_TICKS (print_ticks $DEACTIVE_TICKS)

if test "$MEM_USED_PERC" -lt 15
   set TICKS_COLOR '#00ff52'
else if test "$MEM_USED_PERC" -lt 30
   set TICKS_COLOR '#a1ff00'
else if test "$MEM_USED_PERC" -lt 45
   set TICKS_COLOR '#b3ff00'
else if test "$MEM_USED_PERC" -lt 60
   set TICKS_COLOR '#ccff00'
else if test "$MEM_USED_PERC" -lt 75
   set TICKS_COLOR '#ffe500'
else if test "$MEM_USED_PERC" -lt 90
   set TICKS_COLOR '#ff9c00'
else if test "$MEM_USED_PERC" -lt 100
   set TICKS_COLOR '#ff0000'
end

if test "$MEM_USED_PERC" -lt 10
  set MEM_USED_PERC "0"$MEM_USED_PERC
end

set TEXT "MEM "$MEM_USED_PERC"% <span foreground='"$TICKS_COLOR"'>"(echo $ACTIVE_TICKS)"</span><span foreground='#444444'>"(echo $DEACTIVE_TICKS)"</span>"


echo $TEXT
echo $MEM_USED" GB used"
echo "custom-mem-usage"
