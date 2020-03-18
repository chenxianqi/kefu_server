package controllers

import (
	"kefu_server/configs"
	"kefu_server/services"
)

// UploadsConfigController struct
type UploadsConfigController struct {
	BaseController
	UploadsConfigRepository *services.UploadsConfigRepository
}

// Prepare More like construction method
func (c *UploadsConfigController) Prepare() {

	// UploadsConfigRepository instance
	c.UploadsConfigRepository = services.GetUploadsConfigRepositoryInstance()

}

// Finish Comparison like destructor or package init()
func (c *UploadsConfigController) Finish() {}

// Config get upload config all
func (c *UploadsConfigController) Config() {

	uploadsConfigs := c.UploadsConfigRepository.GetUploadsConfigs()
	c.JSON(configs.ResponseSucess, "success", &uploadsConfigs)

}
