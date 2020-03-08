package task

import (
	"encoding/base64"
	"encoding/json"
	"kefu_server/im"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/toolbox"
)

// 定时任务
func appTask() {

	o := orm.NewOrm()
	// 任务调度（1分钟会执行一次）
	checkOnLineTk := toolbox.NewTask("checkOnLine", "0 */1 * * * *", func() error {
		im.RobotInit()
		userOffLineUnixTimer := time.Now().Unix() - (60 * 10)  // 用户最后活动时间T出在线状态规则
		adminOffLineUnixTimer := time.Now().Unix() - (60 * 30) // 最后回复消息时间清理回话规则
		lastMessageUnixTimer := time.Now().Unix() - (60 * 8)   // 判断用户是否超过一定时间不使用，强制其下线
		uqs := o.QueryTable(new(models.User))
		aqs := o.QueryTable(new(models.Admin))
		// 检查User
		count, _ := uqs.Filter("online__in", 1, 2).Filter("last_activity__lte", lastMessageUnixTimer).Update(orm.Params{
			"online":    0,
			"is_window": 0,
		})
		logs.Info("清理登录超时用户,有", count, "个用户被强制下线")
		// 检查Admin
		_, _ = aqs.Filter("online__in", 1, 2).Filter("last_activity__lte", adminOffLineUnixTimer).Update(orm.Params{
			"online":           0,
			"current_con_user": 0,
		})

		// 2.判断用户是否超时无应答
		cqs := o.QueryTable(new(models.Contact))
		// 检查(有机器人在线)
		if len(im.Robots) > 0 {
			robot := im.Robots[0]
			var contacts []models.Contact
			_, _ = o.Raw("SELECT * FROM `contact` WHERE `create_at` <= ? AND `is_session_end` = 0 AND `last_message_type` != 'timeout'", lastMessageUnixTimer).QueryRows(&contacts)
			logs.Info("清理会话超时用户,有", len(contacts), "个用户被结束对话")
			for _, contact := range contacts {

				// 判断发送方是客服就不处理发送了
				if err := o.Read(&models.Admin{ID: contact.FromAccount}); err == nil {
					continue
				}
				// 发送超时消息体
				message := models.Message{}
				message.BizType = "timeout"
				message.Read = 0
				appAccount, _ := strconv.ParseInt(robot.AppAccount(), 10, 64)
				message.FromAccount = appAccount
				message.Timestamp = time.Now().Unix()
				message.Payload = "由于您长时间未回复，本次会话超时了"
				message.ToAccount = contact.FromAccount
				var messageJSON []byte
				var messageString string
				messageJSON, _ = json.Marshal(message)
				messageString = base64.StdEncoding.EncodeToString([]byte(messageJSON))
				robot.SendMessage(strconv.FormatInt(contact.FromAccount, 10), []byte(messageString))

				// 该客户超时后给客服发送提醒消息
				message.FromAccount = contact.FromAccount
				message.ToAccount = contact.ToAccount
				messageJSON, _ = json.Marshal(message)
				messageString = base64.StdEncoding.EncodeToString([]byte(messageJSON))
				robot.SendMessage(strconv.FormatInt(contact.ToAccount, 10), []byte(messageString))
				utils.MessageInto(message, true)

				// 超时后消息
				// 数据库获取机器人配置信息
				robotData := models.Robot{ID: appAccount}
				cacheRobotKey := "robot_" + string(appAccount)
				if robotDataTemp := im.BmCache.Get(cacheRobotKey); robotDataTemp == nil {
					robotData = models.Robot{ID: appAccount}
					_ = o.Read(&robotData)
					robotDataJSON, _ := json.Marshal(robotData)
					_ = im.BmCache.Put(cacheRobotKey, robotDataJSON, 60*time.Second)
				} else {
					_ = json.Unmarshal([]byte(string(robotDataTemp.([]byte))), &robotData)
				}
				if robotData.TimeoutText != "" {
					message.FromAccount = appAccount
					message.ToAccount = contact.FromAccount
					message.BizType = "text"
					message.Key = time.Now().Unix()
					message.Payload = robotData.TimeoutText
					messageJSON, _ = json.Marshal(message)
					messageString = base64.StdEncoding.EncodeToString([]byte(messageJSON))
					robot.SendMessage(strconv.FormatInt(contact.FromAccount, 10), []byte(messageString))
				}

			}
		} else {
			// 执行到这里说明，机器人死掉了
			logs.Error("执行到这里说明，机器人死掉了")
			im.RobotInit()
			_, _ = cqs.Filter("create_at__lte", userOffLineUnixTimer).Update(orm.Params{
				"last_message_type": "timeout",
				"is_session_end":    1,
			})
		}
		return nil
	})

	toolbox.AddTask("checkOnLine", checkOnLineTk)

	toolbox.StartTask()
	defer toolbox.StopTask()

}
