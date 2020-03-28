package task

import (
	"kefu_server/services"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/toolbox"
)

// moveMessage tk
func moveMessage() {

	// moveMessage day at 5 am
	moveMessageTk := toolbox.NewTask("moveMessage", "0 0 05 * * * ", func() error {
		length := services.GetMessageRepositoryInstance().MoveMessageToHistory()
		logs.Info("定时迁移了", length, "条消息记录到历史表~")
		return nil
	})
	toolbox.AddTask("moveMessage", moveMessageTk)

}
