package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// ShortcutController struct
type ShortcutController struct {
	BaseController
	ShortcutRepository *services.ShortcutRepository
}

// Prepare More like construction method
func (c *ShortcutController) Prepare() {

	// ShortcutRepository instance
	c.ShortcutRepository = services.GetShortcutRepositoryInstance()
}

// Finish Comparison like destructor or package init()
func (c *ShortcutController) Finish() {}

// Get get shortcut
func (c *ShortcutController) Get() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	shortcut := c.ShortcutRepository.GetShortcut(id)
	if shortcut == nil || auth.UID != shortcut.UID {
		c.JSON(configs.ResponseFail, "fail，内容不存在!", nil)
	}
	c.JSON(configs.ResponseSucess, "success", &shortcut)

}

// Put update shortcut
func (c *ShortcutController) Put() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// request body
	shortcut := models.Shortcut{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &shortcut); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(shortcut.Title, "title").Message("标题不能为空！")
	valid.Required(shortcut.Content, "content").Message("内容不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// if is my shortcut
	if shortcut.UID != auth.UID {
		c.JSON(configs.ResponseFail, "更新失败，内容不存在!", nil)
	}

	// update
	_, err := c.ShortcutRepository.Update(shortcut.ID, orm.Params{
		"UpdateAt": time.Now().Unix(),
		"Content":  shortcut.Content,
		"Title":    shortcut.Title,
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", nil)
	}
	c.JSON(configs.ResponseSucess, "更新成功!", nil)
}

// Post add new shortcut
func (c *ShortcutController) Post() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// request body
	var shortcut models.Shortcut
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &shortcut); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(shortcut.Title, "title").Message("标题不能为空！")
	valid.Required(shortcut.Content, "content").Message("内容不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// exist ? create
	shortcut.UID = auth.UID
	isNew, _, err := c.ShortcutRepository.Add(&shortcut, "Title", "Uid")
	if err != nil {
		c.JSON(configs.ResponseFail, "添加失败！", nil)
	}
	if !isNew {
		c.JSON(configs.ResponseFail, "已存在相同的内容!", nil)
	}
	c.JSON(configs.ResponseSucess, "添加成功！!", nil)
}

// Delete delete remove shortcut
func (c *ShortcutController) Delete() {

	// GetAuthInfo
	auth := c.GetAuthInfo()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	if row, err := c.ShortcutRepository.Delete(id, auth.UID); err != nil || row == 0 {
		c.JSON(configs.ResponseFail, "删除失败!", err.Error())
	}
	c.JSON(configs.ResponseSucess, "删除成功！!", nil)
}

// List get shortcut all
func (c *ShortcutController) List() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	// query
	shortcuts := c.ShortcutRepository.GetShortcuts(auth.UID)
	c.JSON(configs.ResponseSucess, "success", &shortcuts)

}
