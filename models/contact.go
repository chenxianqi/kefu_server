package models

// Contact 通讯录
type Contact struct {
	ID              int64  `orm:"auto;pk;column(id)" json:"id"`
	FromAccount     int64  `orm:"type(bigint);column(from_account)" json:"from_account"`
	ToAccount       int64  `orm:"type(bigint);column(to_account)" json:"to_account"`
	IsSessionEnd    int    `orm:"default(0),column(is_session_end)" json:"is_session_end"` // 1 已结束对话 0 未结束对话
	LastMessage     string `orm:"null;type(text);column(last_message)" json:"last_message"`
	Delete          int    `orm:"default(0);column(delete)" json:"delete"` // 1 已删除 0 未删除
	LastMessageType string `orm:"null;type(text);column(last_message_type)" json:"last_message_type"`
	CreateAt        int64  `orm:"type(bigint);column(create_at)" json:"create_at"`
}
