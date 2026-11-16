#!/bin/bash
/root/openlumara/run.sh &
/usr/sbin/sshd -D -e &
wait -n