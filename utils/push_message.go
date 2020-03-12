package utils

import (
	"fmt"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
)

// PushMessage send message
// toAccount receive message account
// bizType message type
// msg message base 64
func PushMessage(toAccount int64, msg string) bool {
	appID, _ := beego.AppConfig.Int64("mimc_appId")
	appKey := beego.AppConfig.String("mimc_appKey")
	appSecret := beego.AppConfig.String("mimc_appSecret")
	api := "https://mimc.chat.xiaomi.net/api/push/p2p/"
	var request = map[string]string{}
	request["appId"] = strconv.FormatInt(appID, 10)
	request["appKey"] = appKey
	request["appSecret"] = appSecret
	request["fromAccount"] = "1"
	request["toAccount"] = strconv.FormatInt(toAccount, 10)
	request["msg"] = msg
	response := HTTPRequest(api, "POST", request, "")
	logs.Info(response)
	if response.Code != 200 {
		fmt.Println(response)
		return false
	}

	return true

}
