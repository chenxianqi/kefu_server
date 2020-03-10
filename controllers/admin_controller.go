package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// AdminController struct
type AdminController struct {
	BaseController
	AdminRepository *services.AdminRepository
}

// Prepare More like construction method
func (c *AdminController) Prepare() {

	// AdminRepository instance
	c.AdminRepository = services.GetAdminRepositoryInstance()

}

// Finish Comparison like destructor
func (c *AdminController) Finish() {}

// GetMeInfo get me info
func (c *AdminController) GetMeInfo() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil {
		c.JSON(configs.ResponseFail, "fail，用户不存在!", nil)
	}

	c.JSON(configs.ResponseSucess, "success", &admin)
}

// Get admin
func (c *AdminController) Get() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil {
		c.JSON(configs.ResponseFail, "fail，用户不存在!", nil)
	}

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	if admin.ID != id && admin.Root != 1 {
		c.JSON(configs.ResponseFail, "没有权限查看用户信息!", nil)
	}

	retrunAdmin := c.AdminRepository.GetAdmin(id)
	if retrunAdmin == nil {
		c.JSON(configs.ResponseFail, "fail，用户不存在!", nil)
	}

	retrunAdmin.Password = "******"
	c.JSON(configs.ResponseSucess, "success", &retrunAdmin)
}

// Put update admin
func (c *AdminController) Put() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// get request
	admin := models.Admin{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &admin); err != nil {
		logs.Warn("Put update admin error------------", err)
		c.JSON(configs.ResponseFail, "参数有误，请检查！", &err)
	}

	// admin exist
	oldAdmin := c.AdminRepository.GetAdmin(auth.UID)
	if oldAdmin == nil {
		c.JSON(configs.ResponseFail, "更新失败，用户不存在！", nil)
	}

	// is admin
	if auth.UID != admin.ID && oldAdmin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限修改该客服资料！", nil)
	}

	// validation request
	valid := validation.Validation{}
	valid.Required(admin.ID, "id").Message("用户ID不能为空！")
	valid.Required(admin.Avatar, "avatar").Message("头像不能为空！")
	valid.Required(admin.NickName, "nickname").Message("昵称不能为空！")
	valid.MaxSize(admin.NickName, 5, "nickname").Message("昵称不能超过5个字！")
	valid.Required(admin.AutoReply, "auto_reply").Message("自动回复语不能为空！")
	valid.MaxSize(admin.AutoReply, 100, "auto_reply").Message("自动回复语不能超过100个字！")
	valid.Required(admin.Phone, "phone").Message("手机号不能为空！")
	valid.Mobile(admin.Phone, "phone").Message("手机号格式不正确！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// update
	if _, err := c.AdminRepository.Update(admin.ID, orm.Params{
		"Phone":     admin.Phone,
		"NickName":  admin.NickName,
		"UpdateAt":  time.Now().Unix(),
		"Avatar":    admin.Avatar,
		"AutoReply": admin.AutoReply,
	}); err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", &err)
	}

	admin.Password = "******"
	c.JSON(configs.ResponseSucess, "更新成功！", nil)
}

// Post add new admin
func (c *AdminController) Post() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil {
		c.JSON(configs.ResponseFail, "更新失败，用户不存在！", nil)
	}
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限添加用户！", nil)
	}

	// get request
	var newAdmin models.Admin
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &newAdmin); err != nil {
		logs.Info("Post add new admin error------------", err)
		c.JSON(configs.ResponseFail, "参数有误，请检查！", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(newAdmin.UserName, "username").Message("账号不能为空！")
	valid.AlphaNumeric(newAdmin.UserName, "username").Message("账号格式不正确，建议qq,手机，或邮箱！")
	valid.MaxSize(newAdmin.UserName, 16, "username").Message("账号不能超过16个字！")
	valid.MaxSize(newAdmin.NickName, 5, "nickname").Message("昵称不能超过5个字！")
	valid.MaxSize(newAdmin.AutoReply, 100, "auto_reply").Message("自动回复语不能超过100个字！")
	valid.Required(newAdmin.Password, "password").Message("密码不能为空！")
	valid.AlphaNumeric(newAdmin.Password, "password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MinSize(newAdmin.Password, 6, "password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MaxSize(newAdmin.Password, 16, "password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, &err)
		}
	}

	// MD5 password
	m5 := md5.New()
	m5.Write([]byte(newAdmin.Password))
	newAdmin.Password = hex.EncodeToString(m5.Sum(nil))
	newAdmin.CreateAt = time.Now().Unix()
	if admin.AutoReply == "" {
		admin.AutoReply = "您好，我是在线人工客服，有什么可以帮到你？"
	}

	// exist No ? create
	if isExist, id, err := c.AdminRepository.Add(&newAdmin, "UserName"); err == nil {
		if isExist {
			c.JSON(configs.ResponseSucess, "添加成功!", id)
		}
		c.JSON(configs.ResponseFail, "账号已被使用!", nil)
	}

	c.JSON(configs.ResponseFail, "服务异常!", nil)
}

// Delete remove admin
func (c *AdminController) Delete() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil || admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限删除该账号！", nil)
	}

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// Can't delete myself
	if admin.ID == id {
		c.JSON(configs.ResponseFail, "自己不能删除自己!", nil)
	}

	// delete
	num, err := c.AdminRepository.Delete(id)
	if err != nil || num == 0 {
		logs.Info("Delete remove admin error------------", err)
		c.JSON(configs.ResponseFail, "删除失败!", &err)
	}
	c.JSON(configs.ResponseSucess, "删除成功！", num)
}

