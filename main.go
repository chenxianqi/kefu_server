package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"

	"github.com/Xiaomi-mimc/mimc-go-sdk/util/log"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/toolbox"
	_ "github.com/go-sql-driver/mysql"

	"kefu_server/controllers"
	"kefu_server/im"
	"kefu_server/models"
	_ "kefu_server/routers"
	"strconv"
	"time"
)

// init Mysql DB
func initDB() {

	// 链接IM数据库
	imAliasName := beego.AppConfig.String("im_alias_name")
	imDriverName := beego.AppConfig.String("im_driver_name")
	var imDataSource string
	imDataSource = beego.AppConfig.String("im_mysql_user") + ":"
	imDataSource += beego.AppConfig.String("im_mysql_pwd")
	imDataSource += "@tcp(" + beego.AppConfig.String("im_mysql_host") + ":3306" + ")/"
	imDataSource += beego.AppConfig.String("im_mysql_db") + "?charset=utf8"
	_ = orm.RegisterDataBase(imAliasName, imDriverName, imDataSource, 30)

	// 注册模型
	orm.RegisterModel(new(models.User))
	orm.RegisterModel(new(models.Admin))
	orm.RegisterModel(new(models.Platform))
	orm.RegisterModel(new(models.KnowledgeBase))
	orm.RegisterModel(new(models.Robot))
	orm.RegisterModel(new(models.Message))
	orm.RegisterModel(new(models.System))
	orm.RegisterModel(new(models.Shortcut))
	orm.RegisterModel(new(models.Contact))
	orm.RegisterModel(new(models.Company))
	orm.RegisterModel(new(models.QiniuSetting))
	orm.RegisterModel(new(models.UploadsConfig))
	orm.RegisterModel(new(models.ServicesStatistical))

	// 创建表
	_ = orm.RunSyncdb("default", false, true)
}

// 初始化日志
func initLog() {

	// 初始化日志
	if isDev := beego.AppConfig.String("runmode"); isDev == "prod" {
		log.SetLogLevel(log.FatalLevel)
		_ = logs.SetLogger(logs.AdapterFile, `{"filename":"project.log","level":7,"maxlines":0,"maxsize":0,"daily":true,"maxdays":10,"color":true}`)
		fmt.Print("当前环境为生产环境")
		_ = beego.BeeLogger.DelLogger("console")
	} else {
		log.SetLogLevel(log.ErrorLevel)
		_ = logs.SetLogger(logs.AdapterConsole, `{"filename":"test.log","level":7,"maxlines":0,"maxsize":0,"daily":true,"maxdays":10,"color":true}`)
		fmt.Print("当前环境为测试环境")
	}
	logs.EnableFuncCallDepth(true)

}

