package models

// Shortcut 快捷语
type Shortcut struct {
	ID       int64  `orm:"auto;pk;column(id)" json:"id"`                    // ID
	UID      int64  `orm:"type(bigint);column(uid)" json:"uid"`             // 用户ID
	Title    string `orm:"type(text);null;column(title)" json:"title"`      // 标题
	Content  string `orm:"type(text);null;column(content)" json:"content"`  // 内容
	UpdateAt int64  `orm:"type(bigint);column(update_at)" json:"update_at"` // 更新时间
	CreateAt int64  `orm:"type(bigint);column(create_at)" json:"create_at"` // 创建时间
}
