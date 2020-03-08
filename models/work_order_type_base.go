package models

// WorkOrderType model
type WorkOrderType struct {
	ID    int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`     // ID
	WID   int64  `orm:"type(bigint);column(wid)" json:"wid"`           // 关联（WorkOrder ID）
	Title string `orm:"type(varchar);null;column(title)" json:"title"` // 类型名称
}
