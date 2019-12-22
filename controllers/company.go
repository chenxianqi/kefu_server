package controllers

import (
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// CompanyController struct
type CompanyController struct {
	beego.Controller
}

// Get get conpany info
func (c *CompanyController) Get() {
	o := orm.NewOrm()
	company := models.Company{ID: 1}
	if err := o.Read(&company); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &company)
	}
	c.ServeJSON()
}

// Put update conpany info
func (c *CompanyController) Put() {

	company := models.Company{}
	company.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &company); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
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
			logs.Error(err)
			c.Data["json"] = &models.Response{Code: 400, Message: err.Message, Data: nil}
			break
		}
		c.ServeJSON()
		return
	}

	// orm
	o := orm.NewOrm()
	company.ID = 1
	company.UpdateAt = time.Now().Unix()
	if _, err := o.Update(&company); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", &company)
	}
	c.ServeJSON()
}
