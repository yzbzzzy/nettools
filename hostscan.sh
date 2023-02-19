#!/bin/bash
if [ -f $filename ];then
   echo "the file is exist" 
 for n in {100..106};do
      host=192.168.0.$n
      ping -c2 $host &>/dev/null
      if [ $? = 0 ];then
         echo "$host is up"
         echo "$host" >> /tmp/alive.txt
      else
          echo "$host is Down"
      fi
   done
      echo "------------------`date +"%Y-%m-%d"`-------------------------------"
 else
   echo "the file is not exist"
   touch /root/alive.txt
fi