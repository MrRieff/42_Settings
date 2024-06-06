#!/bin/bash

ASCII_HEADER="
    d 888  ,8,\"88e  888     ,e,       888                        
   d8 888   \"  888D 888      \"   dP\"Y 888 88e   e88 88e   ,\"Y88b 
  d88 888e     88P  888     888 C88b  888 888b d888 888b \"8\" 888 
  \"\"\" 888\"    ,*\"   888  ,d 888  Y88D 888 888P Y888 888P ,ee 888 
      888   8888888 888,d88 888 d,dP  888 88\"   \"88 88\"  \"88 888 
"


ARCH=$(uname -srvmo)
PCPU=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)
VCPU=$(grep processor /proc/cpuinfo | uniq | wc -l)
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_USED=$(free -h | grep Mem | awk '{print $3}')
RAM_PERC=$(free -k | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df -k --total | grep total | awk '{print $5}')
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')
LAST_BOOT=$(who -b | awk '{print($3 " " $4)}')
LVM=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
TCP=$(grep TCP /proc/net/sockstat | awk '{print $3}')
USER_LOG=$(who | wc -l)
IP_ADDR=$(hostname -I | awk '{print $1}')
MAC_ADDR=$(ip link show | grep link/ether | awk '{print $2}')
SUDO_LOG=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

echo "$ASCII_HEADER"
wall "
       ------------------------------------------------
       Architecture    : $ARCH
       Physical CPUs   : $PCPU
       Virtual CPUs    : $VCPU
       Memory Usage    : $RAM_USED/$RAM_TOTAL ($RAM_PERC)
       Disk Usage      : $DISK_USED/$DISK_TOTAL ($DISK_PERC)
       CPU Load        : $CPU_LOAD
       Last Boot       : $LAST_BOOT
       LVM use         : $LVM
       TCP Connections : $TCP established
       Users logged    : $USER_LOG
       Network         : $IP_ADDR ($MAC_ADDR)
       Sudo            : $SUDO_LOG commands used
       ------------------------------------------------"
