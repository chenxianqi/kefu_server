package models

// QiniuSetting struct
type QiniuSetting struct {
	ID        int64  `orm:"auto;pk;column(id)" json:"id"`
	Bucket    string `orm:"type(char);column(bucket)" json:"bucket"`
	AccessKey string `orm:"unique;type(char);column(access_key)" json:"access_key"`
	SecretKey string `orm:"type(char);column(secret_key)" json:"secret_key"`
	Host      string `orm:"type(char);column(host)" json:"host"`
	UpdateAt  int64  `orm:"type(bigint);column(update_at)" json:"update_at"`
}
