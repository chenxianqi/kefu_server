package services

import (
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
)

// WorkOrderCommentRepositoryInterface interface
type WorkOrderCommentRepositoryInterface interface {
	GetWorkOrderComments(wid int64) ([]models.WorkOrderComment, error)
	Add(workOrderComment models.WorkOrderComment) (int64, error)
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

// GetWorkOrderComments get WorkOrderComments
func (r *WorkOrderCommentRepository) GetWorkOrderComments(wid int64) ([]models.WorkOrderComment, error) {
	var workOrderComments []models.WorkOrderComment
	_, err := r.q.Filter("wid", wid).OrderBy("id").All(&workOrderComments)
	if err != nil {
		logs.Warn("GetWorkOrderComments get WorkOrderComments-----------", err)
	}
	return workOrderComments, err
}

// Add add WorkOrderComment
func (r *WorkOrderCommentRepository) Add(workOrderComment models.WorkOrderComment) (int64, error) {
	workOrderComment.CreateAt = time.Now().Unix()
	index, err := r.o.Insert(&workOrderComment)
	if err != nil {
		logs.Warn(" Add add WorkOrderComment------------", err)
	}
	return index, err
}
