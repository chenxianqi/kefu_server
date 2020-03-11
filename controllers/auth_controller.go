package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"kefu_server/configs"
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"strconv"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

// AuthController struct
type AuthController struct {
	BaseController
	AuthTypesRepository *services.AuthTypesRepository
	AdminRepository     *services.AdminRepository
	AuthsRepository     *services.AuthsRepository
}

// Prepare More like construction method
func (c *AuthController) Prepare() {

	// AuthTypes instance
	c.AuthTypesRepository = services.GetAuthTypesRepositoryInstance()

	// AdminRepository instance
	c.AdminRepository = services.GetAdminRepositoryInstance()

	// AuthsRepository instance
	c.AuthsRepository = services.GetAuthsRepositoryInstance()

}

// Finish Comparison like destructor
func (c *AuthController) Finish() {}

// LoginRequest login
// auth_type 登录客户端标识ID
// username 用户名
// password 密码
type LoginRequest struct {
	AuthType int64  `json:"auth_type"`
	UserName string `json:"username"`
	Password string `json:"password"`
}

// Login admin login
func (c *AuthController) Login() {

	var request LoginRequest
	valid := validation.Validation{}

	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &request); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查", nil)
	}

	// valid
	valid.Required(request.UserName, "username").Message("用户名不能为空！")
	valid.Required(request.Password, "password").Message("密码不能为空！")
	valid.Required(request.AuthType, "auth_type").Message("登录客户端标识auth_type不能为空！")

	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}

	}

	// MD5
	m5 := md5.New()
	m5.Write([]byte(request.Password))
	request.Password = hex.EncodeToString(m5.Sum(nil))

	/// auth_type exist ？
	authType := c.AuthTypesRepository.GetAuthType(request.AuthType)
	if authType == nil {
		c.JSON(configs.ResponseFail, "客户端标识不存在！", nil)
	}

	queryAdmin := c.AdminRepository.GetAdminWithUserName(request.UserName)
	if queryAdmin == nil {
		c.JSON(configs.ResponseFail, "用户不存在！", nil)
	}
	if queryAdmin.Password != request.Password {
		c.JSON(configs.ResponseFail, "密码错误！", nil)
	}
	if request.UserName != queryAdmin.UserName {
		c.JSON(configs.ResponseFail, "用户不存在！", nil)
	}

	// create token
	newToken := utils.GenerateToken(models.JwtKeyDto{ID: queryAdmin.ID, UserName: queryAdmin.UserName, AuthType: authType.ID})
	auth := c.AuthsRepository.GetAuthInfoWithTypeAndUID(request.AuthType, queryAdmin.ID)
	if auth == nil {

		newAuth := models.Auths{
			Token:    newToken,
			UID:      queryAdmin.ID,
			AuthType: authType.ID,
			UpdateAt: time.Now().Unix(),
			CreateAt: time.Now().Unix(),
		}
		if _, err := c.AuthsRepository.Add(&newAuth); err != nil {
			c.JSON(configs.ResponseFail, "登录失败!", nil)
		}

	} else {

		_, err := c.AuthsRepository.Update(auth.ID, orm.Params{
			"Token":    newToken,
			"UpdateAt": time.Now().Unix(),
		})
		if err != nil {
			c.JSON(configs.ResponseFail, "登录失败!", nil)
		}

	}

	queryAdmin.Password = "*****"
	queryAdmin.Token = newToken
	c.JSON(configs.ResponseSucess, "登录成功！!", &queryAdmin)
}

// Logout admin logout
func (c *AuthController) Logout() {

	// GetAuthInfo
	auth := c.GetAuthInfo()

	if count := c.AuthsRepository.GetAdminOnlineCount(auth.UID); count <= 1 {

		if _, err := c.AdminRepository.Update(auth.UID, orm.Params{
			"CurrentConUser": 0,
			"Online":         0,
		}); err != nil {
			c.JSON(configs.ResponseFail, "退出失败！", &err)
		}
	}
	if row, err := c.AuthsRepository.Delete(auth.ID); err != nil || row == 0 {
		c.JSON(configs.ResponseFail, "退出失败！", &err)
	}
	c.JSON(configs.ResponseSucess, "退出成功！", nil)
}

// RobotFetchTokenRequest struct
type RobotFetchTokenRequest struct {
	AppSecret string `json:"app_secret"`
}

// RobotFetchToken admin logout
func (c *AuthController) RobotFetchToken() {

	var request RobotFetchTokenRequest
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &request); err != nil {
		c.JSON(configs.ResponseFail, "参数有误，请检查", nil)
	}

	// valid
	valid := validation.Validation{}
	valid.Required(request.AppSecret, "app_secret").Message("app_secret不能为空！")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			c.JSON(configs.ResponseFail, err.Message, nil)
		}
	}

	// current app Secret
	_AppID, _ := beego.AppConfig.Int64("mimc_appId")
	_AppKey := beego.AppConfig.String("mimc_appKey")
	_AppSecret := beego.AppConfig.String("mimc_appSecret")
	m51 := md5.New()
	m51.Write([]byte(strconv.FormatInt(_AppID, 10) + _AppKey + _AppSecret))
	currentAppSecret := hex.EncodeToString(m51.Sum(nil))

	// check
	if request.AppSecret != currentAppSecret {
		c.JSON(configs.ResponseFail, "server error~", nil)
	}

	// create token
	newToken := utils.GenerateToken(models.JwtKeyDto{ID: _AppID, UserName: _AppKey, AuthType: 0})
	auth := c.AuthsRepository.GetAuthInfoWithTypeAndUID(0, 0)
	if auth == nil {

		newAuth := models.Auths{
			Token:    newToken,
			UID:      0,
			AuthType: 0,
			UpdateAt: time.Now().Unix(),
			CreateAt: time.Now().Unix(),
		}
		if _, err := c.AuthsRepository.Add(&newAuth); err != nil {
			c.JSON(configs.ResponseFail, "授权失败!", nil)
		}

	} else {

		_, err := c.AuthsRepository.Update(auth.ID, orm.Params{
			"Token":    newToken,
			"UpdateAt": time.Now().Unix(),
		})
		if err != nil {
			c.JSON(configs.ResponseFail, "授权失败!", nil)
		}

	}

	c.JSON(configs.ResponseSucess, "授权成功!", &newToken)

}
