package models

// MessagePaginationDto struct
type MessagePaginationDto struct {
	PageSize  int         `json:"page_size"`
	Total     int64       `json:"total"`
	Account   int64       `json:"account"`
	Service   int64       `json:"service"`
	Timestamp int64       `json:"timestamp"`
	List      interface{} `json:"list"`
}
