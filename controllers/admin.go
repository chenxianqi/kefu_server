package controllers

import (
	"crypto/md5"
	"encoding/hex"
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

// AdminController struct
type AdminController struct {
	beego.Controller
}

// GetMeInfo get me info
func (c *AdminController) GetMeInfo() {
	o := orm.NewOrm()
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	admin := models.Admin{ID: _auth.UID}
	if err := o.Read(&admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在", err)
	} else {
		admin.Password = "******"
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &admin)
	}
	c.ServeJSON()
}

// Get admin
func (c *AdminController) Get() {
	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	_admin := models.Admin{ID: _auth.UID}
	if err := o.Read(&_admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在", err)
		c.ServeJSON()
		return
	}

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	if _admin.ID != id && _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "没有权限查看用户信息！", nil)
		c.ServeJSON()
		return
	}

	admin := models.Admin{ID: id}
	if err := o.Read(&admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在", err)
	} else {
		admin.Password = "******"
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &admin)
	}
	c.ServeJSON()
}

// Put update admin
func (c *AdminController) Put() {
	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}

	// get request
	admin := models.Admin{}
	admin.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &admin); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误", nil)
		c.ServeJSON()
		return
	}

	// admin exist
	_oldAdmin := models.Admin{ID: _auth.UID}
	if err := o.Read(&_oldAdmin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败，用户不存在", err)
		c.ServeJSON()
		return
	}

	// is admin
	if _auth.UID != admin.ID && _oldAdmin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限修改该客服资料！", nil)
		c.ServeJSON()
		return
	}

	// validation request
	valid := validation.Validation{}
	valid.Required(admin.ID, "id").Message("用户ID不能为空！")
	valid.Required(admin.NickName, "nickname").Message("昵称不能为空！")
	valid.MaxSize(admin.NickName, 5, "nickname").Message("昵称不能超过5个字！")
	valid.MaxSize(admin.AutoReply, 100, "auto_reply").Message("自动回复语不能超过100个字！")
	valid.Mobile(admin.Phone, "phone").Message("手机号格式不正确！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// update
	if _, err := o.Update(&admin, "Phone", "NickName", "UpdateAt", "Avatar", "AutoReply"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败", err)
	} else {
		admin.Password = "******"
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", &admin)
	}
	c.ServeJSON()
}

// Post add new admin
func (c *AdminController) Post() {

	o := orm.NewOrm()

	// is admin ?
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	_admin := models.Admin{ID: _auth.UID}
	if err := o.Read(&_admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败，用户不存在", err)
		c.ServeJSON()
		return
	}
	if _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限添加用户", nil)
		c.ServeJSON()
		return
	}

	// get request
	var admin models.Admin
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &admin); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(admin.UserName, "username").Message("用户名不能为空！")
	valid.AlphaNumeric(admin.UserName, "username").Message("账号格式不正确，建议qq,手机，或邮箱！")
	valid.MaxSize(admin.UserName, 16, "username").Message("账号不能超过16个字！")
	valid.MaxSize(admin.NickName, 5, "nickname").Message("昵称不能超过5个字！")
	valid.MaxSize(admin.AutoReply, 100, "auto_reply").Message("自动回复语不能超过100个字！")
	valid.Required(admin.Password, "password").Message("密码不能为空！")
	valid.AlphaNumeric(admin.Password, "password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MinSize(admin.Password, 6, "password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MaxSize(admin.Password, 16, "password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// MD5 password
	m5 := md5.New()
	m5.Write([]byte(admin.Password))
	admin.Password = hex.EncodeToString(m5.Sum(nil))
	admin.CreateAt = time.Now().Unix()
	if admin.AutoReply == "" {
		admin.AutoReply = "您好，我是在线人工客服，有什么可以帮到你？"
	}

	// exist No ? create
	if isExist, _, err := o.ReadOrCreate(&admin, "UserName"); err == nil {
		if isExist {
			c.Data["json"] = utils.ResponseSuccess(c.Ctx, "添加成功！", nil)
		} else {
			c.Data["json"] = utils.ResponseError(c.Ctx, "用户名已被使用!", nil)
		}
	} else {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "服务异常!", err)
	}
	c.ServeJSON()
	return
}

// Delete remove admin
func (c *AdminController) Delete() {

	// orm instance
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
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限删除客服!", nil)
		c.ServeJSON()
		return
	}

	// Can't delete myself
	if _admin.ID == id {
		c.Data["json"] = utils.ResponseError(c.Ctx, "自己不能删除自己!", nil)
		c.ServeJSON()
		return
	}

	// admin
	admin := models.Admin{ID: id}

	// query read
	if err := o.Read(&admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败，客服不存在!", err)
		c.ServeJSON()
		return
	}

	if num, err := o.Delete(&admin); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功！", num)
	}
	c.ServeJSON()
}

