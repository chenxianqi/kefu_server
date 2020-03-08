package models

// KnowledgeBase struct
type KnowledgeBase struct {
	ID       int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`                // 递增ID
	UID      int64  `orm:"type(bigint);column(uid)" json:"uid"`                      // 所属发布者者ID
	Title    string `orm:"unique;type(char);column(title)" json:"title"`             // 标题
	SubTitle string `orm:"null;type(content);column(sub_title)" json:"sub_title"`    // 子标题
	Content  string `orm:"null;type(text);column(content)" json:"content"`           // 内容
	Platform int64  `orm:"default(1),type(bigint);column(platform)" json:"platform"` // 0是匹配所有，其它
	UpdateAt int64  `orm:"type(bigint);column(update_at)" json:"update_at"`          // 更新时间
	CreateAt int64  `orm:"type(bigint);column(create_at)" json:"create_at"`          // 创建时间
}
