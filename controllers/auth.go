package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// AuthController struct
type AuthController struct {
	beego.Controller
}

// LoginRequest login
// auth_type 登录客户端标识ID
// username 用户名
// password 密码
type LoginRequest struct {
	AuthType int64  `json:"auth_type"`
	UserName string `json:"username"`
	Password string `ojson:"password"`
}

// Login admin login
func (c *AuthController) Login() {

	var loginRequest LoginRequest
	valid := validation.Validation{}

	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &loginRequest); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误", nil)
		c.ServeJSON()
		return
	}

	// valid
	valid.Required(loginRequest.UserName, "username").Message("用户名不能为空！")
	valid.Required(loginRequest.Password, "password").Message("密码不能为空！")
	valid.Required(loginRequest.AuthType, "auth_type").Message("登录客户端标识auth_type不能为空！")

	if valid.HasErrors() {

		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return

	}

	// MD5
	m5 := md5.New()
	m5.Write([]byte(loginRequest.Password))
	loginRequest.Password = hex.EncodeToString(m5.Sum(nil))

	o := orm.NewOrm()

	/// auth_type exist ？
	authType := models.AuthTypes{ID: loginRequest.AuthType}
	if err := o.Read(&authType); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "客户端标识不存在！", nil)
		c.ServeJSON()
		return
	}

	queryAdmin := models.Admin{UserName: loginRequest.UserName}
	err := o.Read(&queryAdmin, "UserName")
	if err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在！", nil)
	} else if queryAdmin.Password != loginRequest.Password {
		c.Data["json"] = utils.ResponseError(c.Ctx, "密码错误！", nil)
	} else if loginRequest.UserName != queryAdmin.UserName {
		c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在！", nil)
	} else {
		newToken := utils.GenerateToken(models.JwtKey{ID: queryAdmin.ID, UserName: queryAdmin.UserName, AuthType: authType.ID})
		auth := models.Auths{}
		as := o.QueryTable(auth)
		if err := as.Filter("auth_type", loginRequest.AuthType).Filter("uid", queryAdmin.ID).One(&auth); err != nil {
			auth.Token = newToken
			auth.UID = queryAdmin.ID
			auth.AuthType = authType.ID
			auth.UpdateAt = time.Now().Unix()
			auth.CreateAt = time.Now().Unix()
			if _, err := o.Insert(&auth); err != nil {
				c.Data["json"] = utils.ResponseError(c.Ctx, "登录失败", &err)
				c.ServeJSON()
				return
			}
		} else {
			auth.Token = newToken
			auth.UpdateAt = time.Now().Unix()
			o.Update(&auth)
		}
		queryAdmin.Password = ""
		queryAdmin.Token = newToken
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "登录成功！", queryAdmin)

	}
	c.ServeJSON()
}

// Logout admin logout
func (c *AuthController) Logout() {
	o := orm.NewOrm()
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	qs := o.QueryTable(models.Auths{})
	if count, _ := qs.Filter("uid", _auth.UID).Count(); count <= 1 {
		admin := models.Admin{ID: _auth.UID}
		_ = o.Read(&admin)
		admin.CurrentConUser = 0
		admin.Online = 0
		if _, err := o.Update(&admin); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "退出失败！", nil)
			c.ServeJSON()
			return
		}
	}
	o.Delete(&_auth)
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "退出成功！", nil)
	c.ServeJSON()
}
