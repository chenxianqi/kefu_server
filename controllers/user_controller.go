package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// UserController struct
type UserController struct {
	BaseController
	UserRepository *services.UserRepository
}

// Prepare More like construction method
func (c *UserController) Prepare() {

	// UserRepository instance
	c.UserRepository = services.GetUserRepositoryInstance()

}

// Finish Comparison like destructor
func (c *UserController) Finish() {}

// Get get a user
func (c *UserController) Get() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	user := c.UserRepository.GetUser(id)
	if user == nil {
		c.JSON(configs.ResponseFail, "fail，用户不存在!", nil)
	}

	c.JSON(configs.ResponseSucess, "success", &user)

}

// Put update a user
func (c *UserController) Put() {

	// request
	user := models.User{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &user); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(user.ID, "id").Message("用户ID不能为空！")
	valid.MaxSize(user.Address, 80, "address").Message("用户所在地区不能超过80个字符！")
	valid.MaxSize(user.NickName, 15, "nickname").Message("用户昵称不能超过15个字符！")
	valid.MaxSize(user.Phone, 20, "phone").Message("用户联系方式不能超过20个字符！")
	valid.MaxSize(user.Remarks, 150, "remarks").Message("用户备注不能超过150个字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// update
	_, err := c.UserRepository.Update(user.ID, orm.Params{
		"Address":  user.Address,
		"NickName": user.NickName,
		"Phone":    user.Phone,
		"Remarks":  user.Remarks,
		"UpdateAt": time.Now().Unix(),
		"Avatar":   user.Avatar,
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", err.Error())
	}
	c.JSON(configs.ResponseSucess, "更新成功!", nil)
}

// Post add new user
// Create user Please move on (the user creation logic is not provided here /v1/public/register)
func (c *UserController) Post() {
	c.ServeJSON()
}

// Delete delete remove user
func (c *UserController) Delete() {

	// uid
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限删除用户!", nil)
	}

	// user
	user := c.UserRepository.GetUser(id)

	// exist
	if user == nil {
		c.JSON(configs.ResponseFail, "删除失败，用户不存在!", nil)
	}

	// delete
	if _, err := c.UserRepository.Delete(id); err != nil {
		c.JSON(configs.ResponseFail, "删除失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "删除成功!", nil)

}

// Users get users
func (c *UserController) Users() {

	// request body
	var usersPaginationDto models.UsersPaginationDto
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &usersPaginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", err.Error())
	}

	// validation
	valid := validation.Validation{}
	valid.Required(usersPaginationDto.PageOn, "page_on").Message("page_on不能为空！")
	valid.Required(usersPaginationDto.PageSize, "page_size").Message("page_size不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, err.Error())
		}
	}

	// get users
	res, err := c.UserRepository.GetUsers(&usersPaginationDto)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}
	c.JSON(configs.ResponseSucess, "success", &res)

}

// OnLineCount get all online user count
func (c *UserController) OnLineCount() {

	rows, err := c.UserRepository.GetOnlineCount()
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}
	c.JSON(configs.ResponseSucess, "success", &rows)

}
