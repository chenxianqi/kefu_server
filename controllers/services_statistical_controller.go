package controllers

import (
	"encoding/json"
	"kefu_server/utils"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// ServicesStatisticalController struct
type ServicesStatisticalController struct {
	beego.Controller
}

// ServicesStatisticalPaginationData struct
type ServicesStatisticalPaginationData struct {
	PageSize      int         `json:"page_size"`
	PageOn        int         `json:"page_on"`
	Cid           int64       `json:"cid"`
	Date          string      `json:"date"`
	IsDeWeighting bool        `json:"is_de_weighting"`
	Total         int64       `json:"total"`
	List          interface{} `json:"list"`
}

// List Services Statistical
func (c *ServicesStatisticalController) List() {

	// request body
	var paginationData ServicesStatisticalPaginationData
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &paginationData); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", err)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(paginationData.PageOn, "page_on").Message("page_on不能为空！")
	valid.Required(paginationData.PageSize, "page_size").Message("page_size不能为空！")
	valid.Required(paginationData.Cid, "cid").Message("cid不能为空！")
	valid.Required(paginationData.Date, "date").Message("date不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	o := orm.NewOrm()

	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	startDateStr := paginationData.Date + " 00:00:00"
	endDateStr := paginationData.Date + " 23:59:59"
	startDate, _ := time.ParseInLocation(layoutDate, startDateStr, loc)
	endDate, _ := time.ParseInLocation(layoutDate, endDateStr, loc)

	var params []orm.Params
	type TotalModel struct {
		Count int64
	}
	var totalModel TotalModel

	// Deduplication
	addSQL := " COUNT(*) "
	if paginationData.IsDeWeighting {
		addSQL = " count(distinct user_account) "
	}

	o.Raw("SELECT "+addSQL+" AS `count` FROM services_statistical AS s INNER JOIN (SELECT * FROM `user`) AS u ON s.user_account = u.id AND s.service_account = ? AND s.create_at > ? AND s.create_at < ?", paginationData.Cid, startDate.Unix(), endDate.Unix()).QueryRow(&totalModel)
	paginationData.Total = totalModel.Count

	// Deduplication
	addSQL1 := " "
	if paginationData.IsDeWeighting {
		addSQL1 = " GROUP BY `user_account` "
	}

	if counter, _ := o.Raw("SELECT s.id, s.user_account, s.service_account,s.create_at, s.transfer_account,s.platform,u.nickname FROM services_statistical AS s INNER JOIN (SELECT * FROM `user` ) AS u ON s.user_account = u.id AND s.service_account = ? AND s.create_at > ? AND s.create_at < ? "+addSQL1+" ORDER BY s.create_at DESC LIMIT ?,?", paginationData.Cid, startDate.Unix(), endDate.Unix(), (paginationData.PageOn-1)*paginationData.PageSize, paginationData.PageSize).Values(&params); counter <= 0 {
		paginationData.List = []string{}
		c.Data["json"] = paginationData
	} else {
		paginationData.List = params
		c.Data["json"] = paginationData
	}

	c.ServeJSON()
}
