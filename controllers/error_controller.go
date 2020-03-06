package controllers

import "kefu_server/configs"

// ErrorController  struct
type ErrorController struct {
	BaseController
}

// Error404  Controller public fun
func (c *ErrorController) Error404() {
	c.JSON(configs.ResponseNotFound, "Sorry The Page Not Found~", nil)
}
