package controllers

import (
	"encoding/base64"
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"os"
	"path"
	"strconv"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	"github.com/qiniu/api.v7/auth/qbox"
	"github.com/qiniu/api.v7/storage"
)

// PublicController struct
type PublicController struct {
	BaseController
	UserRepository    *services.UserRepository
	MessageRepository *services.MessageRepository
	AdminRepository   *services.AdminRepository
}

// Prepare More like construction method
func (c *PublicController) Prepare() {

	// UserRepository inttance
	c.UserRepository = services.GetUserRepositoryInstance()

	// MessageRepository instance
	c.MessageRepository = services.GetMessageRepositoryInstance()

	// AdminRepository instance
	c.AdminRepository = services.GetAdminRepositoryInstance()

}

// Finish Comparison like destructor
func (c *PublicController) Finish() {}

// Register mimc and user
func (c *PublicController) Register() {

	// request body
	var sessionRequestDto models.SessionRequestDto
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &sessionRequestDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// type
	if sessionRequestDto.Type > 1 || sessionRequestDto.Type < 0 {
		c.JSON(configs.ResponseFail, "type类型错误!", nil)
	}

	imTokenDto := new(models.IMTokenDto)

	var user *models.User
	var admin *models.Admin
	var (
		fetchResult string
		fetchError  error
	)

	// user
	if sessionRequestDto.Type == 0 {

		// platfrom id exist
		if pt := services.GetPlatformRepositoryInstance().GetPlatform(sessionRequestDto.Platform); pt == nil || sessionRequestDto.Platform == 1 {
			c.JSON(configs.ResponseFail, "注册失败，该平台ID不存在!", nil)
		}

		// Do business user data expansion here
		if sessionRequestDto.UID != 0 {

			// “sessionRequestDto.UID”, If there is a mapping relationship with the business platform
			// You can update the business profile user information to the customer service database here
			// example:
			// &myUser := modes.MyUser{}
			// o.Raw("SELECT * FROM `members` WHERE id = 100", sessionRequestDto.UID).QueryRow(&myUser)
			// & myUser is the data of the business platform user, and finally assigned to models.User

			// Read users based on business platform
			user = c.UserRepository.GetUserWithUID(sessionRequestDto.UID)

		} else {

			// Read users using AccountID
			user = c.UserRepository.GetUser(sessionRequestDto.AccountID)

		}

		/// old user
		if user != nil {

			// fetchResult
			fetchResult, fetchError = utils.CreateMiMcToken(strconv.FormatInt(user.ID, 10))
			if err := json.Unmarshal([]byte(fetchResult), &imTokenDto); err != nil {
				c.JSON(configs.ResponseFail, "注册失败!", &err)
			}
			// update userinfo
			c.UserRepository.Update(user.ID, orm.Params{
				"Online":       1,
				"Address":      sessionRequestDto.Address,
				"Platform":     sessionRequestDto.Platform,
				"LastActivity": time.Now().Unix(),
				"Token":        imTokenDto.Data.Token,
			})
			user.Token = imTokenDto.Data.Token

		} else {

			// create new user
			user = &models.User{}
			user.CreateAt = time.Now().Unix()
			user.ID = 0
			user.Online = 1
			user.LastActivity = time.Now().Unix()
			user.Address = sessionRequestDto.Address

			if accountID, err := c.UserRepository.Add(user); err == nil {

				fetchResult, fetchError = utils.CreateMiMcToken(strconv.FormatInt(accountID, 10))
				if err := json.Unmarshal([]byte(fetchResult), &imTokenDto); err != nil {
					c.JSON(configs.ResponseFail, "注册失败!", &err)
				}

				// update userinfo
				c.UserRepository.Update(user.ID, orm.Params{
					"Token":    imTokenDto.Data.Token,
					"NickName": "访客" + strconv.FormatInt(accountID, 10),
				})

			} else {
				c.JSON(configs.ResponseFail, "注册失败!", &err)
			}
		}

	} else {

		// GetAuthInfo
		auth := c.GetAuthInfo()
		admin = c.AdminRepository.GetAdmin(auth.UID)

		// fetchResult
		fetchResult, fetchError = utils.CreateMiMcToken(strconv.FormatInt(admin.ID, 10))

		// imTokenDto
		if err := json.Unmarshal([]byte(fetchResult), &imTokenDto); err != nil {
			c.JSON(configs.ResponseFail, "注册失败!", &err)
		}
	}

	// is Error ?
	if fetchError != nil {
		c.JSON(configs.ResponseFail, "注册失败!", &fetchError)
	}

	// response data
	type successData struct {
		Token interface{} `json:"token"`
		User  interface{} `json:"user"`
	}
	var resData successData
	if sessionRequestDto.Type == 0 {
		resData = successData{Token: &imTokenDto, User: &user}
	} else {
		resData = successData{Token: &imTokenDto, User: &admin}
	}

	c.JSON(configs.ResponseSucess, "注册成功!", &resData)

}

