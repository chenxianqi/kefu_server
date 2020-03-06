package controllers

import (
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"
)

// ContactController struct
type ContactController struct {
	BaseController
	ContactRepository *services.ContactRepository
	AdminRepository   *services.AdminRepository
}

// Prepare More like construction method
func (c *ContactController) Prepare() {

	// init ContactRepository
	c.ContactRepository = new(services.ContactRepository)
	c.ContactRepository.Init(new(models.Contact))

	// init AdminRepository
	c.AdminRepository = new(services.AdminRepository)
	c.AdminRepository.Init(new(models.Admin))

}

// Finish Comparison like destructor
func (c *ContactController) Finish() {}

// GetContacts get all Contacts
func (c *ContactController) GetContacts() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	contactData, err := c.ContactRepository.GetContacts(auth.UID)

	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败!", &err)
	}
	if len(contactData) == 0 {
		contactData = []models.ContactData{}
	}
	c.JSON(configs.ResponseSucess, "查询成功！", &contactData)

}

// Delete a Contact
func (c *ContactController) Delete() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// delete
	rows, err := c.ContactRepository.Delete(id, auth.UID)

	if err != nil || rows == 0 {
		c.JSON(configs.ResponseFail, "删除失败!", &err)
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
		c.JSON(configs.ResponseFail, "清空成功！", &err)
	}
	c.JSON(configs.ResponseSucess, "清空成功!", rows)
}
