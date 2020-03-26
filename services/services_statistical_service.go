package services

import (
	"errors"
	"kefu_server/models"
	"math"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// StatisticalRepositoryInterface interface
type StatisticalRepositoryInterface interface {
	Add(servicesStatistical *models.ServicesStatistical) (int64, error)
	GetStatisticals(startDate string, endDate string) (map[string]interface{}, error)
	GetFlowStatistical(startDate string, endDate string) ([]orm.Params, error)
	GetCustomerServiceList(request models.ServicesStatisticalPaginationDto) models.ServicesStatisticalPaginationDto
	CheckIsReplyAndSetReply(uid int64, aid int64, platform int64)
}

// StatisticalRepository struct
type StatisticalRepository struct {
	BaseRepository
}

// GetStatisticalRepositoryInstance get instance
func GetStatisticalRepositoryInstance() *StatisticalRepository {
	instance := new(StatisticalRepository)
	instance.Init(new(models.ServicesStatistical))
	return instance
}

// GetCustomerServiceList get Customer Service List
func (r *StatisticalRepository) GetCustomerServiceList(request models.ServicesStatisticalPaginationDto) models.ServicesStatisticalPaginationDto {

	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	startDateStr := request.Date + " 00:00:00"
	endDateStr := request.Date + " 23:59:59"
	startDate, _ := time.ParseInLocation(layoutDate, startDateStr, loc)
	endDate, _ := time.ParseInLocation(layoutDate, endDateStr, loc)

	var params []orm.Params
	type TotalModel struct {
		Count int64
	}
	var totalModel TotalModel

	// Deduplication
	addSQL := " COUNT(*) "
	if request.IsDeWeighting {
		addSQL = " count(distinct user_account) "
	}

	// is not reception?
	INReception := "0,1"
	if request.IsReception {
		INReception = "0"
	}

	if err := r.o.Raw("SELECT "+addSQL+" AS `count` FROM services_statistical AS s INNER JOIN (SELECT * FROM `user`) AS u ON s.user_account = u.id AND s.service_account = ? AND s.create_at > ? AND s.create_at < ? AND is_reception IN("+INReception+")", request.Cid, startDate.Unix(), endDate.Unix()).QueryRow(&totalModel); err != nil {
		logs.Warn("GetCustomerServiceList get Customer Service List1------------", err)
	}
	request.Total = totalModel.Count

	// Deduplication
	addSQL1 := " "
	if request.IsDeWeighting {
		addSQL1 = " GROUP BY `user_account` "
	}

	if counter, err := r.o.Raw("SELECT s.id, s.user_account, s.service_account,s.create_at,s.is_reception, s.transfer_account,s.platform,u.nickname FROM services_statistical AS s INNER JOIN (SELECT * FROM `user` ) AS u ON s.user_account = u.id AND s.service_account = ? AND s.create_at > ? AND s.create_at < ? AND is_reception IN("+INReception+") "+addSQL1+" ORDER BY s.create_at DESC LIMIT ?,?", request.Cid, startDate.Unix(), endDate.Unix(), (request.PageOn-1)*request.PageSize, request.PageSize).Values(&params); counter <= 0 {
		logs.Warn("GetCustomerServiceList get Customer Service List2------------", err)
		request.List = []string{}
		return request
	}

	request.List = params
	return request

}

// Add add statistical
func (r *StatisticalRepository) Add(servicesStatistical *models.ServicesStatistical) (int64, error) {
	id, err := r.o.Insert(servicesStatistical)
	if err != nil {
		logs.Warn("Add add statistical------------", err)
	}
	return id, err
}

// GetStatisticals get statistical
func (r *StatisticalRepository) GetStatisticals(startDate string, endDate string) (map[string]interface{}, error) {

	// transform date
	var oneDaySecond float64 = 86400
	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	dateStartString := startDate + " 00:00:00"
	dateEndString := endDate + " 23:59:59"
	dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
	dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)
	k := dateEnd.Unix() - dateStart.Unix()
	maxDay := int(math.Ceil(float64(k) / oneDaySecond))

	if maxDay < 1 || maxDay >= 32 {
		logs.Warn("GetStatisticals get statistical | 日期有误，最大只能查询一个月以内~------------", nil)
		return nil, errors.New("日期有误，最大只能查询一个月以内~")
	}
	countsArr := map[string]interface{}{}

	// Count customer service access
	var membersData []orm.Params
	_, err := r.o.Raw("SELECT a.id, a.username, a.nickname, IFNULL(s.count,0) as count FROM `admin` a LEFT JOIN (SELECT service_account,COUNT(*) AS count FROM services_statistical WHERE `create_at` BETWEEN ? AND	? GROUP BY service_account) s ON a.id = s.service_account ORDER BY a.id", dateStart.Unix(), dateEnd.Unix()).Values(&membersData)
	if err != nil {
		logs.Warn("GetStatisticals get statistical | Count customer service access------------", err)
		return nil, err
	}
	countsArr["members"] = membersData

	// Count the traffic of each channel
	var statisticalData []interface{}
	for i := 0; i < maxDay; i++ {
		var statisticalTemp []orm.Params
		increment := int64(i) * int64(oneDaySecond)
		start := dateStart.Unix() + increment
		end := start + int64(oneDaySecond)
		if i == maxDay-1 {
			end = dateEnd.Unix()
		}
		_, err := r.o.Raw("SELECT p.id, p.title, IFNULL(s.count,0) as count FROM `platform` p LEFT JOIN (SELECT platform,COUNT(*) AS count FROM `services_statistical`  WHERE `create_at` BETWEEN ? AND ? GROUP BY platform) s ON p.id = s.platform ORDER BY p.id", start, end).Values(&statisticalTemp)
		if err != nil {
			logs.Warn("GetStatisticals get statistical |Count the traffic of each channel------------", nil)
			return nil, err
		}
		day := time.Unix(start, 0).Format("2006-01-02")
		statisticalArrItem := map[string]interface{}{}
		statisticalArrItem["date"] = day
		statisticalArrItem["list"] = statisticalTemp
		statisticalData = append(statisticalData, statisticalArrItem)
	}
	countsArr["statistical"] = statisticalData
	return countsArr, nil
}

