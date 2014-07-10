#!/bin/bash

while true ; do
	~/.bin/mail-job.sh
	~/.bin/msmtp-runqueue.sh
	sleep 3
done
