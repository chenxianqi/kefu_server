package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/services"

	"github.com/astaxie/beego/validation"
)

// HomeController struct
type HomeController struct {
	BaseController
	StatisticalRepository *services.StatisticalRepository
}

// Prepare More like construction method
func (c *HomeController) Prepare() {

	// StatisticalRepository instance
	c.StatisticalRepository = services.GetStatisticalRepositoryInstance()

}

// Finish Comparison like destructor
func (c *HomeController) Finish() {}

// StatisticalRequest home Statistical
type StatisticalRequest struct {
	DateStart string `json:"date_start"`
	DateEnd   string `json:"date_end"`
}

// Statistical statistical services
func (c *HomeController) Statistical() {

	// request body
	statisticalRequest := StatisticalRequest{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &statisticalRequest); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", &err)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(statisticalRequest.DateStart, "date_start").Message("date_start不能为空！")
	valid.Required(statisticalRequest.DateEnd, "date_end").Message("date_end不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, &err)
		}
	}

	countsArr, err := c.StatisticalRepository.GetStatisticals(statisticalRequest.DateStart, statisticalRequest.DateEnd)
	if err != nil {
		c.JSON(configs.ResponseFail, err.Error(), &err)
	}

	c.JSON(configs.ResponseSucess, "success", &countsArr)

}

// TodayActionStatistical today Statistical
func (c *HomeController) TodayActionStatistical() {

	// request body
	statisticalRequest := StatisticalRequest{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &statisticalRequest); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", &err)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(statisticalRequest.DateStart, "date_start").Message("date_start不能为空！")
	valid.Required(statisticalRequest.DateEnd, "date_end").Message("date_end不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, &err)
		}
	}

	statisticalData, err := c.StatisticalRepository.GetTodayActionStatistical(statisticalRequest.DateStart, statisticalRequest.DateEnd)
	if err != nil {
		c.JSON(configs.ResponseFail, err.Error(), &err)
	}

	c.JSON(configs.ResponseSucess, "success", &statisticalData)

}
