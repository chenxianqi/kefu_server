package task

import (
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/toolbox"
)

// Timed task
func appTask() {

	// Task scheduling (will be executed once every 5 minute)
	checkOnLineTk := toolbox.NewTask("checkOnLine", "0 */1 * * * *", func() error {

		// timers
		userOffLineUnixTimer := time.Now().Unix() - (60 * 10)  // User's last activity time T out online status rule
		adminOffLineUnixTimer := time.Now().Unix() - (60 * 30) // Final reply time
		lastMessageUnixTimer := time.Now().Unix() - (60 * 8)   // Determine if the user will not use it for a certain period of time and force them to go offline

		// user
		userOfflineCount := services.GetUserRepositoryInstance().CheckUsersLoginTimeOutAndSetOffline(userOffLineUnixTimer)
		logs.Info("清理登录超时user", userOfflineCount, "个被强制下线")

		// admin
		adminOfflineCount := services.GetAdminRepositoryInstance().CheckAdminsLoginTimeOutAndSetOffline(adminOffLineUnixTimer)
		logs.Info("清理登录超时admin", adminOfflineCount, "个被强制下线")

		// get offline all robots
		robots, _ := services.GetRobotRepositoryInstance().GetRobotOnlineAll()
		if robots != nil && len(robots) == 0 {
			services.GetContactRepositoryInstance().SetTimeOutContactOffline(userOffLineUnixTimer)
		}

		contacts := services.GetContactRepositoryInstance().GetTimeOutList(lastMessageUnixTimer)
		logs.Info("清理会话超时用户,有", len(contacts), "个被结束对话")
		for _, contact := range contacts {

			// set end is session end
			services.GetContactRepositoryInstance().UpdateIsSessionEnd(contact.FromAccount)

			// Does not handle customer service
			if admin := services.GetAdminRepositoryInstance().GetAdmin(contact.FromAccount); admin != nil {
				continue
			}

			_lastBackAdmin := services.GetAdminRepositoryInstance().GetAdmin(contact.LastAccount)
			robot := robots[0]

			// message body
			message := models.Message{}
			message.BizType = "timeout"
			message.Read = 0
			message.FromAccount = robot.ID
			message.Timestamp = time.Now().Unix()
			message.Payload = "您长时间未回复，本次会话超时了"
			if _lastBackAdmin == nil {
				message.Payload = "客服长时间未回复，会话结束，您可以重新发起人工"
			}
			message.ToAccount = contact.FromAccount
			var messageString string
			messageString = utils.InterfaceToString(message)
			utils.PushMessage(contact.FromAccount, messageString)
			utils.MessageInto(message)

			// Send a reminder message to customer service
			message.FromAccount = robot.ID
			message.ToAccount = contact.ToAccount
			message.Payload = "用户长时间无应答，会话结束"
			if _lastBackAdmin == nil {
				message.Read = 1
				message.Payload = "您长时间未回复客户，会话结束"
			}
			messageString = utils.InterfaceToString(message)
			utils.PushMessage(contact.ToAccount, messageString)
			utils.MessageInto(message)

			// Message after timeout
			if robot.TimeoutText != "" && _lastBackAdmin != nil {
				message.FromAccount = robot.ID
				message.ToAccount = contact.FromAccount
				message.BizType = "text"
				message.Key = time.Now().Unix()
				message.Payload = robot.TimeoutText
				messageString = utils.InterfaceToString(message)
				utils.PushMessage(contact.FromAccount, messageString)
			}

		}

		return nil
	})

	toolbox.AddTask("checkOnLine", checkOnLineTk)

}
