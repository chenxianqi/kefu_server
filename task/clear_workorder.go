package task

import (
	"kf_server/models"
	"kf_server/services"
	"kf_server/utils"
	"strconv"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/toolbox"
)

// clearWorkorder tk
func clearWorkorder() {

	// clearWorkorder day at 1 am
	clearWorkorderTk := toolbox.NewTask("clearWorkorder", "0 0 01 * * *", func() error {
		var dayTime int64 = time.Now().Unix() - 60*60*24*7
		workOrderRepository := services.GetWorkOrderRepositoryInstance()
		workOrders := workOrderRepository.GetTimeOutWorkOrders(dayTime)
		for _, workOrder := range workOrders {
			workOrderComment := models.WorkOrderComment{
				UID:      workOrder.UID,
				AID:      workOrder.LastReply,
				WID:      workOrder.ID,
				Content:  "由于您较长时间未反馈该问题，我们暂时先将该工单结束了, 如您的问题还未得到解决，您可以随时联系我们的在线客服，祝您生活愉快~",
				CreateAt: time.Now().Unix(),
			}
			services.GetWorkOrderCommentRepositoryInstance().Add(workOrderComment)
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
		length := workOrderRepository.ClearTimeOutWorkOrders(dayTime)
		logs.Error("tk--------定时清理了", length, "条超期工单~")
		return nil
	})
	toolbox.AddTask("clearWorkorder", clearWorkorderTk)

}
