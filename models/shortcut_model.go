package models

// Shortcut 快捷语
type Shortcut struct {
	ID       int64  `orm:"auto;pk;column(id)" json:"id"`
	UID      int64  `orm:"type(bigint);column(uid)" json:"uid"`
	Title    string `orm:"type(text);null;column(title)" json:"title"`
	Content  string `orm:"type(text);null;column(content)" json:"content"`
	UpdateAt int64  `orm:"type(bigint);column(update_at)" json:"update_at"`
	CreateAt int64  `orm:"type(bigint);column(create_at)" json:"create_at"`
}
