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
	GetAdminAuthInfo() *models.Auths
	GetUserInfo() *models.User
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
	if status == configs.ResponseFail {
		c.Ctx.Output.Status = 400
	} else if status == configs.ResponseError {
		c.Ctx.Output.Status = 500
	}
	c.Data["json"] = &models.ResponseDto{Code: status, Message: msg, Data: &data}
	c.ServeJSON()
	c.StopRun()
}

// GetAdminAuthInfo get current anth admin that AuthInfo
func (c *BaseController) GetAdminAuthInfo() *models.Auths {
	token := c.Ctx.Input.Header("Authorization")
	if token == "" {
		c.JSON(configs.ResponseFail, "用户效验失败！", nil)
	}
	var authsRepository = services.GetAuthsRepositoryInstance()
	auth := authsRepository.GetAdminAuthInfo(token)
	if auth == nil {
		logs.Warn("GetAdminAuthInfo fun error------------用户效验失败！")
		c.JSON(configs.ResponseFail, "用户效验失败！", nil)
	}
	return auth
}

// GetUserInfo get current user info
func (c *BaseController) GetUserInfo() *models.User {
	token := c.Ctx.Input.Header("Token")
	if token == "" {
		return nil
	}
	var userRepository = services.GetUserRepositoryInstance()
	user := userRepository.GetUserWithToken(token)
	print("user==", user)
	if user == nil {
		logs.Warn("GetUserInfo get current user info error------------用户效验失败！")
	}
	return user
}
