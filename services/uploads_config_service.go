package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
)

// UploadsConfigRepositoryInterface interface
type UploadsConfigRepositoryInterface interface {
	GetUploadsConfig(id int64) *models.UploadsConfig
	GetUploadsConfigs() []*models.UploadsConfig
}

// UploadsConfigRepository struct
type UploadsConfigRepository struct {
	BaseRepository
}

// GetUploadsConfigRepositoryInstance get instance
func GetUploadsConfigRepositoryInstance() *UploadsConfigRepository {
	instance := new(UploadsConfigRepository)
	instance.Init(new(models.UploadsConfig))
	return instance
}

// GetUploadsConfig get one UploadsConfig
func (r *UploadsConfigRepository) GetUploadsConfig(id int64) *models.UploadsConfig {
	var config models.UploadsConfig
	if err := r.q.Filter("id", id).One(&config); err != nil {
		logs.Warn("GetUploadsConfig get one UploadsConfig------------", err)
	}
	return &config
}

// GetUploadsConfigs get UploadsConfig all
func (r *UploadsConfigRepository) GetUploadsConfigs() []*models.UploadsConfig {
	var configs []*models.UploadsConfig
	if _, err := r.q.All(&configs); err != nil {
		logs.Warn("GetUploadsConfigs get UploadsConfig all------------", err)
	}
	return configs
}
