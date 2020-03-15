package services

import (
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderTypeRepositoryInterface interface
type WorkOrderTypeRepositoryInterface interface {
	GetWorkOrderType() *models.WorkOrderType
	Update(id int64, params *orm.Params) (int64, error)
	Add(data models.WorkOrderType) (bool, int64, error)
}

// WorkOrderTypeRepository struct
type WorkOrderTypeRepository struct {
	BaseRepository
}

// GetWorkOrderTypeRepositoryInstance get instance
func GetWorkOrderTypeRepositoryInstance() *WorkOrderTypeRepository {
	instance := new(WorkOrderTypeRepository)
	instance.Init(new(models.WorkOrderType))
	return instance
}

// Add add a WorkOrderType
func (r *WorkOrderTypeRepository) Add(data models.WorkOrderType) (bool, int64, error) {
	data.CreateAt = time.Now().Unix()
	isNew, row, err := r.o.ReadOrCreate(&data, "title")
	if err != nil {
		logs.Warn("Add add a WorkOrderType------------", err)
	}
	return isNew, row, err
}

// Update WorkOrderType Info
func (r *WorkOrderTypeRepository) Update(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update WorkOrderType Info------------", err)
	}
	return index, err
}
