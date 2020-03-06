package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
)

// PlatformRepositoryInterface interface
type PlatformRepositoryInterface interface {
	GetPlatform(id int64) *models.Platform
	Add(platform *models.Platform, col1 string) (bool, int64, error)
}

//PlatformRepository struct
type PlatformRepository struct {
	BaseRepository
}

// Add create a Platform
func (r *PlatformRepository) Add(platform *models.Platform, col1 string) (bool, int64, error) {
	_bool, index, err := r.o.ReadOrCreate(&platform, col1)
	if err != nil {
		logs.Warn("Add create a Platform------------", err)
	}
	return _bool, index, err
}

// GetPlatform get one platform
func (r *PlatformRepository) GetPlatform(id int64) *models.Platform {
	var platform models.Platform
	if err := r.q.Filter("id", id).One(&platform); err != nil {
		logs.Warn("GetPlatform get one platform------------", err)
		return nil
	}
	return &platform
}
