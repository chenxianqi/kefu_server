package im

import (
	"encoding/base64"
	"kefu_server/models"
	"strconv"
	"time"

	"github.com/astaxie/beego/orm"
)

// MessageInto push message
func MessageInto(message models.Message, isKF bool) {
	// orm instance
	o := orm.NewOrm()

	// 不处理的类型
	if message.BizType == "contacts" || message.BizType == "pong" || message.BizType == "welcome" || message.BizType == "into" || message.BizType == "search_knowledge" {
		return
	}

	// 判断是否是撤回消息（删掉数据库消息）
	if message.BizType == "cancel" {
		key, _ := strconv.ParseInt(message.Payload, 10, 64)
		_, _ = o.Raw("DELETE FROM message WHERE from_account = ? AND to_account = ? AND `key` = ?", message.FromAccount, message.ToAccount, key).Exec()
	}

	// message create time
	message.Timestamp = time.Now().Unix()

	// content内容转base64
	message.Payload = base64.StdEncoding.EncodeToString([]byte(message.Payload))

	// 过滤掉下面类型的消息不入库
	if !(message.BizType == "handshake") {

		if !isKF {
			// 默认已读消息
			message.Read = 0
			user := models.User{ID: message.ToAccount}
			if err := o.Read(&user); err == nil && user.Online == 0 {
				message.Read = 1
			}
			if user.IsWindow == 0 {
				message.Read = 1
			}
		}

		// message.BizType == "end" is not read
		if message.BizType == "end" || message.BizType == "timeout" {
			message.Read = 0
		}

		// 消息入库
		_, _ = o.Insert(&message)

	}

	// 判断是否和机器人对话（不处理聊天列表）
	var r []orm.Params
	robotCount, _ := o.Raw("SELECT * FROM robot WHERE id IN(?, ?)", message.ToAccount, message.FromAccount).Values(&r)
	if robotCount > 0 {
		return
	}

	// 处理客服聊天列表
	var contact models.Contact
	qs := o.QueryTable(new(models.Contact))
	if err := qs.Filter("from_account__in", message.FromAccount, message.ToAccount).Filter("to_account__in", message.ToAccount, message.FromAccount).One(&contact); err != nil {
		contact.ToAccount = message.ToAccount
		contact.FromAccount = message.FromAccount
		contact.LastMessageType = message.BizType
		contact.CreateAt = time.Now().Unix()
		contact.LastMessage = message.Payload
		o.Insert(&contact)
	} else {
		contact.LastMessageType = message.BizType
		contact.CreateAt = time.Now().Unix()
		contact.LastMessage = message.Payload
		contact.IsSessionEnd = 0
		contact.Delete = 0
		if message.BizType == "end" || message.BizType == "timeout" {
			contact.IsSessionEnd = 1
		}
		o.Update(&contact)
	}

}
