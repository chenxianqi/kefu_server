package models

// WorkOrderComment model
type WorkOrderComment struct {
	ID      int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`      // ID
	WID     int64  `orm:"type(bigint);column(wid)" json:"wid"`            // 关联（WorkOrder ID）
	Content string `orm:"type(text);null;column(content)" json:"content"` // 内容
}
