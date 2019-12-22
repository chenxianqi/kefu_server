package controllers

import (
	"encoding/json"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"

	"kefu_server/im"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"
	"strings"
	"time"
)

// RobotController struct
type RobotController struct {
	beego.Controller
}

// Get get robot
func (c *RobotController) Get() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	robot := models.Robot{ID: id}
	if err := o.Read(&robot); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "获取失败!", err)
		c.ServeJSON()
		return
	}

	robot.Artificial = strings.Trim(robot.Artificial, "|")
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &robot)
	c.ServeJSON()

}

// Delete delete robot
func (c *RobotController) Delete() {

	o := orm.NewOrm()
	token := c.Ctx.Input.Header("Authorization")
	_admin := models.Admin{Token: token}
	_ = o.Read(&_admin, "Token")
	if _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限删除机器人!", nil)
		c.ServeJSON()
		return
	}

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	robot := models.Robot{ID: id}

	// exist
	if err := o.Read(&robot); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败，机器人不存在!", err)
		c.ServeJSON()
		return
	}

	if robot.System == 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "不能删除该机器人，系统保留!", nil)
		c.ServeJSON()
		return
	}

	if num, err := o.Delete(&robot); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", nil)
	} else {
		// init robots
		im.RobotInit()
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功！", &num)
	}
	c.ServeJSON()

}

// Post add robot
func (c *RobotController) Post() {

	o := orm.NewOrm()
	token := c.Ctx.Input.Header("Authorization")
	_admin := models.Admin{Token: token}
	_ = o.Read(&_admin, "Token")
	if _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限添加机器人!", nil)
		c.ServeJSON()
		return
	}

	// request body
	var robot models.Robot
	robot.CreateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &robot); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", err)
		c.ServeJSON()
		return
	}

	// exist robot?
	oldRobot := models.Robot{NickName: robot.NickName}
	if err := o.Read(&oldRobot, "NickName"); err == nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "已存在一个名为"+robot.NickName+"的机器人!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(robot.Avatar, "avatar").Message("请设置一个机器人头像！")
	valid.Required(robot.NickName, "nickname").Message("机器人名不能为空！")
	valid.Required(robot.Welcome, "welcome").Message("请设置机器人欢迎语！")
	valid.Required(robot.Understand, "understand").Message("请设置机器人无法识别回复语！")
	valid.Required(robot.KeyWord, "keyword").Message("请设置检索知识库热词！")
	valid.Required(robot.Artificial, "artificial").Message("请设置转人工关键字！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// insert
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	if robot.Artificial != "" {
		robot.Artificial = "|" + robot.Artificial + "|"
	}
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	if robot.KeyWord != "" {
		robot.KeyWord = "|" + robot.KeyWord + "|"
	}
	if id, err := o.Insert(&robot); err == nil {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "添加成功！", &id)
		im.RobotInit()
	} else {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "服务异常!", err)
	}
	c.ServeJSON()

}

// Put update robot
func (c *RobotController) Put() {

	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	_admin := models.Admin{Token: token}
	_ = o.Read(&_admin, "Token")
	if _admin.Root != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "您没有权限修改机器人!", nil)
		c.ServeJSON()
		return
	}

	// RequestBody
	var robot models.Robot
	robot.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &robot); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", err)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(robot.ID, "id").Message("机器人不存在！")
	valid.Required(robot.Avatar, "avatar").Message("请设置一个机器人头像！")
	valid.Required(robot.NickName, "nickname").Message("机器人名不能为空！")
	valid.Required(robot.Welcome, "welcome").Message("请设置机器人欢迎语！")
	valid.Required(robot.Understand, "understand").Message("请设置机器人无法识别回复语！")
	valid.Required(robot.KeyWord, "keyword").Message("请设置检索知识库热词！")
	valid.Required(robot.Artificial, "artificial").Message("请设置转人工关键字！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// is change default robot ?
	if robot.System == 1 && robot.Switch == 0 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "不能暂停该机器人！", nil)
		c.ServeJSON()
		return
	}

	// is change default robot ?
	if robot.System == 1 && robot.Platform != 1 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "不能修改该机器人平台！", nil)
		c.ServeJSON()
		return
	}

	// exist
	oldRobot := models.Robot{ID: robot.ID}
	if err := o.Read(&oldRobot); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "机器人"+robot.NickName+"不存在", nil)
		c.ServeJSON()
		return
	}

	// robot name exist
	oldRobot = models.Robot{NickName: robot.NickName}
	if err := o.Read(&oldRobot, "NickName"); err == nil && oldRobot.ID != robot.ID {
		c.Data["json"] = utils.ResponseError(c.Ctx, "已存在一个名为"+robot.NickName+"的机器人", nil)
		c.ServeJSON()
		return
	}

	// insert
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	if robot.Artificial != "" {
		robot.Artificial = "|" + robot.Artificial + "|"
	}
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	if robot.KeyWord != "" {
		robot.KeyWord = "|" + robot.KeyWord + "|"
	}
	if _, err := o.Update(&robot, "NickName", "Avatar", "Welcome", "Understand", "Artificial", "Switch", "UpdateAt", "KeyWord", "TimeoutText", "NoServices", "LoogTimeWaitText"); err == nil {
		robot.Artificial = strings.Trim(robot.Artificial, "|")
		robot.KeyWord = strings.Trim(robot.KeyWord, "|")
		robot.CreateAt = oldRobot.CreateAt
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "修改成功！", &robot)
		im.RobotInit()
	} else {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "修改失败!", err)
	}
	c.ServeJSON()

}

// List get robot all
func (c *RobotController) List() {

	o := orm.NewOrm()
	robot := new(models.Robot)
	qs := o.QueryTable(robot)

	// query
	var lists []models.Robot
	if _, err := qs.OrderBy("create_at").All(&lists); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
		c.ServeJSON()
		return
	}
	for index := range lists {
		lists[index].Artificial = strings.Trim(lists[index].Artificial, "|")
		lists[index].KeyWord = strings.Trim(lists[index].KeyWord, "|")
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &lists)
	c.ServeJSON()
}
