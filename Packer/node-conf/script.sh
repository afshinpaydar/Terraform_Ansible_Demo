#!/bin/sh

case "$1" in 
start)
   docker run -d -p 3000:3000 --name node-app phantasm/node-app.nodejs:latest
   echo $!>/run/node-app-service.pid
   ;;
stop)
   docker stop node-app
   docker rm node-app
   rm /run/node-app-service.pid
   ;;
restart)
   $0 stop
   $0 start
   ;;
status)
   if [ -e /run/node-app-service.pid ]; then
      echo node_app.service is running, pid=`cat /run/node-app-service.pid`
   else
      echo node_app.service is NOT running
      exit 1
   fi
   ;;
*)
   echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 