package models

// AuthTypes 登录配置模
// 目前有一种情况是机器人客户端使用的 0类型
type AuthTypes struct {
	ID    int64  `orm:"auto;pk;column(id)" json:"id"`          // ID
	Title string `orm:"type(char);column(title)" json:"title"` // 标题
}
