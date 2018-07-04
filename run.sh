#!/bin/bash

DIR=""
ACTION=""
REPEAT=1

CASE_TV="テレビ"
CASE_CHANNEL="チャンネル"
CASE_VOLUME="ボリューム"
CASE_HEATER="暖房"
CASE_COOLER="冷房"
CASE_TEMP="温度"
CASE_REBOOT="リブート"

echo $1 >> /var/log/remoconlog.txt

case $1 in
    ${CASE_TV}* )
        DIR="tv"
        ACTION=${1/${CASE_TV}/""};;
    ${CASE_CHANNEL}* )
        DIR="tv"
        ACTION=${1/${CASE_CHANNEL}/""};;
    ${CASE_VOLUME}* )
        DIR="tv"
        ACTION=${1/${CASE_VOLUME}/""};;
    ${CASE_HEATER}* )
        DIR="heater"
        ACTION=${1/${CASE_HEATER}/""}
        REPEAT=3;;
    ${CASE_COOLER}* )
        DIR="cooler"
        ACTION=${1/${CASE_COOLER}/""}
        REPEAT=3;;
    ${CASE_TEMP}* )
        DIR="aircon"
        ACTION=${1/${CASE_TEMP}/""}
        REPEAT=3;;
    ${CASE_REBOOT}* )
        sudo reboot
        echo "reboot!!" >> /var/log/remoconlog.txt
        exit;;
    * )
        sudo reboot
        exit;;
esac

echo "/home/pi/dev/remocon/${DIR}/${ACTION}.txt" >> /var/log/remoconlog.txt

if [ ${DIR} != "" ] ; then
    for i in `seq 1 ${REPEAT}`
    do
        ~/dev/remocon/SendInfraredData /home/pi/dev/remocon/${DIR}/${ACTION}.txt
    done
fi
