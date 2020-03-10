package robotlbrary

import (
	"kefu_server/models"
	"kefu_server/services"
	"strconv"

	"github.com/Xiaomi-mimc/mimc-go-sdk"
	"github.com/astaxie/beego"
)

// Robots 工作中的机器人
var Robots []*mimc.MCUser

// CreateRobot 创建机器人
func CreateRobot(appAccount string) *mimc.MCUser {
	appID, _ := beego.AppConfig.Int64("mimc_appId")
	mcUser := mimc.NewUser(uint64(appID), appAccount)
	mcUser.RegisterStatusDelegate(NewStatusHandler(appAccount))
	mcUser.RegisterTokenDelegate(NewTokenHandler(appAccount))
	mcUser.RegisterMessageDelegate(NewMsgHandler(appAccount))
	mcUser.InitAndSetup()
	return mcUser
}

// GetRobots get robot all
func GetRobots() []models.Robot {

	// RobotRepository instance
	robotRepository := services.GetRobotRepositoryInstance()
	var robots []models.Robot
	robots, _ = robotRepository.GetRobots()
	return robots
}

// RobotInit 初始化机器人
func RobotInit() {

	// 如果有机器人在工作先退出登录
	if len(Robots) > 0 {
		for _, robot := range Robots {
			robot.Logout()
			robot.Destory()
		}
		Robots = []*mimc.MCUser{}
	}
	robotsData := GetRobots()
	var tempRobots []*mimc.MCUser
	for _, robot := range robotsData {
		if robot.Switch == 1 {
			rb := CreateRobot(strconv.FormatInt(robot.ID, 10))
			tempRobots = append(tempRobots, rb)
			rb.Login()
		}
	}
	Robots = tempRobots
}
