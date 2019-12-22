package models

// System struct
type System struct {
	ID         int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"` // id
	Title      string `orm:"type(char);column(title)" json:"title"`
	Logo       string `orm:"type(char);column(logo)" json:"logo"`
	CopyRight  string `orm:"column(copy_right)" json:"copy_right"`
	UploadMode int    `orm:"column(upload_mode)" json:"upload_mode"` // 1 七牛 目前只实现七牛，其它的后续可以扩展
	UpdateAt   int64  `orm:"type(bigint);column(update_at)" json:"update_at"`
}
