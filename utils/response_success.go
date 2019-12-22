package utils

import (
	"kefu_server/models"

	"github.com/astaxie/beego/context"
)

// ResponseSuccess ...
func ResponseSuccess(ctx *context.Context, message string, data interface{}) *models.Response {
	ctx.Output.Header("Access-Control-Max-Age", "2592000")
	return &models.Response{Code: 200, Message: message, Data: data}
}
