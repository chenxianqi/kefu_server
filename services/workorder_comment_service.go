package services

import (
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
)

// WorkOrderCommentRepositoryInterface interface
type WorkOrderCommentRepositoryInterface interface {
	GetWorkOrderComments(wid int64) ([]models.WorkOrderCommentDto, error)
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
func (r *WorkOrderCommentRepository) GetWorkOrderComments(wid int64) ([]models.WorkOrderCommentDto, error) {
	var workOrderComments []models.WorkOrderCommentDto
	_, err := r.o.Raw("SELECT * FROM (SELECT w.*,w.id AS i_d,u.nickname AS u_nickname,a.nickname AS a_nickname,a.avatar AS a_avatar,u.avatar AS u_avatar FROM work_order_comment w LEFT JOIN (SELECT * FROM admin) a ON w.aid = a.id LEFT JOIN (SELECT * FROM `user`) u ON w.uid = u.id AND w.wid = ? ORDER BY w.id ASC) b WHERE wid = ?", wid, wid).QueryRows(&workOrderComments)
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
