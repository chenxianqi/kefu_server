package models

// AuthTypes 登录配置模
type AuthTypes struct {
	ID    int64  `orm:"auto;pk;column(id)" json:"id"`          // ID
	Title string `orm:"type(char);column(title)" json:"title"` // 标题
}
