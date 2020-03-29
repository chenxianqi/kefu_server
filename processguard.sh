


# ! /bin/sh
CURRENT_PATH=$(readlink -f "$(dirname "$0")")
SERVICE_PATH="$CURRENT_PATH/kefu_server"
ROBOT_SERVICE_PATH="$SERVICE_PATH/robot"
SERVICE_NAME="kefu_server"
ROBOT_SERVICE_NAME="kefu_go_robot"
START_CMD_SERVER="nohup ./$SERVICE_NAME &"
START_CMD_ROBOT="nohup ./$ROBOT_SERVICE_NAME &"
LOG_FILE="restart.log"
cd $SERVICE_PATH
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
    procnum_robot=`ps -ef|grep $ROBOT_SERVICE_NAME|grep -v grep|wc -l`
    if [ $procnum_robot -eq 0 ]
    then
        echo "start robot service...................."
        echo `date +%Y-%m-%d` `date +%H:%M:%S`  $ROBOT_SERVICE_NAME >>$LOG_FILE
        ${START_CMD_ROBOT}
    fi
    sleep 5
done


