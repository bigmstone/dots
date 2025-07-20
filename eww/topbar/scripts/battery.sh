#!/bin/bash

## Get battery info
BATTERY=$(acpi | awk -F ' ' 'NR==1 {print $4}' | tr -d '%',)
CHARGE=$(acpi | awk -F ' ' 'NR==1 {print $3}')
ADAPTER=$(acpi -a | awk -F ' ' '{print $3}')

main() {
	if [[ "$CHARGE" == *"Charging"* ]] && [[ "$BATTERY" -lt 100 ]]; then
		echo ""
		echo -n "$BATTERY"
	elif [[ "$ADAPTER" == *"on-line"* ]] && [[ "$CHARGE" != *"Charging"* ]]; then
		echo "No Charge"
	else
		if [[ "$BATTERY" -lt 100 && "$BATTERY" -ge 66 ]]; then
			echo ""
		elif [[ "$BATTERY" -lt 66 && "$BATTERY" -ge 35 ]]; then
			echo ""
		elif [[ "$BATTERY" -lt 35 && "$BATTERY" -ge 15 ]]; then
			echo ""
		elif [[ "$BATTERY" -lt 15 && "$BATTERY" -ge 0 ]]; then
			echo ""
		fi
	fi
}

if [[ "$1" == '--icon' ]]; then
	main
elif [[ "$1" == '--perc' && "$CHARGE" == *"Charging"* ]]; then
	echo -n "$BATTERY"
elif [[ "$1" == '--perc' ]] && [[ "$ADAPTER" == *"on-line"* ]] && [[ "$CHARGE" != *"Charging"* ]]; then
	echo -n "Plugged"
elif [[ "$1" == '--perc' ]]; then
	echo -n "$BATTERY%"
fi
