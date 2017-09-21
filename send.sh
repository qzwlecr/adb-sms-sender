#!/bin/bash
if [ $# != 2 ] ;then
    echo "Usage : $0 template-file user-file";
    exit
fi

template=`cat $1`
echo "Template is"
echo ${template}
exec 3<$2
while read line <&3
do
    IFS=","
    arr=($line)
    IFS=$'\n'
    message=${template}
    message=${message//'${NAME}'/${arr[0]}}
    echo "Send Message to ${arr[0]} ${arr[1]}"
    adb shell am start -a android.intent.action.SENDTO -d sms:${arr[1]} --es sms_body "\""${message}"\""
    sleep 1
    adb shell input tap 1335 2315
    sleep 1
    adb shell input keyevent 4
    sleep 1
    adb shell input keyevent 4
    sleep 1
done
