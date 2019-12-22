package controllers

import (
	"kefu_server/models"
	"kefu_server/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

// UploadsConfigController struct
type UploadsConfigController struct {
	beego.Controller
}

// Config get upload config
func (c *UploadsConfigController) Config() {

	o := orm.NewOrm()
	var configs []models.UploadsConfig
	if _, err := o.QueryTable(new(models.UploadsConfig)).All(&configs); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &configs)
	}
	c.ServeJSON()

}
