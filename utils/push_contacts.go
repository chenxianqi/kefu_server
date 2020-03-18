package utils

import (
	"encoding/json"
	"kefu_server/models"
	"kefu_server/services"
	"time"
)

// PushNewContacts 推送最新聊天列表给客服
func PushNewContacts(uid int64) {
	contactData, _ := services.GetContactRepositoryInstance().GetContacts(uid)
	// 消息体
	message := models.Message{}
	message.BizType = "contacts"
	message.FromAccount = 1
	message.Timestamp = time.Now().Unix()
	message.ToAccount = uid
	messageContentByte, _ := json.Marshal(contactData)
	message.Payload = string(messageContentByte)
	PushMessage(uid, InterfaceToString(message))
}
