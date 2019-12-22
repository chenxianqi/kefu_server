package controllers

import (
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"math"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// HomeController struct
type HomeController struct {
	beego.Controller
}

// StatisticalRequest home Statistical
type StatisticalRequest struct {
	DateStart string `json:"date_start"`
	DateEnd   string `json:"date_end"`
}

// Statistical statistical services
func (c *HomeController) Statistical() {

	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	admin := models.Admin{Token: token}
	if err := o.Read(&admin, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在", err)
		c.ServeJSON()
		return
	}

	// request body
	statisticalRequest := StatisticalRequest{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &statisticalRequest); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(statisticalRequest.DateStart, "date_start").Message("date_start不能为空！")
	valid.Required(statisticalRequest.DateEnd, "date_end").Message("date_end不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// transform date
	var oneDaySecond float64 = 86400
	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	dateStartString := statisticalRequest.DateStart + " 00:00:00"
	dateEndString := statisticalRequest.DateEnd + " 23:59:59"
	dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
	dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)
	k := dateEnd.Unix() - dateStart.Unix()
	maxDay := int(math.Ceil(float64(k) / oneDaySecond))
	if maxDay < 1 || maxDay >= 32 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "日期有误，最大只能查询一个月以内", nil)
		c.ServeJSON()
		return
	}
	countsArr := map[string]interface{}{}

	// Count customer service access
	var membersData []orm.Params
	_, _ = o.Raw("SELECT a.id, a.username, a.nickname, IFNULL(s.count,0) as count FROM `admin` a LEFT JOIN (SELECT service_account,COUNT(*) AS count FROM services_statistical WHERE `create_at` BETWEEN ? AND	? GROUP BY service_account) s ON a.id = s.service_account ORDER BY a.id", dateStart.Unix(), dateEnd.Unix()).Values(&membersData)
	countsArr["members"] = membersData

	// Count the traffic of each channel
	var statisticalData []interface{}
	for i := 0; i < maxDay; i++ {
		var statisticalTemp []orm.Params
		increment := int64(i) * int64(oneDaySecond)
		start := dateStart.Unix() + increment
		end := start + int64(oneDaySecond)
		if i == maxDay-1 {
			end = dateEnd.Unix()
		}
		_, _ = o.Raw("SELECT p.id, p.title, IFNULL(s.count,0) as count FROM `platform` p LEFT JOIN (SELECT platform,COUNT(*) AS count FROM `services_statistical`  WHERE `create_at` BETWEEN ? AND ? GROUP BY platform) s ON p.id = s.platform ORDER BY p.id", start, end).Values(&statisticalTemp)
		day := time.Unix(start, 0).Format("2006-01-02")
		statisticalArrItem := map[string]interface{}{}
		statisticalArrItem["date"] = day
		statisticalArrItem["list"] = statisticalTemp
		statisticalData = append(statisticalData, statisticalArrItem)
	}
	countsArr["statistical"] = statisticalData

	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &countsArr)
	c.ServeJSON()
}

// TodayActionStatistical today Statistical
func (c *HomeController) TodayActionStatistical() {

	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	admin := models.Admin{Token: token}
	if err := o.Read(&admin, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在", err)
		c.ServeJSON()
		return
	}

	// request body
	statisticalRequest := StatisticalRequest{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &statisticalRequest); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(statisticalRequest.DateStart, "date_start").Message("date_start不能为空！")
	valid.Required(statisticalRequest.DateEnd, "date_end").Message("date_end不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// transform date
	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	dateStartString := statisticalRequest.DateStart + " 00:00:00"
	dateEndString := statisticalRequest.DateEnd + " 23:59:59"
	dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
	dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)

	var statisticalData []orm.Params
	_, _ = o.Raw("SELECT p.id platform,p.title, IFNULL(u.count,0) AS `count` FROM platform as p LEFT  JOIN (SELECT platform,COUNT(*) AS count FROM `user` WHERE last_activity BETWEEN ? AND ? GROUP BY platform) u ON p.id = u.platform", dateStart.Unix(), dateEnd.Unix()).Values(&statisticalData)

	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &statisticalData)
	c.ServeJSON()
}
