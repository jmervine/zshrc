#!/bin/bash

REPOS="$HOME/.ssh
$HOME/.bin
$HOME/.vim
$HOME/sbin"

LOG="$HOME/.synclog"

running=`ps aux | grep syncgit.sh | grep -v grep | wc -l`
#echo $running 
# this script also shows up in grep so I would get if runnig = 2, but it's 3 for some reason
if [ $running -lt 3 ]; then
    while [ 1 ]; do
	cd
        echo `date` >> $LOG
	for repo in $REPOS; do
		if [ -d $repo ]; then
			echo $repo >> $LOG
			cd $repo
			echo "$repo, committing changes" >> $LOG
			git commit -a -m "auto upload" 2>&1 >> $LOG
			echo "$repo, pulling updates" >> $LOG
			git pull 2>&1 >> $LOG
			echo "$repo, pushing updates" >> $LOG
			git push origin master 2>&1 >> $LOG
		else
			echo "$repo not found" >> $LOG
		fi
	done
	echo "sleeping for 600 seconds" >> $LOG
        sleep 600
    done
fi


