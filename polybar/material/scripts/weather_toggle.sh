#!/bin/bash

t=0
sleep_pid=0

toggle() {
	t=$(((t + 1) % 2))
	if [ "$sleep_pid" -ne 0 ]; then
		kill $sleep_pid >/dev/null 2>&1
	fi
}

trap "toggle" USR1

while true; do
	if [ $t -eq 0 ]; then
		sh $HOME/.config/polybar/material/scripts/weather.sh --widget
		##Here to change between each weather update (900s means 15 minutes between updates) from open-meteo (it will also update if you toggle the widget).
		sleep 900 &
	else
		sh $HOME/.config/polybar/material/scripts/weather.sh --text
		sleep 300 &
	fi
	sleep 1 &
	sleep_pid=$!
	wait
done
