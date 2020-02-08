package controllers

import (
	"encoding/base64"
	"encoding/json"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"

	"kefu_server/im"
	"kefu_server/models"
	"kefu_server/utils"
	"strconv"
	"time"
)

// MessageController struct
type MessageController struct {
	beego.Controller
}

// List get messages
func (c *MessageController) List() {

	o := orm.NewOrm()

	messagePaginationData := models.MessagePaginationData{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &messagePaginationData); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// service ID
	var serviceID int64

	if messagePaginationData.Service == 0 {
		token := c.Ctx.Input.Header("Authorization")
		_auth := models.Auths{Token: token}
		if err := o.Read(&_auth, "Token"); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
			c.ServeJSON()
			return
		}
		admin := models.Admin{ID: _auth.UID}
		if err := o.Read(&admin); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在", err)
			c.ServeJSON()
			return
		}
		serviceID = admin.ID
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
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	// join string
	qs := o.QueryTable(new(models.Message))
	accounts := []int64{messagePaginationData.Account, serviceID}
	inExp := "?,?"

	// get all robot
	robots := im.GetRobots()
	for _, robot := range robots {
		accounts = append(accounts, robot.ID)
		inExp = inExp + ",?"
	}
	var messages []*models.Message
	msgCount, _ := qs.Filter("timestamp__lt", messagePaginationData.Timestamp).Filter("to_account__in", accounts).Filter("from_account__in", accounts).Filter("delete", 0).Count()

	// Paging
	end := msgCount
	start := int(msgCount) - messagePaginationData.PageSize
	if start <= 0 {
		start = 0
	}

	if msgCount > 0 {
		_, err := o.Raw("SELECT * FROM `message` WHERE to_account IN ("+inExp+") AND `delete` = 0 AND from_account IN ("+inExp+") AND `timestamp` < ? ORDER BY `timestamp` ASC LIMIT ?,?", accounts, accounts, messagePaginationData.Timestamp, start, end).QueryRows(&messages)
		_, _ = qs.Filter("from_account", messagePaginationData.Account).Update(orm.Params{"read": 0})
		if err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败！", &err)
			c.ServeJSON()
			return
		}
		total, _ := qs.Filter("to_account__in", accounts).Filter("from_account__in", accounts).Filter("delete", 0).Count()
		messagePaginationData.List = messages
		messagePaginationData.Total = total
	} else {
		messagePaginationData.List = []models.Message{}
		messagePaginationData.Total = 0
	}
	for index, msg := range messages {
		payload, _ := base64.StdEncoding.DecodeString(msg.Payload)
		messages[index].Payload = string(payload)
	}
	if len(im.Robots) > 0 {
		im.PushNewContacts(serviceID, im.Robots[0])
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &messagePaginationData)
	c.ServeJSON()
}

// RemoveRequestData struct
type RemoveRequestData struct {
	FromAccount int64 `json:"from_account"`
	ToAccount   int64 `json:"to_account"`
	Key         int64 `json:"key"`
}

// Remove one message
func (c *MessageController) Remove() {
	o := orm.NewOrm()
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	admin := models.Admin{ID: _auth.UID}
	if err := o.Read(&admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "无权限操作", err)
		c.ServeJSON()
		return
	}

	// request body
	removeRequestData := RemoveRequestData{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &removeRequestData); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(removeRequestData.ToAccount, "to_account").Message("to_account不能为空！")
	valid.Required(removeRequestData.FromAccount, "from_account").Message("from_account不能为空！")
	valid.Required(removeRequestData.Key, "key").Message("key不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	_, err := o.Raw("UPDATE message SET `delete` = 1 WHERE from_account = ? AND to_account = ? AND `key` = ?", removeRequestData.FromAccount, removeRequestData.ToAccount, removeRequestData.Key).Exec()
	if err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "删除失败!", &err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "删除成功", nil)
	}
	c.ServeJSON()
}

// TransferRequestData struct
type TransferRequestData struct {
	ToAccount   int64 `json:"to_account"`   // 转接给谁
	UserAccount int64 `json:"user_account"` // 用户ID
}

// Transfer transfer user to user
func (c *MessageController) Transfer() {

	o := orm.NewOrm()
	token := c.Ctx.Input.Header("Authorization")
	_auth := models.Auths{Token: token}
	if err := o.Read(&_auth, "Token"); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "登录已失效！", nil)
		c.ServeJSON()
		return
	}
	admin := models.Admin{ID: _auth.UID}
	if err := o.Read(&admin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败，用户不存在", err)
		c.ServeJSON()
		return
	}

	// request body
	transferRequestData := TransferRequestData{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &transferRequestData); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// validation
	valid := validation.Validation{}
	valid.Required(transferRequestData.ToAccount, "to_account").Message("to_account不能为空！")
	valid.Required(transferRequestData.UserAccount, "user_account").Message("user不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.Data["json"] = utils.ResponseError(c.Ctx, err.Message, nil)
			break
		}
		c.ServeJSON()
		return
	}

	robot := im.Robots[0]
	robotID, _ := strconv.ParseInt(robot.AppAccount(), 10, 64)

	type adminData struct {
		ID       int64  `orm:"column(id)" json:"id"`
		NickName string `json:"nickname"`
		Avatar   string `json:"avatar"`
	}

	toAdmin := models.Admin{ID: transferRequestData.ToAccount}
	if err := o.Read(&toAdmin); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "转接失败，转接客服不存在", nil)
		c.ServeJSON()
		return
	}
	toAdminJSON, _ := json.Marshal(adminData{ID: toAdmin.ID, Avatar: toAdmin.Avatar, NickName: toAdmin.NickName})

	user := models.User{ID: transferRequestData.UserAccount}
	_ = o.Read(&user)

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
	im.MessageInto(message, true)

	// Send to forwarded customer service
	message.ToAccount = transferRequestData.ToAccount
	message.Payload = admin.NickName + "将" + user.NickName + "转接给您"
	messageJSONTwo, _ := json.Marshal(message)
	messageStringTwo := base64.StdEncoding.EncodeToString([]byte(messageJSONTwo))
	robot.SendMessage(strconv.FormatInt(transferRequestData.ToAccount, 10), []byte(messageStringTwo))
	im.MessageInto(message, true)

	// send to user
	message.FromAccount = robotID
	message.ToAccount = transferRequestData.UserAccount
	message.Delete = 1
	message.Payload = string(toAdminJSON)
	messageJSONThree, _ := json.Marshal(message)
	messageString3 := base64.StdEncoding.EncodeToString([]byte(messageJSONThree))
	robot.SendMessage(strconv.FormatInt(transferRequestData.UserAccount, 10), []byte(messageString3))
	im.MessageInto(message, false)

	// Transfer to the library for counting service times
	servicesStatistical := models.ServicesStatistical{UserAccount: transferRequestData.UserAccount, ServiceAccount: transferRequestData.ToAccount, TransferAccount: admin.ID, Platform: user.Platform, CreateAt: time.Now().Unix()}
	_, _ = o.Insert(&servicesStatistical)

	// End the repeater's and user's current session
	tk := time.NewTimer(1 * time.Second)
	select {
	case <-tk.C:
		endUsersID := []int64{admin.ID, transferRequestData.UserAccount}
		_, _ = o.Raw("UPDATE contact SET is_session_end = 1 WHERE to_account IN(?,?) AND from_account IN(?,?)", endUsersID, endUsersID).Exec()
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "转接成功", nil)
	c.ServeJSON()
}
