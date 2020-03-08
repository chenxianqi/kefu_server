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

// CompanyController struct
type CompanyController struct {
	BaseController
	CompanyRepository *services.CompanyRepository
}

// Prepare More like construction method
func (c *CompanyController) Prepare() {

	// CompanyRepository instance
	c.CompanyRepository = services.GetCompanyRepositoryInstance()

}

// Finish Comparison like destructor
func (c *CompanyController) Finish() {}

// Get get conpany info
func (c *CompanyController) Get() {
	company := c.CompanyRepository.GetCompany(1)
	if company == nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}
	c.JSON(configs.ResponseSucess, "success", &company)
}

// Put update conpany info
func (c *CompanyController) Put() {

	company := models.Company{}
	company.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &company); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(company.Logo, "logo").Message("公司LOGO不能为空！")
	valid.Required(company.Title, "title").Message("公司名称不能为空！")
	valid.MaxSize(company.Title, 50, "title").Message("公司名称不能超过50个字符！")
	valid.Required(company.Service, "service").Message("在线客服时间不能为空！")
	valid.MaxSize(company.Service, 50, "service").Message("在线客服时间长度不能超过50个字符！")
	valid.MaxSize(company.Email, 50, "service").Message("Email长度不能超过50个字符！")
	valid.MaxSize(company.Tel, 50, "tel").Message("公司电话长度不能超过50个字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// orm
	row, err := c.CompanyRepository.Update(1, orm.Params{
		"Title":    company.Title,
		"Address":  company.Address,
		"Email":    company.Email,
		"UpdateAt": time.Now().Unix(),
		"Logo":     company.Logo,
		"Service":  company.Service,
		"Tel":      company.Tel,
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", nil)
	}
	c.JSON(configs.ResponseSucess, "更新成功!", row)
}
