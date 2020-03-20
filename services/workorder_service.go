package services

import (
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderRepositoryInterface interface
type WorkOrderRepositoryInterface interface {
	GetWorkOrder(id int64) (models.WorkOrder, error)
	GetUserWorkOrders(uid int64) ([]models.WorkOrder, error)
	Update(id int64, params *orm.Params) (int64, error)
	Add(workOrder models.WorkOrder) (int64, error)
	Delete(id int64) (int64, error)
	Close(id int64, cid int64, remark string) (int64, error)
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

// Close close WorkOrder
func (r *WorkOrderRepository) Close(id int64, cid int64, remark string) (int64, error) {
	row, err := r.q.Filter("id", id).Update(orm.Params{
		"Status": 3,
	})
	if err != nil {
		logs.Warn("Close close WorkOrder-----------", err)
	}
	if _, err := r.Update(id, orm.Params{
		"Remark":  remark,
		"Cid":     cid,
		"CloseAt": time.Now().Unix(),
	}); err != nil {
		logs.Warn("Close close WorkOrder-----------", err)
	}
	return row, err
}

// GetUserWorkOrders get user WorkOrders
func (r *WorkOrderRepository) GetUserWorkOrders(uid int64) ([]models.WorkOrder, error) {
	var workOrders []models.WorkOrder
	_, err := r.q.Filter("uid", uid).Filter("delete", 0).OrderBy("-id").All(&workOrders)
	if err != nil {
		logs.Warn("GetUserWorkOrders get user WorkOrders------------", err)
	}
	return workOrders, err
}

// GetWorkOrder get WorkOrder
func (r *WorkOrderRepository) GetWorkOrder(id int64) (models.WorkOrder, error) {
	var workOrder models.WorkOrder
	err := r.q.Filter("id", id).Filter("delete", 0).One(&workOrder)
	if err != nil {
		logs.Warn("GetWorkOrder get WorkOrder------------", err)
	}
	return workOrder, err
}

// Delete delete WorkOrder
func (r *WorkOrderRepository) Delete(id int64) (int64, error) {
	row, err := r.q.Filter("id", id).Update(orm.Params{
		"Delete": 1,
	})
	if err != nil {
		logs.Warn("Delete delete WorkOrder-----------", err)
	}
	return row, err
}

// Add add WorkOrder
func (r *WorkOrderRepository) Add(workOrder models.WorkOrder) (int64, error) {
	createAt := time.Now().Unix()
	workOrder.CreateAt = createAt
	wid, err := r.o.Insert(&workOrder)
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
	params["UpdateAt"] = time.Now().Unix()
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update WorkOrder Info------------", err)
	}
	return index, err
}
