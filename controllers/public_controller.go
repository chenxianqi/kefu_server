package controllers

import (
	"crypto/md5"
	"encoding/base64"
	"encoding/hex"
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
	"github.com/qiniu/api.v7/v7/auth/qbox"
	"github.com/qiniu/api.v7/v7/storage"
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

// Finish Comparison like destructor or package init()
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

		}

		if user == nil {

			// Read users using AccountID
			user = c.UserRepository.GetUser(sessionRequestDto.AccountID)

		}

		// Addr for this request IP
		currentRemoteAddr := c.Ctx.Input.IP()

		/// old user
		if user != nil {

			// fetchResult
			fetchResult, fetchError = utils.CreateMiMcToken(strconv.FormatInt(user.ID, 10))
			if err := json.Unmarshal([]byte(fetchResult), &imTokenDto); err != nil {
				c.JSON(configs.ResponseFail, "注册失败!", err.Error())
			}
			// MD5 user token
			m5 := md5.New()
			m5.Write([]byte(imTokenDto.Data.Token))
			_md5Token := hex.EncodeToString(m5.Sum(nil))

			// update userinfo
			userInfo := orm.Params{
				"Online":       1,
				"RemoteAddr":   currentRemoteAddr,
				"Address":      sessionRequestDto.Address,
				"Platform":     sessionRequestDto.Platform,
				"LastActivity": time.Now().Unix(),
				"Token":        _md5Token,
			}
			c.UserRepository.Update(user.ID, userInfo)
			user.Token = _md5Token

		} else {

			// create new user
			user = &models.User{}
			user.CreateAt = time.Now().Unix()
			user.ID = 0
			user.Online = 1
			user.RemoteAddr = currentRemoteAddr
			user.Platform = sessionRequestDto.Platform
			user.LastActivity = time.Now().Unix()
			user.Address = sessionRequestDto.Address

			if accountID, err := c.UserRepository.Add(user); err == nil {

				fetchResult, fetchError = utils.CreateMiMcToken(strconv.FormatInt(accountID, 10))
				if err := json.Unmarshal([]byte(fetchResult), &imTokenDto); err != nil {
					c.JSON(configs.ResponseFail, "注册失败!", err.Error())
				}
				// MD5 user token
				m5 := md5.New()
				m5.Write([]byte(imTokenDto.Data.Token))
				_md5Token := hex.EncodeToString(m5.Sum(nil))
				user.Token = _md5Token
				// update userinfo
				c.UserRepository.Update(user.ID, orm.Params{
					"Token":    _md5Token,
					"NickName": "访客" + strconv.FormatInt(accountID, 10),
				})

			} else {
				c.JSON(configs.ResponseFail, "注册失败!", err.Error())
			}
		}

		// flow Statistical
		services.GetFlowStatisticalRepositoryInstance().Increment(user.Platform, user.ID)

	} else {

		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		admin = c.AdminRepository.GetAdmin(auth.UID)

		// fetchResult
		fetchResult, fetchError = utils.CreateMiMcToken(strconv.FormatInt(admin.ID, 10))

		// imTokenDto
		if err := json.Unmarshal([]byte(fetchResult), &imTokenDto); err != nil {
			c.JSON(configs.ResponseFail, "注册失败!", err.Error())
		}
	}

	// is Error ?
	if fetchError != nil {
		c.JSON(configs.ResponseFail, "注册失败!", fetchError.Error())
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

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "查询失败!", 0)
	}

	readCount, err := c.MessageRepository.GetReadCount(user.ID)
	if err == nil {
		readCount = 0
	}

	c.JSON(configs.ResponseSucess, "查询成功!", readCount)

}

// Window set user window
func (c *PublicController) Window() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "更新失败!", "")
	}

	type WindowType struct {
		Window int `json:"window"`
	}
	var wType WindowType
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &wType); err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", nil)
	}

	// update
	_, err := c.UserRepository.Update(user.UID, orm.Params{
		"IsWindow": wType.Window,
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "更新失败!", nil)
	}

	c.JSON(configs.ResponseSucess, "更新成功!", nil)
}

// CleanRead clean user read
func (c *PublicController) CleanRead() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "清除失败!", "")
	}

	// clear
	if _, err := c.MessageRepository.ClearRead(user.UID); err != nil {
		c.JSON(configs.ResponseFail, "清除失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "清除成功!", nil)

}

// Robot get robot
func (c *PublicController) Robot() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "fail,!", nil)
		}
	}

	// request body
	pid, _ := strconv.ParseInt(c.Ctx.Input.Param(":platform"), 10, 64)

	// get robot
	robot, err := services.GetRobotRepositoryInstance().GetRobotWithOnline(pid)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}

	c.JSON(configs.ResponseSucess, "success", &robot)

}

