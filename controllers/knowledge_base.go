package controllers

import (
	"encoding/json"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// KnowledgeBaseController struct
type KnowledgeBaseController struct {
	beego.Controller
}

// Get get a  knowledge Base
func (c *KnowledgeBaseController) Get() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	knowledgeBase := models.KnowledgeBase{ID: id}
	if err := o.Read(&knowledgeBase); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "获取失败!", err)
		c.ServeJSON()
	}
	knowledgeBase.SubTitle = strings.Trim(knowledgeBase.SubTitle, "|")
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &knowledgeBase)
	c.ServeJSON()

}

// Post add a  knowledge Base
func (c *KnowledgeBaseController) Post() {

	o := orm.NewOrm()

	// request body
	var knowledgeBase models.KnowledgeBase
	knowledgeBase.CreateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &knowledgeBase); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", err)
		c.ServeJSON()
	}

	// exist title ?
	oldKnowledgeBase := models.KnowledgeBase{Title: knowledgeBase.Title}
	if err := o.Read(&oldKnowledgeBase, "Title"); err == nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "标题已存在，请换个标题!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(knowledgeBase.Title, "title").Message("标题不能为空！")
	valid.Required(knowledgeBase.Content, "content").Message("内容不能为空！")
	valid.Required(knowledgeBase.UID, "uid").Message("用户ID不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			logs.Error(err)
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// Platform exist
	if err := o.Read(&models.Platform{ID: knowledgeBase.Platform}); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "不存在的平台id!", nil)
		c.ServeJSON()
		return
	}

	// insert
	knowledgeBase.SubTitle = strings.Trim(knowledgeBase.SubTitle, "|")
	if knowledgeBase.SubTitle != "" {
		knowledgeBase.SubTitle = "|" + knowledgeBase.SubTitle + "|"
	}
	if id, err := o.Insert(&knowledgeBase); err == nil {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "添加成功！", &id)
	} else {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "服务异常！", err)
	}
	c.ServeJSON()
}

// Put update  a  knowledge Base
func (c *KnowledgeBaseController) Put() {

	o := orm.NewOrm()

	// request body
	var newKnowledgeBase models.KnowledgeBase
	newKnowledgeBase.UpdateAt = time.Now().Unix()
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &newKnowledgeBase); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误！", err)
		c.ServeJSON()
	}

	// validation
	valid := validation.Validation{}
	valid.Required(newKnowledgeBase.Title, "title").Message("标题不能为空！")
	valid.Required(newKnowledgeBase.Content, "content").Message("内容不能为空！")
	valid.Required(newKnowledgeBase.UID, "uid").Message("用户ID不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// is exist ?
	oldKnowledgeBase := models.KnowledgeBase{ID: newKnowledgeBase.ID}
	if err := o.Read(&oldKnowledgeBase); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "内容不存在!", err)
		c.ServeJSON()
	}

	// is exist title?
	oldKnowledgeBase = models.KnowledgeBase{Title: newKnowledgeBase.Title}
	if err := o.Read(&oldKnowledgeBase, "Title"); err == nil && oldKnowledgeBase.ID != newKnowledgeBase.ID {
		c.Data["json"] = utils.ResponseError(c.Ctx, "标题已存在，请换个标题!", nil)
		c.ServeJSON()
	}

	// is exist Platform?
	if err := o.Read(&models.Platform{ID: newKnowledgeBase.Platform}); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "不存在的平台id!", nil)
		c.ServeJSON()
		return
	}

	// sub title
	newKnowledgeBase.SubTitle = strings.Trim(newKnowledgeBase.SubTitle, "|")
	if newKnowledgeBase.SubTitle != "" {
		newKnowledgeBase.SubTitle = "|" + newKnowledgeBase.SubTitle + "|"
	}

	// insert
	newKnowledgeBase.CreateAt = oldKnowledgeBase.CreateAt
	if _, err := o.Update(&newKnowledgeBase, "Title", "SubTitle", "Content", "Platform", "UpdateAt"); err == nil {
		newKnowledgeBase.SubTitle = strings.Trim(newKnowledgeBase.SubTitle, "|")
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", &newKnowledgeBase)
	} else {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败!", err)
	}
	c.ServeJSON()

}

// Delete delete a  knowledge Base
func (c *KnowledgeBaseController) Delete() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	knowledgeBase := models.KnowledgeBase{ID: id}

	// exist
	if err := o.Read(&knowledgeBase); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败，内容不存在!", err)
		c.ServeJSON()
		return
	}

	if num, err := o.Delete(&knowledgeBase); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", nil)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功!", num)
	}

	c.ServeJSON()
}

// List quesy list
func (c *KnowledgeBaseController) List() {

	// request body
	var paginationData models.PaginationData
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &paginationData); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", err)
		c.ServeJSON()
		return
	}

	// orm instance
	o := orm.NewOrm()
	model := new(models.KnowledgeBase)
	qs := o.QueryTable(model)

	// query
	var lists []models.KnowledgeBase
	if _, err := qs.OrderBy("-create_at").Limit(paginationData.PageSize).Offset((paginationData.PageOn - 1) * paginationData.PageSize).All(&lists); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
		c.ServeJSON()
		return
	}

	total, _ := qs.Count()
	for index := range lists {
		lists[index].SubTitle = strings.Trim(lists[index].SubTitle, "|")
	}
	paginationData.Total = total
	paginationData.List = &lists
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &paginationData)
	c.ServeJSON()

}
