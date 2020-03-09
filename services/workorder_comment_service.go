package services

import (
	"kefu_server/models"
)

// WorkOrderCommentRepositoryInterface interface
type WorkOrderCommentRepositoryInterface interface {
	GetWorkOrder() *models.WorkOrderComment
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

