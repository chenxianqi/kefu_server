package models

// WorkOrderDto model
type WorkOrderDto struct {
	ID        int64  `json:"id"`         // ID
	UID       int64  `json:"uid"`        // 用户ID
	TID       int64  `json:"tid"`        // 工单类型ID
	Title     string `json:"title"`      // 工单标题
	Content   string `json:"content"`    // 内容
	Phone     string `json:"phone"`      // 用户联系电话
	Email     string `json:"email"`      // 邮箱(可用于客服回复后发提醒邮件给客户)
	Status    int    `json:"status"`     // 当前状态 （ 0=待处理 | 1=客服已回复 | 2=客户已回复 | 3=已结单 ）
	LastReply int64  `json:"last_reply"` // 最后回复的客服ID
	CID       int64  `json:"cid"`        // 结单客服ID
	CloseAt   int64  `json:"close_at"`   // 结单时间
	Remark    string `json:"remark"`     // 结单原因
	UpdateAt  int64  `json:"update_at"`  // 更新时间
	Delete    int    `json:"delete"`     // 是否已删除 0 未删除， 1已删除 （未结单状态不能删除）
	CreateAt  int64  `json:"create_at"`  // 提交时间
	UNickname string `json:"u_nickname"` // 用户昵称
	UAvatar   string `json:"u_avatar"`   // 用户头像
	ANickname string `json:"a_nickname"` // 客服昵称
}
