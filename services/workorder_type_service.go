package services

import (
	"errors"
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderTypeRepositoryInterface interface
type WorkOrderTypeRepositoryInterface interface {
	GetWorkOrderType(id int64) (models.WorkOrderType, error)
	GetWorkOrderTypes() []models.WorkOrderType
	Update(id int64, params orm.Params) (int64, error)
	Delete(id int64) (int64, error)
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
	isNew, id, err := r.o.ReadOrCreate(&data, "title")
	if err != nil {
		logs.Warn("Add add a WorkOrderType------------", err)
	}
	return isNew, id, err
}

// Delete del a WorkOrderType
func (r *WorkOrderTypeRepository) Delete(id int64) (int64, error) {
	// 增加工单分类检查是否有内容
	row, err := r.q.Filter("id", id).Delete()
	if err != nil {
		logs.Warn("Delete del a WorkOrderType------------", err)
	}
	return row, err
}

// GetWorkOrderType get
func (r *WorkOrderTypeRepository) GetWorkOrderType(id int64) (models.WorkOrderType, error) {
	var workOrderType models.WorkOrderType
	err := r.q.Filter("id", id).One(&workOrderType)
	if err != nil {
		logs.Warn(" GetWorkOrderType get------------", err)
	}
	return workOrderType, err
}

// GetWorkOrderTypes get all
func (r *WorkOrderTypeRepository) GetWorkOrderTypes() []models.WorkOrderType {
	var workOrderTypes []models.WorkOrderType
	_, err := r.q.All(&workOrderTypes)
	if err != nil {
		logs.Warn("GetWorkOrderTypes get all------------", err)
		return []models.WorkOrderType{}
	}
	return workOrderTypes
}

// Update WorkOrderType Info
func (r *WorkOrderTypeRepository) Update(id int64, params orm.Params) (int64, error) {
	var res models.WorkOrderType
	err := r.q.Filter("id", id).Filter("title", params["title"].(string)).One(&res)
	if err == nil {
		return 0, errors.New("title already exists")
	}
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update WorkOrderType Info------------", err)
	}
	return index, err
}
