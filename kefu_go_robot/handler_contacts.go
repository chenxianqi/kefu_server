package robotlbrary

import (
	"encoding/base64"
	"encoding/json"
	"kefu_server/models"
	"strconv"
	"time"

	"github.com/Xiaomi-mimc/mimc-go-sdk"
	"github.com/astaxie/beego/orm"
)

// PushNewContacts 推送最新聊天列表给客服
func PushNewContacts(accountID int64, robot *mimc.MCUser) {
	o := orm.NewOrm()
	var contactDto []models.ContactDto
	// 消息体
	message := models.Message{}
	message.BizType = "contacts"
	robotAccount, _ := strconv.ParseInt(robot.AppAccount(), 10, 64)
	message.FromAccount = robotAccount
	message.Timestamp = time.Now().Unix()
	rCount, _ := o.Raw("SELECT c.id AS cid,c.to_account,c.is_session_end, c.last_message,c.last_message_type,c.from_account, c.create_at AS contact_create_at,u.*, IFNULL(m.`count`,0) AS `read` FROM  `contact` c LEFT JOIN `user` u ON c.from_account = u.id LEFT JOIN (SELECT to_account,from_account, COUNT(*) as `count` FROM message WHERE `read` = 1 GROUP BY to_account,from_account) m ON m.to_account = c.to_account AND m.from_account = c.from_account WHERE c.to_account = ? AND c.delete = 0 ORDER BY c.create_at DESC", accountID).QueryRows(&contactDto)
	if rCount == 0 {
		contactDto = []models.ContactDto{}
	}
	// base 64转换回来
	for index, contact := range contactDto {
		payload, _ := base64.StdEncoding.DecodeString(contact.LastMessage)
		contactDto[index].LastMessage = string(payload)
	}
	message.ToAccount = accountID
	messageContentByte, _ := json.Marshal(contactDto)
	message.Payload = string(messageContentByte)
	messageJSON, _ := json.Marshal(message)
	messageString := base64.StdEncoding.EncodeToString([]byte(messageJSON))
	robot.SendMessage(strconv.FormatInt(accountID, 10), []byte(messageString))
}
