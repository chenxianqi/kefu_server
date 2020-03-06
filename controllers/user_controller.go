package controllers

import (
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// UserController struct
type UserController struct {
	beego.Controller
}

// Get get a user
func (c *UserController) Get() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	user := models.User{ID: id}
	if err := o.Read(&user); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &user)
	}
	c.ServeJSON()

}

// Put update a user
func (c *UserController) Put() {

	// request
	user := models.User{}
	user.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &user); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", err)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(user.ID, "id").Message("用户ID不能为空！")
	valid.MaxSize(user.Address, 80, "address").Message("用户所在地区不能超过80个字符！")
	valid.MaxSize(user.NickName, 15, "nickname").Message("用户昵称不能超过15个字符！")
	valid.MaxSize(user.Phone, 20, "phone").Message("用户联系方式不能超过20个字符！")
	valid.MaxSize(user.Remarks, 150, "remarks").Message("用户备注不能超过150个字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// orm
	o := orm.NewOrm()
	if _, err := o.Update(&user, "Address", "NickName", "Phone", "Remarks", "UpdateAt", "UpdateAt", "Avatar"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", &user)
	}
	c.ServeJSON()
}

// Post add new user
// 用户创建 请移步（此处暂不提供创建用户逻辑） /v1/im/register
func (c *UserController) Post() {
	c.ServeJSON()
}

// Delete delete remove user
func (c *UserController) Delete() {

	// orm instance
	o := orm.NewOrm()

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// is admin ?
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	_admin := models.Admin{ID: _auth.UID}
	_ = o.Read(&_admin)
	if _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限删除用户!", nil)
		c.ServeJSON()
		return
	}

	// user
	user := models.User{ID: id}

	// exist
	if err := o.Read(&user); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败，用户不存在!", err)
		c.ServeJSON()
		return
	}

	if num, err := o.Delete(&user); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功！", &num)
	}
	c.ServeJSON()
}

// UsersPaginationData struct
type UsersPaginationData struct {
	PageSize  int         `json:"page_size"`
	PageOn    int         `json:"page_on"`
	Keyword   string      `json:"keyword"`
	Total     int64       `json:"total"`
	Platform  int64       `json:"platform"`
	DateStart string      `json:"date_start"`
	DateEnd   string      `json:"date_end"`
	List      interface{} `json:"list"`
}

// Users get users
func (c *UserController) Users() {

	// request body
	var usersPaginationData UsersPaginationData
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &usersPaginationData); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误", err)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(usersPaginationData.PageOn, "page_on").Message("page_on不能为空！")
	valid.Required(usersPaginationData.PageSize, "page_size").Message("page_size不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// orm instance
	o := orm.NewOrm()
	qs := o.QueryTable(new(models.User))
	cond := orm.NewCondition()
	var cond1 *orm.Condition
	var cond2 *orm.Condition
	if usersPaginationData.Keyword != "" {
		cond1 = cond.Or("nickname__icontains", usersPaginationData.Keyword).Or("phone__icontains", usersPaginationData.Keyword).Or("remarks__icontains", usersPaginationData.Keyword)
	}

	// exist platfrom id?
	if usersPaginationData.Platform != 0 && usersPaginationData.Platform != 1 {
		cond2 = cond.And("platform", usersPaginationData.Platform)
	}
	// exist platfrom date?
	if usersPaginationData.DateStart != "" && usersPaginationData.DateEnd != "" {
		layoutDate := "2006-01-02 15:04:05"
		loc, _ := time.LoadLocation("Local")
		dateStartString := usersPaginationData.DateStart + " 00:00:00"
		dateEndString := usersPaginationData.DateEnd + " 23:59:59"
		dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
		dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)
		cond2 = cond2.And("create_at__gte", dateStart.Unix()).And("create_at__lte", dateEnd.Unix())
	}

	// query
	var lists []models.User
	cond3 := cond.AndCond(cond2).OrCond(cond1)
	qs = qs.SetCond(cond3)
	qs = qs.OrderBy("-online", "-create_at").Limit(usersPaginationData.PageSize)
	if _, err := qs.Offset((usersPaginationData.PageOn - 1) * usersPaginationData.PageSize).All(&lists); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败", err)
		c.ServeJSON()
		return
	}
	total, _ := qs.Count()
	usersPaginationData.Total = total
	usersPaginationData.List = &lists
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &usersPaginationData)
	c.ServeJSON()

}

// OnLineCount get all online user count
func (c *UserController) OnLineCount() {

	o := orm.NewOrm()
	if onLineCount, err := o.QueryTable(models.User{}).Filter("online", 1).Count(); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败！", nil)
		c.ServeJSON()
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", onLineCount)
		c.ServeJSON()
	}

}
