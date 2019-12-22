package utils

import (
	"kefu_server/models"

	"github.com/astaxie/beego/context"
)

// ResponseError ...
func ResponseError(ctx *context.Context, message string, error interface{}) *models.Response {
	ctx.Output.Status = 400
	ctx.Output.Header("Access-Control-Max-Age", "2592000")
	return &models.Response{Code: 400, Message: message, Data: error}
}
