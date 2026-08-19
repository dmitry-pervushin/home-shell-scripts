#!/bin/bash

function probe() {
     local index=$1
     local catpid
     local catfile="/tmp/cat$$"

     echo -ne "Probing ${index}...."
     stty -F ${index} speed 115200 >/dev/null
     rm -f $catfile
     cat ${index} >$catfile 2>/dev/null &
     catpid=$!
     echo -ne "\r\n" > ${index}
     echo -ne "\n\r" > ${index}
     echo -ne "\n" > ${index}
     sleep 1
     kill $catpid 2>/dev/null
     wait $catpid 2>/dev/null
     sleep 1
     if [ -s /tmp/cat ]; then
	echo -ne "OK, $index is responding"
     else
        echo -ne "\r                             \r"
     fi
     rm $catfile
}

for i in $(ls /dev/ttyUSB*); do probe $i; done
echo "Done"
