package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"

	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// PlatformController struct
type PlatformController struct {
	BaseController
	PlatformRepository *services.PlatformRepository
}

// Prepare More like construction method
func (c *PlatformController) Prepare() {

	// PlatformRepository instance
	c.PlatformRepository = services.GetPlatformRepositoryInstance()

}

// Finish Comparison like destructor
func (c *PlatformController) Finish() {}

// Get get a admin
func (c *PlatformController) Get() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	platform := c.PlatformRepository.GetPlatform(id)
	if platform == nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}

	c.JSON(configs.ResponseSucess, "success", &platform)

}

// Put update admin
func (c *PlatformController) Put() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)

	// is admin root ?
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "更新失败，无权限更新!", nil)
	}

	// request body
	platform := models.Platform{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &platform); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// platform exist
	if p := c.PlatformRepository.GetPlatform(platform.ID); p == nil {
		c.JSON(configs.ResponseFail, "更新失败，数据不存在!", nil)
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
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// title exist
	if pt := c.PlatformRepository.GetPlatformWithIDAndTitle(platform.ID, platform.Title); pt != nil {
		c.JSON(configs.ResponseFail, "平台名已被使用，请换一个试试", nil)
	}

	// Alias exist
	if pt := c.PlatformRepository.GetPlatformWithIDAndAlias(platform.ID, platform.Alias); pt != nil {
		c.JSON(configs.ResponseFail, "别名已被使用，请换一个试试", nil)
	}
	_, _ = c.PlatformRepository.Update(platform.ID, orm.Params{
		"Title": platform.Title,
		"Alias": platform.Alias,
	})

	c.JSON(configs.ResponseSucess, "更新成功！", &platform)
}

// Post add new platform
func (c *PlatformController) Post() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)

	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限添加平台！", nil)
	}

	// request body
	var platform models.Platform
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &platform); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
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
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	pt := c.PlatformRepository.GetPlatformWithIDAndAlias(platform.ID, platform.Alias)
	if pt != nil {
		c.JSON(configs.ResponseFail, "别名已被使用，请换一个试试!", nil)
	}

	// exist ? and create
	platform.ID = 0
	isExist, _, err := c.PlatformRepository.Add(&platform, "Title")

	if err != nil {
		c.JSON(configs.ResponseFail, "添加失败，换个名字试试!", nil)
	}

	if !isExist {
		c.JSON(configs.ResponseFail, "平台名已被使用，请换一个试试!", nil)
	}

	c.JSON(configs.ResponseSucess, "添加成功!", nil)
}

// Delete delete remove admin
func (c *PlatformController) Delete() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)

	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限添加平台！", nil)
	}

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// platform
	platform := c.PlatformRepository.GetPlatform(id)

	// exist
	if platform == nil {
		c.JSON(configs.ResponseFail, "删除失败，平台不存在!", nil)
	}

	if _, err := c.PlatformRepository.Delete(id); err != nil {
		c.JSON(configs.ResponseFail, "删除失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "删除成功!", nil)
}

// List get admin all
func (c *PlatformController) List() {

	platforms, err := c.PlatformRepository.GetPlatformAll("id")

	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}

	c.JSON(configs.ResponseSucess, "success", &platforms)
}
