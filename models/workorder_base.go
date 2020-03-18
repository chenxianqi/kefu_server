package models

// WorkOrder model
type WorkOrder struct {
	ID       int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`       // ID
	UID      int64  `orm:"type(bigint);column(uid)" json:"uid"`             // 用户ID
	AID      int64  `orm:"type(bigint);column(aid))" json:"aid"`            // 客服ID
	TID      int64  `orm:"type(bigint);column(tid))" json:"tid"`            // 工单类型ID
	Phone    string `orm:"type(char);null;column(phone)" json:"phone"`      // 用户联系电话
	Email    string `orm:"type(varchar);null;column(email)" json:"email"`   // 邮箱(可用于客服回复后发提醒邮件给客户)
	Status   int    `orm:"default(0);column(status)" json:"status"`         // 当前状态 （ 0=待处理 | 1=客服已回复 | 2=客户已回复 | 3=已结单 ）
	CID      int64  `orm:"type(bigint);column(cid))" json:"cid"`            // 结单客服ID
	CloseAt  int64  `orm:"type(bigint);column(close_at)" json:"close_at"`   // 结单时间
	Comment  int64  `orm:"type(bigint);column(comment)" json:"comment"`     // 结单原因
	CreateAt int64  `orm:"type(bigint);column(create_at)" json:"create_at"` // 提交时间
}
