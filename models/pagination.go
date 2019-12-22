package models

// PaginationData struct
type PaginationData struct {
	PageSize int         `json:"page_size"`
	PageOn   int         `json:"page_on"`
	Keyword  string      `json:"keyword"`
	Total    int64       `json:"total"`
	List     interface{} `json:"list"`
}
