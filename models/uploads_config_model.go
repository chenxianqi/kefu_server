package models

// UploadsConfig struct
type UploadsConfig struct {
	ID   int64  `orm:"auto;pk;column(id)" json:"id"`
	Name string `orm:"type(char);column(name)" json:"name"`
}
