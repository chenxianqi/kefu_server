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
	GetTodayActionStatistical(startDate string, endDate string) ([]orm.Params, error)
}

// StatisticalRepository struct
type StatisticalRepository struct {
	BaseRepository
}

// Add add statistical
func (r *StatisticalRepository) Add(servicesStatistical *models.ServicesStatistical) (int64, error) {
	id, err := r.o.Insert(&servicesStatistical)
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

// GetTodayActionStatistical get Today Action Statistical
func (r *StatisticalRepository) GetTodayActionStatistical(startDate string, endDate string) ([]orm.Params, error) {
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
		logs.Warn("GetTodayActionStatistical get Today Action Statistical------------", err)
		return nil, err
	}
	return statisticalData, nil
}
