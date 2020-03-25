// @APIVersion 2.0.0
// @Title KEFU server API
// @Description kefu server APIs.
// @Contact 361554012@qq.com

package routers

import (
	"kefu_server/controllers"
	"kefu_server/filters"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/plugins/cors"
)

// routers
func routers(prefix string) *beego.Namespace {

	return beego.NewNamespace(prefix,

		// auth
		beego.NSNamespace("/auth",
			beego.NSRouter("/login", &controllers.AuthController{}, "post:Login"),
			beego.NSRouter("/logout", &controllers.AuthController{}, "get:Logout"),
		),

		// public
		beego.NSNamespace("/public",
			beego.NSRouter("/register", &controllers.PublicController{}, "post:Register"),
			beego.NSRouter("/robot/:platform", &controllers.PublicController{}, "get:Robot"),
			beego.NSRouter("/read", &controllers.PublicController{}, "get:Read"),
			beego.NSRouter("/secret", &controllers.PublicController{}, "get:UploadSecret"),
			beego.NSRouter("/activity", &controllers.PublicController{}, "get:LastActivity"),
			beego.NSRouter("/company", &controllers.PublicController{}, "get:GetCompanyInfo"),
			beego.NSRouter("/robot_info/:id", &controllers.PublicController{}, "get:RobotInfo"),
			beego.NSRouter("/clean_read", &controllers.PublicController{}, "get:CleanRead"),
			beego.NSRouter("/window", &controllers.PublicController{}, "put:Window"),
			beego.NSRouter("/upload", &controllers.PublicController{}, "post:Upload"),
			beego.NSRouter("/messages", &controllers.PublicController{}, "post:GetMessageHistoryList"),
			beego.NSRouter("/message/push", &controllers.PublicController{}, "post:PushMessage"),
			beego.NSRouter("/message/cancel", &controllers.PublicController{}, "post:CancelMessage"),
			beego.NSRouter("/workorder/create", &controllers.PublicController{}, "post:CreateWorkOrder"),
			beego.NSRouter("/workorder/reply", &controllers.PublicController{}, "post:ReplyWorkOrder"),
			beego.NSRouter("/workorders", &controllers.PublicController{}, "get:GetWorkOrders"),
			beego.NSRouter("/workorder/types", &controllers.PublicController{}, "get:GetWorkOrderTypes"),
			beego.NSRouter("/workorder/comments/:wid", &controllers.PublicController{}, "get:GetWorkOrderComments"),
			beego.NSRouter("/workorder/:wid", &controllers.PublicController{}, "get:GetWorkOrder"),
			beego.NSRouter("/workorder/:wid", &controllers.PublicController{}, "delete:DeleteWorkOrder"),
			beego.NSRouter("/workorder/close/:wid", &controllers.PublicController{}, "put:CloseWorkOrder"),
		),

		// knowledge_base
		beego.NSNamespace("/knowledge",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/?:id", &controllers.KnowledgeBaseController{}),
			beego.NSRouter("/list", &controllers.KnowledgeBaseController{}, "post:List"),
			beego.NSRouter("/total", &controllers.KnowledgeBaseController{}, "get:Total"),
		),

		// home
		beego.NSNamespace("/home",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/statistical", &controllers.HomeController{}, "post:Statistical"),
			beego.NSRouter("/today_statistical", &controllers.HomeController{}, "post:TodayActionStatistical"),
		),

		// message
		beego.NSNamespace("/message",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/list", &controllers.MessageController{}, "post:List"),
			beego.NSRouter("/remove", &controllers.MessageController{}, "post:Remove"),
		),

		// admin
		beego.NSNamespace("/admin",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/?:id", &controllers.AdminController{}),
			beego.NSRouter("/list", &controllers.AdminController{}, "post:List"),
			beego.NSRouter("/password", &controllers.AdminController{}, "put:UpdatePassword"),
			beego.NSRouter("/me", &controllers.AdminController{}, "get:GetMeInfo"),
			beego.NSRouter("/current/user/?:id", &controllers.AdminController{}, "get:ChangeCurrentUser"),
			beego.NSRouter("/online/?:state", &controllers.AdminController{}, "put:Online"),
		),

		// user
		beego.NSNamespace("/user",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/?:id", &controllers.UserController{}),
			beego.NSRouter("/list", &controllers.UserController{}, "post:Users"),
			beego.NSRouter("/onlines", &controllers.UserController{}, "get:OnLineCount"),
		),

		// robot
		beego.NSNamespace("/robot",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/?:id", &controllers.RobotController{}),
			beego.NSRouter("/list", &controllers.RobotController{}, "get:List"),
			beego.NSRouter("/online/all", &controllers.RobotController{}, "get:GetOnlineAll"),
		),

		// shortcut
		beego.NSNamespace("/shortcut",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/?:id", &controllers.ShortcutController{}),
			beego.NSRouter("/list", &controllers.ShortcutController{}, "get:List"),
		),

		// company
		beego.NSNamespace("/company",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/", &controllers.CompanyController{}),
		),

		// system
		beego.NSNamespace("/system",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/", &controllers.SystemController{}),
		),

		// uploads config
		beego.NSNamespace("/uploads",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/config", &controllers.UploadsConfigController{}, "get:Config"),
		),

		// QiniuUp
		beego.NSNamespace("/qiniu",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/", &controllers.QiniuController{}),
		),

		// contact
		beego.NSNamespace("/contact",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/?:id", &controllers.ContactController{}),
			beego.NSRouter("/list", &controllers.ContactController{}, "get:GetContacts"),
			beego.NSRouter("/clear", &controllers.ContactController{}, "delete:DeleteAll"),
			beego.NSRouter("/transfer", &controllers.ContactController{}, "post:Transfer"),
		),

		// platform
		beego.NSNamespace("/platform",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/?:id", &controllers.PlatformController{}),
			beego.NSRouter("/list", &controllers.PlatformController{}, "get:List"),
		),

		// Services Statistical
		beego.NSNamespace("/services_statistical",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/list", &controllers.ServicesStatisticalController{}, "post:List"),
		),

		// Work Order
		beego.NSNamespace("/workorder",
			beego.NSBefore(filters.FilterToken),
			beego.NSRouter("/type", &controllers.WorkOrderController{}, "post:PostWorkType"),
			beego.NSRouter("/type", &controllers.WorkOrderController{}, "put:UpdateWorkType"),
			beego.NSRouter("/type/:id", &controllers.WorkOrderController{}, "delete:DeleteWorkType"),
			beego.NSRouter("/type/:id", &controllers.WorkOrderController{}, "get:GetWorkType"),
			beego.NSRouter("/types", &controllers.WorkOrderController{}, "get:GetWorkTypes"),
			beego.NSRouter("/close", &controllers.WorkOrderController{}, "post:CloseWorkOrder"),
			beego.NSRouter("/list", &controllers.WorkOrderController{}, "post:GetWorkOrders"),
		),
	)

}

func init() {

	/// 跨域处理
	beego.InsertFilter("*", beego.BeforeRouter, cors.Allow(&cors.Options{
		AllowAllOrigins: true,
		//AllowOrigins:      []string{"https://192.168.0.102"}, // 开放跨域白名单
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Authorization", "Access-Control-Allow-Origin", "Access-Control-Allow-Headers", "Content-Type", "token"},
		ExposeHeaders:    []string{"Content-Length", "Access-Control-Allow-Origin", "Access-Control-Allow-Headers", "Content-Type"},
		AllowCredentials: true,
	}))

	// a new ns used /api
	newNs := routers("/api")

	// scrapped /v1
	oldNs := routers("/v1")

	beego.AddNamespace(newNs, oldNs)

}
