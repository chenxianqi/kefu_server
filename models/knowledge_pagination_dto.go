package models

// KnowledgePaginationDto struct
type KnowledgePaginationDto struct {
	PageSize int         `json:"page_size"`
	PageOn   int         `json:"page_on"`
	Keyword  string      `json:"keyword"`
	Platform int64       `json:"platform"`
	Total    int64       `json:"total"`
	List     interface{} `json:"list"`
}
