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

// QiniuController struct
type QiniuController struct {
	BaseController
	QiniuRepository *services.QiniuRepository
	AdminRepository *services.AdminRepository
}

// Prepare More like construction method
func (c *QiniuController) Prepare() {

	// QiniuRepository instance
	c.QiniuRepository = services.GetQiniuRepositoryInstance()

	// AdminRepository instance
	c.AdminRepository = services.GetAdminRepositoryInstance()

}

// Finish Comparison like destructor or package init()
func (c *QiniuController) Finish() {}

// Get get qiniu config info
func (c *QiniuController) Get() {

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil || admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限获取配置!", nil)
	}

	// get qiniu config info
	qiniuSetting := c.QiniuRepository.GetQiniuConfigInfo()
	if qiniuSetting == nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}

	// return
	c.JSON(configs.ResponseSucess, "success", &qiniuSetting)
}

// Put update
func (c *QiniuController) Put() {

	qiniuSetting := models.QiniuSetting{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &qiniuSetting); err != nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin == nil || admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限获取配置!", nil)
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
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// update
	if _, err := c.QiniuRepository.Update(orm.Params{
		"Bucket":    qiniuSetting.Bucket,
		"AccessKey": qiniuSetting.AccessKey,
		"SecretKey": qiniuSetting.SecretKey,
		"Host":      qiniuSetting.Host,
		"UpdateAt":  time.Now().Unix(),
	}); err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "更新成功!", &qiniuSetting)
}
