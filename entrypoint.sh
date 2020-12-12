#!/bin/bash

set -e

if ! [ -z "$CRON" ]
then
  # Prints to stdout without trailing '> /proc/1/fd/1 2>/proc/1/fd/2'
  echo "$CRON" | sed -e $'s/,/\\\n/g' > /etc/crontabs/root
fi

(crond -f) & CRONPID=$!
trap "kill $CRONPID; wait $CRONPID" SIGINT SIGTERM
wait $CRONPID
