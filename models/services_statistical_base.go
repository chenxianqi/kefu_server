package models

// ServicesStatistical 转接一次计算一次服务次数
type ServicesStatistical struct {
	ID              int64  `orm:"auto;pk;column(id)" json:"id"`                                  // ID
	UserAccount     int64  `orm:"type(bigint);column(user_account)" json:"user_account"`         // 服务对象ID
	ServiceAccount  int64  `orm:"type(bigint);column(service_account)" json:"service_account"`   // 服务者ID
	TransferAccount int64  `orm:"type(bigint);column(transfer_account)" json:"transfer_account"` // 转接者ID
	Platform        int64  `orm:"type(bigint);column(platform)" json:"platform"`                 // 此用户来自哪个平台（即渠道）
	NickName        string `orm:"type(char);null;column(nickname)" json:"nickname"`              // 用户昵称
	IsReception     int    `orm:"default(0);null;column(is_reception)" json:"is_reception"`      // 客服是否已回复用户 0 未接待处理 1 已接待处理
	Satisfaction    int    `orm:"default(0);column(satisfaction)" json:"satisfaction"`           // 满意度1-5
	CreateAt        int64  `orm:"type(bigint);column(create_at)" json:"create_at"`               // 创建时间
}