// List get admin all
func (c *AdminController) List() {

	// request body
	var paginationDto services.AdminPaginationDto
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &paginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", &err)
	}

	data, err := c.AdminRepository.GetAdmins(&paginationDto)

	if err != nil {
		c.JSON(configs.ResponseFail, "fail", &err)
	}

	c.JSON(configs.ResponseSucess, "success", &data)
}

// UpdatePassword update password
func (c *AdminController) UpdatePassword() {

	request := services.UpdatePasswordRequest{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &request); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", &err)
	}

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// oldAdmin
	oldAdmin := c.AdminRepository.GetAdmin(auth.UID)
	if oldAdmin == nil {
		c.JSON(configs.ResponseFail, "fail，暂时无法更新!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(request.OldPassword, "old_password").Message("旧密码不能为空！")
	valid.Required(request.NewPassword, "new_password").Message("新密码不能为空！")
	valid.AlphaNumeric(request.NewPassword, "new_password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MinSize(request.NewPassword, 6, "new_password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.MaxSize(request.NewPassword, 16, "new_password").Message("密码格式不正确，请输入6-16位字母数字下划线为密码！")
	valid.Required(request.EnterPassword, "enter_password").Message("请再次输入新密码！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, &err)
		}
	}

	// validation old password
	oldM5 := md5.New()
	oldM5.Write([]byte(request.OldPassword))
	oldPassword := hex.EncodeToString(oldM5.Sum(nil))
	if oldPassword != oldAdmin.Password {
		c.JSON(configs.ResponseFail, "旧密码不正确!", nil)
	}

	if request.NewPassword != request.EnterPassword {
		c.JSON(configs.ResponseFail, "两次密码不一致!", nil)
	}

	// admin
	newAdmin := models.Admin{}
	newAdmin.ID = oldAdmin.ID
	newAdmin.UpdateAt = time.Now().Unix()

	// MD5密码
	newM5 := md5.New()
	newM5.Write([]byte(request.NewPassword))
	newAdmin.Password = hex.EncodeToString(newM5.Sum(nil))
	newAdmin.UpdateAt = time.Now().Unix()

	if oldPassword == newAdmin.Password {
		c.JSON(configs.ResponseFail, "新密码不能与旧密码相同", nil)
	}

	// Update
	if _, err := c.AdminRepository.Update(newAdmin.ID, orm.Params{
		"Password": newAdmin.Password,
		"UpdateAt": newAdmin.UpdateAt,
	}); err != nil {
		logs.Warn("UpdatePassword update password error------------", err)
		c.JSON(configs.ResponseFail, "修改失败!", nil)
	}
	c.JSON(configs.ResponseSucess, "修改成功!", nil)
}

// ChangeCurrentUser current connect user
func (c *AdminController) ChangeCurrentUser() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// admin
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil {
		c.JSON(configs.ResponseFail, "更新失败!", nil)
	}

	uid, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// Update
	if _, err := c.AdminRepository.Update(admin.ID, orm.Params{
		"CurrentConUser": uid,
	}); err != nil {
		logs.Info("ChangeCurrentUser current connect user Warn------------", err)
		c.JSON(configs.ResponseFail, "更新失败!", &err)
	}
	c.JSON(configs.ResponseSucess, "更新成功！", nil)
}

// Online change state
func (c *AdminController) Online() {

	online, _ := strconv.Atoi(c.Ctx.Input.Param(":state"))
	if online > 2 {
		online = 0
	}

	// GetAuthInfo
	auth := c.GetAuthInfo()

	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil {
		c.JSON(configs.ResponseFail, "客服不存在!", nil)
	}

	// Update
	if _, err := c.AdminRepository.Update(admin.ID, orm.Params{
		"Online": online,
	}); err != nil {
		c.JSON(configs.ResponseFail, "更新在线状态失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "更新在线状态成功!", nil)
}
