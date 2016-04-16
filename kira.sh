#!/bin/bash

if [ -z $2 ]; then
    echo "Usage: $0 <process-regex> <program-name>"
    echo "Example: $0 /usr/bin/cutycapt cutycapt"
    exit
fi

PROCESS_REGEX=$1

PROGRAM_NAME=$2

KIRA_PID=$$

LOG_FILE=/tmp/kira-$PROGRAM_NAME.log
PIDS_FILE=/tmp/kira-$PROGRAM_NAME.pids

touch $PIDS_FILE

function emit_log {
    ms=$(($(date +%s%N)/1000000))
    echo "$ms $1" >> $LOG_FILE
}

function kirapids {

    # kill pids if they have been hanging around for too long.
    for pid in `pgrep -f $PROCESS_REGEX`
      do
        # if pid is listed in the pids_file, kill it.
        if grep -q $pid $PIDS_FILE
          then
            ps_of_pid=`ps -f --no-headers --pid $pid`
            emit_log "killing pid $pid | $ps_of_pid"
            kill $pid
        fi
      done 
    
    # clear the pid file.
    > $PIDS_FILE
    
    # collect pids of the given program, save them to $PIDSFILE.
    for pid in `pgrep -f $PROCESS_REGEX`
      do
        # don't match kira program (self).
        if [ "$pid" != "$KIRA_PID" ]
          then
            emit_log "watching pid $pid"
            echo $pid >> $PIDS_FILE
        fi
      done
}

# call our kira (killer) function.
kirapids
