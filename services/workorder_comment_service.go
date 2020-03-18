package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
)

// WorkOrderCommentRepositoryInterface interface
type WorkOrderCommentRepositoryInterface interface {
	GetWorkOrder() *models.WorkOrderComment
	DeleteAll(wid int64) (int64, error)
}

// WorkOrderCommentRepository struct
type WorkOrderCommentRepository struct {
	BaseRepository
}

// GetWorkOrderCommentRepositoryInstance get instance
func GetWorkOrderCommentRepositoryInstance() *WorkOrderCommentRepository {
	instance := new(WorkOrderCommentRepository)
	instance.Init(new(models.WorkOrderComment))
	return instance
}

// DeleteAll delete all WorkOrderComment
func (r *WorkOrderRepository) DeleteAll(wid int64) (int64, error) {
	index, err := r.q.Filter("wid", wid).Delete()
	if err != nil {
		logs.Warn(" DeleteAll delete all WorkOrderComment------------", err)
	}
	return index, err
}