// GetFlowStatistical get Today Action Statistical
func (r *StatisticalRepository) GetFlowStatistical(startDate string, endDate string) ([]orm.Params, error) {
	// transform date
	layoutDate := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	dateStartString := startDate + " 00:00:00"
	dateEndString := endDate + " 23:59:59"
	dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
	dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)

	var statisticalData []orm.Params
	_, err := r.o.Raw("SELECT p.id platform,p.title, IFNULL(u.count,0) AS `count` FROM platform as p LEFT  JOIN (SELECT platform,COUNT(*) AS count FROM `user` WHERE last_activity BETWEEN ? AND ? GROUP BY platform) u ON p.id = u.platform", dateStart.Unix(), dateEnd.Unix()).Values(&statisticalData)
	if err != nil {
		logs.Warn("GetFlowStatistical get Today Action Statistical------------", err)
		return nil, err
	}
	return statisticalData, nil
}

// CheckIsReplyAndSetReply cehck is reply and set reply
func (r *StatisticalRepository) CheckIsReplyAndSetReply(userAccount int64, serviceAccount int64, userPlatform int64) {
	logs.Info(userAccount, serviceAccount, userPlatform)
	var servicesStatistical models.ServicesStatistical
	maxTime := time.Now().Unix() - 60*10
	logs.Info(maxTime)
	err := r.q.Filter("user_account", userAccount).Filter("service_account", serviceAccount).Filter("is_reception", 0).Filter("platform", userPlatform).Filter("create_at__gte", maxTime).One(&servicesStatistical)
	if err != nil {
		logs.Warn("CheckIsReplyAndSetReply cehck is reply and set reply Filter------------", err)
	} else {
		servicesStatistical.IsReception = 1
		_, err := r.o.Update(&servicesStatistical)
		if err != nil {
			logs.Warn("CheckIsReplyAndSetReply cehck is reply and set reply Update------------", err)
		}
	}
}