// Read get user read count
func (c *PublicController) Read() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	readCount, err := c.MessageRepository.GetReadCount(id)
	if err == nil {
		readCount = 0
	}
	c.JSON(configs.ResponseSucess, "查询成功!", readCount)

}

// Window set user window
func (c *PublicController) Window() {

	type WindowType struct {
		Window int `json:"window"`
	}
	var wType WindowType
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &wType); err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", nil)
	}

	// get user info
	uid, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)
	user := c.UserRepository.GetUser(uid)

	if user == nil {
		c.JSON(configs.ResponseFail, "更新失败，用户不存在!", nil)
	}

	// update
	_, err := c.UserRepository.Update(uid, orm.Params{
		"IsWindow": wType.Window,
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", nil)
	}

	c.JSON(configs.ResponseSucess, "更新成功!", nil)
}

// CleanRead clean user read
func (c *PublicController) CleanRead() {
	uid, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// Can't just clear customer service
	if admin := c.AdminRepository.GetAdmin(uid); admin != nil {
		c.JSON(configs.ResponseFail, "清除成功!", nil)
	}

	// clear
	if _, err := c.MessageRepository.ClearRead(uid); err != nil {
		c.JSON(configs.ResponseFail, "清除失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "清除成功!", nil)

}

// Robot get robot
func (c *PublicController) Robot() {

	// request body
	pid, _ := strconv.ParseInt(c.Ctx.Input.Param(":platform"), 10, 64)

	// get robot
	robot, err := services.GetRobotRepositoryInstance().GetRobotWithOnline(pid)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", &err)
	}

	c.JSON(configs.ResponseSucess, "success", &robot)

}

// RobotInfo get robot info
func (c *PublicController) RobotInfo() {

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// request
	robot := services.GetRobotRepositoryInstance().GetRobot(id)
	if robot == nil {
		c.JSON(configs.ResponseFail, "fail,机器人不存在!", nil)
	}

	c.JSON(configs.ResponseSucess, "success", &robot)

}

// UploadSecretMode struct
type UploadSecretMode struct {
	Mode   int         `json:"mode"`
	Secret interface{} `json:"secret"`
	Host   string      `json:"host"`
}

// UploadSecret update Secret
func (c *PublicController) UploadSecret() {

	// system info
	system := services.GetSystemRepositoryInstance().GetSystem()

	// System built-in storage
	if system.UploadMode == 1 {
		c.JSON(configs.ResponseSucess, "success", &UploadSecretMode{
			Mode:   system.UploadMode,
			Secret: "",
			Host:   beego.AppConfig.String("static_host"),
		})
	}

	// qiniu
	if system.UploadMode == 2 {

		qiniuSetting := services.GetQiniuRepositoryInstance().GetQiniuConfigInfo()
		putPolicy := storage.PutPolicy{
			Scope: qiniuSetting.Bucket,
		}

		// 2 hours validity
		putPolicy.Expires = 7200 * 12
		mac := qbox.NewMac(qiniuSetting.AccessKey, qiniuSetting.SecretKey)
		upToken := putPolicy.UploadToken(mac)
		secretModeData := UploadSecretMode{Mode: system.UploadMode, Secret: upToken, Host: qiniuSetting.Host}
		c.JSON(configs.ResponseSucess, "success", &secretModeData)

	}

	c.JSON(configs.ResponseFail, "fail", nil)
}

// LastActivity change last Activity
func (c *PublicController) LastActivity() {

	// uid id if exist current request is user, else admin
	uid, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// user
	if uid > 0 {
		_, err := c.UserRepository.Update(uid, orm.Params{
			"LastActivity": time.Now().Unix(),
		})
		if err != nil {
			c.JSON(configs.ResponseFail, "fail,用户不存在!", &err)
		}
		c.JSON(configs.ResponseSucess, "上报成功!", nil)
	}

	// admin
	// GetAuthInfo
	auth := c.GetAuthInfo()
	_, err := c.AdminRepository.Update(auth.UID, orm.Params{
		"LastActivity": time.Now().Unix(),
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "fail,用户不存在!", &err)
	}

	c.JSON(configs.ResponseSucess, "上报成功!", nil)
}

// GetCompanyInfo get Company info
func (c *PublicController) GetCompanyInfo() {

	// system info
	system := services.GetSystemRepositoryInstance().GetSystem()
	c.JSON(configs.ResponseSucess, "上报成功!", &system)

}

// PushMessage push message store
// This Api can be connected to Xiaomi's message callback to determine whether it is an offline message to handle the push
// see https://admin.mimc.chat.xiaomi.net/docs/09-callback.html
// Or the client can manually store messages through the Api
// OFFLINE_MSG type is offline message
// NORMAL_MSG  type is online message
// Notice!!!: This Api does not handle types other than NORMAL_MSG
func (c *PublicController) PushMessage() {

	// PushMessage
	// PushMessage.MsgType == "NORMAL_MSG" || "OFFLINE_MSG"
	// PushMessage.Payload, Must be base64 of models.Message
	type PushMessage struct {
		MsgType string `json:"msgType"`
		Payload string `json:"payload"`
	}

	// get body
	var pushMessage PushMessage
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &pushMessage); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// is not Single chat message And kill
	if pushMessage.MsgType != "NORMAL_MSG" {
		c.JSON(configs.ResponseFail, "sorry you send message type is not NORMAL_MSG, it is "+pushMessage.MsgType, nil)
	}
	// push message store
	var getMessage models.Message
	var msgContent []byte
	msgContent, _ = base64.StdEncoding.DecodeString(pushMessage.Payload)
	utils.StringToInterface(string(msgContent), &getMessage)
	utils.MessageInto(getMessage, false)

	c.JSON(configs.ResponseSucess, "push success", nil)

}

