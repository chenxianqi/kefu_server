package utils

import (
	"encoding/base64"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"
	"time"

	"github.com/astaxie/beego/orm"
)

// MessageInto push message
func MessageInto(message models.Message, isKF bool) {

	// 不处理的类型
	if message.BizType == "contacts" || message.BizType == "pong" || message.BizType == "welcome" || message.BizType == "into" || message.BizType == "search_knowledge" {
		return
	}

	// init MessageRepository
	messageRepository := new(services.MessageRepository)
	messageRepository.Init(new(models.Message))

	// 判断是否是撤回消息（软删除）
	if message.BizType == "cancel" {
		key, _ := strconv.ParseInt(message.Payload, 10, 64)
		_, _ = messageRepository.Delete(models.RemoveMessageRequestData{FromAccount: message.FromAccount, ToAccount: message.ToAccount, Key: key})
	}

	// message create time
	message.Timestamp = time.Now().Unix()

	// content内容转base64
	message.Payload = base64.StdEncoding.EncodeToString([]byte(message.Payload))

	// 过滤掉下面类型的消息不入库
	if !(message.BizType == "handshake") {

		if !isKF {
			// init UserRepository
			userRepository := new(services.UserRepository)
			userRepository.Init(new(models.User))
			// 默认已读消息
			message.Read = 0
			user := userRepository.GetUser(message.ToAccount)
			if user != nil && user.Online == 0 {
				message.Read = 1
			}
			if user != nil && user.IsWindow == 0 {
				message.Read = 1
			}
		}

		// message.BizType == "end" is not read
		if message.BizType == "end" || message.BizType == "timeout" {
			message.Read = 0
		}

		// 消息入库
		_, _ = messageRepository.Add(&message)

	}

	// init RobotRepository
	robotRepository := new(services.RobotRepository)
	robotRepository.Init(new(models.Robot))

	// 判断是否机器人对话（不处理聊天列表）
	if rbts, _ := robotRepository.GetRobotWithInIds(message.ToAccount, message.FromAccount); len(rbts) > 0 {
		return
	}

	// init ContactRepository
	contactRepository := new(services.ContactRepository)
	contactRepository.Init(new(models.Contact))

	// 处理客服聊天列表
	if contact, err := contactRepository.GetContactWithIds(message.ToAccount, message.FromAccount); err != nil {
		contact.ToAccount = message.ToAccount
		contact.FromAccount = message.FromAccount
		contact.LastMessageType = message.BizType
		contact.CreateAt = time.Now().Unix()
		contact.LastMessage = message.Payload
		_, _ = contactRepository.Add(contact)
	} else {
		isSessionEnd := 0
		if message.BizType == "end" || message.BizType == "timeout" {
			isSessionEnd = 1
		}
		_, _ = contactRepository.UpdateParams(contact.ID, orm.Params{
			"LastMessageType": message.BizType,
			"CreateAt":        time.Now().Unix(),
			"LastMessage":     message.Payload,
			"IsSessionEnd":    isSessionEnd,
			"Delete":          0,
		})
	}

}
