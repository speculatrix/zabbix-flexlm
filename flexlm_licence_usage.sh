#!/bin/bash
# a script to discover and measure flexlm licence usage
#
# 1. input the template into zabbix server
# 2. put this script into /opt/zabbix/bin and make it executable
# 3. create a file called /etc/zabbix_agentd.conf.d/flexlm_licence_usage.conf
# and make it contain the following three lines:
# UserParameter=flexlm.discovery,/opt/zabbix/bin/flexlm_licence_usage discovery
# UserParameter=flexlm.used[*],/opt/zabbix/bin/flexlm_licence_usage used $1
# UserParameter=flexlm.total[*],/opt/zabbix/bin/flexlm_licence_usage total $1
# 4. restart the zabbix agent

# capture $1 and $2 before they're lost
ARG1="$1"
ARG2="$2"

LICENCE_FILE="/opt/flexlm/licence.dat"
LM_BIN_DIR="/opt/flexlm/bin"

# we keep a cache of flexlm status so we don't have to
# keep interrogating the manager daemon
STAT_FILE="/var/run/zabbix/flexlm_licence_usage-stat.txt"
MAX_AGE=300	# 300s = 5 mins max age of stat file

### cache maintenance ###
# if the stat file exists, then see how old it,
# if too old delete it
if [ -f "$STAT_FILE" ] ; then
	EPOCH_TIME=$( date +%s )
	FILE_AGE=$( stat -c %Y "$STAT_FILE" )

	AGE=$(( $EPOCH_TIME - $FILE_AGE ))

	if [ $AGE -gt $MAX_AGE ] ; then
		rm "$STAT_FILE"
		#echo "Debug, deleting too old stat file"
	fi
fi


# generate the stat file if it doesn't exist
if [ ! -f "$STAT_FILE" ] ; then
	"$LM_BIN_DIR/lmutil" lmstat -c "$LICENCE_FILE" -a | \
		grep '^Users of' | \
		sed 's/:/ /' > "$STAT_FILE"
fi

# if the stat file created was empty, throw and error
if [ ! -s "$STAT_FILE" ] ; then
	echo -999
	exit
fi


#### handle the specific query from zabbix ###

if [ "$ARG1" == "discovery" ] ; then
	# generate the json in response to discovery query
	FEATURES=$( awk '{print $3 }' < "$STAT_FILE" )

	echo -n '{"data":['
	FIRSTLOOP=1
	for FF in $FEATURES ; do
		if [ "$FIRSTLOOP" -eq 0 ] ; then
			echo -n ","
		fi
		echo -n "{\"{#FEATURE}\":\"$FF\"}"
		FIRSTLOOP=0
	done
	echo "]}"

else
	# extract a specific value
	if [ "$ARG1" == "total" ] ; then
		value=$( awk "/ $ARG2/{print \$6 }" < "$STAT_FILE" )
	elif [ "$ARG1" == "used" ] ; then
		value=$( awk "/ $ARG2/{print \$11 }" < "$STAT_FILE" )
	else
		#value=$ARG1--$ARG2
		value=-5	# indicates error
	fi

	echo $value

fi

# end of hacky zabbix agent-side flexlm_check extension
