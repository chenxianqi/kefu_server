package controllers

import (
	"encoding/json"

	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"time"

	"github.com/astaxie/beego/validation"
)

// MessageController struct
type MessageController struct {
	BaseController
	MessageRepository *services.MessageRepository
}

// Prepare More like construction method
func (c *MessageController) Prepare() {

	// MessageRepository instance
	c.MessageRepository = services.GetMessageRepositoryInstance()
}

// Finish Comparison like destructor or package init()
func (c *MessageController) Finish() {}

// List get messages
func (c *MessageController) List() {
	messageList(c, false)
}

// HistoryList get History messages
func (c *MessageController) HistoryList() {
	messageList(c, true)
}

// messageList get messages
func messageList(c *MessageController, isHistory bool) {

	messagePaginationDto := models.MessagePaginationDto{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &messagePaginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()

	// Timestamp == 0
	if messagePaginationDto.Timestamp == 0 {
		messagePaginationDto.Timestamp = time.Now().Unix()
	}

	// validation
	valid := validation.Validation{}
	valid.Required(messagePaginationDto.Account, "account").Message("account不能为空！")
	valid.Required(messagePaginationDto.PageSize, "page_size").Message("page_size不能为空！")
	valid.Required(messagePaginationDto.Timestamp, "timestamp").Message("timestamp不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// query messages
	var returnMessagePaginationDto *models.MessagePaginationDto
	var err error
	if !isHistory {
		returnMessagePaginationDto, err = c.MessageRepository.GetAdminMessages(messagePaginationDto)
	} else {
		returnMessagePaginationDto, err = c.MessageRepository.GetAdminHistoryMessages(messagePaginationDto)
	}
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}

	// push notify update current service contacts list
	utils.PushNewContacts(auth.UID)

	c.JSON(configs.ResponseSucess, "success", &returnMessagePaginationDto)
}

// Remove one message
func (c *MessageController) Remove() {

	// request body
	removeRequestDto := models.RemoveMessageRequestDto{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &removeRequestDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(removeRequestDto.ToAccount, "to_account").Message("to_account不能为空！")
	valid.Required(removeRequestDto.FromAccount, "from_account").Message("from_account不能为空！")
	valid.Required(removeRequestDto.Key, "key").Message("key不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	row, err := c.MessageRepository.Delete(removeRequestDto)
	if err != nil || row == 0 {
		c.JSON(configs.ResponseFail, "删除失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "删除成!", row)
}
