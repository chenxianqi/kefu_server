package services

import (
	"errors"
	"kefu_server/models"
	"math/rand"
	"strings"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// RobotRepositoryInterface interface
type RobotRepositoryInterface interface {
	GetRobot(id int64) *models.Robot
	GetRobotWithNickName(nickName string) *models.Robot
	GetRobotWithOnline(platformID int64) (*models.Robot, error)
	GetRobotOnlineAll() ([]*models.Robot, error)
	GetRobotWithRandomOnline() *models.Robot
	GetRobots() ([]models.Robot, error)
	GetRobotWithInIds(ids ...int64) ([]models.Robot, error)
	Delete(id int64) (int64, error)
	Add(robot *models.Robot) (int64, error)
	Update(id int64, params *orm.Params) (int64, error)
}

// RobotRepository struct
type RobotRepository struct {
	BaseRepository
}

// GetRobotRepositoryInstance get instance
func GetRobotRepositoryInstance() *RobotRepository {
	instance := new(RobotRepository)
	instance.Init(new(models.Robot))
	return instance
}

// Add a robot
func (r *RobotRepository) Add(robot *models.Robot) (int64, error) {
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	if robot.Artificial != "" {
		robot.Artificial = "|" + robot.Artificial + "|"
	}
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	if robot.KeyWord != "" {
		robot.KeyWord = "|" + robot.KeyWord + "|"
	}
	index, err := r.o.Insert(robot)
	if err != nil {
		logs.Warn("Add create a robot------------", err)
	}
	return index, err
}

// Update robot
func (r *RobotRepository) Update(id int64, params orm.Params) (int64, error) {
	srtificial := params["Artificial"].(string)
	keyWord := params["KeyWord"].(string)
	srtificial = strings.Trim(srtificial, "|")
	if srtificial != "" {
		srtificial = "|" + srtificial + "|"
	}
	keyWord = strings.Trim(keyWord, "|")
	if keyWord != "" {
		keyWord = "|" + keyWord + "|"
	}
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update robot------------", err)
	}
	return index, err
}

// GetRobots get Robots
func (r *RobotRepository) GetRobots() ([]models.Robot, error) {
	var robots []models.Robot
	if _, err := r.q.Filter("delete", 0).OrderBy("-create_at").All(&robots); err != nil {
		logs.Warn("GetRobots get Robots------------", err)
		return nil, err
	}
	for index := range robots {
		robots[index].Artificial = strings.Trim(robots[index].Artificial, "|")
		robots[index].KeyWord = strings.Trim(robots[index].KeyWord, "|")
	}
	return robots, nil
}

// GetRobot get one Robot
func (r *RobotRepository) GetRobot(id int64) *models.Robot {
	var robot models.Robot
	if err := r.q.Filter("delete", 0).Filter("id", id).One(&robot); err != nil {
		logs.Warn("GetRobot get one Robot------------", err)
		return nil
	}
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	return &robot
}

// GetRobotWithNickName get one Robot with nickname
func (r *RobotRepository) GetRobotWithNickName(nickName string) *models.Robot {
	var robot models.Robot
	if err := r.q.Filter("delete", 0).Filter("nickname", nickName).One(&robot); err != nil {
		logs.Warn("GetRobotWithNickName get one Robot with nickname------------", err)
		return nil
	}
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	return &robot
}

// GetRobotWithRandomOnline get one Robot with Random Online
func (r *RobotRepository) GetRobotWithRandomOnline() (*models.Robot, error) {
	var robot *models.Robot
	if err := r.q.Filter("delete", 0).Filter("switch", 1).One(&robot); err != nil {
		logs.Warn("GetRobotWithRandomOnline get one Robot with Random Online------------", err)
		return nil, err
	}
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	return robot, nil
}

// GetRobotOnlineAll get one Robot with Random Online
func (r *RobotRepository) GetRobotOnlineAll() ([]*models.Robot, error) {
	var robots []*models.Robot
	if _, err := r.q.Filter("delete", 0).Filter("switch", 1).All(&robots); err != nil {
		logs.Warn("GetRobotWithRandomOnline get one Robot with Random Online------------", err)
		return nil, err
	}
	for index := range robots {
		robots[index].Artificial = strings.Trim(robots[index].Artificial, "|")
		robots[index].KeyWord = strings.Trim(robots[index].KeyWord, "|")
	}
	return robots, nil
}

// GetRobotWithOnline get one Robot with Online
func (r *RobotRepository) GetRobotWithOnline(platformID int64) (*models.Robot, error) {
	var robots []*models.Robot
	if _, err := r.q.Filter("delete", 0).Filter("platform__in", platformID, 1).Filter("switch", 1).All(&robots); err != nil {
		logs.Warn("GetRobotWithRandom get one Robot with Random------------", err)
		return nil, err
	}
	var robot *models.Robot
	if len(robots) > 0 {
		robot = robots[rand.Intn(len(robots))]
	}
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	robot.KeyWord = strings.Trim(robot.KeyWord, "|")
	return robot, nil
}

// GetRobotWithInIds get one Robot with in() ids
func (r *RobotRepository) GetRobotWithInIds(ids ...int64) ([]models.Robot, error) {
	var robots []models.Robot
	_, err := r.o.Raw("SELECT * FROM robot WHERE id IN(?, ?) AND `delete` = 0", ids).QueryRows(&robots)
	if err != nil {
		logs.Warn("GetRobotWithInIds get one Robot with in() ids", err)
	}
	return robots, err
}

// Delete delete a robot
func (r *RobotRepository) Delete(id int64) (int64, error) {
	if id == 1 {
		return 0, errors.New("system robot do not delete")
	}
	index, err := r.q.Filter("id", id).Update(orm.Params{"Delete": 1})
	if err != nil {
		logs.Warn("Delete delete a robot------------", err)
	}
	return index, err
}
