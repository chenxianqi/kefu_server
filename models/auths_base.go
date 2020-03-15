package models

// Auths 登录授权信息
type Auths struct {
	ID       int64  `orm:"auto;pk;column(id)" json:"id"`                    // 客服(管理员)ID
	AuthType int64  `orm:"column(auth_type)" json:"auth_type"`              // AuthType登录配置模ID
	UID      int64  `orm:"column(uid)" json:"uid"`                          // 用户ID
	Token    string `orm:"null;type(text);column(token)" json:"token"`      // token
	UpdateAt int64  `orm:"type(bigint);column(update_at)" json:"update_at"` // 更新时间
	CreateAt int64  `orm:"type(bigint);column(create_at)" json:"create_at"` // 创建时间
}
