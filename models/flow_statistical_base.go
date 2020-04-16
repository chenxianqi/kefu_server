package models

// FlowStatistical 独立流量统计
type FlowStatistical struct {
	ID       int64  `orm:"auto;pk;column(id)" json:"id"`               // id
	Date     int64  `orm:"column(date)" json:"date"`                   // 统计日期
	Platform int64  `orm:"column(platform)" json:"platform"`           // 用户ID
	Count    int64  `orm:"column(count)" json:"count"`                 // 数量
	Users    string `orm:"null;type(text);column(users)" json:"users"` // 用户IDS
}
