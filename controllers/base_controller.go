package controllers

import (
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
)

// BaseControllerInterface interface
type BaseControllerInterface interface {
	JSON()
	Prepare()
	GetAuthInfo() *models.Auths
}

// BaseController Base class
type BaseController struct {
	beego.Controller
}

// JSON handle http Response
// Return json data, and stop moving on
func (c *BaseController) JSON(status configs.ResponseStatusType, message string, data interface{}) {
	c.Ctx.Output.Header("Access-Control-Max-Age", "2592000")
	msg := message
	if status != configs.ResponseSucess && status != configs.ResponseFail {
		msg = "sorry server error"
		data = nil
	}
	c.Data["json"] = &models.ResponseDto{Code: status, Message: msg, Data: &data}
	c.ServeJSON()
	c.StopRun()
}

// GetAuthInfo get current anth user that AuthInfo
func (c *BaseController) GetAuthInfo() *models.Auths {
	token := c.Ctx.Input.Header("Authorization")
	var authsRepository = services.GetAuthsRepositoryInstance()
	auth := authsRepository.GetAuthInfo(token)
	if auth == nil {
		logs.Warn("GetAuthInfo fun error------------登录已失效！")
		c.JSON(configs.ResponseFail, "登录已失效！", nil)
	}
	return auth
}
