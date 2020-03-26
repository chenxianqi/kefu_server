package models

// WorkOrderPaginationDto struct
type WorkOrderPaginationDto struct {
	PageSize int         `json:"page_size"`
	PageOn   int         `json:"page_on"`
	Total    int64       `json:"total"`
	Tid      int64       `json:"tid"`
	Del      int         `json:"del"`
	Status   string      `json:"status"`
	List     interface{} `json:"list"`
}
