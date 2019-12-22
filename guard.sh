


# ! /bin/sh

SERVICE_PATH="/home/kefu_server"

SERVICE_NAME="kefu_server"

START_CMD="nohup ./$SERVICE_NAME &"

LOG_FILE="restart.log"

cd $SERVICE_PATH

pwd

while true 

do

    procnum=`ps -ef|grep $SERVICE_NAME|grep -v grep|wc -l`

    if [ $procnum -eq 0 ]

    then

        echo "start service...................."

        echo `date +%Y-%m-%d` `date +%H:%M:%S`  $SERVICE_NAME >>$LOG_FILE

        ${START_CMD}

    fi

    sleep 5
	

done


