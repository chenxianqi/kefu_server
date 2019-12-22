package models

// Admin 默认值不生效请自行到mysql修改表结构哦
type Admin struct {
	ID             int64  `orm:"auto;pk;column(id)" json:"id"`                                                 // 客服(管理员)ID
	Avatar         string `orm:"type(char);column(avatar)" json:"avatar"`                                      // 头像
	UserName       string `orm:"unique;type(char);column(username)" json:"username"`                           // 账号（用于登录）这个字段用错名词，将就用吧
	NickName       string `orm:"type(char);column(nickname)" json:"nickname"`                                  // 昵称
	Password       string `orm:"type(char);column(password)" json:"password"`                                  // 密码MD5
	Phone          string `orm:"type(char);null;column(phone)" json:"phone"`                                   // 手机
	Token          string `orm:"null;type(text);column(token)" json:"token"`                                   // token
	AutoReply      string `orm:"null;default('您好有什么可以帮到您呢？');type(text);column(auto_reply)" json:"auto_reply"` // 自动回复语
	Online         int    `orm:"default(0);column(online)" json:"online"`                                      // 在线状态 0 离线 1 在线 2 繁忙（繁忙状态不接待新客户）
	Root           int    `orm:"default(0);column(root)" json:"root"`                                          // 是否是超级管理员
	CurrentConUser int64  `orm:"default(0);column(current_con_user)" json:"current_con_user"`                  // 当前连线的用户
	LastActivity   int64  `orm:"type(bigint);column(last_activity)" json:"last_activity"`                      // 最后活动时间
	UpdateAt       int64  `orm:"type(bigint);column(update_at)" json:"update_at"`                              // 资料更新时间
	CreateAt       int64  `orm:"type(bigint);column(create_at)" json:"create_at"`                              // 账号创建时间
}
