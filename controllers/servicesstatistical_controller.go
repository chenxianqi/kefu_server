package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"

	"github.com/astaxie/beego/validation"
)

// ServicesStatisticalController struct
type ServicesStatisticalController struct {
	BaseController
	StatisticalRepository *services.StatisticalRepository
}

// Prepare More like construction method
func (c *ServicesStatisticalController) Prepare() {

	// StatisticalRepository instance
	c.StatisticalRepository = services.GetStatisticalRepositoryInstance()
}

// Finish Comparison like destructor or package init()
func (c *ServicesStatisticalController) Finish() {}

// List Services Statistical
func (c *ServicesStatisticalController) List() {

	// request body
	var paginationDto models.ServicesStatisticalPaginationDto
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &paginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", err.Error())
	}

	// validation
	valid := validation.Validation{}
	valid.Required(paginationDto.PageOn, "page_on").Message("page_on不能为空！")
	valid.Required(paginationDto.PageSize, "page_size").Message("page_size不能为空！")
	valid.Required(paginationDto.Cid, "cid").Message("cid不能为空！")
	valid.Required(paginationDto.Date, "date").Message("date不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// get data
	data := c.StatisticalRepository.GetCustomerServiceList(paginationDto)
	c.JSON(configs.ResponseSucess, "success", &data)

}
