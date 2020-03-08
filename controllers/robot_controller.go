package controllers

import (
	"encoding/json"

	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"

	"kefu_server/configs"
	"kefu_server/im"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"
	"strings"
	"time"
)

// RobotController struct
type RobotController struct {
	BaseController
	RobotRepository    *services.RobotRepository
	AdminRepository    *services.AdminRepository
	PlatformRepository *services.PlatformRepository
}

// Prepare More like construction method
func (c *RobotController) Prepare() {

	// RobotRepository instance
	c.RobotRepository = services.GetRobotRepositoryInstance()

	// PlatformRepository instance
	c.PlatformRepository = services.GetPlatformRepositoryInstance()

	// AdminRepository instance
	c.AdminRepository = services.GetAdminRepositoryInstance()

}

// Finish Comparison like destructor
func (c *RobotController) Finish() {}

// Get get robot
func (c *RobotController) Get() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	robot := c.RobotRepository.GetRobot(id)
	if robot == nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}

	c.JSON(configs.ResponseSucess, "success", &robot)

}

// Delete delete robot
func (c *RobotController) Delete() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限删除机器人!", nil)
	}

	// get robot
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	robot := c.RobotRepository.GetRobot(id)

	// exist
	if robot == nil {
		c.JSON(configs.ResponseFail, "删除失败，机器人不存在!", nil)
	}

	if robot.System == 1 {
		c.JSON(configs.ResponseFail, "不能删除该机器人，系统保留!", nil)
	}

	if _, err := c.RobotRepository.Delete(id); err != nil {
		c.JSON(configs.ResponseFail, "删除失败!", nil)
	}

	// init robots
	im.RobotInit()
	c.JSON(configs.ResponseSucess, "删除成功!", nil)

}

// Post add robot
func (c *RobotController) Post() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限添加机器人!", nil)
	}

	// request body
	var robot models.Robot
	robot.CreateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &robot); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", &err)
	}

	// is exist platform?
	if platform := c.PlatformRepository.GetPlatform(robot.Platform); platform == nil {
		c.JSON(configs.ResponseFail, "平台参数不存在!", nil)
	}

	// exist robot?
	oldRobot := c.RobotRepository.GetRobotWithNickName(robot.NickName)
	if oldRobot != nil {
		c.JSON(configs.ResponseFail, "已存在一个名为"+robot.NickName+"的机器人!", nil)
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
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// add
	id, err := c.RobotRepository.Add(&robot)
	if err != nil {
		c.JSON(configs.ResponseFail, "添加失败!", nil)
	}

	im.RobotInit()
	c.JSON(configs.ResponseSucess, "添加成功!", id)

}

// Put update robot
func (c *RobotController) Put() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := c.AdminRepository.GetAdmin(auth.UID)
	if admin.Root != 1 {
		c.JSON(configs.ResponseFail, "您没有权限修改机器人!", nil)
	}

	// RequestBody
	var robot models.Robot
	robot.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &robot); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
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
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// is change default robot ?
	if robot.System == 1 && robot.Switch == 0 {
		c.JSON(configs.ResponseFail, "不能暂停该机器人！", nil)
	}

	// is change default robot ?
	if robot.System == 1 && robot.Platform != 1 {
		c.JSON(configs.ResponseFail, "不能修改该机器人平台！", nil)
	}

	// is exist platform?
	if platform := c.PlatformRepository.GetPlatform(robot.Platform); platform == nil {
		c.JSON(configs.ResponseFail, "平台参数不存在!", nil)
	}

	// exist robot
	if rbt := c.RobotRepository.GetRobot(robot.ID); rbt == nil {
		c.JSON(configs.ResponseFail, "机器人不存在", nil)
	}

	// robot name exist
	oldRobot := c.RobotRepository.GetRobotWithNickName(robot.NickName)
	if oldRobot != nil && oldRobot.ID != robot.ID {
		c.JSON(configs.ResponseFail, "已存在一个名为"+robot.NickName+"的机器人", nil)
	}

	// update
	if _, err := c.RobotRepository.Update(robot.ID, orm.Params{
		"NickName":         robot.NickName,
		"Avatar":           robot.Avatar,
		"Welcome":          robot.Welcome,
		"Understand":       robot.Understand,
		"Artificial":       robot.Artificial,
		"Switch":           robot.Switch,
		"UpdateAt":         robot.UpdateAt,
		"KeyWord":          robot.KeyWord,
		"TimeoutText":      robot.TimeoutText,
		"NoServices":       robot.NoServices,
		"LoogTimeWaitText": robot.LoogTimeWaitText,
	}); err != nil {
		c.JSON(configs.ResponseFail, "修改失败!", nil)
	}

	robot.Artificial = strings.Trim(robot.Artificial, "|")
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	robot.CreateAt = oldRobot.CreateAt
	im.RobotInit()
	c.JSON(configs.ResponseSucess, "修改成功!", &robot)

}

// List get robot all
func (c *RobotController) List() {

	// query
	robots, err := c.RobotRepository.GetRobots()
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}
	c.JSON(configs.ResponseSucess, "success", &robots)

}
