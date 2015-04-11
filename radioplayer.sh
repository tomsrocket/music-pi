#!/bin/bash
STATION="??"
CSONG="waa"
PID=0

clear

while true; do

	TSONG="`mpc --format \"[%title%]\" |head -n1`"
	if [ "$TSONG" = "" ]; then
		TSONG="`mpc --format \"[%name%]\" |head -n1`"
	fi


	if [ $PID -gt 0 ]; then 
		if ! ps -p $PID > /dev/null
		then
		   CSONG="restart scroller"
		fi

	fi	

	if [ "$CSONG" != "$TSONG" ]; then
		CSONG=$TSONG

		if [ $PID -gt 0 ]; then 
			kill $PID
			sleep 1
		fi
		./songdisplay.sh "$TSONG" &
		PID=$!

	fi


	kill -SIGSTOP $PID
	echo -en "\E[6n"
	read -sdR CURPOS
	CURPOS=${CURPOS#*[}

	clear
    echo -e -n "\033[2;0H\033[0;31m"
	echo -e "\033[1;33m            P I     R A D I O       "
	echo " "
	echo -e "\033[0;31m           `date "+%d.%m.%Y %H:%M:%S"`   "


    echo -e -n "\033[13;0H\033[0;31m"

    echo -e "\033[1;34m  "
	echo "Press keys 1-9 to choose radio station,"
	echo -e "\033[0;34m + - for volume       / =  next station "
	echo " * = pause playback "
	echo " . = show station information "
	echo -e " \033[1;32m"
	echo "station $STATION  -  volume `mpc | head -n 3 | tail -n 1 | awk {'print $2'}`"
	echo -e " \033[0;37m"
	echo `mpc --format \"[%name%]\" |head -n1`
	echo -e " \033[1;37m"
	echo $TSONG
	
	echo -e -n "\033[${CURPOS}H"
	kill -SIGCONT $PID





	# wir speichern die gedrückte taste in der variable $KEY

	read -t20 -n1 KEY 

	MPC="mpc -h localhost"

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



