#!/bin/bash
#
# Shell script designed to take 3 measures within 1'30
# using a BME680 sensor.
#
# The Solar Pi Platter wakes the Pi up every 30 minutes during the day and allows
# the RFM95W LoRa module, taking 3 measures every 30 seconds, storing the power information in a file
# file and sending to LoRa gateway server.
#
# The script is designed to be run by /etc/rc.local when the Pi boots.  It looks at
# the power-up reason and does not execute if the Pi was powered on because the user
# powered up using the Solar Pi Platter button.
#

echo beginning of script

# times to start and stop each date are military format: HHMM
STARTOFDAY=0800
ENDOFDAY=2000

# time (in seconds) between two data transmissions
TIMELAPSE=900		# 15 mins

# time (in seconds) between two battery test
TIMELOWBATT=1800		# 30 mins

# get the date from the RTC
MYDATE=$(talkpp -t)			# device RTC with the current system clock
MYHHMM=${MYDATE:4:4}

# set our date from the RTC
echo "setup date from RTC"
date $MYDATE

# get the power-up reason from the board (along with other status)
STATUS=$(talkpp -c S)

# set our next wakeup time
echo "setup wakeup and alarm"
if [ $MYHHMM -gt $ENDOFDAY ]; then
	# getting dark: Set an alarm for tomorrow morning
	talkpp -a $(date --date=tomorrow +%m%d$STARTOFDAY%Y.00)
else
	# set an alarm for 30 minutes from now
	talkpp -d $TIMELAPSE
fi

# enable the alarm
echo "alarm ON"
talkpp -c C0=1

# get the current board status
STATUS=$(talkpp -c S)

# read battery voltage
echo "battery test"
BATT=$(talkpp -c B)

if [ $BATT -lt 3.45 ]; then
    talkpp -d $TIMELOWBATT  # set to restart Pi Platter in 10 mins
    talkpp -c O=30  		# turn off Pi Platter in 30 seconds
else
	# initialisation of our raspberry pi zero
    echo "run python script to read sensor and send data to TTN"
	echo $MYDATE,$BATT,$STATUS >> ~/tralala_pi0_sp_ws/03-run/data/power_info.txt
	python ~/tralala_pi0_sp_ws/01-hardware/tests/test_data_ttn_abp.py
fi

# shutdown and then power off
echo "shutdown Pi Platter board"
talkpp -c O=30