package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"strconv"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/validation"
)

// ContactController struct
type ContactController struct {
	BaseController
	ContactRepository *services.ContactRepository
	AdminRepository   *services.AdminRepository
}

// Prepare More like construction method
func (c *ContactController) Prepare() {

	// ContactRepository instance
	c.ContactRepository = services.GetContactRepositoryInstance()

	// AdminRepository instance
	c.AdminRepository = services.GetAdminRepositoryInstance()

}

// Finish Comparison like destructor or package init()
func (c *ContactController) Finish() {}

// GetContacts get all Contacts
func (c *ContactController) GetContacts() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	contactDto, err := c.ContactRepository.GetContacts(auth.UID)

	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}
	if len(contactDto) == 0 {
		contactDto = []models.ContactDto{}
	}
	c.JSON(configs.ResponseSucess, "success", &contactDto)

}

// Delete a Contact
func (c *ContactController) Delete() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// delete
	rows, err := c.ContactRepository.Delete(id, auth.UID)

	if err != nil || rows == 0 {
		c.JSON(configs.ResponseFail, "删除失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "删除成功!", rows)
}

// DeleteAll all
func (c *ContactController) DeleteAll() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// delete
	rows, err := c.ContactRepository.DeleteAll(auth.UID)

	if err != nil {
		c.JSON(configs.ResponseFail, "清空成功！", err.Error())
	}
	c.JSON(configs.ResponseSucess, "清空成功!", rows)
}

// Transfer transfer admin to admin
func (c *ContactController) Transfer() {

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
	message.Platform = user.Platform
	message.FromAccount = transferDto.UserAccount
	message.Timestamp = time.Now().Unix()
	message.TransferAccount = transferDto.ToAccount

	// Send to forwarder
	message.ToAccount = admin.ID
	message.Payload = "您将" + user.NickName + "转接给" + toAdmin.NickName
	messageString := utils.InterfaceToString(message)
	utils.PushMessage(admin.ID, messageString)

	utils.MessageInto(message)

	// Send to forwarded customer service
	message.ToAccount = transferDto.ToAccount
	message.Payload = admin.NickName + "将" + user.NickName + "转接给您"
	messageString = utils.InterfaceToString(message)
	utils.PushMessage(toAdmin.ID, messageString)

	utils.MessageInto(message)

	// send to user
	message.FromAccount = 1
	message.ToAccount = transferDto.UserAccount
	message.Delete = 1
	message.Payload = string(toAdminJSON)
	messageString = utils.InterfaceToString(message)
	utils.PushMessage(user.ID, messageString)

	utils.MessageInto(message)

	// Transfer to the library for counting service times
	servicesStatistical := models.ServicesStatistical{UserAccount: transferDto.UserAccount, ServiceAccount: transferDto.ToAccount, TransferAccount: admin.ID, Platform: user.Platform, CreateAt: time.Now().Unix()}
	// StatisticalRepository instance
	statisticalRepository := services.GetStatisticalRepositoryInstance()
	_, _ = statisticalRepository.Add(&servicesStatistical)

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
