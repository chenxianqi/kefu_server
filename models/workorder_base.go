package models

// WorkOrder model
type WorkOrder struct {
	ID        int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`          // ID
	UID       int64  `orm:"type(bigint);column(uid)" json:"uid"`                // 用户ID
	TID       int64  `orm:"type(bigint);column(tid))" json:"tid"`               // 工单类型ID
	Title     string `orm:"column(title)" json:"title"`                         // 工单标题
	Content   string `orm:"type(text);column(content)" json:"content"`          // 内容
	Phone     string `orm:"type(char);null;column(phone)" json:"phone"`         // 用户联系电话
	Email     string `orm:"type(varchar);null;column(email)" json:"email"`      // 邮箱(可用于客服回复后发提醒邮件给客户)
	Status    int    `orm:"default(0);column(status)" json:"status"`            // 当前状态 （ 0=待处理 | 1=客服已回复 | 2=客户已回复 | 3=已结单 ）
	LastReply int64  `orm:"type(bigint);column(last_reply))" json:"last_reply"` // 最后回复的客服ID
	CID       int64  `orm:"type(bigint);column(cid))" json:"cid"`               // 结单客服ID
	CloseAt   int64  `orm:"type(bigint);column(close_at)" json:"close_at"`      // 结单时间
	Remark    string `orm:"column(remark)" json:"remark"`                       // 结单原因
	UpdateAt  int64  `orm:"type(bigint);column(update_at)" json:"update_at"`    // 更新时间
	Delete    int    `orm:"default(0);column(delete)" json:"delete"`            // 是否已删除 0 未删除， 1已删除 （未结单状态不能删除）
	CreateAt  int64  `orm:"type(bigint);column(create_at)" json:"create_at"`    // 提交时间
}
