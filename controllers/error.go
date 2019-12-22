package controllers

import (
	"github.com/astaxie/beego"
)

// ErrorController  struct
type ErrorController struct {
	beego.Controller
}

// Error404  Controller public fun
func (c *ErrorController) Error404() {
	c.Data["content"] = "page not found"
	c.TplName = "404.tpl"
}
