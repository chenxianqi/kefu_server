package main

import (
	"fmt"

	"github.com/Xiaomi-mimc/mimc-go-sdk/util/log"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/toolbox"
	_ "github.com/go-sql-driver/mysql"

	"kefu_server/controllers"
	"kefu_server/db"
	"kefu_server/grpcs"
	_ "kefu_server/routers"
	"kefu_server/task"
)

// Initialization log
func initLog() {

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

func main() {

	// init db
	db.Run()

	// init log
	initLog()

	// init task
	task.Run()
	toolbox.StartTask()
	defer toolbox.StopTask()

	/// Static file configuration
	beego.SetStaticPath("/", "public/client")
	beego.SetStaticPath("/admin", "public/admin")
	beego.SetStaticPath("/static", "static")

	// Handling Error
	beego.ErrorController(&controllers.ErrorController{})

	// grpcserver init
	go grpcs.Run()

	// run application
	beego.Run()

}
