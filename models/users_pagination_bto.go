package models

// UsersPaginationDto struct
type UsersPaginationDto struct {
	PageSize  int         `json:"page_size"`
	PageOn    int         `json:"page_on"`
	Keyword   string      `json:"keyword"`
	Total     int64       `json:"total"`
	Platform  int64       `json:"platform"`
	DateStart string      `json:"date_start"`
	DateEnd   string      `json:"date_end"`
	List      interface{} `json:"list"`
}
