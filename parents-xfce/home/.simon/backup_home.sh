#!/bin/bash

TODAY=`date '+%Y_%m_%d_%s'`

tar -czvf \
/home/dehaut/.simon/home-backup_$TODAY.tar.gz \
--exclude='/home/dehaut/.cache/*' \
--exclude='/home/dehaut/.googleearth/Cache/*' \
--exclude='/home/dehaut/.local/share/Trash/*' \
--exclude='/home/dehaut/.simon/home-backup*' \
/home/dehaut


