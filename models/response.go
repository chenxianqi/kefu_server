package models

import "kefu_server/configs"

// Response struct
type Response struct {
	Code    configs.ResponseStatusType `json:"code"`    // 错误类型
	Message string                 `json:"message"` // 信息
	Data    interface{}            `json:"data"`    // 任意类型
}
