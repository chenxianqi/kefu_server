package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// AuthController struct
type AuthController struct {
	beego.Controller
}

// Login admin login
func (c *AuthController) Login() {
	var admin models.Admin
	valid := validation.Validation{}

	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &admin); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误", nil)
		c.ServeJSON()
		return
	}

	// MD5
	m5 := md5.New()
	m5.Write([]byte(admin.Password))
	admin.Password = hex.EncodeToString(m5.Sum(nil))

	// valid
	valid.Required(admin.UserName, "username").Message("用户名不能为空！")
	valid.Required(admin.Password, "password").Message("密码不能为空！")

	if valid.HasErrors() {

		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return

	}

	//  else if queryAdmin.Token != "" {
	// 	c.Data["json"] = utils.ResponseError(c.Ctx, "该用户已登录，请稍后再试哦！", nil)
	// }

	o := orm.NewOrm()
	queryAdmin := models.Admin{UserName: admin.UserName}
	err := o.Read(&queryAdmin, "UserName")
	if err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在！", nil)
	} else if queryAdmin.Password != admin.Password {
		c.Data["json"] = utils.ResponseError(c.Ctx, "密码错误！", nil)
	} else if admin.UserName != queryAdmin.UserName {
		c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在！", nil)
	} else {
		queryAdmin.Password = ""
		queryAdmin.Token = utils.GenerateToken(queryAdmin)
		_, err := o.Update(&queryAdmin, "Token")
		if err != nil {
			logs.Error(err)
			c.Data["json"] = utils.ResponseError(c.Ctx, "登录失败，请稍后再试！", queryAdmin)
		} else {
			c.Data["json"] = utils.ResponseSuccess(c.Ctx, "登录成功！", queryAdmin)
		}

	}
	c.ServeJSON()
}

// Logout admin logout
func (c *AuthController) Logout() {
	o := orm.NewOrm()
	token := c.Ctx.Input.Header("Authorization")
	admin := models.Admin{Token: token}
	_ = o.Read(&admin, "Token")
	admin.Token = ""
	admin.CurrentConUser = 0
	if _, err := o.Update(&admin); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "退出失败！", nil)
		c.ServeJSON()
		return
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "退出成功！", nil)
	c.ServeJSON()
}
