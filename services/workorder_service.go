package services

import (
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderRepositoryInterface interface
type WorkOrderRepositoryInterface interface {
	GetWorkOrder() models.WorkOrder
	Update(id int64, params *orm.Params) (int64, error)
	Add(workOrder models.WorkOrder) (int64, error)
	Delete(id int64) (int64, error)
}

// WorkOrderRepository struct
type WorkOrderRepository struct {
	BaseRepository
	WorkOrderCommentRepository *WorkOrderCommentRepository
}

// GetWorkOrderRepositoryInstance get instance
func GetWorkOrderRepositoryInstance() *WorkOrderRepository {
	instance := new(WorkOrderRepository)
	instance.Init(new(models.WorkOrder))
	instance.WorkOrderCommentRepository = GetWorkOrderCommentRepositoryInstance()
	return instance
}

// Delete delete WorkOrder
func (r *WorkOrderRepository) Delete(id int64) (int64, error) {
	index, err := r.q.Filter("id", id).Delete()
	if err != nil {
		logs.Warn("Delete delete WorkOrder------------", err)
	}
	if index > 0 {
		_, err := r.WorkOrderCommentRepository.DeleteAll(id)
		if err != nil {
			logs.Warn("Delete delete WorkOrder child------------", err)
		}
	}
	return index, err
}

// Add add WorkOrder
func (r *WorkOrderRepository) Add(workOrder models.WorkOrder) (int64, error) {
	createAt := time.Now().Unix()
	workOrder.CreateAt = createAt
	wid, err := r.o.Insert(workOrder)
	if err != nil {
		logs.Warn("Add add WorkOrder------------", err)
	}
	if wid > 0 {
		r.WorkOrderCommentRepository.Add(models.WorkOrderComment{
			WID:      wid,
			Content:  workOrder.Content,
			CreateAt: createAt,
		})
	}
	return wid, err
}

// Update WorkOrder Info
func (r *WorkOrderRepository) Update(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update WorkOrder Info------------", err)
	}
	return index, err
}
