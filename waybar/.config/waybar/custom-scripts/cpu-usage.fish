#!/usr/bin/env fish

function print_ticks
  for x in (seq $argv)
    printf '∎'
  end
end


set CPU_USAGE (vmstat 1 2 -w | awk 'NR==4 {print 100-$15}')

set ACTIVE_TICKS (math "ceil($CPU_USAGE / 5)")
set DEACTIVE_TICKS (math 20 - $ACTIVE_TICKS)

set ACTIVE_TICKS (print_ticks $ACTIVE_TICKS)
set DEACTIVE_TICKS (print_ticks $DEACTIVE_TICKS)

if test "$CPU_USAGE" -lt 15
   set TICKS_COLOR '#00ff52'
else if test "$CPU_USAGE" -lt 30
   set TICKS_COLOR '#a1ff00'
else if test "$CPU_USAGE" -lt 45
   set TICKS_COLOR '#b3ff00'
else if test "$CPU_USAGE" -lt 60
   set TICKS_COLOR '#ccff00'
else if test "$CPU_USAGE" -lt 75
   set TICKS_COLOR '#ffe500'
else if test "$CPU_USAGE" -lt 90
   set TICKS_COLOR '#ff9c00'
else if test "$CPU_USAGE" -lt 101
   set TICKS_COLOR '#ff0000'
end

if test "$CPU_USAGE" -lt 10
  set CPU_USAGE "0"$CPU_USAGE
end

set TEXT "CPU "$CPU_USAGE"% <span foreground='"$TICKS_COLOR"'>"(echo $ACTIVE_TICKS)"</span><span foreground='#444444'>"(echo $DEACTIVE_TICKS)"</span>"


echo $TEXT
echo $CPU_USAGE
echo "custom-cpu-usage"
