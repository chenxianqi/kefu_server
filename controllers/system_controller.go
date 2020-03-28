package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// SystemController struct
type SystemController struct {
	BaseController
	SystemRepository *services.SystemRepository
}

// Prepare More like construction method
func (c *SystemController) Prepare() {

	// ShortcutRepository instance
	c.SystemRepository = services.GetSystemRepositoryInstance()

}

// Finish Comparison like destructor or package init()
func (c *SystemController) Finish() {}

// Get get info
func (c *SystemController) Get() {

	system := c.SystemRepository.GetSystem()
	if system == nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}
	c.JSON(configs.ResponseSucess, "success", &system)

}

// PutOpenWorkorder update system
func (c *SystemController) PutOpenWorkorder() {

	system := models.System{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &system); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)
	// is root ?
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限修改系统设置!", nil)
	}
	if system.OpenWorkorder != 0 && system.OpenWorkorder != 1 {
		c.JSON(configs.ResponseFail, "参数有误，更新失败!", nil)
	}

	// update
	_, err := c.SystemRepository.Update(orm.Params{
		"OpenWorkorder": system.OpenWorkorder,
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", err.Error())
	}
	c.JSON(configs.ResponseSucess, "更新成功!", nil)
}

// Put update system
func (c *SystemController) Put() {

	system := models.System{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &system); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)
	// is root ?
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限修改系统设置!", nil)
	}

	// validation upload mode
	uploadConfig := services.GetUploadsConfigRepositoryInstance().GetUploadsConfig(int64(system.UploadMode))
	if uploadConfig == nil {
		c.JSON(configs.ResponseFail, "上传模型选项不存在!", nil)
	}

	// validation request
	valid := validation.Validation{}
	valid.Required(system.Title, "title").Message("系统名称不能为空！")
	valid.MaxSize(system.Title, 50, "title").Message("系统名称不能超过50个字符！")
	valid.MaxSize(system.CopyRight, 80, "copy_right").Message("版权信息不能超过80个字符！")
	valid.Required(system.Logo, "logo").Message("系统LOGO不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// update
	_, err := c.SystemRepository.Update(orm.Params{
		"Title":      system.Title,
		"Logo":       system.Logo,
		"CopyRight":  system.CopyRight,
		"UploadMode": system.UploadMode,
		"UpdateAt":   time.Now().Unix(),
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", err.Error())
	}
	c.JSON(configs.ResponseSucess, "更新成功!", &system)
}
