package models

// WorkOrderCommentDto model
type WorkOrderCommentDto struct {
	ID        int64  `json:"id"`         // ID
	UID       int64  `json:"uid"`        // 用户ID
	AID       int64  `json:"aid"`        // 客服ID
	WID       int64  `json:"wid"`        // 关联（WorkOrder ID）
	Content   string `json:"content"`    // 内容
	UAvatar   string `json:"u_avatar"`   // 用户头像
	UNickname string `json:"u_nickname"` // 用户昵称
	AAvatar   string `json:"a_avatar"`   // 客服头像
	ANickname string `json:"a_nickname"` // 客服昵称
	CreateAt  int64  `json:"create_at"`  // 提交时间
}
