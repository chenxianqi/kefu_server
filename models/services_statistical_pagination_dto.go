package models

// ServicesStatisticalPaginationDto struct
type ServicesStatisticalPaginationDto struct {
	PageSize      int         `json:"page_size"`
	PageOn        int         `json:"page_on"`
	Cid           int64       `json:"cid"`
	Date          string      `json:"date"`
	IsDeWeighting bool        `json:"is_de_weighting"`
	Total         int64       `json:"total"`
	List          interface{} `json:"list"`
}
