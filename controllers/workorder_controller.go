package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
)

// WorkOrderController  struct
type WorkOrderController struct {
	BaseController
	WorkOrderRepository        *services.WorkOrderRepository
	WorkOrderTypeRepository    *services.WorkOrderTypeRepository
	WorkOrderCommentRepository *services.WorkOrderCommentRepository
}

// Prepare More like construction method
func (c *WorkOrderController) Prepare() {

	// WorkOrderRepository instance
	c.WorkOrderRepository = services.GetWorkOrderRepositoryInstance()

	// WorkOrderTypeRepository instance
	c.WorkOrderTypeRepository = services.GetWorkOrderTypeRepositoryInstance()

	// WorkOrderCommentRepository instance
	c.WorkOrderCommentRepository = services.GetWorkOrderCommentRepositoryInstance()

}

// Finish Comparison like destructor
func (c *WorkOrderController) Finish() {}

// Get get one WorkOrder
func (c *WorkOrderController) Get() {
}

// Post create WorkOrder
func (c *WorkOrderController) Post() {

}

// Put update WorkOrder
func (c *WorkOrderController) Put() {

}

// Delete delete WorkOrder
func (c *WorkOrderController) Delete() {

}

// Comment send comment
func (c *WorkOrderController) Comment() {

}

// PostType add work order type
func (c *WorkOrderController) PostType() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)
	if admin != nil && admin.Root != 1 {
		c.JSON(configs.ResponseFail, "没有权限!", nil)
	}

	// request body
	var workOrderType models.WorkOrderType
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &workOrderType); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	if workOrderType.Title == "" {
		c.JSON(configs.ResponseFail, "类型标题不能为空！!", nil)
	}

	isNew, _, err := c.WorkOrderTypeRepository.Add(workOrderType)
	if err != nil {
		c.JSON(configs.ResponseFail, "添加失败!", err)
	}
	if !isNew {
		c.JSON(configs.ResponseFail, "类型名称已存在!", err)
	}

	c.JSON(configs.ResponseSucess, "添加成功！", nil)
}

// GetType get work order type
func (c *WorkOrderController) GetType() {

}

// GetTypes get work order types
func (c *WorkOrderController) GetTypes() {

}

// PutType update work order type
func (c *WorkOrderController) PutType() {

}

// DeleteType delete work order type
func (c *WorkOrderController) DeleteType() {

}
