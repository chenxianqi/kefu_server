package controllers

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"kefu_server/im"
	"kefu_server/models"
	"kefu_server/utils"
	"math/rand"
	"os"
	"path"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/qiniu/api.v7/auth/qbox"
	"github.com/qiniu/api.v7/storage"
)

// PublicController struct
type PublicController struct {
	beego.Controller
}

// Register mimc and user
func (c *PublicController) Register() {

	// request body
	var sessionRequest models.SessionRequest
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &sessionRequest); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// type
	if sessionRequest.Type > 1 || sessionRequest.Type < 0 {
		c.Data["json"] = utils.ResponseError(c.Ctx, "type类型错误!", nil)
		c.ServeJSON()
		return
	}

	o := orm.NewOrm()

	var (
		fetchResult string
		fetchError  error
	)

	// user
	var user models.User
	if sessionRequest.Type == 0 {

		// platfrom id exist
		if count, err := o.QueryTable(new(models.Platform)).Filter("id", sessionRequest.Platform).Count(); count <= 0 || sessionRequest.Platform == 1 {
			c.Data["json"] = utils.ResponseError(c.Ctx, "注册失败，该平台ID不存在!", &err)
			c.ServeJSON()
			return
		}

		user = models.User{ID: sessionRequest.AccountID, UID: sessionRequest.UID, Platform: sessionRequest.Platform, Address: sessionRequest.Address}

		/// old user
		if err := o.QueryTable(new(models.User)).Filter("platform", sessionRequest.Platform).Filter("id", sessionRequest.AccountID).One(&user); err == nil {
			user.Online = 1
			user.UID = sessionRequest.UID
			user.Address = sessionRequest.Address
			user.Platform = sessionRequest.Platform
			user.LastActivity = time.Now().Unix()
			_, _ = o.Update(&user)
			fetchResult, fetchError = im.GetMiMcToken(strconv.FormatInt(user.ID, 10))
		} else {
			// create new user
			user.CreateAt = time.Now().Unix()
			user.ID = 0
			user.Online = 1
			user.LastActivity = time.Now().Unix()
			user.Address = sessionRequest.Address
			if accountID, err := o.Insert(&user); err == nil {
				user.NickName = "访客" + strconv.FormatInt(accountID, 10)
				_, _ = o.Update(&user)
				fetchResult, fetchError = im.GetMiMcToken(strconv.FormatInt(accountID, 10))
			} else {
				logs.Info(err)
				c.Data["json"] = utils.ResponseError(c.Ctx, "服务异常,请稍后重试!", err)
				c.ServeJSON()
				return
			}
		}

	} else {

		// is service
		token := c.Ctx.Input.Header("Authorization")

		// admin
		admin := models.Admin{Token: token}
		if err := o.Read(&admin, "Token"); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "客服不存在!", err)
			c.ServeJSON()
			return
		}

		fetchResult, fetchError = im.GetMiMcToken(strconv.FormatInt(admin.ID, 10))
	}

	if fetchError != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "注册失败!", &fetchError)
		c.ServeJSON()
		return
	}
	imToken := new(models.IMToken)
	if err := json.Unmarshal([]byte(fetchResult), &imToken); err != nil {
		logs.Info(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "注册失败!", &err)
		c.ServeJSON()
		return
	}
	type successData struct {
		Token interface{} `json:"token"`
		User  interface{} `json:"user"`
	}
	var resData successData
	if sessionRequest.Type == 0 {
		resData = successData{Token: &imToken, User: &user}
	} else {
		resData = successData{Token: &imToken, User: nil}
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "获取成功!", &resData)
	c.ServeJSON()

}

// Read get user read count
func (c *PublicController) Read() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	qs := o.QueryTable(new(models.Message))
	var readCount int64
	if _count, err := qs.Filter("to_account", id).Filter("read", 1).Count(); err == nil {
		readCount = _count
	} else {
		readCount = 0
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &readCount)
	c.ServeJSON()

}

// Window set user window
func (c *PublicController) Window() {

	o := orm.NewOrm()
	type WindowType struct {
		Window int `json:"window"`
	}
	var wType WindowType
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &wType); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败！", nil)
		return
	}
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	user := models.User{ID: id}
	if err := o.Read(&user); err != nil {
		logs.Info(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "更新失败！", nil)
	} else {
		user.IsWindow = wType.Window
		_, _ = o.Update(&user)
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "更新成功！", nil)
	}
	c.ServeJSON()
}

// CleanRead clean user read
func (c *PublicController) CleanRead() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	if _, err := o.Raw("UPDATE `message` SET `read` = 0 WHERE `to_account` = ?", id).Exec(); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "执行失败！", err)

	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "执行成功！", nil)
	}
	c.ServeJSON()

}

// Robot get robot
func (c *PublicController) Robot() {

	o := orm.NewOrm()

	// request body
	platformID, _ := strconv.ParseInt(c.Ctx.Input.Param(":platform"), 10, 64)

	var robots []*models.Robot
	qs := o.QueryTable(new(models.Robot))
	_, _ = qs.Filter("platform__in", platformID, 1).Filter("switch", 1).All(&robots)
	if len(robots) > 0 {
		robot := robots[rand.Intn(len(robots))]
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &robot)
	} else {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", nil)
	}
	c.ServeJSON()

}

