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
CASE_RESTART="リスタート"
CASE_REBOOT="リブート"
CASE_VIDEO_PC="PC"
CASE_VIDEO="video"

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
    ${CASE_VIDEO}* )
        DIR="tv"
        ACTION="video";;
    ${CASE_VIDEO_PC}* )
        DIR="tv"
        ACTION="video_pc";;
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
    ${CASE_RESTART}* )
        cd /home/pi/dev/slack-speaker;sh ./bin/hubot_restart
        echo "restart" >> /var/log/remoconlog.txt
        exit;;
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
        if [ ${REPEAT} -ne 1 ] ; then
            sleep 1
        fi
    done
fi
