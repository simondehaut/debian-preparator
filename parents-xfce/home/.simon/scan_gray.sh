#!/bin/bash

if [ ! -d "~/doc/" ] 
then
    mkdir ~/doc
fi

if [ ! -d "~/doc/scan" ] 
then
    mkdir ~/doc/scan
fi

cd ~/doc/scan

hp-scan --device=hpaio:/usb/Deskjet_3520_series?serial=CN27B1275D05SY --resolution=300 --mode=gray --compression=jpeg
