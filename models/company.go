package models

// Company struct
type Company struct {
	ID       int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`      // id
	Title    string `orm:"null;type(char);column(title)" json:"title"`     // 公司名称
	Logo     string `orm:"null;type(char);column(logo)" json:"logo"`       // 公司logo
	Service  string `orm:"null;column(service)" json:"service"`            // 在线客服服务时间
	Email    string `orm:"null;column(email)" json:"email"`                // 公司邮箱
	Tel      string `orm:"null;column(tel)" json:"tel"`                    // 公司电话
	Address  string `orm:"null;type(char);column(address)" json:"address"` // 公司地址
	UpdateAt int64  `orm:"type(bigint);column(update_at)" json:"update_at"`
}
