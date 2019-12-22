package models

// ContactData struct
type ContactData struct {
	ID              int64  `orm:"column(id)" json:"id"`
	Cid             int64  `json:"cid"`
	FromAccount     int64  `json:"from_account"`
	ToAccount       int64  `json:"to_account"`
	LastMessage     string `json:"last_message"`
	IsSessionEnd    int    `json:"is_session_end"`
	LastMessageType string `json:"last_message_type"`

	UID             int64  `orm:"column(uid)" json:"uid"`
	Avatar          string `json:"avatar"`
	Address         string `json:"address"`
	Nickname        string `json:"nickname"`
	Phone           string `json:"phone"`
	Platform        int64  `json:"platform"`
	Online          int    `json:"online"`
	Read            int    `json:"read"`
	UpdateAt        int64  `json:"update_at"`
	Remarks         string `json:"remarks"`
	LastActivity    int64  `json:"last_activity"`
	CreateAt        int64  `json:"create_at"`
	ContactCreateAt int64  `json:"contact_create_at"`
}