// Upload upload image
func (c *PublicController) Upload() {

	f, h, er := c.GetFile("file")
	fileName := c.GetString("file_name")
	if er != nil {
		c.JSON(configs.ResponseFail, "上传失败,文件不存在!", nil)
	}
	if fileName == "" {
		c.JSON(configs.ResponseFail, "上传失败,file_name不能为空!", nil)
	}
	ext := path.Ext(h.Filename)

	// Verify that the suffix name meets the requirements
	var AllowExtMap map[string]bool = map[string]bool{
		".jpg":  true,
		".jpeg": true,
		".png":  true,
		".JPG":  true,
		".JPEG": true,
		".PNG":  true,
	}
	if _, ok := AllowExtMap[ext]; !ok {
		c.JSON(configs.ResponseFail, "上传失败,上传文件不合法!", nil)
	}

	// create dir
	uploadDir := "static/uploads/images/" + time.Now().Format("2006-01-02") + "/"
	err := os.MkdirAll(uploadDir, os.ModePerm)
	if err != nil {
		c.JSON(configs.ResponseFail, "上传失败,创建文件夹失败!", &err)
	}
	fpath := uploadDir + fileName
	defer f.Close()
	err = c.SaveToFile("file", fpath)
	if err != nil {
		c.JSON(configs.ResponseFail, "上传失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "上传成功!", &fileName)
}

// CancelMessage cancel a message
func (c *PublicController) CancelMessage() {

	removeMessageRequestDto := models.RemoveMessageRequestDto{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &removeMessageRequestDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}
	// validation
	valid := validation.Validation{}
	valid.Required(removeMessageRequestDto.Key, "key").Message("key不能为空！")
	valid.Required(removeMessageRequestDto.FromAccount, "from_account").Message("from_account不能为空！")
	valid.Required(removeMessageRequestDto.ToAccount, "to_account").Message("to_account不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// cancel
	messageRepository := services.GetMessageRepositoryInstance()
	_, err := messageRepository.Delete(removeMessageRequestDto)

	if err != nil {
		c.JSON(configs.ResponseFail, "撤回失败!", &err)
	}

	c.JSON(configs.ResponseSucess, "撤回成功!", nil)
}

// GetMessageHistoryList get user messages
func (c *PublicController) GetMessageHistoryList() {

	messagePaginationDto := models.MessagePaginationDto{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &messagePaginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	token := c.Ctx.Input.Header("token")
	if token == "" {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(messagePaginationDto.Account, "account").Message("account不能为空！")
	valid.Required(messagePaginationDto.PageSize, "page_size").Message("page_size不能为空！")

	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// exist user
	user := c.UserRepository.GetUser(messagePaginationDto.Account)
	if user == nil {
		c.JSON(configs.ResponseFail, "fail，用户不存在!", nil)
	}

	/// validation TOKEN
	if token != user.Token {
		c.JSON(configs.ResponseFail, "fail，用户不存在!", nil)
	}

	// Timestamp == 0
	if messagePaginationDto.Timestamp == 0 {
		messagePaginationDto.Timestamp = time.Now().Unix()
	}

	// query messages
	returnMessagePaginationDto, err := c.MessageRepository.GetAdminMessages(messagePaginationDto)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", &err)
	}

	c.JSON(configs.ResponseSucess, "success", &returnMessagePaginationDto)

}
