package services

import (
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderCommentRepositoryInterface interface
type WorkOrderCommentRepositoryInterface interface {
	GetWorkOrderComments(wid int64) ([]orm.Params, error)
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
func (r *WorkOrderCommentRepository) GetWorkOrderComments(wid int64) ([]orm.Params, error) {
	var workOrderComments []orm.Params
	_, err := r.o.Raw("SELECT * FROM (SELECT w.*,a.nickname,a.avatar FROM work_order_comment w LEFT JOIN (SELECT * FROM admin) a ON w.a_i_d = a.id AND w.wid = ? ORDER BY w.id DESC) b WHERE wid = ?", wid, wid).Values(&workOrderComments)
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
