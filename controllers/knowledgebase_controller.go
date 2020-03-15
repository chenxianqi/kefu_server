package controllers

import (
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// KnowledgeBaseController struct
type KnowledgeBaseController struct {
	BaseController
	PlatformRepository      *services.PlatformRepository
	KnowledgeBaseRepository *services.KnowledgeBaseRepository
}

// Prepare More like construction method
func (c *KnowledgeBaseController) Prepare() {

	// StatisticalRepository instance
	c.KnowledgeBaseRepository = services.GetKnowledgeBaseRepositoryInstance()

	// PlatformRepository instance
	c.PlatformRepository = services.GetPlatformRepositoryInstance()

}

// Finish Comparison like destructor
func (c *KnowledgeBaseController) Finish() {}

// Get get a  knowledge Base
func (c *KnowledgeBaseController) Get() {

	id, err := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", &err)
	}

	knowledgeBase := c.KnowledgeBaseRepository.GetKnowledgeBase(id)

	if knowledgeBase == nil {
		c.JSON(configs.ResponseFail, "fail", nil)
	}

	c.JSON(configs.ResponseFail, "success", &knowledgeBase)
}

// Post add a  knowledge Base
func (c *KnowledgeBaseController) Post() {

	// request body
	var knowledgeBase models.KnowledgeBase
	knowledgeBase.CreateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &knowledgeBase); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", &err)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(knowledgeBase.Title, "title").Message("标题不能为空！")
	valid.Required(knowledgeBase.Content, "content").Message("内容不能为空！")
	valid.Required(knowledgeBase.UID, "uid").Message("用户ID不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// Platform exist
	if platform := c.PlatformRepository.GetPlatform(knowledgeBase.Platform); platform == nil {
		c.JSON(configs.ResponseFail, "不存在的平台id!", nil)
	}

	// insert
	isNewCreate, index, err := c.KnowledgeBaseRepository.Add(&knowledgeBase, "Title")
	if !isNewCreate {
		c.JSON(configs.ResponseFail, "标题已存在，请换个标题!", nil)
	}

	if err != nil {
		c.JSON(configs.ResponseFail, "添加失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "添加成功!", index)
}

// Put update  a  knowledge Base
func (c *KnowledgeBaseController) Put() {

	// request body
	var newKnowledgeBase models.KnowledgeBase
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &newKnowledgeBase); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查！", &err)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(newKnowledgeBase.Title, "title").Message("标题不能为空！")
	valid.Required(newKnowledgeBase.Content, "content").Message("内容不能为空！")
	valid.Required(newKnowledgeBase.UID, "uid").Message("用户ID不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, &err)
		}
	}

	// is exist title?
	oldKnowledgeBase := c.KnowledgeBaseRepository.GetKnowledgeBaseWithTitle(newKnowledgeBase.Title)
	if oldKnowledgeBase != nil && oldKnowledgeBase.ID != newKnowledgeBase.ID {
		c.JSON(configs.ResponseFail, "标题已存在，请换个标题!", nil)
	}

	// Platform exist
	if platform := c.PlatformRepository.GetPlatform(newKnowledgeBase.Platform); platform == nil {
		c.JSON(configs.ResponseFail, "不存在的平台id!", nil)
	}

	// handle sub title
	newKnowledgeBase.SubTitle = strings.Trim(newKnowledgeBase.SubTitle, "|")
	if newKnowledgeBase.SubTitle != "" {
		newKnowledgeBase.SubTitle = "|" + newKnowledgeBase.SubTitle + "|"
	}

	// insert
	row, err := c.KnowledgeBaseRepository.Update(newKnowledgeBase.ID, orm.Params{
		"Title":    newKnowledgeBase.Title,
		"SubTitle": newKnowledgeBase.SubTitle,
		"Content":  newKnowledgeBase.Content,
		"Platform": newKnowledgeBase.Platform,
		"UpdateAt": time.Now().Unix(),
	})

	if err != nil || row == 0 {
		c.JSON(configs.ResponseFail, "更新失败!", &err)
	}

	if oldKnowledgeBase != nil {
		newKnowledgeBase.CreateAt = oldKnowledgeBase.CreateAt
	}

	newKnowledgeBase.SubTitle = strings.Trim(newKnowledgeBase.SubTitle, "|")
	c.JSON(configs.ResponseSucess, "更新成功！", &newKnowledgeBase)

}

// Delete delete a  knowledge Base
func (c *KnowledgeBaseController) Delete() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	num, err := c.KnowledgeBaseRepository.Delete(id)
	if err != nil || num == 0 {
		c.JSON(configs.ResponseFail, "删除失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "删除成功!", num)
}

// List quesy list
func (c *KnowledgeBaseController) List() {

	// request body
	var knowledgePaginationDto *models.KnowledgePaginationDto
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &knowledgePaginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", &err)
	}

	// query
	knowledgePaginationDto, err := c.KnowledgeBaseRepository.GetKnowledgeBases(knowledgePaginationDto)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", &err)
	}

	c.JSON(configs.ResponseSucess, "success", &knowledgePaginationDto)
}

// Total platforms Total
func (c *KnowledgeBaseController) Total() {
	res := c.KnowledgeBaseRepository.GetKnowledgeBasePlatformsTotal()
	c.JSON(configs.ResponseSucess, "success", &res)
}
