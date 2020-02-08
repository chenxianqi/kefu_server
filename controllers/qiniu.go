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

// QiniuController struct
type QiniuController struct {
	beego.Controller
}

// Get get qiniu config info
func (c *QiniuController) Get() {

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
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限获取配置!", nil)
		c.ServeJSON()
		return
	}

	qiniuSetting := models.QiniuSetting{ID: 1}
	if err := o.Read(&qiniuSetting); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &qiniuSetting)
	}

	c.ServeJSON()
}

// Put update
func (c *QiniuController) Put() {

	qiniuSetting := models.QiniuSetting{}
	qiniuSetting.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &qiniuSetting); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
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
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限设置!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(qiniuSetting.Bucket, "bucket").Message("bucket不能为空！")
	valid.MaxSize(qiniuSetting.Bucket, 100, "bucket").Message("bucket不能超过100字符！")
	valid.Required(qiniuSetting.AccessKey, "access_key").Message("access_key不能为空！")
	valid.MaxSize(qiniuSetting.AccessKey, 100, "access_key").Message("access_key不能超过100字符！")
	valid.Required(qiniuSetting.SecretKey, "secret_key").Message("secret_key不能为空！")
	valid.MaxSize(qiniuSetting.SecretKey, 100, "secret_key").Message("secret_key不能超过100字符！")
	valid.Required(qiniuSetting.Host, "host").Message("host不能为空！")
	valid.MaxSize(qiniuSetting.Host, 100, "host").Message("host不能超过100字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			logs.Error(err)
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	qiniuSetting.ID = 1
	qiniuSetting.UpdateAt = time.Now().Unix()
	if _, err := o.Update(&qiniuSetting); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", &qiniuSetting)
	}
	c.ServeJSON()
}
