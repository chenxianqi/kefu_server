package controllers

import (
	"encoding/base64"
	"encoding/json"

	"github.com/astaxie/beego/logs"
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

	// MessageRepository instance
	c.MessageRepository = services.GetMessageRepositoryInstance()
}

// Finish Comparison like destructor
func (c *MessageController) Finish() {}

// List get messages
func (c *MessageController) List() {

	messagePaginationDto := models.MessagePaginationDto{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &messagePaginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// GetAuthInfo
	auth := c.GetAuthInfo()
	messagePaginationDto.Service = auth.UID

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
	returnMessagePaginationDto, err := c.MessageRepository.GetAdminMessages(messagePaginationDto)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", &err)
	}

	// push notify update current service contacts list
	if len(im.Robots) > 0 {
		im.PushNewContacts(auth.UID, im.Robots[0])
	}

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
		c.JSON(configs.ResponseFail, "删除失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "删除成!", row)
}

// Transfer transfer user to user
func (c *MessageController) Transfer() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	adminRepository := services.GetAdminRepositoryInstance()
	admin := adminRepository.GetAdmin(auth.UID)

	// request body
	var transferDto *models.TransferDto
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &transferDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(transferDto.ToAccount, "to_account").Message("to_account不能为空！")
	valid.Required(transferDto.UserAccount, "user_account").Message("user不能为空！")
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
	toAdmin := adminRepository.GetAdmin(transferDto.ToAccount)
	if toAdmin == nil {
		c.JSON(configs.ResponseFail, "转接失败，转接客服不存在!", nil)
	}
	toAdminJSON, _ := json.Marshal(adminData{ID: toAdmin.ID, Avatar: toAdmin.Avatar, NickName: toAdmin.NickName})

	// UserRepository instance
	userRepository := services.GetUserRepositoryInstance()

	user := userRepository.GetUser(transferDto.UserAccount)
	if user == nil {
		c.JSON(configs.ResponseFail, "转接失败用户ID不存在!", nil)
	}

	// message
	message := models.Message{}
	message.BizType = "transfer"
	message.FromAccount = transferDto.UserAccount
	message.Timestamp = time.Now().Unix()
	message.TransferAccount = transferDto.ToAccount

	// Send to forwarder
	message.ToAccount = admin.ID
	message.Payload = "您将" + user.NickName + "转接给" + toAdmin.NickName
	messageJSONOne, _ := json.Marshal(message)
	messageStringOne := base64.StdEncoding.EncodeToString([]byte(messageJSONOne))
	robot.SendMessage(strconv.FormatInt(admin.ID, 10), []byte(messageStringOne))
	utils.MessageInto(message, true)

	// Send to forwarded customer service
	message.ToAccount = transferDto.ToAccount
	message.Payload = admin.NickName + "将" + user.NickName + "转接给您"
	messageJSONTwo, _ := json.Marshal(message)
	messageStringTwo := base64.StdEncoding.EncodeToString([]byte(messageJSONTwo))
	robot.SendMessage(strconv.FormatInt(transferDto.ToAccount, 10), []byte(messageStringTwo))
	utils.MessageInto(message, true)

	// send to user
	message.FromAccount = robotID
	message.ToAccount = transferDto.UserAccount
	message.Delete = 1
	message.Payload = string(toAdminJSON)
	messageJSONThree, _ := json.Marshal(message)
	messageString3 := base64.StdEncoding.EncodeToString([]byte(messageJSONThree))
	robot.SendMessage(strconv.FormatInt(transferDto.UserAccount, 10), []byte(messageString3))
	utils.MessageInto(message, false)

	// Transfer to the library for counting service times
	servicesStatistical := models.ServicesStatistical{UserAccount: transferDto.UserAccount, ServiceAccount: transferDto.ToAccount, TransferAccount: admin.ID, Platform: user.Platform, CreateAt: time.Now().Unix()}
	// StatisticalRepository instance
	statisticalRepository := services.GetStatisticalRepositoryInstance()
	_, err := statisticalRepository.Add(&servicesStatistical)
	if err != nil {
	}

	// End the repeater's and user's current session
	tk := time.NewTimer(1 * time.Second)
	select {
	case <-tk.C:
		usersID := []int64{admin.ID, transferDto.UserAccount}

		// ContactRepository instance
		contactRepository := services.GetContactRepositoryInstance()
		_, err := contactRepository.UpdateIsSessionEnd(usersID, 1)

		if err != nil {
			logs.Info(err)
		}
	}

	c.JSON(configs.ResponseSucess, "转接成功!", nil)
}
