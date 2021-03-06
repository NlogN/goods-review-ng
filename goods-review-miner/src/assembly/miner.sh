#!/bin/sh

#
# usage:
# ./miner.sh (start|restart|stop)
#

LOG=miner.log
PID=../miner.pid

start() {
    LANG=ru_RU.UTF8

    CLASSPATH=`find lib -name '*.jar' -printf '%p:'`$CLASSPATH

    if [ -s $PID ]; then
        echo already started.
        return
    fi

    java -classpath $CLASSPATH \
        -Dfile.encoding=UTF8 \
        -showversion -server -Xverify:none \
        -Xmx128m -Xms64m -XX:+UseConcMarkSweepGC -XX:+HeapDumpOnOutOfMemoryError \
         ru.goodsreview.core.util.Main classpath:run-miner-bean.xml >> $LOG 2>&1 &

    echo $! > $PID
    echo server started
}

stop() {
     if [ ! -s $PID ]; then
         echo already stopped.
         return
     fi

     kill $(cat $PID)
     rm $PID
     echo server stoped
}

case "$1" in

start)
  start
  ;;

stop)
  stop
  ;;

restart)
  stop
  start
esac