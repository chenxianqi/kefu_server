package controllers

import (
	"encoding/base64"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// ContactController struct
type ContactController struct {
	beego.Controller
}

// GetContacts get all Contacts
func (c *ContactController) GetContacts() {

	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	admin := models.Admin{Token: token}
	_ = o.Read(&admin, "Token")
	var contactData []models.ContactData
	rCount, err := o.Raw("SELECT c.id AS cid,c.to_account,c.is_session_end, c.last_message,c.last_message_type,c.from_account, c.create_at AS contact_create_at,u.*, IFNULL(m.`count`,0) AS `read` FROM  `contact` c LEFT JOIN `user` u ON c.from_account = u.id LEFT JOIN (SELECT to_account,from_account, COUNT(*) as `count` FROM message WHERE `read` = 1 GROUP BY to_account,from_account) m ON m.to_account = c.to_account AND m.from_account = c.from_account WHERE c.to_account = ? AND c.delete = 0 ORDER BY c.create_at DESC", admin.ID).QueryRows(&contactData)
	logs.Info("contactData===", contactData)
	if err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
	} else {
		if rCount == 0 {
			contactData = []models.ContactData{}
		}
		// base 64
		for index, contact := range contactData {
			payload, _ := base64.StdEncoding.DecodeString(contact.LastMessage)
			contactData[index].LastMessage = string(payload)
		}
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &contactData)
	}

	c.ServeJSON()
}

// Delete a Contact
func (c *ContactController) Delete() {

	o := orm.NewOrm()

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	token := c.Ctx.Input.Header("Authorization")
	admin := models.Admin{Token: token}
	_ = o.Read(&admin, "Token")
	res, _ := o.Raw("UPDATE `contact` SET `delete` = 1 WHERE id = ? AND to_account = ?", id, admin.ID).Exec()
	if rowsAffected, _ := res.RowsAffected(); rowsAffected == 0 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功！", nil)
	}

	c.ServeJSON()
}

// Clear all
func (c *ContactController) Clear() {

	o := orm.NewOrm()

	token := c.Ctx.Input.Header("Authorization")
	admin := models.Admin{Token: token}
	_ = o.Read(&admin, "Token")
	res, _ := o.Raw("UPDATE `contact` SET `delete` = 1 WHERE to_account = ?", admin.ID).Exec()
	if rowsAffected, _ := res.RowsAffected(); rowsAffected == 0 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "清空失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "清空成功！", nil)
	}
	c.ServeJSON()
}
