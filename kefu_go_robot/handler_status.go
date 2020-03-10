package robotlbrary

import "github.com/astaxie/beego/logs"

// StatusHandler struct
type StatusHandler struct {
	appAccount string
}

// NewStatusHandler newStatusHandler
func NewStatusHandler(appAccount string) *StatusHandler {
	return &StatusHandler{appAccount}
}

// HandleChange handleChange
func (c StatusHandler) HandleChange(isOnline bool, errType, errReason, errDescription *string) {
	if isOnline {
		logs.Info("机器人霸道上线 status changed: online.", "")
	} else {
		// 有机器人掉线，重新登录
		logs.Error("[机器人挂掉了] status changed: offline，errType:%v, errReason:%v, errDes:%v", *errType, *errReason, *errDescription)
	}
}
