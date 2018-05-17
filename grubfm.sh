#!/bin/bash

read -p "请输入安装位置 [/]:" directory

if [ -z ${directory} ]; then 
    directory="/"
fi

if [ ! -d ${directory} ];then
	echo "文件夹不存在"
	exit
fi

read -p "请输入GRUB2分区号 [(hd0,msdos1)]:" partition

if [ -z ${partition} ]; then 
    partition="(hd0,msdos1)"
fi

wget https://github.com/FanhuaCloud/grubfm-install/raw/master/grubfm.iso -P ${directory}
wget https://github.com/FanhuaCloud/grubfm-install/raw/master/memdisk -P ${directory}

echo "
#######GRUB Manager#########
menuentry \"GRUB Manager\" {
        set root='${partition}'
        linux16 /memdisk iso raw
        initrd16 /grubfm.iso
}" >> /etc/grub.d/40_custom


sed -i 's%GRUB_TIMEOUT=5%GRUB_TIMEOUT=60%' /etc/default/grub 
grub2-mkconfig -o /boot/grub2/grub.cfg