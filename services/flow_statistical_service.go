package services

import (
	"kefu_server/models"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// FlowStatisticalRepositoryInterface interface
type FlowStatisticalRepositoryInterface interface {
	GetCounter(startDate string, endDate string) ([]orm.Params, error)
	Increment(platform int64, uid int64)
}

// FlowStatisticalRepository struct
type FlowStatisticalRepository struct {
	BaseRepository
}

// GetFlowStatisticalRepositoryInstance get instance
func GetFlowStatisticalRepositoryInstance() *FlowStatisticalRepository {
	instance := new(FlowStatisticalRepository)
	instance.Init(new(models.FlowStatistical))
	return instance
}

// Increment add counter
func (r *FlowStatisticalRepository) Increment(platform int64, uid int64) {
	uidStr := strconv.FormatInt(uid, 10)
	// transform date
	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	dateStartString := time.Now().Format("2006-01-02") + " 00:00:00"
	dateEndString := time.Now().Format("2006-01-02") + " 23:59:59"
	dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
	dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)
	var flowStatistical models.FlowStatistical
	err := r.q.Filter("platform", platform).Filter("date__gte", dateStart.Unix()).Filter("date__lte", dateEnd.Unix()).One(&flowStatistical)
	if err != nil {
		logs.Warn("Increment add counter------------", err, dateStart, dateEnd)
		_, err := r.o.Insert(&models.FlowStatistical{
			Date:     time.Now().Unix(),
			Platform: platform,
			Count:    1,
			Users:    uidStr + "|",
		})
		if err != nil {
			logs.Warn("Increment Insert err------------", err, dateStart, dateEnd)
		}
		return
	}
	if !strings.Contains(flowStatistical.Users, uidStr) {
		flowStatistical.Users = flowStatistical.Users + uidStr + "|"
		flowStatistical.Count = flowStatistical.Count + 1
		_, err := r.o.Update(&flowStatistical)
		if err != nil {
			logs.Warn("Increment Update err------------", err, dateStart, dateEnd)
		}
	}

}

// GetCounter get counter
func (r *FlowStatisticalRepository) GetCounter(startDate string, endDate string) ([]orm.Params, error) {
	// transform date
	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	dateStartString := startDate + " 00:00:00"
	dateEndString := endDate + " 23:59:59"
	dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
	dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)

	var statisticalData []orm.Params
	_, err := r.o.Raw("SELECT p.id platform,p.title, IFNULL(f.count,0) AS `count` FROM platform as p LEFT  JOIN (SELECT platform,SUM(count) AS `count` FROM `flow_statistical` WHERE date BETWEEN ? AND ? GROUP BY platform) f ON p.id = f.platform ORDER BY platform ASC", dateStart.Unix(), dateEnd.Unix()).Values(&statisticalData)
	if err != nil {
		logs.Warn("GetCounter get counter------------", err)
		return []orm.Params{}, err
	}
	return statisticalData, nil
}
