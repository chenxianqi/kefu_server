package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"

	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
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

// Finish Comparison like destructor or package init()
func (c *WorkOrderController) Finish() {}

// PostWorkType add work order type
func (c *WorkOrderController) PostWorkType() {

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
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

	isNew, id, err := c.WorkOrderTypeRepository.Add(workOrderType)
	if err != nil {
		c.JSON(configs.ResponseFail, "添加失败!", err.Error())
	}
	if !isNew {
		c.JSON(configs.ResponseFail, "类型名称已存在!", nil)
	}

	c.JSON(configs.ResponseSucess, "添加成功！", id)

}

// UpdateWorkType update work order type
func (c *WorkOrderController) UpdateWorkType() {

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
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

	_, err := c.WorkOrderTypeRepository.Update(workOrderType.ID, orm.Params{
		"title": workOrderType.Title,
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "修改失败!", err.Error())
	}
	c.JSON(configs.ResponseSucess, "修改成功！", nil)
}

// DeleteWorkType delete work order type
func (c *WorkOrderController) DeleteWorkType() {

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
	admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)
	if admin != nil && admin.Root != 1 {
		c.JSON(configs.ResponseFail, "没有权限!", nil)
	}

	// id
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	row, _ := c.WorkOrderTypeRepository.Delete(id)
	if row == 0 {
		c.JSON(configs.ResponseFail, "删除失败!", nil)
	}
	c.JSON(configs.ResponseSucess, "删除成功！", nil)
}

// GetWorkType get work order type
func (c *WorkOrderController) GetWorkType() {

	// id
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	workOrderType, err := c.WorkOrderTypeRepository.GetWorkOrderType(id)
	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败!", err.Error())
	}
	c.JSON(configs.ResponseSucess, "查询成功！", workOrderType)

}

// GetWorkTypes get work order types
func (c *WorkOrderController) GetWorkTypes() {
	workOrderTypes := c.WorkOrderTypeRepository.GetWorkOrderTypes()
	c.JSON(configs.ResponseSucess, "查询成功！", workOrderTypes)
}

// CloseWorkOrder close workorder
func (c *WorkOrderController) CloseWorkOrder() {

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()

	type Request struct {
		CID    int64  `json:"cid"`
		WID    int64  `json:"wid"`
		Remark string `json:"remark"`
	}

	request := Request{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &request); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(request.WID, "wid").Message("工单ID不能为空！")
	valid.Required(request.Remark, "remark").Message("关闭原因不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	rows, err := c.WorkOrderRepository.Close(request.WID, auth.UID, request.Remark)
	if err != nil {
		c.JSON(configs.ResponseFail, "关闭失败，出现异常!", nil)
	}
	c.JSON(configs.ResponseSucess, "工单已关闭！", rows)

}
