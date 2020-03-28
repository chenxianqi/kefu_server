package models

// ConfigsDto struct
type ConfigsDto struct {
	UploadMode    int         `json:"upload_mode"`    // 上传配置模块
	UploadSecret  interface{} `json:"upload_secret"`  // 上传秘钥
	UploadHost    string      `json:"upload_host"`    // 资源host
	OpenWorkorder int         `json:"open_workorder"` // 是否开启工单功能
}
