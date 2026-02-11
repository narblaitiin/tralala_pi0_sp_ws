#! /usr/bin/bash
# first script test to measure battery discharge time
# version 1.0 - 16/12/22 (add command to disable unnecessary services)
# version 1.1 - 23/01/23 (change the test of while loop)

echo beginning of script

# enable/disable BLE
sudo rfkill block bluetooth
echo bluetooth disable
#sudo rfkill unblock bluetooth
#echo bluetooth enable

# disable HDMI output
sudo /usr/bin/tvservice -o
#sudo /usr/bin/tvservice -p

# go to measurement file directory
cd ~/tralala_pi0_sp_ws/04-measure/data

#MYDATE=$(talkpp -t)
MYDATE=$(talkpp -s)
MYDATE=$(talkpp -f)
echo $MYDATE >> batt_info.txt

ITR=1
BATT=$(talkpp -c B)
echo $BATT >> batt_info.txt

# issue when we test battery level value (warn in file text)
# simple while loop with x iterations
# 288 -> 1 measurement every 5 minutes during one day
while [ $ITR -le 288 ]
do
	echo $ITR
	BATT=$(talkpp -c B)
	echo $BATT >> batt_info.txt
	((ITR++))
	# 1 measurement every 5 minutes 
	sleep 300
done