// 定时任务
func appTask() {
	o := orm.NewOrm()
	// 任务调度（1分钟会执行一次）
	checkOnLineTk := toolbox.NewTask("checkOnLine", "0 */1 * * * *", func() error {
		userOffLineUnixTimer := time.Now().Unix() - (60 * 10)  // 用户最后活动时间T出在线状态规则
		adminOffLineUnixTimer := time.Now().Unix() - (60 * 30) // 最后回复消息时间清理回话规则
		lastMessageUnixTimer := time.Now().Unix() - (60 * 8)   // 判断用户是否超过一定时间不使用，强制其下线
		uqs := o.QueryTable(new(models.User))
		aqs := o.QueryTable(new(models.Admin))
		// 检查User
		count, _ := uqs.Filter("online__in", 1, 2).Filter("last_activity__lte", lastMessageUnixTimer).Update(orm.Params{
			"online":    0,
			"is_window": 0,
		})
		logs.Info("清理登录超时用户,有", count, "个用户被强制下线")
		// 检查Admin
		_, _ = aqs.Filter("online__in", 1, 2).Filter("last_activity__lte", adminOffLineUnixTimer).Update(orm.Params{
			"online": 0,
		})

		// 2.判断用户是否超时无应答
		cqs := o.QueryTable(new(models.Contact))
		// 检查(有机器人在线)
		if len(im.Robots) > 0 {
			robot := im.Robots[0]
			var contacts []models.Contact
			_, _ = o.Raw("SELECT * FROM `contact` WHERE `create_at` <= ? AND `is_session_end` = 0 AND `last_message_type` != 'timeout'", lastMessageUnixTimer).QueryRows(&contacts)
			logs.Info("清理会话超时用户,有", len(contacts), "个用户被结束对话")
			for _, contact := range contacts {

				// 判断发送方是客服就不处理发送了
				if err := o.Read(&models.Admin{ID: contact.FromAccount}); err == nil {
					continue
				}
				// 发送超时消息体
				message := models.Message{}
				message.BizType = "timeout"
				message.Read = 0
				appAccount, _ := strconv.ParseInt(robot.AppAccount(), 10, 64)
				message.FromAccount = appAccount
				message.Timestamp = time.Now().Unix()
				message.Payload = "由于您长时间未回复，本次会话超时了"
				message.ToAccount = contact.FromAccount
				var messageJSON []byte
				var messageString string
				messageJSON, _ = json.Marshal(message)
				messageString = base64.StdEncoding.EncodeToString([]byte(messageJSON))
				robot.SendMessage(strconv.FormatInt(contact.FromAccount, 10), []byte(messageString))

				// 该客户超时后给客服发送提醒消息
				message.FromAccount = contact.FromAccount
				message.ToAccount = contact.ToAccount
				messageJSON, _ = json.Marshal(message)
				messageString = base64.StdEncoding.EncodeToString([]byte(messageJSON))
				robot.SendMessage(strconv.FormatInt(contact.ToAccount, 10), []byte(messageString))
				im.MessageInto(message, true)

				// 超时后消息
				// 数据库获取机器人配置信息
				robotData := models.Robot{ID: appAccount}
				cacheRobotKey := "robot_" + string(appAccount)
				if robotDataTemp := im.BmCache.Get(cacheRobotKey); robotDataTemp == nil {
					robotData = models.Robot{ID: appAccount}
					_ = o.Read(&robotData)
					robotDataJSON, _ := json.Marshal(robotData)
					_ = im.BmCache.Put(cacheRobotKey, robotDataJSON, 60*time.Second)
				} else {
					_ = json.Unmarshal([]byte(string(robotDataTemp.([]byte))), &robotData)
				}
				if robotData.TimeoutText != "" {
					message.FromAccount = appAccount
					message.ToAccount = contact.FromAccount
					message.BizType = "text"
					message.Key = time.Now().Unix()
					message.Payload = robotData.TimeoutText
					messageJSON, _ = json.Marshal(message)
					messageString = base64.StdEncoding.EncodeToString([]byte(messageJSON))
					robot.SendMessage(strconv.FormatInt(contact.FromAccount, 10), []byte(messageString))
				}

			}
		} else {
			// 执行到这里说明，机器人死掉了
			logs.Error("执行到这里说明，机器人死掉了")
			im.RobotInit()
			_, _ = cqs.Filter("create_at__lte", userOffLineUnixTimer).Update(orm.Params{
				"last_message_type": "timeout",
				"is_session_end":    1,
			})
		}
		return nil
	})

	toolbox.AddTask("checkOnLine", checkOnLineTk)
}

func main() {

	// 初始化数据库
	initDB()

	// 初始化日志
	initLog()

	// 启动任务
	appTask()
	toolbox.StartTask()
	defer toolbox.StopTask()

	/// 静态文件配置
	beego.SetStaticPath("/", "public/client")
	beego.SetStaticPath("/admin", "public/admin")
	beego.SetStaticPath("/static", "static")

	// 错误处理
	beego.ErrorController(&controllers.ErrorController{})

	// 启动机器人
	im.RobotInit()

	// 初始化beeGo
	beego.Run()

}