// RobotInfo get robot info
func (c *PublicController) RobotInfo() {

	o := orm.NewOrm()
	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// request
	robot := models.Robot{ID: id}
	if err := o.Read(&robot); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "获取失败!", err)
		c.ServeJSON()
		return
	}
	robot.Artificial = strings.Trim(robot.Artificial, "|")
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &robot)
	c.ServeJSON()

}

// UploadSecretMode struct
type UploadSecretMode struct {
	Mode   int         `json:"mode"`
	Secret interface{} `json:"secret"`
	Host   string      `json:"host"`
}

// UploadSecret update Secret
func (c *PublicController) UploadSecret() {

	o := orm.NewOrm()
	system := models.System{ID: 1}
	if err := o.Read(&system); err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", nil)
		c.ServeJSON()
		return
	}

	// System built-in storage
	if system.UploadMode == 1 {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &UploadSecretMode{
			Mode:   system.UploadMode,
			Secret: "",
			Host:   beego.AppConfig.String("static_host"),
		})
		c.ServeJSON()

		// qiniu
	} else if system.UploadMode == 2 {
		qiniuSetting := models.QiniuSetting{ID: 1}
		if err := o.Read(&qiniuSetting); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", nil)
			c.ServeJSON()
			return
		}
		putPolicy := storage.PutPolicy{
			Scope: qiniuSetting.Bucket,
		}

		// 2 hours validity
		putPolicy.Expires = 7200 * 12
		mac := qbox.NewMac(qiniuSetting.AccessKey, qiniuSetting.SecretKey)
		upToken := putPolicy.UploadToken(mac)
		secretModeData := UploadSecretMode{Mode: system.UploadMode, Secret: upToken, Host: qiniuSetting.Host}
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &secretModeData)

		// aliyun OSS
	} else if system.UploadMode == 3 {

	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", nil)
		c.ServeJSON()
	}

	c.ServeJSON()
}

// LastActivity change last Activity
func (c *PublicController) LastActivity() {

	o := orm.NewOrm()
	uid, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	if uid > 0 {

		user := models.User{ID: uid}
		user.LastActivity = time.Now().Unix()
		if _, err := o.Update(&user, "LastActivity"); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在!", &err)
			c.ServeJSON()
			return
		}

	} else {

		// token
		token := c.Ctx.Input.Header("Authorization")
		admin := models.Admin{Token: token}
		if err := o.Read(&admin, "Token"); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在!", nil)
			c.ServeJSON()
			return
		}

		admin.LastActivity = time.Now().Unix()
		if _, err := o.Update(&admin, "LastActivity"); err != nil {
			c.Data["json"] = utils.ResponseError(c.Ctx, "用户不存在!", nil)
			c.ServeJSON()
			return
		}

	}

	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "上报成功!", nil)
	c.ServeJSON()
}

// GetCompanyInfo get Company info
func (c *PublicController) GetCompanyInfo() {

	o := orm.NewOrm()

	company := models.Company{ID: 1}
	if err := o.Read(&company); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "查询失败!", err)
	} else {
		c.Data["json"] = utils.ResponseSuccess(c.Ctx, "查询成功！", &company)
	}
	c.ServeJSON()

}

// PushMessage push message
func (c *PublicController) PushMessage() {

	// PushMessage
	type PushMessage struct {
		MsgType string `json:"msgType"`
		Payload string `json:"payload"`
	}

	var pushMessage PushMessage
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &pushMessage); err != nil {
		logs.Error(err)
		c.Data["json"] = utils.ResponseError(c.Ctx, "参数错误!", nil)
		c.ServeJSON()
		return
	}

	// 判断是否是单聊消息
	if pushMessage.MsgType != "NORMAL_MSG" {
		c.ServeJSON()
		return
	}

	// message
	var getMessage models.Message
	msgContent, _ := base64.StdEncoding.DecodeString(pushMessage.Payload)
	msgContent, _ = base64.StdEncoding.DecodeString(string(msgContent))
	json.Unmarshal(msgContent, &getMessage)
	im.MessageInto(getMessage, false)
	c.ServeJSON()

}

// Upload Upload image
func (c *PublicController) Upload() {

	f, h, _ := c.GetFile("file")
	fileName := c.GetString("file_name")
	if fileName == "" {
		c.Data["json"] = utils.ResponseError(c.Ctx, "上传失败", "file_name不能为空")
		c.ServeJSON()
		return
	}
	ext := path.Ext(h.Filename)

	// Verify that the suffix name meets the requirements
	var AllowExtMap map[string]bool = map[string]bool{
		".jpg":  true,
		".jpeg": true,
		".png":  true,
	}
	if _, ok := AllowExtMap[ext]; !ok {
		c.Data["json"] = utils.ResponseError(c.Ctx, "上传失败", "上传文件不合法")
		c.ServeJSON()
		return
	}

	// create dir
	uploadDir := "static/uploads/images/"
	err := os.MkdirAll(uploadDir, 777)
	if err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "上传失败,创建文件夹失败", fmt.Sprintf("%v", err))
		c.ServeJSON()
		return
	}
	fpath := uploadDir + fileName
	defer f.Close()

	err = c.SaveToFile("file", fpath)

	if err != nil {
		c.Data["json"] = utils.ResponseError(c.Ctx, "上传失败", fmt.Sprintf("%v", err))
		c.ServeJSON()
		return
	}
	c.Data["json"] = utils.ResponseSuccess(c.Ctx, "上传成功", &fileName)
	c.ServeJSON()

}
