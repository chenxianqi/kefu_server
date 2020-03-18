package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// QiniuRepositoryInterface interface
type QiniuRepositoryInterface interface {
	GetQiniu() *models.QiniuSetting
	Update(params *orm.Params) (int64, error)
}

// QiniuRepository struct
type QiniuRepository struct {
	BaseRepository
}

// GetQiniuRepositoryInstance get instance
func GetQiniuRepositoryInstance() *QiniuRepository {
	instance := new(QiniuRepository)
	instance.Init(new(models.QiniuSetting))
	return instance
}

// GetQiniuConfigInfo get Qiniu Info
func (r *QiniuRepository) GetQiniuConfigInfo() *models.QiniuSetting {
	var system models.QiniuSetting
	if err := r.q.Filter("id", 1).One(&system); err != nil {
		logs.Warn("GetQiniu get Qiniu Info------------", err)
		return nil
	}
	return &system
}

// Update Qiniu Info
func (r *QiniuRepository) Update(params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", 1).Update(params)
	if err != nil {
		logs.Warn("Update Qiniu Info------------", err)
	}
	return index, err
}
