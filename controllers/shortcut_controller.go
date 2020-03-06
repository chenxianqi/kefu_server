package controllers

import (
	"encoding/base64"
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// ShortcutController struct
type ShortcutController struct {
	beego.Controller
}

// Get get shortcut
func (c *ShortcutController) Get() {
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

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	shortcut := models.Shortcut{ID: id}
	if err := o.Read(&shortcut); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，内容不存在!", err)
	} else {
		if _admin.ID != shortcut.UID {
			c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，内容不存在!", nil)
		} else {
			title, _ := base64.StdEncoding.DecodeString(shortcut.Title)
			content, _ := base64.StdEncoding.DecodeString(shortcut.Content)
			shortcut.Title = string(title)
			shortcut.Content = string(content)
			c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &shortcut)
		}
	}
	c.ServeJSON()
}

// Put update shortcut
func (c *ShortcutController) Put() {

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

	// request body
	shortcut := models.Shortcut{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &shortcut); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(shortcut.Title, "title").Message("标题不能为空！")
	valid.Required(shortcut.Content, "content").Message("内容不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	oldShortcut := models.Shortcut{ID: shortcut.ID}
	_ = o.Read(&oldShortcut)
	if oldShortcut.UID != _admin.ID {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败，内容不存在!", nil)
		c.ServeJSON()
		return
	}

	// update
	shortcut.Title = base64.StdEncoding.EncodeToString([]byte(shortcut.Title))
	shortcut.Content = base64.StdEncoding.EncodeToString([]byte(shortcut.Content))
	if _, err := o.Update(&shortcut, "UpdateAt", "Content", "Title"); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", nil)
	}
	c.ServeJSON()
}

// Post add new shortcut
func (c *ShortcutController) Post() {

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

	// request body
	var shortcut models.Shortcut
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &shortcut); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(shortcut.Title, "title").Message("标题不能为空！")
	valid.Required(shortcut.Content, "content").Message("内容不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// exist ? create
	shortcut.UID = _admin.ID
	shortcut.CreateAt = time.Now().Unix()
	shortcut.Title = base64.StdEncoding.EncodeToString([]byte(shortcut.Title))
	shortcut.Content = base64.StdEncoding.EncodeToString([]byte(shortcut.Content))
	if isExist, createID, err := o.ReadOrCreate(&shortcut, "Title", "Uid"); err == nil {
		if isExist {
			c.Data["json"] = utils.ResponseSuccess(c.Ctx, "添加成功！", &createID)
		} else {
			c.Data["json"] = utils.ResponseError(c.Ctx, "已存在相同的内容!", nil)
		}
	} else {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "服务异常!", err)
	}
	c.ServeJSON()
	return
}

// Delete delete remove shortcut
func (c *ShortcutController) Delete() {

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

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	shortcut := models.Shortcut{ID: id}

	// exist
	if err := o.Read(&shortcut); err != nil || shortcut.UID != _admin.ID {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败，内容不存在!", nil)
		c.ServeJSON()
		return
	}

	if num, err := o.Delete(&shortcut); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功！", &num)
	}
	c.ServeJSON()
}

// List get shortcut all
func (c *ShortcutController) List() {

	o := orm.NewOrm()
	shortcut := new(models.Shortcut)
	qs := o.QueryTable(shortcut)

	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	_admin := models.Admin{ID: _auth.UID}
	_ = o.Read(&_admin)

	// query
	var lists []models.Shortcut
	if _, err := qs.Filter("uid", _admin.ID).OrderBy("-create_at").All(&lists); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
		c.ServeJSON()
		return
	}
	// base 64转换回来
	for index, shortcut := range lists {
		title, _ := base64.StdEncoding.DecodeString(shortcut.Title)
		content, _ := base64.StdEncoding.DecodeString(shortcut.Content)
		lists[index].Title = string(title)
		lists[index].Content = string(content)
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &lists)
	c.ServeJSON()

}
