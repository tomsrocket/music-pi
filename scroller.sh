#!/bin/bash
foo="     $1        "
numchars=7
for (( i=0; i<$((${#foo}-$numchars)); i++ )); do
  some=$(($i+$numchars-1))
  if  [ "${foo:$some:1}" = " " ]; then
	  echo -e -n "\033[0;0H"
	  echo ".                                       "
	  echo "                                        "
	  echo "                                        "
	  echo "                                        "
	  echo "                                        "
	  echo "                                        "
	  echo "                                        "
	  echo "                                        "
	  echo "                                        "
  fi
  echo -e -n "\033[0;0H"
  toilet -w 40 -f mono9 -F gay -S ${foo:$i:$numchars}
  #echo -e "\033[0;31m1234567890123456789012345678901234567890"
  sleep 0.1
done
exit
