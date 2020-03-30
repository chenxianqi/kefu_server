


# ! /bin/sh
CURRENT_PATH=$(readlink -f "$(dirname "$0")")
SERVICE_NAME="kefu_server"
START_CMD_SERVER="nohup ./$SERVICE_NAME &"
LOG_FILE="restart.log"
cd $CURRENT_PATH
pwd
while true 
do
    procnum_server=`ps -ef|grep $SERVICE_NAME|grep -v grep|wc -l`
    if [ $procnum_server -eq 0 ]
    then
        echo "start service...................."
        echo `date +%Y-%m-%d` `date +%H:%M:%S`  $SERVICE_NAME >>$LOG_FILE
        ${START_CMD_SERVER}
    fi
    sleep 5
done


