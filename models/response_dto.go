package models

import "kefu_server/configs"

// ResponseDto struct
type ResponseDto struct {
	Code    configs.ResponseStatusType `json:"code"`    // 错误类型
	Message string                     `json:"message"` // 信息
	Data    interface{}                `json:"data"`    // 任意类型
}
