package models

// KnowledgeBase struct
type KnowledgeBase struct {
	ID       int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`
	UID      int64  `orm:"type(bigint);column(uid)" json:"uid"`
	Title    string `orm:"unique;type(char);column(title)" json:"title"`
	SubTitle string `orm:"null;type(content);column(sub_title)" json:"sub_title"`
	Content  string `orm:"null;type(text);column(content)" json:"content"`
	Platform int64  `orm:"default(1),type(bigint);column(platform)" json:"platform"` // 0是匹配所有
	UpdateAt int64  `orm:"type(bigint);column(update_at)" json:"update_at"`
	CreateAt int64  `orm:"type(bigint);column(create_at)" json:"create_at"`
}
