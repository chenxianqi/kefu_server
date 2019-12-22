package models

// User struct
type User struct {
	ID           int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`               // 用户ID
	UID          int64  `orm:"type(bigint);column(uid)" json:"uid"`                     // 对应业务平台的用户ID（保留字段）
	Avatar       string `orm:"type(char);null;column(avatar)" json:"avatar"`            // 用户头像
	Address      string `orm:"type(char);null;column(address)" json:"address"`          // 用户所在地
	NickName     string `orm:"type(char);null;column(nickname)" json:"nickname"`        // 用户昵称
	UserToken    string `orm:"type(text);null;column(token)" json:"token"`              // 对应业务平台的用户的token（保留字段）
	Phone        string `orm:"type(char);null;column(phone)" json:"phone"`              // 用户联系电话
	Platform     int64  `orm:"type(bigint);column(platform)" json:"platform"`           // 用户所在渠道（平台）
	Online       int    `orm:"default(0);column(online)" json:"online"`                 // 用户是否在线
	IsWindow     int    `orm:"default(0);column(is_window)" json:"is_window"`           // 是否在聊天窗口
	UpdateAt     int64  `orm:"type(bigint);column(update_at)" json:"update_at"`         // 用户资料被更新时间
	Remarks      string `orm:"type(char);null;column(remarks)" json:"remarks"`          // 备注
	LastActivity int64  `orm:"type(bigint);column(last_activity)" json:"last_activity"` // 最后活动时间
	CreateAt     int64  `orm:"type(bigint);column(create_at)" json:"create_at"`         // 创建时间
}
