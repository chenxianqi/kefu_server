package robotlbrary

import (
	"encoding/base64"
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"
	"strings"
	"time"

	"github.com/Xiaomi-mimc/mimc-go-sdk"
	"github.com/astaxie/beego/cache"
	"github.com/astaxie/beego/orm"
)

// PayloadData struct
type PayloadData struct {
	Payload string `json:"payload"`
}

// KnowledgeBaseData struct
type KnowledgeBaseData struct {
	Title string `json:"title"`
}

// ContactAdminCount struct
type ContactAdminCount struct {
	Count     string `json:"count"`
	ToAccount string `json:"to_account"`
}

// adminData struct
type adminData struct {
	ID       int64  `json:"id"`
	NickName string `json:"nickname"`
	Avatar   string `json:"avatar"`
}

// BmCache ...
var BmCache, _ = cache.NewCache("memory", `{"interval":60}`)

// MessageP2P p2p message
func MessageP2P(message models.Message) {

	// orm
	o := orm.NewOrm()

	// 当前服务机器人
	var robot *mimc.MCUser
	var robotID int64
	msgToAccount := strconv.FormatInt(message.ToAccount, 10)
	isFromAccountRobot := false
	for _, robot = range Robots {
		robotID, _ = strconv.ParseInt(robot.AppAccount(), 10, 64)
		if robotID == message.FromAccount {
			isFromAccountRobot = true
			return
		}
		if toAccount := robot.AppAccount(); toAccount == msgToAccount {
			break
		}
	}

	if isFromAccountRobot {
		return
	}

	// 是否是入库消息(中转入库)
	if message.BizType == "into" {
		var intoMessage models.Message
		intoMessageString, _ := base64.StdEncoding.DecodeString(message.Payload)
		_ = json.Unmarshal(intoMessageString, &intoMessage)
		// 接收方是否是客服
		isKF := false
		admin := models.Admin{ID: intoMessage.ToAccount}
		if err := o.Read(&admin); err == nil {
			isKF = true
			intoMessage.Read = 0
			if admin.Online == 0 || admin.CurrentConUser != intoMessage.FromAccount {
				intoMessage.Read = 1
			}
		}
		utils.MessageInto(intoMessage, isKF)
		if isKF {
			PushNewContacts(intoMessage.ToAccount, robot)
		}
		admin1 := models.Admin{ID: intoMessage.FromAccount}
		if err := o.Read(&admin1); err == nil {
			PushNewContacts(intoMessage.FromAccount, robot)
		}
		return
	}

	// 不处理的消息类型
	if message.BizType == "cancel" {
		key, _ := strconv.ParseInt(message.Payload, 10, 64)
		_, _ = o.Raw("UPDATE message SET `delete` = 1 WHERE from_account = ? AND to_account = ? AND `key` = ?", message.FromAccount, message.ToAccount, key).Exec()
		return
	}

	// 取出发信人信息
	userData := models.User{ID: message.FromAccount}
	userInfoKey := "userInfo"
	if userTemp := BmCache.Get(userInfoKey); userTemp == nil {
		userData = models.User{ID: message.FromAccount}
		_ = o.Read(&userData)
		robotDataJSON, _ := json.Marshal(userData)
		_ = BmCache.Put(userInfoKey, robotDataJSON, 60*time.Second)
	} else {
		_ = json.Unmarshal([]byte(string(userTemp.([]byte))), &userData)
	}

	// 获取公司配置
	companyData := models.Company{ID: 1}
	systemInfoKey := "systemInfo"
	if systemTemp := BmCache.Get(systemInfoKey); systemTemp == nil {
		companyData = models.Company{ID: 1}
		_ = o.Read(&companyData)
		robotDataJSON, _ := json.Marshal(companyData)
		_ = BmCache.Put(systemInfoKey, robotDataJSON, 60*time.Second)
	} else {
		_ = json.Unmarshal([]byte(string(systemTemp.([]byte))), &companyData)
	}

	// 数据库获取机器人配置信息
	robotData := models.Robot{ID: message.ToAccount}
	cacheRobotKey := "robot_" + msgToAccount
	if robotDataTemp := BmCache.Get(cacheRobotKey); robotDataTemp == nil {
		robotData = models.Robot{ID: message.ToAccount}
		_ = o.Read(&robotData)
		robotDataJSON, _ := json.Marshal(robotData)
		_ = BmCache.Put(cacheRobotKey, robotDataJSON, 60*time.Second)
	} else {
		_ = json.Unmarshal([]byte(string(robotDataTemp.([]byte))), &robotData)
	}

	// 消息体
	callbackMessage := models.Message{}

	//  没有找到子标题的内容, 不明白语句
	var understand = robotData.Understand

	// 无法匹配知识库默认关键词[]string
	roobtKeyWords := strings.Split(strings.Trim(robotData.KeyWord, "|"), "|")

	// 返回给对方的消息内容
	var messageContent string
	// 返回的消息类型
	bizType := "text"

	//检索关键词知识库消息
	var knowledgeBases []KnowledgeBaseData
	if message.BizType == "search_knowledge" {
		// 默认关键词
		var subTitle = ""
		for _, value := range roobtKeyWords {
			if strings.Contains(message.Payload, value) {
				subTitle = subTitle + " sub_title LIKE '%" + value + "%' OR "
			}
		}
		if subTitle != "" {
			subTitle = subTitle[1 : len(subTitle)-3]
		}
		_, _ = o.Raw("SELECT title,sub_title FROM knowledge_base WHERE ("+subTitle+") AND platform IN (?,?) ORDER by rand() limit 5", 1, userData.Platform).QueryRows(&knowledgeBases)
		bizType = "search_knowledge"
		if len(knowledgeBases) > 0 {
			messageContentByte, _ := json.Marshal(knowledgeBases)
			messageContent = string(messageContentByte)
		} else {
			messageContent = ""
		}

		// 判断是否是握手消息
	} else if message.BizType == "handshake" {
		messageContent = robotData.Welcome
		bizType = "welcome"
	} else {

		// 判断是否符合转人工
		artificial := strings.Split(strings.Trim(robotData.Artificial, "|"), "|")
		isTransfer := false
		if message.Payload == "人工" {
			isTransfer = true
		} else {
			for i := 0; i < len(artificial); i++ {
				if artificial[i] == message.Payload {
					isTransfer = true
					break
				}
			}
		}

		// 符合
		if isTransfer {
			var admins []models.Admin
			_, _ = o.Raw("SELECT a.*, IFNULL(c.count,0) AS `count` FROM admin as a LEFT  JOIN (SELECT to_account,COUNT(*) AS count FROM `contact` WHERE is_session_end = 0 GROUP BY to_account) c ON a.id = c.to_account WHERE a.`online` = 1 ORDER BY c.count").QueryRows(&admins)
			if len(admins) <= 0 {
				messageContent = robotData.NoServices
			} else {
				// 平均分配客服
				admin := admins[0]
				adminDataJSON, _ := json.Marshal(adminData{ID: admin.ID, NickName: admin.NickName, Avatar: admin.Avatar})
				messageContent = string(adminDataJSON)

				// 发送一条消息告诉客服端
				var newMsgJSON []byte
				var newMsgBase64 string
				newMsg := models.Message{}
				newMsg.BizType = "transfer"
				newMsg.FromAccount = message.FromAccount
				newMsg.ToAccount = admin.ID
				newMsg.Timestamp = time.Now().Unix()
				newMsg.TransferAccount = admin.ID
				newMsg.Payload = "系统将客户分配给您"
				newMsgJSON, _ = json.Marshal(newMsg)
				newMsgBase64 = base64.StdEncoding.EncodeToString([]byte(newMsgJSON))

				// 消息入库
				utils.MessageInto(newMsg, true)
				robot.SendMessage(strconv.FormatInt(admin.ID, 10), []byte(newMsgBase64))
				newMsg.FromAccount = robotID
				newMsg.ToAccount = message.FromAccount
				newMsg.Payload = messageContent
				newMsgJSON, _ = json.Marshal(newMsg)
				newMsgBase64 = base64.StdEncoding.EncodeToString([]byte(newMsgJSON))
				robot.SendMessage(strconv.FormatInt(message.FromAccount, 10), []byte(newMsgBase64))

				// 帮助客服发送欢迎语
				newMsg.BizType = "text"
				newMsg.Payload = admin.AutoReply
				newMsg.ToAccount = message.FromAccount
				newMsg.FromAccount = admin.ID
				newMsgJSON, _ = json.Marshal(newMsg)
				newMsgBase64 = base64.StdEncoding.EncodeToString([]byte(newMsgJSON))

				// 消息入库
				utils.MessageInto(newMsg, true)
				robot.SendMessage(strconv.FormatInt(admin.ID, 10), []byte(newMsgBase64))
				robot.SendMessage(strconv.FormatInt(message.FromAccount, 10), []byte(newMsgBase64))

				PushNewContacts(admin.ID, robot)

				// 转接入库用于统计服务次数
				servicesStatistical := models.ServicesStatistical{UserAccount: message.FromAccount, ServiceAccount: admin.ID, Platform: message.Platform, TransferAccount: robotID, CreateAt: time.Now().Unix()}
				_, _ = o.Insert(&servicesStatistical)
				return
			}

			// 不符合去查知识库
		} else {

			// 数据库查找知识库主标题
			qs := o.QueryTable(new(models.KnowledgeBase))

			// 先完全匹配
			var knowledge models.KnowledgeBase
			err := qs.Filter("title", message.Payload).Filter("platform__in", 1, userData.Platform).One(&knowledge)
			if err == nil {

				bizType = "text"
				messageContent = knowledge.Content
				// 模糊匹配列表返回列表
			} else {

				_, _ = o.Raw("SELECT title FROM knowledge_base WHERE title LIKE ? AND platform IN (?,?) ORDER by rand() limit 4", "%"+message.Payload+"%", 1, userData.Platform).QueryRows(&knowledgeBases)
				if len(knowledgeBases) > 0 {
					bizType = "knowledge"
					messageContentByte, _ := json.Marshal(knowledgeBases)
					messageContent = string(messageContentByte)
				} else {
					// 没有找到再次找副标题
					_, _ = o.Raw("SELECT title,sub_title FROM knowledge_base WHERE sub_title LIKE ? AND platform IN (?,?) ORDER by rand() limit 4", "|%"+message.Payload+"%|", 1, userData.Platform).QueryRows(&knowledgeBases)
					if len(knowledgeBases) > 0 {
						bizType = "knowledge"
						messageContentByte, _ := json.Marshal(knowledgeBases)
						messageContent = string(messageContentByte)
					} else {
						// 默认关键词
						var subTitle = ""
						for _, value := range roobtKeyWords {
							subTitle = subTitle + " sub_title LIKE '%" + value + "%' OR "
						}
						subTitle = subTitle[1 : len(subTitle)-3]
						_, _ = o.Raw("SELECT title,sub_title FROM knowledge_base WHERE ("+subTitle+") AND platform IN (?,?) ORDER by rand() limit 4", 1, userData.Platform).QueryRows(&knowledgeBases)
						if len(knowledgeBases) > 0 {
							bizType = "knowledge"
							messageContentByte, _ := json.Marshal(knowledgeBases)
							messageContent = string(messageContentByte)
						} else {
							messageContent = understand
						}
					}
				}
			}

		}
	}

	// 消息体
	callbackMessage.BizType = bizType
	callbackMessage.FromAccount = message.ToAccount
	callbackMessage.Timestamp = time.Now().Unix() + 1
	callbackMessage.ToAccount = message.FromAccount
	callbackMessage.Key = time.Now().Unix()
	callbackMessage.Payload = messageContent
	messageJSON, _ := json.Marshal(callbackMessage)
	messageString := base64.StdEncoding.EncodeToString([]byte(messageJSON))

	// 发给用户
	robot.SendMessage(strconv.FormatInt(message.FromAccount, 10), []byte(messageString))

	// 消息入库
	utils.MessageInto(callbackMessage, false)

}
