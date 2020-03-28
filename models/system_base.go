package models

// System struct
type System struct {
	ID            int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`       // ID
	Title         string `orm:"type(char);column(title)" json:"title"`           // 系统名称
	Logo          string `orm:"type(char);column(logo)" json:"logo"`             // logo
	CopyRight     string `orm:"column(copy_right)" json:"copy_right"`            // 版权
	OpenWorkorder int    `orm:"column(open_workorder)" json:"open_workorder"`    // 是否开启工单功能
	UploadMode    int    `orm:"column(upload_mode)" json:"upload_mode"`          // 1系统内置，2 七牛云，其它的后续可以扩展
	UpdateAt      int64  `orm:"type(bigint);column(update_at)" json:"update_at"` // 更新时间
}
