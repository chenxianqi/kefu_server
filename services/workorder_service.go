package services

import (
	"kefu_server/models"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// WorkOrderRepositoryInterface interface
type WorkOrderRepositoryInterface interface {
	GetWorkOrders(request models.WorkOrderPaginationDto) (models.WorkOrderPaginationDto, error)
	GetWorkOrder(id int64) (models.WorkOrderDto, error)
	GetWorkOrderCountsWithType(tid int64) int64
	GetUserWorkOrders(uid int64) ([]models.WorkOrder, error)
	Update(id int64, params *orm.Params) (int64, error)
	Add(workOrder models.WorkOrder) (int64, error)
	Delete(id int64) (int64, error)
	Close(id int64, cid int64, remark string) (int64, error)
	GetCounts() (models.WorkOrderCountDto, error)
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

// GetWorkOrderCountsWithType get counts with type id
func (r *WorkOrderRepository) GetWorkOrderCountsWithType(tid int64) int64 {
	counts, err := r.q.Filter("tid", tid).Count()
	if err != nil {
		logs.Warn("GetUserWorkOrders get user WorkOrders------------", err)
		return 0
	}
	return counts
}

// GetUserWorkOrders get user WorkOrders
func (r *WorkOrderRepository) GetUserWorkOrders(uid int64) ([]models.WorkOrder, error) {
	var workOrders []models.WorkOrder
	_, err := r.q.Filter("uid", uid).OrderBy("-id").OrderBy("status").OrderBy("-create_at").All(&workOrders)
	if err != nil {
		logs.Warn("GetUserWorkOrders get user WorkOrders------------", err)
	}
	return workOrders, err
}

// GetCounts get WorkOrder counts
func (r *WorkOrderRepository) GetCounts() (models.WorkOrderCountDto, error) {
	var workOrderCouns models.WorkOrderCountDto
	err := r.o.Raw("SELECT * FROM ((SELECT count(*) AS status0 FROM work_order WHERE `status` = 0 AND `delete` = 0) w0,(SELECT count(*) AS status1 FROM work_order WHERE `status` = 1 AND `delete` = 0) w1,(SELECT count(*) AS status2 FROM work_order WHERE `status` = 2 AND `delete` = 0) w2,(SELECT count(*) AS status3 FROM work_order WHERE `status` = 3 AND `delete` = 0) w3,(SELECT count(*) AS delete_count FROM work_order WHERE `delete` = 1) w4)").QueryRow(&workOrderCouns)
	if err != nil {
		logs.Warn(" GetCounts get WorkOrder count", err)
	}
	return workOrderCouns, err
}

// GetWorkOrder get WorkOrder
func (r *WorkOrderRepository) GetWorkOrder(id int64) (models.WorkOrderDto, error) {
	var workOrder models.WorkOrderDto
	err := r.o.Raw("SELECT * FROM (SELECT w.*,w.id AS i_d, w.uid AS u_i_d, w.tid AS t_i_d, w.cid AS c_i_d,u.nickname AS u_nickname FROM work_order w LEFT JOIN (SELECT * FROM `user`) u ON w.uid = u.id) w WHERE w.id = ?", id).QueryRow(&workOrder)
	if err != nil {
		logs.Warn("GetWorkOrder get WorkOrder------------", err)
	}
	return workOrder, err
}

// GetWorkOrders get WorkOrders
func (r *WorkOrderRepository) GetWorkOrders(request models.WorkOrderPaginationDto) (models.WorkOrderPaginationDto, error) {
	statusSQL := ""
	if request.Status != "" {
		statusSQL = " AND `status` IN(" + strings.Trim(request.Status, ",") + ") "
	}
	tidSQL := ""
	if request.Tid != 0 && request.Tid != -1 && request.Tid != -2 {
		tidSQL = " AND `tid` = " + strconv.FormatInt(request.Tid, 10) + " "
	}
	if request.PageSize == 0 {
		request.PageSize = 10
	}
	if request.PageOn == 0 {
		request.PageOn = 1
	}
	del := strconv.Itoa(request.Del)
	var workOrders []models.WorkOrderDto
	SQLSUB := "SELECT w.*,u.nickname AS u_nickname,a.nickname  AS a_nickname,w.id AS i_d,w.uid AS u_i_d,w.tid AS t_i_d,w.cid AS c_i_d FROM work_order w LEFT JOIN (SELECT id, nickname FROM `user`) u ON w.uid = u.id LEFT JOIN (SELECT id, nickname FROM `admin`) a ON w.last_reply = a.id"
	SQL := "SELECT * FROM (" + SQLSUB + ") w WHERE `delete` = " + del + statusSQL + tidSQL + " ORDER BY status ASC, create_at DESC, update_at DESC"
	_, err := r.o.Raw(SQL+" LIMIT ? OFFSET ?", request.PageSize, (request.PageOn-1)*request.PageSize).QueryRows(&workOrders)
	if err != nil {
		logs.Warn("GetWorkOrders get WorkOrders------------", err)
		request.List = []int{}
	}
	if len(workOrders) == 0 {
		request.List = []int{}
	} else {
		request.List = workOrders
	}
	var _maps []orm.Params
	total, _ := r.o.Raw(SQL).Values(&_maps)
	request.Total = total
	return request, err
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
