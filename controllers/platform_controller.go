package controllers

import (
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// PlatformController struct
type PlatformController struct {
	beego.Controller
}

// Get get a admin
func (c *PlatformController) Get() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	platform := models.Platform{ID: id}
	if err := o.Read(&platform); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &platform)
	}
	c.ServeJSON()

}

// Put update admin
func (c *PlatformController) Put() {

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

	// is admin ?
	if _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败，无权限更新", nil)
		c.ServeJSON()
		return
	}

	// request body
	platform := models.Platform{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &platform); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// admin exist
	if err := o.Read(&models.Platform{ID: platform.ID}); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败，数据不存在!", err)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(platform.ID, "id").Message("平台ID不能为空！")
	valid.Min(platform.ID, 7, "id").Message("默认配置平台不能修改！")
	valid.Required(platform.Title, "title").Message("平台名不能为空！")
	valid.MaxSize(platform.Title, 30, "title").Message("平台名不能超过30个字符！")
	valid.AlphaNumeric(platform.Alias, "alias").Message("别名不能含有中文和特别符号！")
	valid.Required(platform.Alias, "alias").Message("别名不能为空！")
	valid.MaxSize(platform.Alias, 30, "alias").Message("别名不能超过30个字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// title exist
	var pt models.Platform
	if err := o.Raw("SELECT * FROM platform WHERE id != ? AND title = ?", platform.ID, platform.Title).QueryRow(&pt); err == nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "平台名已被使用，请换一个试试!", err)
		c.ServeJSON()
		return
	}

	// Alias exist
	if err := o.Raw("SELECT * FROM platform WHERE id != ? AND alias = ?", platform.ID, platform.Alias).QueryRow(&pt); err == nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "别名已被使用，请换一个试试!", err)
		c.ServeJSON()
		return
	}

	if _, err := o.Update(&platform, "Title", "Alias"); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败!", err)
	} else {
		platform.System = 0
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", &platform)
	}
	c.ServeJSON()
}

// Post add new admin
func (c *PlatformController) Post() {

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
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限添加平台!", nil)
		c.ServeJSON()
		return
	}

	// request body
	var platform models.Platform
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &platform); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(platform.Title, "title").Message("平台名不能为空！")
	valid.MaxSize(platform.Title, 30, "title").Message("平台名不能超过30个字符！")
	valid.Required(platform.Alias, "alias").Message("别名不能为空！")
	valid.AlphaNumeric(platform.Alias, "alias").Message("别名不能含有中文和特别符号！")
	valid.MaxSize(platform.Alias, 30, "alias").Message("别名不能超过30个字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	var pt models.Platform
	if err := o.Raw("SELECT * FROM platform WHERE id != ? AND alias = ?", platform.ID, platform.Alias).QueryRow(&pt); err == nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "别名已被使用，请换一个试试!", err)
		c.ServeJSON()
		return
	}

	// exist ? and create
	platform.ID = 0
	if isExist, _, err := o.ReadOrCreate(&platform, "Title"); err == nil {
		if isExist {
			c.Data["json"] = utils.ResponseSuccess(c.Ctx, "添加成功！", nil)
		} else {
			c.Data["json"] = utils.ResponseError(c.Ctx, "平台名已被使用，请换一个试试!", nil)
		}
	} else {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "服务异常", err)
	}
	c.ServeJSON()
	return
}

// Delete delete remove admin
func (c *PlatformController) Delete() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
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
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限删除平台!", nil)
		c.ServeJSON()
		return
	}

	// platform
	platform := models.Platform{ID: id}

	// exist
	if err := o.Read(&platform); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败，平台不存在!", err)
		c.ServeJSON()
		return
	}

	if num, err := o.Delete(&platform); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功！", num)
	}
	c.ServeJSON()
}

// List get admin all
func (c *PlatformController) List() {

	o := orm.NewOrm()
	var platforms []models.Platform
	qs := o.QueryTable(new(models.Platform))
	if _, err := qs.OrderBy("id").All(&platforms); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &platforms)
	}
	c.ServeJSON()

}
