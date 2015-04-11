#!/bin/bash
foo="_____$* "
toilet -w 10000 $foo > songdisplay.txt
flength=`wc -L songdisplay.txt | grep -Po "^\d+"`

numchars=40
for (( i=0; i<$flength; i++ )); do
  end=$(($i+$numchars-1))
  echo -e -n "\033[6;0H\033[1;31m"
  cut -b $i-$end songdisplay.txt
done
exit
