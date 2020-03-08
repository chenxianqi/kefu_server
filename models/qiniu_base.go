package models

// QiniuSetting struct
type QiniuSetting struct {
	ID        int64  `orm:"auto;pk;column(id)" json:"id"`                           // ID
	Bucket    string `orm:"type(char);column(bucket)" json:"bucket"`                // Bucket
	AccessKey string `orm:"unique;type(char);column(access_key)" json:"access_key"` // AccessKey
	SecretKey string `orm:"type(char);column(secret_key)" json:"secret_key"`
	Host      string `orm:"type(char);column(host)" json:"host"`             // Host
	UpdateAt  int64  `orm:"type(bigint);column(update_at)" json:"update_at"` // 更新时间
}
