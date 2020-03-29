package models

// WorkOrderComment model
type WorkOrderComment struct {
	ID       int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`       // ID
	UID      int64  `orm:"type(bigint);column(uid)" json:"uid"`             // 用户ID
	AID      int64  `orm:"type(bigint);column(aid)" json:"aid"`             // 客服ID
	WID      int64  `orm:"type(bigint);column(wid)" json:"wid"`             // 关联（WorkOrder ID）
	Content  string `orm:"type(text);null;column(content)" json:"content"`  // 内容
	CreateAt int64  `orm:"type(bigint);column(create_at)" json:"create_at"` // 提交时间
}
