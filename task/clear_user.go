package task

import (
	"kefu_server/services"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/toolbox"
)

// clearUser tk
// Regularly clean up users without conversation records
func clearUser() {

	// Every day at 3 am
	clearUserTk := toolbox.NewTask("clearUser", "0 0 03 * * * ", func() error {
		ids := services.GetUserRepositoryInstance().ClearWhiteUser()
		services.GetMessageRepositoryInstance().DeleteWhiteMessage(ids)
		logs.Info("定时清理了", len(ids), "个没有服务记录的用户~")
		return nil
	})
	toolbox.AddTask("clearUser", clearUserTk)

}
