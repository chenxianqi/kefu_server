package services

import (
	"kefu_server/models"
	"strings"

	"github.com/astaxie/beego/logs"
)

// RobotRepositoryInterface interface
type RobotRepositoryInterface interface {
	GetRobot(id int64) *models.Robot
	GetRobots() ([]models.Robot, error)
	GetRobotWithInIds(ids ...int64) ([]models.Robot, error)
}

// RobotRepository struct
type RobotRepository struct {
	BaseRepository
}

// GetRobots get Robots
func (r *RobotRepository) GetRobots() ([]models.Robot, error) {
	var robots []models.Robot
	if _, err := r.q.OrderBy("-create_at").All(&robots); err != nil {
		logs.Warn("GetRobot get one Robot------------", err)
		return nil, err
	}
	for index := range robots {
		robots[index].Artificial = strings.Trim(robots[index].Artificial, "|")
	}
	return robots, nil
}

// GetRobot get one Robot
func (r *RobotRepository) GetRobot(id int64) *models.Robot {
	var robot models.Robot
	if err := r.q.Filter("id", id).One(&robot); err != nil {
		logs.Warn("GetRobot get one Robot------------", err)
		return nil
	}
	return &robot
}

// GetRobotWithInIds get one Robot with in() ids
func (r *RobotRepository) GetRobotWithInIds(ids ...int64) ([]models.Robot, error) {
	var robots []models.Robot
	_, err := r.o.Raw("SELECT * FROM robot WHERE id IN(?, ?)", ids).QueryRows(&robots)
	if err != nil {
		logs.Warn("GetRobot get one Robot------------", err)
	}
	return robots, err
}
