package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderRepositoryInterface interface
type WorkOrderRepositoryInterface interface {
	GetWorkOrder() *models.WorkOrder
	Update(id int64,params *orm.Params) (int64, error)
}

// WorkOrderRepository struct
type WorkOrderRepository struct {
	BaseRepository
}

// GetWorkOrderRepositoryInstance get instance
func GetWorkOrderRepositoryInstance() *WorkOrderRepository {
	instance := new(WorkOrderRepository)
	instance.Init(new(models.WorkOrder))
	return instance
}



// Update WorkOrder Info
func (r *WorkOrderRepository) Update(id int64,params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update WorkOrder Info------------", err)
	}
	return index, err
}
