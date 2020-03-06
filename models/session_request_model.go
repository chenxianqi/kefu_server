package models

// SessionRequest 会话资料
// type 用户类型 0 | 1  0 = 用户  1 = 客服
// uid 自身业务平台用户ID
// account_id 用户客服ID，用户在mimc的唯一ID
// platform 平台 1，2，3，4，5
type SessionRequest struct {
	Type      int    `json:"type"`
	UID       int64  `orm:"column(uid)" json:"uid"`
	Platform  int64  `json:"platform"`
	Address   string `json:"address"`
	AccountID int64  `orm:"column(account_id)" json:"account_id"`
}
