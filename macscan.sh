#!/bin/bash
Ip=`ifconfig eth0|awk -F '[:B]' '/inet addr/{print $2}'`
Mask=`ifconfig eth0|awk -F'[:$]' '/inet addr/{print $4}'`
 
for ((i=1;i< =4;i++));do
    Tmp=`echo $Ip|awk -F "." '{printf $'$i'}'`
    Ip_Bin+=`echo "obase=2;$Tmp"|bc|awk '{printf "%08d\\n",$0}'`
    Tmp1=`echo $Mask|awk -F "." '{printf $'$i'}'`
    Mask_Bin+=`echo "obase=2;$Tmp1"|bc|awk '{printf "%08d\\n",$0}'`
done;
 
Mask_Lng=`printf ${Mask_Bin%%0*}|wc -c`
MyNet=${Ip_Bin:0:$Mask_Lng}$(printf "%0$((32-$Mask_Lng))d")
MyBro=${Ip_Bin:0:$Mask_Lng}$(printf "%0$((32-$Mask_Lng))d"|tr 0 1)
 
echo -e "\\n---------- "start at $(date +"%Y-%m-%d %H:%M:%S")"\\n">$HOME/ScanIpMac.lst
for (( i=$((2#$MyNet+1)); i< $((2#$MyBro)); i++ )); do
    Tmp=$(echo "obase=2;$i"|bc)
    Ip=$(for i in {0..3};do test $i != 0 && printf '.'; printf $((2#${Tmp:$i*8:8}));done)
    ping -n -w 1 -c 1 $Ip > /dev/null 2>&1
    if [ $? == 0 ];then
        Mac=`arp -n $Ip|grep $Ip|awk -F " " '{print $3}'`
        echo $Ip"       "$Mac |tee -a $HOME/ScanIpMac.lst
    fi
done;
echo -e "\\n---------- "End at $(date +"%Y-%m-%d %H:%M:%S")>>$HOME/ScanIpMac.lst
 
exit 0