// RobotInfo get robot info
func (c *PublicController) RobotInfo() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "fail,!", nil)
		}
	}

	id, _ := strconv.ParseInt(c.Ctx.Input.Param(":id"), 10, 64)

	// request
	robot := services.GetRobotRepositoryInstance().GetRobot(id)
	if robot == nil {
		c.JSON(configs.ResponseFail, "fail,机器人不存在!", nil)
	}

	c.JSON(configs.ResponseSucess, "success", &robot)

}

// Configs update Secret
func (c *PublicController) Configs() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "fail!", nil)
		}
	}

	// system info
	system := services.GetSystemRepositoryInstance().GetSystem()

	// System built-in storage
	if system.UploadMode == 1 {
		c.JSON(configs.ResponseSucess, "success", &models.ConfigsDto{
			UploadMode:    system.UploadMode,
			UploadSecret:  "",
			UploadHost:    beego.AppConfig.String("static_host"),
			OpenWorkorder: system.OpenWorkorder,
		})
	}

	// qiniu
	if system.UploadMode == 2 {

		qiniuSetting := services.GetQiniuRepositoryInstance().GetQiniuConfigInfo()
		putPolicy := storage.PutPolicy{
			Scope:    qiniuSetting.Bucket,
			FsizeMin: 1,
		}

		// 2 hours validity
		putPolicy.Expires = 7200 * 12
		mac := qbox.NewMac(qiniuSetting.AccessKey, qiniuSetting.SecretKey)
		upToken := putPolicy.UploadToken(mac)
		secretModeData := &models.ConfigsDto{UploadMode: system.UploadMode, UploadSecret: upToken, UploadHost: qiniuSetting.Host, OpenWorkorder: system.OpenWorkorder}
		c.JSON(configs.ResponseSucess, "success", &secretModeData)

	}

	c.JSON(configs.ResponseFail, "fail", nil)
}

// LastActivity change last Activity
func (c *PublicController) LastActivity() {

	// get user
	user := c.GetUserInfo()

	// user
	if user != nil {
		_, err := c.UserRepository.Update(user.ID, orm.Params{
			"LastActivity": time.Now().Unix(),
		})
		if err != nil {
			c.JSON(configs.ResponseFail, "fail,用户不存在!", err.Error())
		}
		c.JSON(configs.ResponseSucess, "上报成功!", nil)
	}

	// GetAdminAuthInfo
	auth := c.GetAdminAuthInfo()
	_, err := c.AdminRepository.Update(auth.UID, orm.Params{
		"LastActivity": time.Now().Unix(),
	})
	if err != nil {
		c.JSON(configs.ResponseFail, "fail,用户不存在!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "上报成功!", nil)

}

// GetCompanyInfo get Company info
func (c *PublicController) GetCompanyInfo() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "fail!", nil)
		}
	}

	// company info
	company := services.GetCompanyRepositoryInstance().GetCompany()
	c.JSON(configs.ResponseSucess, "查询成功!", &company)

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
	var message models.Message
	var msgContent []byte
	msgContent, _ = base64.StdEncoding.DecodeString(pushMessage.Payload)
	utils.StringToInterface(string(msgContent), &message)
	utils.MessageInto(message)

	c.JSON(configs.ResponseSucess, "push success", nil)

}

// Upload upload file
func (c *PublicController) Upload() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "上传失败,无权限上传!", nil)
		}
	}

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
		".zip":  true,
		".ZIP":  true,
		".mp4":  true,
	}
	if _, ok := AllowExtMap[ext]; !ok {
		c.JSON(configs.ResponseFail, "上传失败,上传文件不合法!", nil)
	}

	// create dir
	uploadDir := "static/uploads/images/" + time.Now().Format("2006-01-02") + "/"
	err := os.MkdirAll(uploadDir, os.ModePerm)
	if err != nil {
		c.JSON(configs.ResponseFail, "上传失败,创建文件夹失败!", err.Error())
	}
	fpath := uploadDir + fileName
	defer f.Close()
	err = c.SaveToFile("file", fpath)
	if err != nil {
		c.JSON(configs.ResponseFail, "上传失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "上传成功!", fpath)
}

// CancelMessage cancel a message
func (c *PublicController) CancelMessage() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "撤回失败!", nil)
		}
	}

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
		c.JSON(configs.ResponseFail, "撤回失败!", err.Error())
	}

	c.JSON(configs.ResponseSucess, "撤回成功!", nil)
}

