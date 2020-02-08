package controllers

import (
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// SystemController struct
type SystemController struct {
	beego.Controller
}

// Get get info
func (c *SystemController) Get() {

	o := orm.NewOrm()
	system := models.System{ID: 1}
	if err := o.Read(&system); err != nil {
		logs.Error(err)
		c.Data["json"] = &models.Response{Code: 400, Message: "查询失败", Data: err}
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &system)
	}
	c.ServeJSON()

}

// Put update system
func (c *SystemController) Put() {

	system := models.System{}
	system.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &system); err != nil {
		logs.Error(err)
		c.Data["json"] = &models.Response{Code: 400, Message: "参数错误", Data: nil}
		c.ServeJSON()
		return
	}

	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	_admin := models.Admin{ID: _auth.UID}
	_ = o.Read(&_admin)
	if _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限修改系统设置!", nil)
		c.ServeJSON()
		return
	}

	// validation upload mode
	var uploadValues []orm.Params
	_, _ = o.Raw("SELECT * FROM uploads_config where id = ?", system.UploadMode).Values(&uploadValues)
	if len(uploadValues) <= 0 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "上传模型选项不存在!", nil)
		c.ServeJSON()
		return
	}

	// validation request
	valid := validation.Validation{}
	valid.Required(system.Title, "title").Message("系统名称不能为空！")
	valid.MaxSize(system.Title, 50, "title").Message("系统名称不能超过50个字符！")
	valid.MaxSize(system.CopyRight, 80, "copy_right").Message("版权信息不能超过80个字符！")
	valid.Required(system.Logo, "logo").Message("系统LOGO不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			logs.Error(err)
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	system.ID = 1
	system.UpdateAt = time.Now().Unix()
	if _, err := o.Update(&system); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", &system)
	}
	c.ServeJSON()

}
