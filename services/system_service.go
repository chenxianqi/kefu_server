package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// SystemRepositoryInterface interface
type SystemRepositoryInterface interface {
	GetSystem() *models.System
	Update(params orm.Params) (int64, error)
}

// SystemRepository struct
type SystemRepository struct {
	BaseRepository
}

// GetSystemRepositoryInstance get instance
func GetSystemRepositoryInstance() *SystemRepository {
	instance := new(SystemRepository)
	instance.Init(new(models.System))
	return instance
}

// GetSystem get System Info
func (r *SystemRepository) GetSystem() *models.System {
	var system models.System
	if err := r.q.Filter("id", 1).One(&system); err != nil {
		logs.Warn("GetSystem get System Info------------", err)
		return nil
	}
	return &system
}

// Update System
func (r *SystemRepository) Update(params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", 1).Update(params)
	if err != nil {
		logs.Warn("Update System------------", err)
	}
	return index, err
}
