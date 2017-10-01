#!/bin/bash

if [[ $# != 2 ]]
then
    echo "Usage: $0 template-file information file";
    exit
fi

template=`cat $1`
echo "Template is ${template}"
exec 3<$2

lines=`cat $2|wc -l`
x=1335
y=2315

if adb get-state 1>/dev/null 2>&1
then
    echo 'device attached'
else
    echo 'no device attached'
    exit 1
fi

read -r -p "Do you want to fit touch coordinates?[y/N]" isfit
isfit=${isfit,,}
if [[ "${isfit}" =~ ^(yes|y)$ ]]
then
    echo "Please touch the send button after about 10 seconds(when your cursor doesn't blink any more)"
    coor=`adb shell getevent -c 10 2>/dev/null | awk '$3=="0035"{print $4," "} $3=="0036"{print $4;exit 0}' 2>/dev/null`
    coor_x_y=($coor)
    x=`echo $((0x${coor_x_y[0]}))`
    y=`echo $((0x${coor_x_y[1]}))`
fi

i=1
while read line <&3
do
    IFS=","
    arr=($line)
    IFS=$'\n'
    message=${template}
    message=${message//'{{MACRO1}}'/${arr[1]}}
    message=${message//'{{MACRO2}}'/${arr[2]}}
    adb shell am start -a android.intent.action.SENDTO -d sms:${arr[0]} --es sms_body "\""${message}"\"" &>/dev/null
    sleep 1
    adb shell input tap ${x} ${y} &>/dev/null
    sleep 1
    adb shell input keyevent 4 &>/dev/null
    rate=$((100*${i}/${lines}))
    bar=""
    for((q=0;$q<=rate;q+=2))
    do
        bar=#$bar
    done
    printf "Sending:[%-50s]%d%%" $bar $rate
    if [[ $lines -eq $i ]]
    then
        printf " Send Message To %s %s %s\n" ${arr[0]} ${arr[1]} ${arr[2]}
    else
        printf " Send Message To %s %s %s\r\r" ${arr[0]} ${arr[1]} ${arr[2]}
    fi
    let i+=1
done
echo "DONE!"
