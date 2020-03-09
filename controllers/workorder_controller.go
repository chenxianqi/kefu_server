package controllers

import (
	"kefu_server/configs"
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
	c.JSON(configs.ResponseSucess, "success", nil)
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