// AdminPaginationData  a struct
type AdminPaginationData struct {
	PageSize int         `json:"page_size"`
	PageOn   int         `json:"page_on"`
	Keyword  string      `json:"keyword"`
	Total    int64       `json:"total"`
	Online   int         `json:"online"`
	List     interface{} `json:"list"`
}

// List get admin all
func (c *AdminController) List() {

	// request body
	var paginationData AdminPaginationData
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &paginationData); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", err)
		c.ServeJSON()
		return
	}

	// orm instance
	o := orm.NewOrm()
	admin := new(models.Admin)
	qs := o.QueryTable(admin)
	qs = qs.Filter("nickname__icontains", paginationData.Keyword)

	var lists []models.Admin
	if paginationData.Online == 0 {
		qs = qs.Filter("online", 0)
	}
	if paginationData.Online == 1 {
		qs = qs.Filter("online", 1)
	}
	if _, err := qs.OrderBy("-root", "id").Limit(paginationData.PageSize, (paginationData.PageOn-1)*paginationData.PageSize).All(&lists); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
		c.ServeJSON()
		return
	}
	total, _ := qs.Count()
	for index := range lists {
		lists[index].Password = "******"
	}
	paginationData.Total = total
	paginationData.List = &lists
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &paginationData)
	c.ServeJSON()

}

// UpdatePasswordRequest admin password
type UpdatePasswordRequest struct {
	OldPassword   string `json:"old_password"`
	NewPassword   string `json:"new_password"`
	EnterPassword string `json:"enter_password"`
}

// UpdatePassword update password
func (c *AdminController) UpdatePassword() {
	o := orm.NewOrm()

	updatePasswordRequest := UpdatePasswordRequest{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &updatePasswordRequest); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// get token
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	oldAdmin := models.Admin{ID: _auth.UID}
	_ = o.Read(&oldAdmin)

	// validation
	valid := validation.Validation{}
	valid.Required(updatePasswordRequest.OldPassword, "old_password").Message("旧密码不能为空！")
	valid.Required(updatePasswordRequest.NewPassword, "new_password").Message("新密码不能为空！")
	valid.AlphaNumeric(updatePasswordRequest.NewPassword, "new_password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MinSize(updatePasswordRequest.NewPassword, 6, "new_password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MaxSize(updatePasswordRequest.NewPassword, 16, "new_password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.Required(updatePasswordRequest.EnterPassword, "enter_password").Message("请再次输入新密码！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// validation old password
	oldM5 := md5.New()
	oldM5.Write([]byte(updatePasswordRequest.OldPassword))
	oldPassword := hex.EncodeToString(oldM5.Sum(nil))
	if oldPassword != oldAdmin.Password {
		c.Data["json"] = utils.ResponseError(c.Ctx, "旧密码不正确!", nil)
		c.ServeJSON()
		return
	}

	if updatePasswordRequest.NewPassword != updatePasswordRequest.EnterPassword {
		c.Data["json"] = utils.ResponseError(c.Ctx, "两次密码不一致!", nil)
		c.ServeJSON()
		return
	}

	// admin
	newAdmin := models.Admin{}
	newAdmin.ID = oldAdmin.ID
	newAdmin.UpdateAt = time.Now().Unix()

	// MD5密码
	newM5 := md5.New()
	newM5.Write([]byte(updatePasswordRequest.NewPassword))
	newAdmin.Password = hex.EncodeToString(newM5.Sum(nil))
	newAdmin.UpdateAt = time.Now().Unix()

	if oldPassword == newAdmin.Password {
		c.Data["json"] = utils.ResponseError(c.Ctx, "新密码不能与旧密码相同!", nil)
		c.ServeJSON()
		return
	}

	// Update
	if _, err := o.Update(&newAdmin, "Password", "UpdateAt"); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "修改失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "修改成功！", nil)
	}
	c.ServeJSON()
}

// ChangeCurrentUser current connect user
func (c *AdminController) ChangeCurrentUser() {
	o := orm.NewOrm()

	// get admin token
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	admin := models.Admin{ID: _auth.UID}
	_ = o.Read(&admin)

	uid, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	user := models.User{ID: uid}
	if err := o.Read(&user); err != nil && uid != 0 {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在!", nil)
		c.ServeJSON()
		return
	}

	// Update
	admin.CurrentConUser = uid
	if _, err := o.Update(&admin, "CurrentConUser"); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", nil)
	}
	c.ServeJSON()
}

// Online change state
func (c *AdminController) Online() {

	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")

	online, _ := strconv.Atoi(c.Ctx.Input.Param(":state"))
	if online > 2 {
		online = 0
	}

	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}

	admin := models.Admin{ID: _auth.UID}
	if err := o.Read(&admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "客服不存在!", err)
		c.ServeJSON()
		return
	}
	admin.Online = online
	if _, err := o.Update(&admin, "Online"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新在线状态失败!", err)
		c.ServeJSON()
		return
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新在线状态成功!", nil)
	c.ServeJSON()
	return
}
