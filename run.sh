#!/bin/bash

DIR=""
ACTION=""
REPEAT=1

CASE_TV="テレビ"
CASE_CHANNEL="チャンネル"
CASE_VOLUME="ボリューム"
CASE_AIRCON="エアコン"
CASE_TEMP="温度"

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
    ${CASE_AIRCON}* )
        DIR="aircon"
        ACTION=${1/${CASE_AIRCON}/""}
        REPEAT=3;;
    ${CASE_TEMP}* )
        DIR="aircon"
        ACTION=${1/${CASE_TEMP}/""}
        REPEAT=3;;
esac

if [ ${DIR} != "" ] ; then
    for i in `seq 1 ${REPEAT}`
    do
        ~/dev/remocon/SendInfraredData /home/pi/dev/remocon/${DIR}/${ACTION}.txt
    done
fi
