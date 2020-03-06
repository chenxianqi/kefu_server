package controllers

import (
	"encoding/base64"
	"encoding/json"

	"github.com/astaxie/beego/validation"

	"kefu_server/configs"
	"kefu_server/im"
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"strconv"
	"time"
)

// MessageController struct
type MessageController struct {
	BaseController
	MessageRepository *services.MessageRepository
}

// Prepare More like construction method
func (c *MessageController) Prepare() {

	// init MessageRepository
	c.MessageRepository = new(services.MessageRepository)
	c.MessageRepository.Init(new(models.Message))

}

// Finish Comparison like destructor
func (c *MessageController) Finish() {}

// List get messages
func (c *MessageController) List() {

	messagePaginationData := models.MessagePaginationData{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &messagePaginationData); err != nil {
		c.JSON(configs.ResponseFail, "参数错误!", nil)
	}

	// service ID
	var serviceID int64

	if messagePaginationData.Service == 0 {

		// GetAuthInfo
		auth := c.GetAuthInfo()
		serviceID = auth.UID

	} else {
		serviceID = messagePaginationData.Service
	}

	// Timestamp == 0
	if messagePaginationData.Timestamp == 0 {
		messagePaginationData.Timestamp = time.Now().Unix()
	}

	// validation
	valid := validation.Validation{}
	valid.Required(messagePaginationData.Account, "account").Message("account不能为空！")
	valid.Required(messagePaginationData.PageSize, "page_size").Message("page_size不能为空！")
	valid.Required(messagePaginationData.Timestamp, "timestamp").Message("timestamp不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// query message
	returnMessagePaginationData, err := c.MessageRepository.GetMessages(serviceID, messagePaginationData)
	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败！", &err)
	}

	// push notify update current service contacts list
	if len(im.Robots) > 0 {
		im.PushNewContacts(serviceID, im.Robots[0])
	}

	c.JSON(configs.ResponseSucess, "查询成功！", &returnMessagePaginationData)
}

// Remove one message
func (c *MessageController) Remove() {

	// request body
	removeRequestData := models.RemoveMessageRequestData{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &removeRequestData); err != nil {
		c.JSON(configs.ResponseFail, "参数错误!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(removeRequestData.ToAccount, "to_account").Message("to_account不能为空！")
	valid.Required(removeRequestData.FromAccount, "from_account").Message("from_account不能为空！")
	valid.Required(removeRequestData.Key, "key").Message("key不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	row, err := c.MessageRepository.Delete(removeRequestData)
	if err != nil || row == 0 {
		c.JSON(configs.ResponseFail, "删除失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "删除成!", row)
}

// Transfer transfer user to user
func (c *MessageController) Transfer() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	adminRepository := new(services.AdminRepository)
	adminRepository.Init(new(models.Admin))
	admin := adminRepository.GetAdmin(auth.UID)

	// request body
	var transferRequestData *models.TransferRequestData
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &transferRequestData); err != nil {
		c.JSON(configs.ResponseFail, "参数错误!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(transferRequestData.ToAccount, "to_account").Message("to_account不能为空！")
	valid.Required(transferRequestData.UserAccount, "user_account").Message("user不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	robot := im.Robots[0]
	robotID, _ := strconv.ParseInt(robot.AppAccount(), 10, 64)

	type adminData struct {
		ID       int64  `orm:"column(id)" json:"id"`
		NickName string `json:"nickname"`
		Avatar   string `json:"avatar"`
	}
	toAdmin := adminRepository.GetAdmin(transferRequestData.ToAccount)
	if toAdmin == nil {
		c.JSON(configs.ResponseFail, "转接失败，转接客服不存在!", nil)
	}
	toAdminJSON, _ := json.Marshal(adminData{ID: toAdmin.ID, Avatar: toAdmin.Avatar, NickName: toAdmin.NickName})

	userRepository := new(services.UserRepository)
	userRepository.Init(new(models.User))
	user := userRepository.GetUser(transferRequestData.UserAccount)
	if user == nil {
		c.JSON(configs.ResponseFail, "转接失败用户ID不存在!", nil)
	}

	// message
	message := models.Message{}
	message.BizType = "transfer"
	message.FromAccount = transferRequestData.UserAccount
	message.Timestamp = time.Now().Unix()
	message.TransferAccount = transferRequestData.ToAccount

	// Send to forwarder
	message.ToAccount = admin.ID
	message.Payload = "您将" + user.NickName + "转接给" + toAdmin.NickName
	messageJSONOne, _ := json.Marshal(message)
	messageStringOne := base64.StdEncoding.EncodeToString([]byte(messageJSONOne))
	robot.SendMessage(strconv.FormatInt(admin.ID, 10), []byte(messageStringOne))
	utils.MessageInto(message, true)

	// Send to forwarded customer service
	message.ToAccount = transferRequestData.ToAccount
	message.Payload = admin.NickName + "将" + user.NickName + "转接给您"
	messageJSONTwo, _ := json.Marshal(message)
	messageStringTwo := base64.StdEncoding.EncodeToString([]byte(messageJSONTwo))
	robot.SendMessage(strconv.FormatInt(transferRequestData.ToAccount, 10), []byte(messageStringTwo))
	utils.MessageInto(message, true)

	// send to user
	message.FromAccount = robotID
	message.ToAccount = transferRequestData.UserAccount
	message.Delete = 1
	message.Payload = string(toAdminJSON)
	messageJSONThree, _ := json.Marshal(message)
	messageString3 := base64.StdEncoding.EncodeToString([]byte(messageJSONThree))
	robot.SendMessage(strconv.FormatInt(transferRequestData.UserAccount, 10), []byte(messageString3))
	utils.MessageInto(message, false)

	// Transfer to the library for counting service times
	servicesStatistical := models.ServicesStatistical{UserAccount: transferRequestData.UserAccount, ServiceAccount: transferRequestData.ToAccount, TransferAccount: admin.ID, Platform: user.Platform, CreateAt: time.Now().Unix()}
	statisticalRepository := new(services.StatisticalRepository)
	statisticalRepository.Init(new(models.ServicesStatistical))
	_, err := statisticalRepository.Add(&servicesStatistical)
	if err != nil {
	}

	// End the repeater's and user's current session
	tk := time.NewTimer(1 * time.Second)
	select {
	case <-tk.C:
		usersID := []int64{admin.ID, transferRequestData.UserAccount}
		contactRepository := new(services.ContactRepository)
		contactRepository.Init(new(models.Contact))
		_, err := contactRepository.UpdateIsSessionEnd(usersID, 1)
		if err != nil {
		}
	}

	c.JSON(configs.ResponseSucess, "转接成功!", nil)
}
