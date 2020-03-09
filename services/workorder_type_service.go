package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderTypeRepositoryInterface interface
type WorkOrderTypeRepositoryInterface interface {
	GetWorkOrder() *models.WorkOrderType
	Update(id int64,params *orm.Params) (int64, error)
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



// Update WorkOrderType Info
func (r *WorkOrderTypeRepository) Update(id int64,params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update WorkOrderType Info------------", err)
	}
	return index, err
}