// GetMessageHistoryList get user messages
func (c *PublicController) GetMessageHistoryList() {

	messagePaginationDto := models.MessagePaginationDto{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &messagePaginationDto); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "fail，用户不存在!", nil)
	}
	messagePaginationDto.Account = user.ID

	// Timestamp == 0
	if messagePaginationDto.Timestamp == 0 {
		messagePaginationDto.Timestamp = time.Now().Unix()
	}

	// query messages
	returnMessagePaginationDto, err := c.MessageRepository.GetUserMessages(messagePaginationDto)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}

	c.JSON(configs.ResponseSucess, "success", &returnMessagePaginationDto)

}

// CreateWorkOrder send word order
func (c *PublicController) CreateWorkOrder() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "工单创建失败,请刷新重试!", "")
	}

	workOrder := models.WorkOrder{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &workOrder); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// validation
	valid := validation.Validation{}
	valid.Required(workOrder.TID, "tid").Message("工单类型不能为空！")
	valid.Required(workOrder.Title, "title").Message("工单名称不能为空！")
	valid.MaxSize(workOrder.Title, 100, "title").Message("工单名称不能大于100个字符！")
	valid.Required(workOrder.Phone, "phone").Message("手机号不能为空！")
	valid.Phone(workOrder.Phone, "phone").Message("手机号格式不正确！")
	if workOrder.Email != "" {
		valid.Email(workOrder.Email, "email").Message("邮箱格式不正确！")
	}
	valid.Required(workOrder.Content, "content").Message("工单内容不能为空！")
	valid.MinSize(workOrder.Content, 10, "content").Message("工单内容不能小于10个字符！")
	valid.MaxSize(workOrder.Content, 2000, "content").Message("工单内容不能大于2000个字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// type is exist?
	workOrderTypeRepository := services.GetWorkOrderTypeRepositoryInstance()
	if _, err := workOrderTypeRepository.GetWorkOrderType(workOrder.TID); err != nil {
		c.JSON(configs.ResponseFail, "创建失败,工单类型不存在~", err.Error())
	}

	workOrder.CreateAt = time.Now().Unix()
	workOrder.UID = user.ID
	workOrderRepository := services.GetWorkOrderRepositoryInstance()
	wid, err := workOrderRepository.Add(workOrder)
	if err != nil {
		c.JSON(configs.ResponseFail, "fail", err.Error())
	}
	services.GetUserRepositoryInstance().Update(user.ID, orm.Params{"is_workorder": 1})
	c.JSON(configs.ResponseSucess, "工单创建成功!", wid)

}

// ReplyWorkOrder send word order
func (c *PublicController) ReplyWorkOrder() {

	// request ctx
	workOrderComment := models.WorkOrderComment{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &workOrderComment); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查!", nil)
	}

	// is user ?
	isUser := true

	// get user
	user := c.GetUserInfo()
	if user == nil {
		isUser = false
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "发送失败!", nil)
		}
		workOrderComment.AID = auth.UID
	}

	// validation
	valid := validation.Validation{}
	valid.Required(workOrderComment.WID, "wid").Message("工单ID不能为空！")
	valid.Required(workOrderComment.Content, "content").Message("工单ID不能为空！")
	valid.Required(workOrderComment.Content, "content").Message("内容不能为空！")
	valid.MaxSize(workOrderComment.Content, 2000, "content").Message("工单内容不能大于2000个字符！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// workorder exist
	workOrderRepository := services.GetWorkOrderRepositoryInstance()
	workOrder, err := workOrderRepository.GetWorkOrder(workOrderComment.WID)
	if err != nil {
		c.JSON(configs.ResponseFail, "发送失败,工单不存在!", nil)
	}

	// add
	workOrderComment.UID = workOrder.UID
	workOrderCommentRepository := services.GetWorkOrderCommentRepositoryInstance()
	if _, err := workOrderCommentRepository.Add(workOrderComment); err != nil {
		c.JSON(configs.ResponseFail, "发送失败!", nil)
	}

	// update WorkOrder params
	var params = orm.Params{}

	// change status
	status := 1
	if !isUser {
		status = 2
		params["LastReply"] = workOrderComment.AID

		// send email message
		openWorkorderEmail, _ := beego.AppConfig.Bool("open_workorder_email")
		if workOrder.Email != "" && openWorkorderEmail {
			go func() {
				mailTo := []string{
					workOrder.Email,
				}
				subject := "您的工单：" + workOrder.Title + "已被回复"
				kefuClientURL := beego.AppConfig.String("kefu_client_url")
				body := "工单标题：" + workOrder.Title + "<br>回复：" + workOrderComment.Content + "<br>您可以点<a target='_blank' href='" + kefuClientURL + "?u=" + strconv.FormatInt(workOrder.UID, 10) + "'>此链接</a>去查看完整内容"
				utils.SendMail(mailTo, subject, body)
			}()
		}

	}
	if workOrder.Status == 0 && user != nil {
		status = 0
	}
	params["Status"] = status
	if _, err := workOrderRepository.Update(workOrderComment.WID, params); err != nil {
		c.JSON(configs.ResponseFail, "发送失败!", nil)
	}
	c.JSON(configs.ResponseSucess, "发送成功!", nil)

}

