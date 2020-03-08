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

	// ContactRepository instance
	c.ContactRepository = services.GetContactRepositoryInstance()

	// AdminRepository instance
	c.AdminRepository = services.GetAdminRepositoryInstance()

}

// Finish Comparison like destructor
func (c *ContactController) Finish() {}

// GetContacts get all Contacts
func (c *ContactController) GetContacts() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	contactDto, err := c.ContactRepository.GetContacts(auth.UID)

	if err != nil {
		c.JSON(configs.ResponseFail, "fail", &err)
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
