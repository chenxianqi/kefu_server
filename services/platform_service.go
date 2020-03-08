package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// PlatformRepositoryInterface interface
type PlatformRepositoryInterface interface {
	GetPlatform(id int64) *models.Platform
	GetPlatformAll(orderByKey string) ([]models.Platform, error)
	Add(platform *models.Platform, col1 string) (bool, int64, error)
	GetPlatformWithIDAndTitle(id int64, title string) *models.Platform
	GetPlatformWithIDAndAlias(id int64, alias string) *models.Platform
	Update(id int64, params *orm.Params) (int64, error)
	Delete(id int64) (int64, error)
}

//PlatformRepository struct
type PlatformRepository struct {
	BaseRepository
}

// GetPlatformRepositoryInstance get instance
func GetPlatformRepositoryInstance() *PlatformRepository {
	instance := new(PlatformRepository)
	instance.Init(new(models.Platform))
	return instance
}

// Add create a Platform
func (r *PlatformRepository) Add(platform *models.Platform, col1 string) (bool, int64, error) {
	_bool, index, err := r.o.ReadOrCreate(platform, col1)
	if err != nil {
		logs.Warn("Add create a Platform------------", err)
	}
	return _bool, index, err
}

// GetPlatform get one platform
func (r *PlatformRepository) GetPlatform(id int64) *models.Platform {
	var platform models.Platform
	if err := r.q.Filter("id", id).One(&platform); err != nil {
		logs.Warn("GetPlatformWithIDAndTitle get one platform with it and title------------", err)
		return nil
	}
	return &platform
}

// GetPlatformAll get all platform
func (r *PlatformRepository) GetPlatformAll(orderByKey string) ([]models.Platform, error) {
	var platforms []models.Platform
	if _, err := r.q.OrderBy(orderByKey).All(&platforms); err != nil {
		logs.Warn("GetPlatforms get all platform------------", err)
		return nil, err
	}
	return platforms, nil
}

// GetPlatformWithIDAndTitle get one platform with it and title
func (r *PlatformRepository) GetPlatformWithIDAndTitle(id int64, title string) *models.Platform {
	var platform models.Platform
	err := r.o.Raw("SELECT * FROM platform WHERE id != ? AND title = ?", id, title).QueryRow(&platform)
	if err != nil {
		logs.Warn("GetPlatformWithIDAndTitle get one platform with it and title------------", err)
		return nil
	}
	return &platform
}

// Update Platform
func (r *PlatformRepository) Update(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update Platform------------", err)
	}
	return index, err
}

// GetPlatformWithIDAndAlias get one platform with it and alias
func (r *PlatformRepository) GetPlatformWithIDAndAlias(id int64, alias string) *models.Platform {
	var platform models.Platform
	err := r.o.Raw("SELECT * FROM platform WHERE id != ? AND alias = ?", id, alias).QueryRow(&platform)
	if err != nil {
		logs.Warn("GetPlatformWithIDAndAlias get one platform with it and alias------------", err)
		return nil
	}
	return &platform
}

// Delete delete a platform
func (r *PlatformRepository) Delete(id int64) (int64, error) {
	index, err := r.q.Filter("id", id).Delete()
	if err != nil {
		logs.Warn("Delete delete a platform------------", err)
	}
	return index, err
}