// GetWorkOrders user get word order all
func (c *PublicController) GetWorkOrders() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "查询失败!", nil)
	}

	workOrderRepository := services.GetWorkOrderRepositoryInstance()
	workOrders, err := workOrderRepository.GetUserWorkOrders(user.ID)
	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败!", nil)
	}
	c.JSON(configs.ResponseSucess, "查询成功!", &workOrders)

}

// GetWorkOrderTypes user get word order type all
func (c *PublicController) GetWorkOrderTypes() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "查询失败!", nil)
	}
	workOrderTypeRepository := services.GetWorkOrderTypeRepositoryInstance()
	workOrderTypes := workOrderTypeRepository.GetWorkOrderTypes()
	c.JSON(configs.ResponseSucess, "查询成功！", workOrderTypes)

}

// GetWorkOrderComments get word order comments
func (c *PublicController) GetWorkOrderComments() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "fail!", nil)
		}
	}

	// wid
	wid, _ := strconv.ParseInt(c.Ctx.Input.Param(":wid"), 10, 64)

	workOrderCommentRepository := services.GetWorkOrderCommentRepositoryInstance()
	workOrderComments, err := workOrderCommentRepository.GetWorkOrderComments(wid)
	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败!", nil)
	}

	c.JSON(configs.ResponseSucess, "查询成功!", &workOrderComments)

}

// GetWorkOrder user get word order content
func (c *PublicController) GetWorkOrder() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "fail!", nil)
		}
	}

	// wid
	wid, _ := strconv.ParseInt(c.Ctx.Input.Param(":wid"), 10, 64)

	workOrderRepository := services.GetWorkOrderRepositoryInstance()
	workOrder, err := workOrderRepository.GetWorkOrder(wid)
	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败,工单不存在!", nil)
	}
	if user != nil && user.ID != workOrder.UID {
		c.JSON(configs.ResponseFail, "查询失败,工单不存在!", nil)
	}
	c.JSON(configs.ResponseSucess, "查询成功!", &workOrder)

}

// DeleteWorkOrder user delete word order
func (c *PublicController) DeleteWorkOrder() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		// GetAdminAuthInfo
		auth := c.GetAdminAuthInfo()
		if auth == nil {
			c.JSON(configs.ResponseFail, "fail!", nil)
		}
		admin := services.GetAdminRepositoryInstance().GetAdmin(auth.UID)
		if admin.Root == 0 {
			c.JSON(configs.ResponseFail, "无权限删除!", nil)
		}
	}

	// wid
	wid, _ := strconv.ParseInt(c.Ctx.Input.Param(":wid"), 10, 64)
	workOrderRepository := services.GetWorkOrderRepositoryInstance()
	workOrder, err := workOrderRepository.GetWorkOrder(wid)
	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败,工单不存在!", nil)
	}
	if user != nil && user.ID != workOrder.UID {
		c.JSON(configs.ResponseFail, "删除失败,工单不存在!", nil)
	}
	if workOrder.Status != 3 {
		c.JSON(configs.ResponseFail, "删除失败,工单未结单不能删除!", nil)
	}
	if _, err := workOrderRepository.Update(wid, orm.Params{"Delete": 1}); err != nil {
		c.JSON(configs.ResponseFail, "删除失败,工单不存在!", nil)
	}
	c.JSON(configs.ResponseSucess, "删除成功!", nil)

}

// CloseWorkOrder user close word order
func (c *PublicController) CloseWorkOrder() {

	// get user
	user := c.GetUserInfo()
	if user == nil {
		c.JSON(configs.ResponseFail, "fail!", nil)
	}
	// wid
	wid, _ := strconv.ParseInt(c.Ctx.Input.Param(":wid"), 10, 64)
	workOrderRepository := services.GetWorkOrderRepositoryInstance()
	workOrder, err := workOrderRepository.GetWorkOrder(wid)
	if err != nil {
		c.JSON(configs.ResponseFail, "查询失败,工单不存在!", nil)
	}
	if user != nil && user.ID != workOrder.UID {
		c.JSON(configs.ResponseFail, "关闭失败,工单不存在!", nil)
	}
	if _, err := workOrderRepository.Update(wid, orm.Params{"Status": 3}); err != nil {
		c.JSON(configs.ResponseFail, "关闭失败,工单不存在!", nil)
	}
	c.JSON(configs.ResponseSucess, "关闭成功!", nil)

}
