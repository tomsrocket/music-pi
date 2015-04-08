#!/bin/bash
COUNT=1
STATION="??"
clear

while true; do

	COUNT=$((COUNT + 1))
	if [ "$COUNT" -gt 2 ]; then
		COUNT=0
	    echo -e "\033[0;0H   \033[0;31m "
		bash ./clock.sh
#		echo " "
#		echo " "
		echo -e "\033[1;33m            P I     R A D I O       "

	    echo -e "\033[1;34m  "
		echo "Press keys 1-9 to choose radio station,"
		echo " + - for volume"
		echo " / =  next station "
		echo " * = pause playback "
		echo " . = show station information "
		echo -e " \033[1;37m"
		echo "station $STATION  -  volume `mpc | head -n 3 | tail -n 1 | awk {'print $2'}`"
		echo -e " \033[0;37m"
		echo `mpc --format \"[%name%]\" |head -n1`
		echo -e " \033[1;37m"
		echo `mpc --format \"[%title%]\" |head -n1`
	fi


	# wir speichern die gedrückte taste in der variable $KEY

	read -t1 -n1 KEY 

	MPC="mpc -h LightPi"

	volume="70"
	commnd=""

	dummy=""

	# play next radio station (=next song in playlist)
	if [ "$KEY" == "/" ];  then	
		dummy=`$MPC next`
		KEY="."
	fi


	if [ "$KEY" == "*" ]; then 
		$MPC stop	
#		echo "Pause" | espeak -a 90 -p30 -s120
		read -n1 K2

		$MPC play
	# change volume
	elif [ "$KEY" == "+" ];  then	
		dummy=`$MPC volume +2`
		echo "volume up"
		clear

	elif [ "$KEY" == "-" ];  then	
		dummy=`$MPC volume -2`
		echo "volume down"
		clear

	# say radio station information
	elif [ "$KEY" == "." ]; then
		va1=`$MPC | sed -n 2p | grep -Poh "#\d+"`
		va2=`$MPC | sed -n 1p | grep -Poh "^[\w\d\s]+"`
		echo "${va1#?} => ${va2}"
#		echo "${va1#?}      ${va2}" | espeak -a200
	else 


		# change radio station // song
		if [ "$KEY" -ge 0  ] && [ "$KEY" -le 9  ];  then	
			read -n1 -t1 TKEY

			re='^[0-9]+$'
			if [[ "$TKEY" =~ $re ]]; then
				KEY=$((10*KEY+TKEY))
			fi

			commnd="$MPC play $KEY"

		fi


		if [ "$KEY" == "0" ];  then
			commnd="$MPC"
		fi


		# execute command
		if [ "$commnd" != "" ]; then 
			retrn=`eval ${commnd}` 
			nam=`echo "${retrn}" | sed -n 1p | grep -Poh "^[\w\d\s]+"`
			if [ "$nam" == "http" ]; then 
				nam=`echo "${retrn}" | sed -n 1p | grep -Poh "#[^#]+$"`
				nam=${nam#?}
			fi 
			echo "$KEY => $nam"
#			echo "$KEY $nam" | espeak -a150 -p30 -s120
			STATION=$KEY
			clear

		fi
	fi

done



