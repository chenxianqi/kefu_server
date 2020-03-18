package db

import (
	"kefu_server/models"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

// Run db init
func Run() {

	// 链接IM数据库
	imAliasName := beego.AppConfig.String("kf_alias_name")
	imDriverName := beego.AppConfig.String("kf_driver_name")
	var imDataSource string
	imDataSource = beego.AppConfig.String("kf_mysql_user") + ":"
	imDataSource += beego.AppConfig.String("kf_mysql_pwd")
	imDataSource += "@tcp(" + beego.AppConfig.String("kf_mysql_host")
	imDataSource +=  ":" + beego.AppConfig.String("kf_mysql_port") + ")/"
	imDataSource += beego.AppConfig.String("kf_mysql_db") + "?charset=utf8"
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
	orm.RegisterModel(new(models.AuthTypes))
	orm.RegisterModel(new(models.Auths))
	orm.RegisterModel(new(models.WorkOrder))
	orm.RegisterModel(new(models.WorkOrderType))
	orm.RegisterModel(new(models.WorkOrderComment))

	// 创建表
	_ = orm.RunSyncdb("default", false, true)

}
